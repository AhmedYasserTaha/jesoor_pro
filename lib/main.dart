import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/app.dart';
import 'package:jesoor_pro/config/locators/app_locator.dart' as di;
import 'package:jesoor_pro/core/cache/hive_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive before dependency injection
  await HiveHelper.initHive();

  // Initialize dependency injection
  await di.init();

  Bloc.observer = MyBlocObserver();

  runApp(const JesoorApp());
}

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }
}
