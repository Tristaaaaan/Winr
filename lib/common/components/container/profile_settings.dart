import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/core/appthemes/app_themes.dart';

class ProfileSettingsContainer extends ConsumerWidget {
  final bool withSwitch;
  final String title;
  final IconData icon;
  final void Function(bool)? onChanged;
  final void Function()? onTap;
  final WidgetRef? ref;
  final String? containerKey;
  final bool? withCaption;
  final bool? withBorder;
  final bool receiveNotif;

  const ProfileSettingsContainer({
    super.key,
    required this.withSwitch,
    required this.title,
    required this.icon,
    this.onTap,
    this.ref,
    this.withCaption = false,
    this.onChanged,
    this.containerKey,
    this.withBorder = true,
    this.receiveNotif = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: withBorder!
              ? BoxDecoration(border: Border(bottom: BorderSide(width: 1)))
              : null,
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  !withCaption!
                      ? Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Expanded(
                                child: Text(
                                  containerKey == "notificationKey"
                                      ? "Enabling this will notify you when a sample containing infested berries is detected."
                                      : "Enabling this will allow you to detect using image sample from your device.",
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              if (withSwitch)
                Switch(
                  key: Key(containerKey!),
                  inactiveThumbColor: Theme.of(context).colorScheme.primary,
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: .48);
                    }
                    if (states.contains(WidgetState.selected)) {
                      return null;
                    }
                    return Theme.of(context).colorScheme.primary;
                  }),
                  value: ref.watch(themeNotifierProvider),
                  onChanged: onChanged,
                ),
              if (!withSwitch) Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

final detectionStatusProvider =
    StateNotifierProvider<DetectionStatusNotifier, bool>((ref) {
      return DetectionStatusNotifier();
    });

class DetectionStatusNotifier extends StateNotifier<bool> {
  DetectionStatusNotifier() : super(false);

  void toggle(bool value) {
    state = value;
  }

  void toggleSwitch() {
    state = !state;
  }
}
