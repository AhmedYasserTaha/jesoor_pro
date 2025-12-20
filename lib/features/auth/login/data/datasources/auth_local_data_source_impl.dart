import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jesoor_pro/core/cache/hive_constants.dart';
import 'package:jesoor_pro/features/auth/login/data/datasources/auth_local_data_source.dart';
import 'package:jesoor_pro/features/auth/login/data/models/category_model.dart';
import 'package:jesoor_pro/features/auth/login/data/models/governorate_model.dart';
import 'package:jesoor_pro/features/auth/login/data/models/user_model.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<String> categoriesBox;
  final Box<String> categoryChildrenBox;
  final Box<String> governoratesBox;
  final Box<String> userBox;

  AuthLocalDataSourceImpl({
    required this.categoriesBox,
    required this.categoryChildrenBox,
    required this.governoratesBox,
    required this.userBox,
  });

  // Categories
  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      final jsonString = categoriesBox.get(HiveConstants.categoriesKey);
      if (jsonString == null) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final jsonList = categories.map((cat) => cat.toJson()).toList();
      await categoriesBox.put(
        HiveConstants.categoriesKey,
        jsonEncode(jsonList),
      );
    } catch (e) {
      // Silently fail - cache is not critical
    }
  }

  @override
  Future<List<CategoryModel>> getCachedCategoryChildren(int categoryId) async {
    try {
      final jsonString = categoryChildrenBox.get(categoryId.toString());
      if (jsonString == null) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheCategoryChildren(
    int categoryId,
    List<CategoryModel> children,
  ) async {
    try {
      final jsonList = children.map((child) => child.toJson()).toList();
      await categoryChildrenBox.put(
        categoryId.toString(),
        jsonEncode(jsonList),
      );
    } catch (e) {
      // Silently fail - cache is not critical
    }
  }

  // Governorates
  @override
  Future<List<GovernorateModel>> getCachedGovernorates() async {
    try {
      final jsonString = governoratesBox.get(HiveConstants.governoratesKey);
      if (jsonString == null) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map(
            (json) => GovernorateModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheGovernorates(List<GovernorateModel> governorates) async {
    try {
      final jsonList = governorates.map((gov) => gov.toJson()).toList();
      await governoratesBox.put(
        HiveConstants.governoratesKey,
        jsonEncode(jsonList),
      );
    } catch (e) {
      // Silently fail - cache is not critical
    }
  }

  // User
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = userBox.get(HiveConstants.userKey);
      if (jsonString == null) return null;
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await userBox.put(HiveConstants.userKey, jsonEncode(user.toJson()));
    } catch (e) {
      // Silently fail - cache is not critical
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await userBox.delete(HiveConstants.userKey);
    } catch (e) {
      // Silently fail
    }
  }

  // Cache management
  @override
  Future<void> clearAllCache() async {
    try {
      await Future.wait([
        categoriesBox.clear(),
        categoryChildrenBox.clear(),
        governoratesBox.clear(),
        userBox.clear(),
      ]);
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<bool> hasCachedCategories() async {
    try {
      return categoriesBox.containsKey(HiveConstants.categoriesKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasCachedGovernorates() async {
    try {
      return governoratesBox.containsKey(HiveConstants.governoratesKey);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasCachedUser() async {
    try {
      return userBox.containsKey(HiveConstants.userKey);
    } catch (e) {
      return false;
    }
  }
}
