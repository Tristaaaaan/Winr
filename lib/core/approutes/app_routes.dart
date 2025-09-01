import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../feature/home/presentation/screen/homescreen.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
    ),
  ],
);
