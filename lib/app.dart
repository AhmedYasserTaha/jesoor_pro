import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/routes/app_router.dart';
import 'package:jesoor_pro/config/theme/app_theme.dart';
import 'package:jesoor_pro/config/locators/app_locator.dart' as di;
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';

class JesoorApp extends StatelessWidget {
  const JesoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<AuthCubit>())],
      child: MaterialApp.router(
        title: 'Jesoor Pro',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
