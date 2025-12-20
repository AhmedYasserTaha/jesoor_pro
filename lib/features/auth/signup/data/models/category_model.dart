import 'package:jesoor_pro/features/auth/signup/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.status,
    super.parentId,
    required super.createdAt,
    required super.updatedAt,
    super.children = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      parentId: json['parent_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      children: json['children'] != null && json['children'] is List
          ? (json['children'] as List)
                .map(
                  (child) =>
                      CategoryModel.fromJson(child as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'parent_id': parentId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'children': children
          .map((child) => (child as CategoryModel).toJson())
          .toList(),
    };
  }
}
