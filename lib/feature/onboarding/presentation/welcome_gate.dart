import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:winr/common/components/placeholder/place_holder.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/core/apptext/app_text.dart';
import 'package:winr/feature/navigation/presentation/gate.dart';
import 'package:winr/feature/onboarding/presentation/onboarding_screen.dart';
import 'package:winr/feature/onboarding/presentation/providers/onboarding_providers.dart';

class Welcome extends HookConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirstTime = ref.watch(firstTimeCheckProvider);

    useEffect(() {
      return null;
    }, []);

    return isFirstTime.when(
      data: (bool isFirstTime) {
        return isFirstTime ? OnboardingScreen() : NavigationGate();
      },
      error: (err, stack) => const DataPlaceHolder(
        withButton: false,
        buttonText: "",
        imagePath: AppImages.errorImage,
        imageHeight: 300,
        imageWidth: 300,
        title: AppText.ohSnap,
        description: AppText.opCantComplete,
      ),
      loading: () => Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
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
