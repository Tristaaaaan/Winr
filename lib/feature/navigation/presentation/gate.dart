import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/navbar/custom_navbar.dart';
import 'package:winr/feature/history/presentation/history_screen.dart';
import 'package:winr/feature/history/presentation/providers/result_provider.dart';
import 'package:winr/feature/records/presentation/widgets/add_record.dart';
import 'package:winr/feature/settings/presentation/settings_screen.dart';

import '../../history/presentation/providers/history_controller.dart';
import '../../records/presentation/providers/image_providers.dart';

class NavigationGate extends ConsumerStatefulWidget {
  const NavigationGate({super.key});

  @override
  ConsumerState<NavigationGate> createState() => _NavigationGateState();
}

class _NavigationGateState extends ConsumerState<NavigationGate> {
  int _selectedIndex = 0;
  final bool _isHolding = false;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _screens => [HistoryScreen(), const SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyControllerProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // main screen
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _screens[_selectedIndex],
          ),

          // ✅ FAB above nav bar (only on HistoryScreen)
          if (_selectedIndex == 0 &&
              historyState.maybeWhen(loaded: (_) => true, orElse: () => false))
            Positioned(
              right: 20,
              bottom:
                  MediaQuery.of(context).padding.bottom +
                  100, // dynamically adjusts
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: .5),
                onPressed: () {
                  ref.read(isImageRemovedProvider.notifier).state = false;
                  ref.read(uploadImageNameProvider.notifier).state = [];
                  ref.read(uploadImagePathProvider.notifier).state = [];
                  ref.read(uploadImagePathNameProvider.notifier).state = [];
                  ref.read(nameProvider.notifier).state = "";
                  ref.read(desiredWinRateProvider.notifier).state = "0";
                  ref.read(numberOfBattlesProvider.notifier).state = "0";
                  ref.read(winRateProvider.notifier).state = "0";
                  showRecordSheet(context, false, null);
                },
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          // bottom nav bar
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: _isHolding ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: _isHolding,
                child: CustomBottomNavBar(
                  currentIndex: _selectedIndex,
                  onTap: _onTabSelected,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
