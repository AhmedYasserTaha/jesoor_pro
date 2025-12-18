import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Grid items data
  final List<Map<String, String>> gridItems = const [
    {'image': 'assets/icons/streaming1.png', 'title': 'المنتدي'},
    {'image': 'assets/icons/streaming2.png', 'title': 'حصص لايف'},
    {'image': 'assets/icons/streaming3.png', 'title': 'حصص مسجله'},
    {'image': 'assets/icons/streaming6.png', 'title': 'الامتحانات'},
    {'image': 'assets/icons/streaming7.png', 'title': 'متجر الكتب'},
    {'image': 'assets/icons/streaming8.png', 'title': 'واجب منزلي'},
  ];

  String _buildEducationText(AuthState state) {
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final userName = state.user?.username ?? "محمد الشافعي";
        final educationText = _buildEducationText(state);

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.home),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.accent,
                        radius: 40,
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "مرحبا بك",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Image.asset(
                  "assets/images/porde.png",
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                SizedBox(height: 10),

                RoundedRectDottedCard(text: educationText),

                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: gridItems.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: .7,
                  ),
                  itemBuilder: (context, index) {
                    final item = gridItems[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xffE8EEFC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            item['image']!,
                            width: 55,
                            height: 55,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RoundedRectDottedCard extends StatelessWidget {
  final String text;

  const RoundedRectDottedCard({super.key, required this.text});

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
                Flexible(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
