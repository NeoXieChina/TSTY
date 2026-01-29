import 'package:flutter/material.dart';
import 'package:tsty_app/components/mine/models.dart';
import 'package:tsty_app/style/app_theme.dart';

class MineClassStarsCard extends StatelessWidget {
  final List<MineStarStudent> stars;

  const MineClassStarsCard({
    super.key,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final yellow = AppTheme.yiYellow.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: yellow, width: 4),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emoji_events, color: yellow, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          '班级之星',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF3D2800),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.star,
                      color: yellow.withValues(alpha: 0.4),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final s in _sortedStars()) _StarProfile(student: s),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<MineStarStudent> _sortedStars() {
    final list = List<MineStarStudent>.from(stars);
    list.sort((a, b) => a.rank.compareTo(b.rank));

    MineStarStudent? first;
    MineStarStudent? second;
    MineStarStudent? third;
    for (final s in list) {
      if (s.rank == 1) first = s;
      if (s.rank == 2) second = s;
      if (s.rank == 3) third = s;
    }

    final out = <MineStarStudent>[];
    if (second != null) out.add(second);
    if (first != null) out.add(first);
    if (third != null) out.add(third);

    if (out.isNotEmpty) return out;
    return list;
  }
}

class _StarProfile extends StatelessWidget {
  final MineStarStudent student;

  const _StarProfile({required this.student});

  @override
  Widget build(BuildContext context) {
    final red = Theme.of(context).colorScheme.primary;
    final yellow = AppTheme.yiYellow.value;

    final isFirst = student.rank == 1;
    final size = student.rank == 1
        ? 90.0
        : student.rank == 2
            ? 80.0
            : 75.0;
    final topOffset = student.rank == 1 ? 0.0 : 16.0;
    final medalColor = student.rank == 1
        ? const Color(0xFFFFD700)
        : student.rank == 2
            ? const Color(0xFFC0C0C0)
            : const Color(0xFFCD7F32);

    return Padding(
      padding: EdgeInsets.only(top: topOffset),
      child: SizedBox(
        width: size + 28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(isFirst ? 4 : 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isFirst ? yellow : const Color(0xFFFFF5E6),
                      width: isFirst ? 4 : 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      student.avatar,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -8,
                  left: -8,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: medalColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${student.rank}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              student.name,
              style: TextStyle(
                fontSize: isFirst ? 16 : 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3D2800),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isFirst ? 10 : 8,
                vertical: isFirst ? 4 : 2,
              ),
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    student.badge,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
