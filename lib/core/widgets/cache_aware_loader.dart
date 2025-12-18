import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/shimmer_loading.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';

/// Widget that shows appropriate loading state based on cache status
class CacheAwareLoader extends StatelessWidget {
  final AuthStatus status;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String? errorMessage;

  const CacheAwareLoader({
    super.key,
    required this.status,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AuthStatus.loading:
        return loadingWidget ?? const ShimmerList();
      case AuthStatus.error:
        return errorWidget ??
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage ?? 'حدث خطأ',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
      case AuthStatus.cached:
      case AuthStatus.success:
      case AuthStatus.initial:
        return child;
    }
  }
}
