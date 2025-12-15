import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jesoor_pro/config/routes/app_router.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static GoRouter get router => _router;
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state, {
    required Widget child,
    PageTransitionType transitionType = PageTransitionType.fade,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      arguments: state.extra,
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return PageTransition(
          type: transitionType,
          child: child,
          duration: Duration(milliseconds: 300),
          settings: RouteSettings(arguments: state.extra),
        ).buildTransitions(context, animation, secondaryAnimation, child);
      },
    );
  }

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      // GoRoute(
      //   path: AppRoutes.initial,
      //   pageBuilder: (context, state) {
      //     return _buildPageWithTransition(
      //       context,
      //       state,
      //       child: SplashScreen(),
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.options,
      //   pageBuilder: (context, state) {
      //     return _buildPageWithTransition(
      //       context,
      //       state,
      //       child: LanguageScreen(),
      //     );
      //   },
      // ),
    ],
  );
}
