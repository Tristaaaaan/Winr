import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/feature/settings/presentation/widgets/about_app.dart';
import 'package:winr/feature/settings/presentation/widgets/configuration.dart';
import 'package:winr/feature/settings/presentation/widgets/feedback_and_suggestions.dart';

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
                AppConfiguration(),
                SizedBox(height: 25),
                BugSuggestionsReport(),
                SizedBox(height: 25),
                AboutApp(),
                SizedBox(height: 50),
              ]),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 25),
            ),
          ],
        ),
      ),
    );
  }
}
