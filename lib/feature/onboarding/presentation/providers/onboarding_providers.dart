import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lastPageProvider = StateProvider.autoDispose<bool>((ref) => false);
final currentPageProvider = StateProvider<int>((ref) => 0);
final isGetStartedLoadingProvider = StateProvider<bool>((ref) => false);
final firstTimeCheckProvider = StreamProvider.autoDispose<bool>((ref) async* {
  // Emit initial value immediately
  final prefs = await SharedPreferences.getInstance();
  bool currentValue = prefs.getBool('isFirstTime') ?? true;
  yield currentValue;

  // Then check every second
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    final newValue = prefs.getBool('isFirstTime') ?? true;

    // Only yield if the value has changed
    if (newValue != currentValue) {
      currentValue = newValue;
      yield currentValue;
    }
  }
});
