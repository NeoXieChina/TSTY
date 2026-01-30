import 'package:flutter/material.dart';
import 'package:tsty_app/components/common/YiSun.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_bottom_deco.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_card.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_evaluate_card.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_eval_dialog.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_header.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_page_bubbles.dart';
import 'package:tsty_app/style/app_theme.dart';

class LevelDetailPage extends StatefulWidget {
  final int? levelIndex;
  final int? totalLevels;

  const LevelDetailPage({super.key, this.levelIndex, this.totalLevels});

  static LevelDetailPage fromArgs(Object? args) {
    if (args is Map) {
      final levelIndex = args['levelIndex'];
      final totalLevels = args['totalLevels'];
      return LevelDetailPage(
        levelIndex: levelIndex is int ? levelIndex : null,
        totalLevels: totalLevels is int ? totalLevels : null,
      );
    }
    return const LevelDetailPage();
  }

  @override
  State<LevelDetailPage> createState() => _LevelDetailPageState();
}

class _LevelDetailPageState extends State<LevelDetailPage> {
  late int _currentLevel;
  late int _totalLevels;

  bool _recording = false;
  String _recordStatus = '长按录音，学说 "b"';

  String _character = 'b';
  String _pinyin = '[p]';
  String _hintImage = 'lib/assets/father.webp';
  String _hintLabel = '爸爸';
  String _exampleText = '爸爸的 b';

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.levelIndex ?? 1;
    _totalLevels = widget.totalLevels ?? 23;
  }

  @override
  void didUpdateWidget(covariant LevelDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentLevel = widget.levelIndex ?? _currentLevel;
    _totalLevels = widget.totalLevels ?? _totalLevels;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _playStandard() {
    _toast('播放标准音（示例）');
  }

  void _playTip() {
    _toast('播放提示音（示例）');
  }

  void _startRecording() {
    if (_recording) return;
    setState(() {
      _recording = true;
      _recordStatus = '正在录音中...';
    });
  }

  Future<void> _showEvaluateDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LevelDetailEvalDialog(
          score: 92,
          accuracyText: '太棒了！',
          stars: 3,
          flowers: 3,
          points: const [
            LevelEvalPoint(success: true, text: '声调准确'),
            LevelEvalPoint(success: true, text: '发音清晰'),
          ],
          learningTip: '下次尝试时，嘴巴可以张得更大一些，让声音更洪亮！',
          onTryAgain: () {
            Navigator.of(context).pop();
            setState(() {
              _recordStatus = '长按录音，学说 "$_character"';
            });
          },
          onNext: () {
            Navigator.of(context).pop();
            _nextLevel();
          },
        );
      },
    );
  }

  Future<void> _stopRecording() async {
    if (!_recording) return;

    setState(() {
      _recording = false;
      _recordStatus = '录音结束，正在测评...';
    });

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    await _showEvaluateDialog();

    if (!mounted) return;
    setState(() {
      _recordStatus = '长按录音，学说 "$_character"';
    });
  }

  void _nextLevel() {
    if (_currentLevel >= _totalLevels) {
      _toast('暂无下一关');
      return;
    }

    final nextIndex = _currentLevel + 1;
    Navigator.of(context).pushReplacementNamed(
      '/learn/level-detail',
      arguments: {'levelIndex': nextIndex, 'totalLevels': _totalLevels},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppTheme.yiYellow.value.withValues(alpha: 0.06);

    final title = '声母 $_character';

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/learn_background.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFFFFF5E6).withValues(alpha: 0.65),
            ),
          ),
          const LevelDetailPageBubbles(),
          Column(
            children: [
              LevelDetailHeader(
                title: title,
                current: _currentLevel,
                total: _totalLevels,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LevelDetailCard(
                                    character: _character,
                                    pinyin: _pinyin,
                                    hintImageAsset: _hintImage,
                                    hintLabel: _hintLabel,
                                    exampleText: _exampleText,
                                    onPlayStandard: _playStandard,
                                    onPlayTip: _playTip,
                                  ),
                                  const SizedBox(height: 18),
                                  LevelDetailEvaluateCard(
                                    recording: _recording,
                                    statusText: _recordStatus,
                                    onLongPressStart: _startRecording,
                                    onLongPressEnd: _stopRecording,
                                    onShowResult: _showEvaluateDialog,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const LevelDetailBottomDeco(),
          const YiSun(
            size: 120,
            top: 70,
            right: 18,
            imageAsset: 'lib/assets/sun.webp',
          ),
        ],
      ),
    );
  }
}
