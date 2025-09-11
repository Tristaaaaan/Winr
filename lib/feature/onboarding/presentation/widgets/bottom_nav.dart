import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:winr/core/apptext/app_text.dart';
import 'package:winr/feature/onboarding/presentation/providers/onboarding_providers.dart';

class BottomNavSheet extends ConsumerWidget {
  final PageController controller;
  final bool isSettings;
  const BottomNavSheet({
    super.key,
    required this.controller,
    this.isSettings = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final lastPage = ref.watch(lastPageProvider); // ✅ must watch this
    final isGetStartedLoading = ref.watch(isGetStartedLoadingProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      child: Stack(
        children: [
          if (!isSettings && currentPage < 3)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: const Text("Skip"),
                onPressed: () {
                  // Jump to last page (index 3)
                  controller.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  ref.read(lastPageProvider.notifier).state = true;
                },
              ),
            ),
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: 4, // ✅ fixed to match pages
              onDotClicked: (int index) {
                ref.read(lastPageProvider.notifier).state = (index == 3);
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                dotColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
                activeDotColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (!isSettings)
            Align(
              alignment: Alignment.centerRight,
              child: isGetStartedLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: isGetStartedLoading
                          ? null
                          : () async {
                              final loadFirstTime = ref.read(
                                isGetStartedLoadingProvider.notifier,
                              );

                              if (!lastPage) {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                                if (currentPage == 2) {
                                  ref.read(lastPageProvider.notifier).state =
                                      true;
                                }
                              } else {
                                loadFirstTime.state = true;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool("isFirstTime", false);
                                loadFirstTime.state = false;
                              }
                            },
                      child: lastPage
                          ? const Text(
                              AppText.getStarted,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : const Text(AppText.next),
                    ),
            ),
        ],
      ),
    );
  }
}
