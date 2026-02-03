// 单元进度响应模型
class UnitProgressResponse {
  String unitId;
  String unitName;
  int totalLevels;
  int completedLevels;
  double completionRate;
  double avgScore;
  int totalStars;
  List<LevelProgressItem> levels;

  UnitProgressResponse({
    required this.unitId,
    required this.unitName,
    required this.totalLevels,
    required this.completedLevels,
    required this.completionRate,
    required this.avgScore,
    required this.totalStars,
    required this.levels,
  });

  factory UnitProgressResponse.fromJSON(Map<String, dynamic> json) {
    return UnitProgressResponse(
      unitId: json["unitId"] ?? "",
      unitName: json["unitName"] ?? "",
      totalLevels: json["totalLevels"] ?? 0,
      completedLevels: json["completedLevels"] ?? 0,
      completionRate: (json["completionRate"] ?? 0).toDouble(),
      avgScore: (json["avgScore"] ?? 0).toDouble(),
      totalStars: json["totalStars"] ?? 0,
      levels: json["levels"] != null
          ? (json["levels"] as List).map((item) {
              return LevelProgressItem.fromJSON(item);
            }).toList()
          : [],
    );
  }
}

// 关卡进度项模型
class LevelProgressItem {
  String levelId;
  String levelName;
  String status;
  int bestScore;
  int stars;
  int attempts;
  String completedAt;

  LevelProgressItem({
    required this.levelId,
    required this.levelName,
    required this.status,
    required this.bestScore,
    required this.stars,
    required this.attempts,
    required this.completedAt,
  });

  factory LevelProgressItem.fromJSON(Map<String, dynamic> json) {
    return LevelProgressItem(
      levelId: json["levelId"] ?? "",
      levelName: json["levelName"] ?? "",
      status: json["status"] ?? "",
      bestScore: json["bestScore"] ?? 0,
      stars: json["stars"] ?? 0,
      attempts: json["attempts"] ?? 0,
      completedAt: json["completedAt"] ?? "",
    );
  }
}