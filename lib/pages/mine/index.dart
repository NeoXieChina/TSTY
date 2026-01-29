import 'package:flutter/material.dart';
import 'package:tsty_app/components/common/YiSideStripe.dart';
import 'package:tsty_app/components/mine/mine_class_stars_card.dart';
import 'package:tsty_app/components/mine/mine_menu_section.dart';
import 'package:tsty_app/components/mine/mine_profile_header.dart';
import 'package:tsty_app/components/mine/models.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    const user = MineUserInfo(
      name: '阿依彝',
      gender: '女生',
      age: 4,
      grade: '中班',
      school: '向阳幼儿园二班',
      learningDays: 15,
    );
    const stats = MineStats(completedLevels: 42, accuracy: 89, flowers: 78);

    const stars = [
      MineStarStudent(
        avatar: 'lib/assets/avatar02.webp',
        rank: 1,
        name: '曲比',
        badge: '96朵',
      ),
      MineStarStudent(
        avatar: 'lib/assets/avatar03.webp',
        rank: 2,
        name: '吾木',
        badge: '85朵',
      ),
      MineStarStudent(
        avatar: 'lib/assets/avatar04.webp',
        rank: 3,
        name: '比尔玛',
        badge: '78朵',
      ),
    ];

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  MineProfileHeader(user: user, stats: stats),
                  const SizedBox(height: 24),
                  MineClassStarsCard(stars: stars),
                  const SizedBox(height: 24),
                  MineMenuSection(
                    onTap: (action) {
                      // TODO: wire navigation
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
        const YiSideStripe(
          direction: 'left',
          topRatio: 0.52,
          width: 14,
          height: 200,
          opacity: 0.7,
          colors: [Color(0xFFC00003), Color(0xFFF0C000), Color(0xFF3D2800)],
        ),
        const YiSideStripe(
          direction: 'right',
          topRatio: 0.58,
          width: 14,
          height: 200,
          opacity: 0.7,
          colors: [Color(0xFF3D2800), Color(0xFFF0C000), Color(0xFFC00003)],
        ),
      ],
    );
  }
}
