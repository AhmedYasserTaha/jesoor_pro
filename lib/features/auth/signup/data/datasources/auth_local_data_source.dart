import 'package:jesoor_pro/features/auth/signup/data/models/category_model.dart';
import 'package:jesoor_pro/features/auth/signup/data/models/governorate_model.dart';
import 'package:jesoor_pro/features/auth/signup/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  // Categories
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>> getCachedCategoryChildren(int categoryId);
  Future<void> cacheCategoryChildren(
    int categoryId,
    List<CategoryModel> children,
  );

  // Governorates
  Future<List<GovernorateModel>> getCachedGovernorates();
  Future<void> cacheGovernorates(List<GovernorateModel> governorates);

  // User
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();

  // Cache management
  Future<void> clearAllCache();
  Future<bool> hasCachedCategories();
  Future<bool> hasCachedGovernorates();
  Future<bool> hasCachedUser();
}
