#!/bin/bash

# run-local-ci.sh - Run GitHub CI pipeline locally with caching and detailed logs
# This script mimics the GitHub Actions CI workflow with performance optimizations

set -e  # Exit on error

# Configuration
CI_CACHE_DIR=".ci-cache"
CI_LOG_DIR=".ci-logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$CI_LOG_DIR/ci_run_$TIMESTAMP.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create directories
mkdir -p "$CI_LOG_DIR"
mkdir -p "$CI_CACHE_DIR"

# Function to print colored status messages
print_status() {
    echo -e "${BLUE}[CI]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}✗${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1" | tee -a "$LOG_FILE"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1" | tee -a "$LOG_FILE"
}

print_fix() {
    echo -e "${MAGENTA}→ FIX:${NC} $1" | tee -a "$LOG_FILE"
}

# Function to show section headers
print_section() {
    echo -e "\n${BOLD}════════════════════════════════════════════════════${NC}" | tee -a "$LOG_FILE"
    echo -e "${BOLD}▶ $1${NC}" | tee -a "$LOG_FILE"
    echo -e "${BOLD}════════════════════════════════════════════════════${NC}" | tee -a "$LOG_FILE"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to pause before exit
pause_before_exit() {
    echo -e "\n${CYAN}Press Enter to exit...${NC}"
    read -r
}

# Function to cache generated files
cache_generated_files() {
    local cache_key=$(git rev-parse HEAD 2>/dev/null || echo "no-git")
    local cache_path="$CI_CACHE_DIR/generated_$cache_key"
    
    print_info "Caching generated files..."
    mkdir -p "$cache_path"
    
    # Find and cache all generated files
    find lib test -name "*.g.dart" -o -name "*.freezed.dart" | while read -r file; do
        cp --parents "$file" "$cache_path/" 2>/dev/null || true
    done
    
    # Save cache metadata
    echo "$(date +%s)" > "$cache_path/.timestamp"
    echo "$cache_key" > "$CI_CACHE_DIR/last_cache_key"
}

# Function to restore cached files
restore_cached_files() {
    local cache_key=$(git rev-parse HEAD 2>/dev/null || echo "no-git")
    local cache_path="$CI_CACHE_DIR/generated_$cache_key"
    
    if [ -d "$cache_path" ] && [ -f "$cache_path/.timestamp" ]; then
        local cache_age=$(($(date +%s) - $(cat "$cache_path/.timestamp")))
        if [ $cache_age -lt 86400 ]; then  # Cache valid for 24 hours
            print_info "Restoring cached generated files (age: $(($cache_age / 60)) minutes)"
            cp -r "$cache_path/lib"/* lib/ 2>/dev/null || true
            cp -r "$cache_path/test"/* test/ 2>/dev/null || true
            return 0
        fi
    fi
    return 1
}

# Function to run a step with detailed error handling
run_step() {
    local step_name="$1"
    local command="$2"
    local continue_on_error="${3:-false}"
    
    print_status "Running: $step_name"
    
    # Create a temporary file for this step's output
    local step_log="$CI_LOG_DIR/${step_name// /_}_$TIMESTAMP.log"
    
    if eval "$command" > "$step_log" 2>&1; then
        print_success "$step_name completed successfully"
        return 0
    else
        print_error "$step_name failed"
        
        # Show relevant error output
        echo -e "\n${RED}Error Output:${NC}" | tee -a "$LOG_FILE"
        tail -20 "$step_log" | tee -a "$LOG_FILE"
        echo -e "${RED}Full log available at: $step_log${NC}\n" | tee -a "$LOG_FILE"
        
        if [ "$continue_on_error" = "false" ]; then
            return 1
        fi
        return 0
    fi
}

# Function to analyze format issues
analyze_format_issues() {
    print_info "Analyzing formatting issues..."
    
    local unformatted_files=$(dart format --output show lib/ test/ 2>/dev/null | grep -E "^[^/]" || true)
    
    if [ -n "$unformatted_files" ]; then
        echo -e "\n${YELLOW}Files needing formatting:${NC}" | tee -a "$LOG_FILE"
        echo "$unformatted_files" | while read -r file; do
            echo "  • $file" | tee -a "$LOG_FILE"
        done
        
        print_fix "Run the following command to fix formatting:"
        echo -e "  ${CYAN}dart format lib/ test/${NC}\n" | tee -a "$LOG_FILE"
    fi
}

# Function to analyze static analysis issues
analyze_flutter_issues() {
    local analyze_output="$CI_LOG_DIR/flutter_analyze_$TIMESTAMP.log"
    flutter analyze --no-fatal-infos --no-fatal-warnings > "$analyze_output" 2>&1 || true
    
    local error_count=$(grep -c "error •" "$analyze_output" 2>/dev/null || echo "0")
    local warning_count=$(grep -c "warning •" "$analyze_output" 2>/dev/null || echo "0")
    local info_count=$(grep -c "info •" "$analyze_output" 2>/dev/null || echo "0")
    
    if [ "$error_count" -gt 0 ] || [ "$warning_count" -gt 0 ]; then
        echo -e "\n${YELLOW}Analysis Summary:${NC}" | tee -a "$LOG_FILE"
        echo "  • Errors: $error_count" | tee -a "$LOG_FILE"
        echo "  • Warnings: $warning_count" | tee -a "$LOG_FILE"
        echo "  • Info: $info_count" | tee -a "$LOG_FILE"
        
        if [ "$error_count" -gt 0 ]; then
            echo -e "\n${RED}Errors found:${NC}" | tee -a "$LOG_FILE"
            grep "error •" "$analyze_output" | head -5 | tee -a "$LOG_FILE"
            if [ "$error_count" -gt 5 ]; then
                echo "  ... and $((error_count - 5)) more errors" | tee -a "$LOG_FILE"
            fi
        fi
        
        print_fix "Review the full analysis output at: $analyze_output"
    fi
}

# Function to analyze test failures
analyze_test_failures() {
    local test_output="$CI_LOG_DIR/test_output_$TIMESTAMP.log"
    
    if [ -f "$test_output" ]; then
        local failed_tests=$(grep -E "^[[:space:]]*[✗✖]" "$test_output" 2>/dev/null || true)
        
        if [ -n "$failed_tests" ]; then
            echo -e "\n${RED}Failed Tests:${NC}" | tee -a "$LOG_FILE"
            echo "$failed_tests" | tee -a "$LOG_FILE"
            
            print_fix "Run failing tests individually to debug:"
            echo -e "  ${CYAN}flutter test --name \"<test_name>\"${NC}\n" | tee -a "$LOG_FILE"
        fi
    fi
}

# Main CI pipeline
main() {
    local START_TIME=$(date +%s)
    local FAILED_STEPS=()
    
    # Default values
    RUN_BUILD=false
    RUN_INTEGRATION=false
    PLATFORM="android"
    ENV="dev"
    CLEAN_CACHE=false
    SKIP_CACHE=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --build)
                RUN_BUILD=true
                shift
                ;;
            --integration)
                RUN_INTEGRATION=true
                shift
                ;;
            --platform)
                PLATFORM="$2"
                shift 2
                ;;
            --env)
                ENV="$2"
                shift 2
                ;;
            --clean-cache)
                CLEAN_CACHE=true
                shift
                ;;
            --no-cache)
                SKIP_CACHE=true
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo ""
                echo "Options:"
                echo "  --build         Run build step (APK/iOS)"
                echo "  --integration   Run integration tests"
                echo "  --platform      Platform to build for (android/ios) [default: android]"
                echo "  --env           Environment (dev/staging/production) [default: dev]"
                echo "  --clean-cache   Clean the cache before running"
                echo "  --no-cache      Skip cache usage"
                echo "  --help          Show this help message"
                echo ""
                echo "Logs are saved to: $CI_LOG_DIR/"
                echo "Cache is stored in: $CI_CACHE_DIR/"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                pause_before_exit
                exit 1
                ;;
        esac
    done
    
    # Header
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}" | tee -a "$LOG_FILE"
    echo -e "${CYAN}║         Winr Frontend Local CI Runner              ║${NC}" | tee -a "$LOG_FILE"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    print_info "Log file: $LOG_FILE"
    print_info "Environment: $ENV"
    print_info "Platform: $PLATFORM"
    echo "" | tee -a "$LOG_FILE"
    
    # Clean cache if requested
    if [ "$CLEAN_CACHE" = true ]; then
        print_status "Cleaning cache..."
        rm -rf "$CI_CACHE_DIR"
        mkdir -p "$CI_CACHE_DIR"
        print_success "Cache cleaned"
    fi
    
    # Check prerequisites
    print_section "Environment Check"
    
    if ! command_exists flutter; then
        print_error "Flutter is not installed or not in PATH"
        print_fix "Install Flutter from https://flutter.dev/docs/get-started/install"
        pause_before_exit
        exit 1
    fi
    
    print_info "Flutter version:"
    flutter --version | head -1 | tee -a "$LOG_FILE"
    
    # Step 1: Dependencies
    print_section "Dependencies"
    if ! run_step "Install Dependencies" "flutter pub get"; then
        FAILED_STEPS+=("Install Dependencies")
        print_error "Cannot continue without dependencies"
        pause_before_exit
        exit 1
    fi
    
    # Step 2: Code Generation
    print_section "Code Generation"
    
    # Try to use cache if not disabled
    if [ "$SKIP_CACHE" = false ] && restore_cached_files; then
        print_success "Using cached generated files"
    else
        if run_step "Generate Code" "flutter pub run build_runner build --delete-conflicting-outputs" true; then
            if [ "$SKIP_CACHE" = false ]; then
                cache_generated_files
            fi
        else
            FAILED_STEPS+=("Code Generation")
            print_warning "Code generation failed, but continuing..."
        fi
    fi
    
    # Step 3: Format Check
    print_section "Code Format Check"
    
    if dart format --output none --set-exit-if-changed lib/ test/ > "$CI_LOG_DIR/format_check_$TIMESTAMP.log" 2>&1; then
        print_success "Code formatting check passed"
    else
        FAILED_STEPS+=("Format Check")
        print_error "Code formatting check failed"
        analyze_format_issues
    fi
    
    # Step 4: Static Analysis
    print_section "Static Analysis"
    
    if run_step "Flutter Analyze" "flutter analyze --no-fatal-infos"; then
        print_success "No analysis issues found"
    else
        FAILED_STEPS+=("Static Analysis")
        analyze_flutter_issues
    fi
    
    # Step 5: Tests
    print_section "Unit & Widget Tests"
    
    TEST_OUTPUT="$CI_LOG_DIR/test_output_$TIMESTAMP.log"
    if flutter test --coverage --dart-define=ENV=$ENV > "$TEST_OUTPUT" 2>&1; then
        print_success "All tests passed"
        
        if [ -f "coverage/lcov.info" ]; then
            print_success "Coverage report generated at coverage/lcov.info"
            
            # Try to show coverage summary
            if command_exists lcov; then
                COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | grep -oE "[0-9]+\.[0-9]+" | tail -1)
                if [ -n "$COVERAGE" ]; then
                    print_info "Line coverage: ${COVERAGE}%"
                fi
            fi
        fi
    else
        FAILED_STEPS+=("Tests")
        print_error "Some tests failed"
        analyze_test_failures
    fi
    
    # Step 6: Build (Optional)
    if [ "$RUN_BUILD" = true ]; then
        if [ "$PLATFORM" = "android" ]; then
            print_section "Android Build"
            if run_step "Build Android APK" "flutter build apk --debug --dart-define=ENV=$ENV"; then
                APK_PATH=$(find build/app/outputs/flutter-apk/ -name "*.apk" 2>/dev/null | head -1)
                if [ -n "$APK_PATH" ]; then
                    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
                    print_info "APK size: $APK_SIZE"
                    print_info "APK location: $APK_PATH"
                fi
            else
                FAILED_STEPS+=("Android Build")
            fi
        elif [ "$PLATFORM" = "ios" ]; then
            print_section "iOS Build"
            if [[ "$OSTYPE" == "darwin"* ]]; then
                if run_step "Build iOS App" "flutter build ios --debug --no-codesign --dart-define=ENV=$ENV"; then
                    print_success "iOS build completed"
                else
                    FAILED_STEPS+=("iOS Build")
                fi
            else
                print_warning "iOS builds are only supported on macOS"
            fi
        fi
    fi
    
    # Calculate duration
    local END_TIME=$(date +%s)
    local DURATION=$((END_TIME - START_TIME))
    
    # Summary
    print_section "CI Pipeline Summary"
    
    echo "Duration: $DURATION seconds" | tee -a "$LOG_FILE"
    echo "Log files: $CI_LOG_DIR/" | tee -a "$LOG_FILE"
    
    if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
        echo -e "\n${GREEN}${BOLD}✅ ALL CHECKS PASSED!${NC}" | tee -a "$LOG_FILE"
        print_info "Your code is ready to be pushed!"
    else
        echo -e "\n${RED}${BOLD}❌ CI PIPELINE FAILED${NC}" | tee -a "$LOG_FILE"
        echo -e "\n${RED}Failed steps:${NC}" | tee -a "$LOG_FILE"
        for step in "${FAILED_STEPS[@]}"; do
            echo "  • $step" | tee -a "$LOG_FILE"
        done
        
        echo -e "\n${YELLOW}Next steps:${NC}" | tee -a "$LOG_FILE"
        echo "1. Review the error messages above" | tee -a "$LOG_FILE"
        echo "2. Check detailed logs in $CI_LOG_DIR/" | tee -a "$LOG_FILE"
        echo "3. Fix the issues and run again" | tee -a "$LOG_FILE"
        echo "4. Use --clean-cache if you encounter cache issues" | tee -a "$LOG_FILE"
    fi
    
    echo -e "\n${CYAN}Full CI log saved to: $LOG_FILE${NC}"
    
    # Pause before exit
    pause_before_exit
    
    # Exit with appropriate code
    if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run the main function
main "$@"