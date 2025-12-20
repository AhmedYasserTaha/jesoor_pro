import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/routes/app_router.dart';
import 'package:jesoor_pro/config/theme/app_theme.dart';
import 'package:jesoor_pro/config/locators/app_locator.dart' as di;
import 'package:jesoor_pro/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_cubit.dart';

class JesoorApp extends StatelessWidget {
  const JesoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginCubit>()),
        BlocProvider(create: (_) => di.sl<SignupCubit>()),
        BlocProvider(create: (_) => di.sl<ForgotPasswordCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Jesoor Pro',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}
