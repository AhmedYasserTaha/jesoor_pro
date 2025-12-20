import 'package:hive_flutter/hive_flutter.dart';
import 'package:jesoor_pro/core/cache/hive_constants.dart';

class HiveHelper {
  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Open boxes (using String type for JSON storage)
    await Future.wait([
      Hive.openBox<String>(HiveConstants.categoriesBox),
      Hive.openBox<String>(HiveConstants.categoryChildrenBox),
      Hive.openBox<String>(HiveConstants.governoratesBox),
      Hive.openBox<String>(HiveConstants.userBox),
      Hive.openBox<String>(HiveConstants.signupStateBox),
    ]);
  }

  static Box<String> getCategoriesBox() {
    return Hive.box<String>(HiveConstants.categoriesBox);
  }

  static Box<String> getCategoryChildrenBox() {
    return Hive.box<String>(HiveConstants.categoryChildrenBox);
  }

  static Box<String> getGovernoratesBox() {
    return Hive.box<String>(HiveConstants.governoratesBox);
  }

  static Box<String> getUserBox() {
    return Hive.box<String>(HiveConstants.userBox);
  }

  static Box<String> getSignupStateBox() {
    return Hive.box<String>(HiveConstants.signupStateBox);
  }
}
