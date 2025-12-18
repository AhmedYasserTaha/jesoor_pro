import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 60,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerLoading(
            width: double.infinity,
            height: itemHeight,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;

  const ShimmerCard({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: width ?? double.infinity,
      height: height ?? 100,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
