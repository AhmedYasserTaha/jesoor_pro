import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:jesoor_pro/config/routes/app_router.dart';
import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/config/locators/app_locator.dart' as di;
import 'package:jesoor_pro/core/storage/token_storage.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_governorates_use_case.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Start animation
    _animationController.forward();

    // Preload critical data in background (non-blocking)
    _preloadCriticalData();

    // Check if user is logged in and navigate accordingly
    _checkAuthAndNavigate();
  }

  // Preload critical data (categories and governorates) for faster signup
  void _preloadCriticalData() {
    // Preload in background - don't block UI
    Future.microtask(() async {
      try {
        // Preload in parallel - don't wait for completion
        unawaited(
          Future.wait([
                di.sl<GetCategoriesUseCase>()(NoParams()),
                di.sl<GetGovernoratesUseCase>()(NoParams()),
              ])
              .then((_) {
                // Data preloaded successfully (cached or fetched)
              })
              .catchError((_) {
                // Silently fail - preloading is not critical
              }),
        );
      } catch (e) {
        // Silently fail - preloading is not critical
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation to complete (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      final tokenStorage = di.sl<TokenStorage>();
      final hasToken = await tokenStorage.hasToken();

      if (mounted) {
        if (hasToken) {
          // User is logged in, go to roots screen
          context.go(Routes.roots);
        } else {
          // User is not logged in, go to onboarding
          context.go(Routes.onboarding);
        }
      }
    } catch (e) {
      // If there's an error checking token, go to onboarding
      if (mounted) {
        context.go(Routes.onboarding);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF092032), // Dark blue background
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LMS Book Logo
              _buildBookIcon(),
              const SizedBox(height: 20),
              // LMS Text
              const Text(
                'L M S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFFDB022),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Book pages effect
          Positioned(
            left: 0,
            right: 0,
            top: 15,
            bottom: 15,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: const Color(0xFF092032), width: 3),
                ),
              ),
            ),
          ),
          // Book lines
          Positioned(
            left: 25,
            right: 25,
            top: 30,
            child: Column(
              children: [
                Container(height: 2, color: const Color(0xFF092032)),
                const SizedBox(height: 8),
                Container(height: 2, color: const Color(0xFF092032)),
                const SizedBox(height: 8),
                Container(height: 2, color: const Color(0xFF092032)),
                const SizedBox(height: 8),
                Container(height: 2, color: const Color(0xFF092032)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
