import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/feature/settings/presentation/about_app.dart';
import 'package:winr/feature/settings/presentation/feedback_and_suggestions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 50),

                BugSuggestionsReport(),
                SizedBox(height: 50),
                AboutApp(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
