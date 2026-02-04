import 'package:flutter/material.dart';
import 'package:tsty_app/api/learn.dart';
import 'package:tsty_app/components/learn/learn_header.dart';
import 'package:tsty_app/components/learn/learn_level_map.dart';
import 'package:tsty_app/constants/index.dart';
import 'package:tsty_app/viewmodels/learn.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int _selectedUnitIndex = 0;
  bool _loading = false;
  String _currentUnitId = UnitConstants.initialUnitId;
  int _totalLevels = 23;
  List<LearnLevelData> _levelData = const [];
  List<LearnUnitProgress> _unitProgressCache = List<LearnUnitProgress>.generate(
    4,
    (_) => const LearnUnitProgress(completed: 0, total: 0),
  );

  Future<UnitProgressResponse> _getLevels(String unitId) async {
    return await getUnitProgressAPI(unitId);
  }

  String _unitIdFromIndex(int index) {
    switch (index) {
      case 0:
        return UnitConstants.initialUnitId;
      case 1:
        return UnitConstants.finalUnitId;
      case 2:
        return UnitConstants.hanziUnitId;
      case 3:
        return UnitConstants.wordUnitId;
      default:
        return UnitConstants.initialUnitId;
    }
  }

  LearnLevelStatus _mapStatus(String status) {
    final s = status.trim().toLowerCase();
    if (s == 'passed' ||
        s == 'complete' ||
        s == 'completed' ||
        s == 'done' ||
        s == 'success') {
      return LearnLevelStatus.passed;
    }
    if (s == 'unlocked' || s == 'open' || s == 'available') {
      return LearnLevelStatus.unlocked;
    }
    return LearnLevelStatus.locked;
  }

  int _uuidOrderKey(String uuid) {
    final s = uuid.trim();
    if (s.length < 4) return 1 << 30;
    final suffix = s.substring(s.length - 4);
    return int.tryParse(suffix, radix: 16) ?? int.tryParse(suffix) ?? (1 << 30);
  }

  Future<void> _loadUnit(int index) async {
    final unitId = _unitIdFromIndex(index);

    setState(() {
      _selectedUnitIndex = index;
      _currentUnitId = unitId;
      _loading = true;
    });

    try {
      final resp = await _getLevels(unitId);
      if (!mounted) return;

      final nextProgress = List<LearnUnitProgress>.from(_unitProgressCache);
      if (index >= 0 && index < nextProgress.length) {
        nextProgress[index] = LearnUnitProgress(
          completed: resp.completedLevels,
          total: resp.totalLevels,
        );
      }

      final items = List<LevelProgressItem>.from(resp.levels)
        ..sort(
          (a, b) =>
              _uuidOrderKey(a.levelId).compareTo(_uuidOrderKey(b.levelId)),
        );

      final total = resp.totalLevels;
      final data = List<LearnLevelData>.generate(total, (i) {
        final id = i + 1;
        if (i >= items.length) {
          return LearnLevelData(id: id, status: LearnLevelStatus.locked);
        }

        final item = items[i];
        return LearnLevelData(
          id: id,
          levelId: item.levelId,
          status: _mapStatus(item.status),
          flowers: item.stars.clamp(0, 3),
        );
      });

      setState(() {
        _totalLevels = total;
        _levelData = data;
        _unitProgressCache = nextProgress;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _levelData = const [];
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUnit(_selectedUnitIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: LearnHeader(
            selectedIndex: _selectedUnitIndex,
            onUnitTap: _loadUnit,
            unitProgress: _unitProgressCache,
          ),
        ),
        Expanded(
          child: _loading && _levelData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _levelData.isEmpty
              ? const Center(child: Text('暂无关卡'))
              : LearnLevelMap(
                  levels: _levelData,
                  onLevelTap: (level) {
                    () async {
                      final localContext = context;
                      final levelId = level.levelId;
                      if (levelId == null || levelId.isEmpty) return;

                      final rootNavigator = Navigator.of(
                        localContext,
                        rootNavigator: true,
                      );
                      showDialog<void>(
                        context: localContext,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      try {
                        final content = await getLevelDetailsAPI(levelId);
                        if (!localContext.mounted) return;

                        if (rootNavigator.mounted && rootNavigator.canPop()) {
                          rootNavigator.pop();
                        }

                        Navigator.of(localContext).pushNamed(
                          '/learn/level-detail',
                          arguments: {
                            'unitId': _currentUnitId,
                            'levelId': levelId,
                            'levelIndex': level.id,
                            'totalLevels': _totalLevels,
                            'levelContent': content,
                            'levelIds': _levelData
                                .map((e) => e.levelId ?? '')
                                .toList(growable: false),
                          },
                        );
                      } catch (_) {
                        if (!localContext.mounted) return;

                        if (rootNavigator.mounted && rootNavigator.canPop()) {
                          rootNavigator.pop();
                        }

                        ScaffoldMessenger.of(localContext).showSnackBar(
                          const SnackBar(content: Text('获取关卡详情失败')),
                        );
                      }
                    }();
                  },
                ),
        ),
      ],
    );
  }
}
