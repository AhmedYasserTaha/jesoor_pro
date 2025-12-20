import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/config/locators/app_locator.dart' as di;
import 'package:jesoor_pro/core/storage/token_storage.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/core/widgets/loading_widget.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_governorates_use_case.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_cubit.dart';

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
  Future<void> _preloadCriticalData() async {
    try {
      // Load in parallel - this will use cache-first strategy
      // If cache exists, it returns immediately. If not, it fetches and caches.
      await Future.wait([
        di.sl<GetCategoriesUseCase>()(NoParams()),
        di.sl<GetGovernoratesUseCase>()(NoParams()),
      ]).timeout(const Duration(seconds: 5));
    } on TimeoutException {
      // If timeout, continue anyway - cache will be used later
      // TimeoutException is caught separately to handle timeout gracefully
    } catch (e) {
      // Silently fail - preloading is not critical, cache will be used later
    }
  }

  Future<void> _checkAuthAndNavigate() async {
    // Preload data first (this ensures cache is populated)
    await _preloadCriticalData();

    // Wait for animation to complete (minimum 3 seconds for smooth UX)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      final tokenStorage = di.sl<TokenStorage>();
      final hasToken = await tokenStorage.hasToken();

      if (mounted) {
        if (hasToken) {
          // User is logged in, load cached user data immediately
          try {
            final loginCubit = context.read<LoginCubit>();
            await loginCubit.loadCachedUser();
          } catch (e) {
            // If loading cached user fails, continue anyway
          }
          // Navigate to roots screen (main app)
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
              const SizedBox(height: 40),
              // Loading Indicator
              _buildLoadingIndicator(),
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

  Widget _buildLoadingIndicator() {
    return const LoadingWidget(
      color: Color(0xFFFDB022),
      size: 50,
      strokeWidth: 4.0,
    );
  }
}
