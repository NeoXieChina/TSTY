import 'dart:convert';

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

// 关卡内容模型
class LevelContent {
  String levelId;
  String levelName;
  String contentType;
  String contentValue;
  String pinyinText;
  String exampleWord;
  List<String> tips;
  int minScoreToPass;
  int timeLimitSeconds;

  LevelContent({
    required this.levelId,
    required this.levelName,
    required this.contentType,
    required this.contentValue,
    required this.pinyinText,
    required this.exampleWord,
    required this.tips,
    required this.minScoreToPass,
    required this.timeLimitSeconds,
  });

  factory LevelContent.fromJSON(Map<String, dynamic> json) {
    return LevelContent(
      levelId: json["levelId"] ?? "",
      levelName: json["levelName"] ?? "",
      contentType: json["contentType"] ?? "",
      contentValue: json["contentValue"] ?? "",
      pinyinText: json["pinyinText"] ?? "",
      exampleWord: json["exampleWord"] ?? "",
      tips: _parseTips(json["tips"]),
      minScoreToPass: json["minScoreToPass"] ?? 0,
      timeLimitSeconds: json["timeLimitSeconds"] ?? 0,
    );
  }
}

List<String> _parseTips(dynamic raw) {
  if (raw == null) return <String>[];

  if (raw is List) {
    final list = raw
        .map((e) => e?.toString().trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    if (list.length == 1) {
      final decoded = _tryDecodeTipsString(list.first);
      if (decoded != null) return decoded;
    }
    return list;
  }

  if (raw is String) {
    final s = raw.trim();
    if (s.isEmpty) return <String>[];

    final decoded = _tryDecodeTipsString(s);
    if (decoded != null) return decoded;

    final parts = s
        .split(RegExp(r'[\n;；,，]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts : <String>[s];
  }

  return <String>[raw.toString()];
}

List<String>? _tryDecodeTipsString(String s) {
  if (!s.startsWith('[') || !s.endsWith(']')) return null;
  try {
    final decoded = jsonDecode(s);
    if (decoded is List) {
      return decoded
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
  } catch (_) {
    final inner = s.substring(1, s.length - 1);
    final parts = inner
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isNotEmpty) return parts;
  }
  return null;
}
