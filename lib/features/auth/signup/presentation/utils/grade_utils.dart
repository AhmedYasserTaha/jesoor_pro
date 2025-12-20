/// Utility class for generating grades based on education stage
class GradeUtils {
  static List<String> getGradesForStage(String stage) {
    switch (stage) {
      case 'Primary':
        return List.generate(6, (i) => '${i + 1} ابتدائي');
      case 'Preparatory':
        return List.generate(3, (i) => '${i + 1} إعدادي');
      case 'Secondary':
        return List.generate(3, (i) => '${i + 1} ثانوي');
      default:
        return [];
    }
  }
}
