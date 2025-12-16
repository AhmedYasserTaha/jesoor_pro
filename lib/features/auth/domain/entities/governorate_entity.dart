import 'package:equatable/equatable.dart';

class GovernorateEntity extends Equatable {
  final int id;
  final String name;
  final String nameEn;
  final String createdAt;
  final String updatedAt;

  const GovernorateEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, name, nameEn, createdAt, updatedAt];
}

