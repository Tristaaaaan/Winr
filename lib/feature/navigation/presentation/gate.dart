import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/ad/banner_ad.dart';
import 'package:winr/common/components/navbar/custom_navbar.dart';
import 'package:winr/feature/history/presentation/history_screen.dart';
import 'package:winr/feature/history/presentation/providers/history_states.dart';
import 'package:winr/feature/history/presentation/providers/result_provider.dart';
import 'package:winr/feature/records/presentation/widgets/add_record.dart';
import 'package:winr/feature/settings/presentation/settings_screen.dart';

import '../../history/presentation/providers/history_controller.dart';
import '../../records/presentation/providers/record_providers.dart';

final historyScrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});

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

  List<Widget> get _screens => [const HistoryScreen(), const SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyControllerProvider);
    final showScrollUp = ref.watch(showScrollUpProvider);

    final showHistoryButtons =
        _selectedIndex == 0 &&
        historyState.maybeWhen(loaded: (_) => true, orElse: () => false);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const BannerAdWidget(),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            layoutBuilder:
                (currentChild, previousChildren) => Stack(
                  children: [
                    if (currentChild != null) currentChild,
                    ...previousChildren,
                  ],
                ),
            child: _screens[_selectedIndex],
          ),

          // ✅ FAB group (only on HistoryScreen)
          if (showHistoryButtons)
            Positioned(
              bottom: 150,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // scroll-up button with fade in/out
                  AnimatedOpacity(
                    opacity: showScrollUp ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !showScrollUp,
                      child: FloatingActionButton(
                        heroTag: 'scrollUp',
                        elevation: 0,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .5),
                        onPressed: () {
                          final controller = ref.read(
                            historyScrollControllerProvider,
                          );
                          if (controller.hasClients) {
                            controller.animateTo(
                              0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: Icon(
                          Icons.arrow_upward_outlined,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  FloatingActionButton(
                    heroTag: 'addRecord',
                    elevation: 0,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .5),
                    onPressed: () {
                      // reset providers before showing sheet
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
                ],
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
