import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import 'package:jesoor_pro/config/theme/app_text_styles.dart';

class AuthTabBar extends StatelessWidget {
  final TabController tabController;

  const AuthTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.tabBarMargin,
      ),
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        labelStyle: AppTextStyles.tabLabelStyle,
        unselectedLabelStyle: AppTextStyles.tabUnselectedLabelStyle,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        tabs: const [
          Tab(text: 'تسجيل الدخول'),
          Tab(text: 'إنشاء حساب'),
        ],
      ),
    );
  }
}
