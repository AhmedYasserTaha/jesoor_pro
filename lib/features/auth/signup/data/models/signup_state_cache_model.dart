class SignupStateCacheModel {
  final String? educationSystem;
  final String? educationStage;
  final String? educationGrade;
  final int? selectedCategoryId;
  final List<int> selectedCategoryChildrenIds;

  SignupStateCacheModel({
    this.educationSystem,
    this.educationStage,
    this.educationGrade,
    this.selectedCategoryId,
    this.selectedCategoryChildrenIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'educationSystem': educationSystem,
      'educationStage': educationStage,
      'educationGrade': educationGrade,
      'selectedCategoryId': selectedCategoryId,
      'selectedCategoryChildrenIds': selectedCategoryChildrenIds,
    };
  }

  factory SignupStateCacheModel.fromJson(Map<String, dynamic> json) {
    return SignupStateCacheModel(
      educationSystem: json['educationSystem'] as String?,
      educationStage: json['educationStage'] as String?,
      educationGrade: json['educationGrade'] as String?,
      selectedCategoryId: json['selectedCategoryId'] as int?,
      selectedCategoryChildrenIds:
          (json['selectedCategoryChildrenIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}
