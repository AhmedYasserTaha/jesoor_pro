/// Utility class for generating grades based on education stage
class GradeUtils {
  static List<String> getGradesForStage(String stage) {
    switch (stage) {
      case 'Primary':
        return List.generate(6, (i) => '${i + 1} Primary');
      case 'Preparatory':
        return List.generate(3, (i) => '${i + 1} Preparatory');
      case 'Secondary':
        return List.generate(3, (i) => '${i + 1} Secondary');
      default:
        return [];
    }
  }
}
