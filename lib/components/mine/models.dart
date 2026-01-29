class MineUserInfo {
  final String name;
  final String gender;
  final int age;
  final String grade;
  final String school;
  final int learningDays;

  const MineUserInfo({
    required this.name,
    required this.gender,
    required this.age,
    required this.grade,
    required this.school,
    required this.learningDays,
  });
}

class MineStats {
  final int completedLevels;
  final int accuracy;
  final int flowers;

  const MineStats({
    required this.completedLevels,
    required this.accuracy,
    required this.flowers,
  });
}

enum MineMenuAction { editProfile, parentEntry, settings }

class MineStarStudent {
  final String avatar;
  final int rank;
  final String name;
  final String badge;

  const MineStarStudent({
    required this.avatar,
    required this.rank,
    required this.name,
    required this.badge,
  });
}
