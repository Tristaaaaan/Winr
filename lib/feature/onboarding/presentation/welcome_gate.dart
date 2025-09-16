import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winr/common/components/placeholder/place_holder.dart';
import 'package:winr/config/app_config.dart';
import 'package:winr/config/app_environments.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/core/apptext/app_text.dart';
import 'package:winr/core/appthemes/app_themes.dart';
import 'package:winr/feature/navigation/presentation/gate.dart';
import 'package:winr/feature/onboarding/presentation/onboarding_screen.dart';
import 'package:winr/feature/onboarding/presentation/providers/onboarding_providers.dart';

Future<void> initializeSettings(WidgetRef ref, BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool theme = prefs.getBool('theme') ?? false;

  final themeNotifier = ref.read(themeNotifierProvider.notifier);
  themeNotifier.setTheme(theme);

  if (AppConfig.environment == Flavors.production) {
    final newVersion = NewVersionPlus(
      androidId: 'com.tristans.winr',
      androidPlayStoreCountry: "en_US",
      androidHtmlReleaseNotes: true,
    );
    if (context.mounted) {
      await advancedStatusCheck(newVersion, context);
    }
  }
}

Future<void> advancedStatusCheck(
  NewVersionPlus newVersion,
  BuildContext context,
) async {
  final status = await newVersion.getVersionStatus();
  if (status != null) {
    if (status.localVersion != status.storeVersion) {
      if (context.mounted) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Time for an Update!'),
                content: const Text(
                  'We’ve got a new version ready for you. Update now to enjoy the latest improvements.',
                ),
                actions: [
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      Uri url = Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.tristans.suri",
                      );

                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              ),
        );
      }
    }
  }
}

class Welcome extends HookConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      initializeSettings(ref, context);
      return null;
    }, []);

    final isFirstTime = ref.watch(firstTimeCheckProvider);

    useEffect(() {
      return null;
    }, []);

    return isFirstTime.when(
      data: (bool isFirstTime) {
        return isFirstTime ? OnboardingScreen() : NavigationGate();
      },
      error:
          (err, stack) => const DataPlaceHolder(
            withButton: false,
            buttonText: "",
            imagePath: AppImages.errorImage,
            imageHeight: 300,
            imageWidth: 300,
            title: AppText.ohSnap,
            description: AppText.opCantComplete,
          ),
      loading:
          () => Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  LoadingAnimationWidget.stretchedDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
