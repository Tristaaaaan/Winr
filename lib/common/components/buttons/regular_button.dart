import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'loading_state_notifier.dart';

class RegularButton extends ConsumerWidget {
  final bool? withIcon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final String buttonKey;
  final bool? withoutLoading;
  final void Function()? onTap;
  final bool? suffixIcon;
  final bool? withBorder;
  final double width;
  const RegularButton({
    super.key,
    this.withBorder = false,
    this.withIcon = true,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.buttonKey,
    this.withoutLoading = false,
    this.onTap,
    this.suffixIcon = true,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(regularButtonLoadingProvider)[buttonKey] ?? false;
    return Container(
      height: 55,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: withBorder!
            ? Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
                width: 1,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: withoutLoading!
              ? onTap
              : isLoading
              ? () {}
              : () async {
                  onTap!();
                },
          child: Row(
            children: [
              // if (withIcon == true)
              //   SvgPicture.asset(AppImages.googleLogo, height: 20, width: 20),
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.stretchedDots(
                          color: withIcon == true
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          size: 30,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (suffixIcon!)
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                        ],
                      ),
              ),
              if (withIcon == true) const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
