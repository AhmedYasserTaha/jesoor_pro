import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final int? parentId;
  final String createdAt;
  final String updatedAt;
  final List<CategoryEntity> children;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.status,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    this.children = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        parentId,
        createdAt,
        updatedAt,
        children,
      ];
}
