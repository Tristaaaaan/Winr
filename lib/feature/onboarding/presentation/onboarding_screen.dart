import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/core/apptext/app_text.dart';
import 'package:winr/feature/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:winr/feature/onboarding/presentation/widgets/bottom_nav.dart';
import 'package:winr/feature/onboarding/presentation/widgets/info_container.dart';

class OnboardingScreen extends ConsumerWidget {
  final bool isSettings;
  OnboardingScreen({super.key, this.isSettings = false});
  final controller = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: isSettings
          ? AppBar(centerTitle: true, title: const Text(AppText.winr101))
          : null,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 700,
              child: PageView(
                onPageChanged: (index) {
                  ref.read(currentPageProvider.notifier).state = index;
                  ref.read(lastPageProvider.notifier).state =
                      (index == 3); // ✅ last page is index 3
                },
                controller: controller,
                physics: const BouncingScrollPhysics(),
                children: [
                  AppInfo(
                    imagePath: AppImages.thinking,
                    title: "What's Winr?",
                    description1: AppText.whatsWinr1,
                    description2: AppText.whatsWinr2,
                  ),
                  AppInfo(
                    imagePath: AppImages.workHow,
                    title: "How does it work?",
                    description1: AppText.howWinr1,
                    description2: AppText.howWinr2,
                  ),
                  AppInfo(
                    imagePath: AppImages.useHow,
                    title: "How to use it?",
                    description1: AppText.winrStep1,
                    description2: AppText.winrStep2,
                    description3: AppText.winrStep3,
                  ),
                  AppInfo(
                    imagePath: AppImages.winr,
                    title: "Winr",
                    description1: AppText.winrDesc,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacing before button
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 4, // ✅ fixed to match pages
                onDotClicked: (int index) {
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
          ],
        ),
      ),
      bottomSheet: BottomNavSheet(
        controller: controller,
        isSettings: isSettings,
      ),
    );
  }
}
