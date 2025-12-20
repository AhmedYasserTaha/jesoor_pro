import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/features/auth/login/presentation/screens/auth_screen.dart';
import 'package:jesoor_pro/features/home/presentation/screens/home_screen.dart';
import 'package:jesoor_pro/features/onboarding/onboarding_screen.dart';
import 'package:jesoor_pro/features/roots/roots_screen.dart';
import 'package:jesoor_pro/features/splash/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static GoRouter get router => _router;
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state, {
    required Widget child,
    PageTransitionType transitionType = PageTransitionType.rightToLeftWithFade,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      arguments: state.extra,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return PageTransition(
          type: transitionType,
          child: child,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          settings: RouteSettings(arguments: state.extra),
        ).buildTransitions(context, animation, secondaryAnimation, child);
      },
    );
  }

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: Routes.initial,
        pageBuilder: (context, state) {
          return _buildPageWithTransition(
            context,
            state,
            child: SplashScreen(),
            transitionType: PageTransitionType.fade,
          );
        },
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) {
          return _buildPageWithTransition(
            context,
            state,
            child: OnboardingScreen(),
            transitionType: PageTransitionType.rightToLeftWithFade,
          );
        },
      ),
      GoRoute(
        path: Routes.authScreen,
        pageBuilder: (context, state) {
          return _buildPageWithTransition(
            context,
            state,
            child: const AuthScreen(),
            transitionType: PageTransitionType.rightToLeftWithFade,
          );
        },
      ),
      GoRoute(
        path: Routes.roots,
        pageBuilder: (context, state) {
          return _buildPageWithTransition(
            context,
            state,
            child: const RootsScreen(),
            transitionType: PageTransitionType.rightToLeftWithFade,
          );
        },
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) {
          return _buildPageWithTransition(
            context,
            state,
            child: HomeScreen(),
            transitionType: PageTransitionType.rightToLeftWithFade,
          );
        },
      ),
    ],
  );
}
