import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';

class LoadingWidget extends StatefulWidget {
  final Color? color;
  final double? strokeWidth;
  final double? size;

  const LoadingWidget({super.key, this.color, this.strokeWidth, this.size});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.size ?? 50,
            height: widget.size ?? 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.color ?? AppColors.primary).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.color ?? AppColors.primary,
              ),
              strokeWidth: widget.strokeWidth ?? 4.0,
              backgroundColor: (widget.color ?? AppColors.primary).withOpacity(
                0.1,
              ),
            ),
          );
        },
      ),
    );
  }
}
