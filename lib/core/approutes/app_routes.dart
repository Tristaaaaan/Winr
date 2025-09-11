import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:winr/feature/onboarding/presentation/onboarding_screen.dart';
import 'package:winr/feature/onboarding/presentation/welcome_gate.dart';
import 'package:winr/feature/settings/presentation/version_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Welcome();
      },
    ),
    GoRoute(
      path: '/version',
      builder: (BuildContext context, GoRouterState state) {
        return VersionScreen();
      },
    ),
    GoRoute(
      path: '/winrintro',
      builder: (BuildContext context, GoRouterState state) {
        // ✅ optional bool (defaults to false)
        final isSettings = state.extra as bool? ?? false;
        return OnboardingScreen(isSettings: isSettings);
      },
    ),
  ],
);
