import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_state.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_cubit.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_state.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Static variable to cache loading state across widget rebuilds
  static bool _isDataLoaded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // If data was already loaded before, skip loading animation
    if (_isDataLoaded) {
      _isLoading = false;
      return;
    }

    // Simulate data loading only on first visit
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isDataLoaded = true; // Mark data as loaded
        });
      }
    });
  }

  final List<Map<String, String>> gridItems = const [
    {'image': 'assets/icons/streaming1.png', 'title': 'المنتدي'},
    {'image': 'assets/icons/streaming2.png', 'title': 'حصص لايف'},
    {'image': 'assets/icons/streaming3.png', 'title': 'حصص مسجله'},
    {'image': 'assets/icons/streaming6.png', 'title': 'الامتحانات'},
    {'image': 'assets/icons/streaming7.png', 'title': 'متجر الكتب'},
    {'image': 'assets/icons/streaming8.png', 'title': 'واجب منزلي'},
  ];

  String _buildEducationText(SignupState state) {
    final grade = state.educationGrade ?? '';
    final stage = state.educationStage ?? '';
    final system = state.educationSystem ?? '';

    if (grade.isEmpty && stage.isEmpty && system.isEmpty) {
      return "الصف الأول < ثانوية عامة > تعليم عام";
    }

    final parts = <String>[];
    if (grade.isNotEmpty) parts.add(grade);
    if (stage.isNotEmpty) parts.add(stage);
    if (system.isNotEmpty) parts.add(system);

    return parts.join(' < ');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<SignupCubit, SignupState>(
          builder: (context, signupState) {
            final userName =
                loginState.user?.username ??
                signupState.user?.username ??
                "محمد الشافعي";
            final educationText = _buildEducationText(signupState);

            return Scaffold(
              appBar: AppBar(
                title: const Text(Strings.home),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              body: _isLoading
                  ? _buildShimmerLoading(screenWidth, screenHeight)
                  : _buildContent(
                      screenWidth,
                      screenHeight,
                      userName,
                      educationText,
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    double screenWidth,
    double screenHeight,
    String userName,
    String educationText,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.accent,
                  radius: screenWidth * 0.08,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: screenWidth * 0.08,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "مرحبا بك",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/porde.png",
            width: double.infinity,
            height: screenHeight * 0.25,
            fit: BoxFit.cover,
          ),
          SizedBox(height: screenHeight * 0.025),
          RoundedRectDottedCard(text: educationText, screenWidth: screenWidth),
          SizedBox(height: screenHeight * 0.025),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: screenWidth * 0.01,
              childAspectRatio: screenWidth / (screenHeight * 0.43),
            ),
            itemBuilder: (context, index) {
              final item = gridItems[index];
              return Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: screenWidth * 0.2,
                    width: screenWidth * 0.2,
                    decoration: BoxDecoration(
                      color: const Color(0xffE8EEFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      item['image']!,
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    item['title']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // User greeting shimmer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: const Color(0xFFE0E0E0),
                  highlightColor: Colors.white,
                  period: const Duration(milliseconds: 1200),
                  child: Container(
                    width: screenWidth * 0.16,
                    height: screenWidth * 0.16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color(0xFFE0E0E0),
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 1200),
                        child: Container(
                          width: screenWidth * 0.35,
                          height: screenWidth * 0.045,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Shimmer.fromColors(
                        baseColor: const Color(0xFFE0E0E0),
                        highlightColor: Colors.white,
                        period: const Duration(milliseconds: 1200),
                        child: Container(
                          width: screenWidth * 0.45,
                          height: screenWidth * 0.04,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Image banner shimmer with gradient effect
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: Colors.white,
              period: const Duration(milliseconds: 1200),
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          // Education card shimmer with icon placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: Colors.white,
              period: const Duration(milliseconds: 1200),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          // Grid items shimmer with icon placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gridItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: screenWidth * 0.01,
                childAspectRatio: screenWidth / (screenHeight * 0.43),
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE8EEFC),
                      highlightColor: Colors.white,
                      period: const Duration(milliseconds: 1200),
                      child: Container(
                        alignment: Alignment.center,
                        height: screenWidth * 0.2,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EEFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Shimmer.fromColors(
                      baseColor: const Color(0xFFE0E0E0),
                      highlightColor: Colors.white,
                      period: const Duration(milliseconds: 1200),
                      child: Container(
                        width: screenWidth * 0.22,
                        height: screenWidth * 0.035,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}

class RoundedRectDottedCard extends StatelessWidget {
  final String text;
  const RoundedRectDottedCard({
    super.key,
    required this.text,
    required double screenWidth,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DottedBorder(
        options: const RoundedRectDottedBorderOptions(
          dashPattern: [8, 4],
          strokeWidth: 1.5,
          radius: Radius.circular(16),
          color: AppColors.primary,
          padding: EdgeInsets.all(0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
