import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:tsty_app/api/learn.dart';
import 'package:tsty_app/api/ise.dart';
import 'package:tsty_app/components/common/YiSun.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_card.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_evaluate_card.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_eval_dialog.dart';
import 'package:tsty_app/components/learn/level_detail/level_detail_header.dart';
import 'package:tsty_app/constants/index.dart';
import 'package:tsty_app/style/app_theme.dart';
import 'package:tsty_app/utils/ToastUtils.dart';
import 'package:tsty_app/utils/yi_recorder.dart';
import 'package:tsty_app/utils/yi_speech_evaluator.dart';
import 'package:tsty_app/utils/user_prefs.dart';
import 'package:tsty_app/viewmodels/learn.dart';

String _formatPinyinForDisplay(String input) {
  var s = input.trim();
  if (s.isEmpty) return s;

  s = s.replaceAll('u:', 'ü').replaceAll('U:', 'Ü');
  s = s.replaceAll('v', 'ü').replaceAll('V', 'Ü');

  return s.replaceAllMapped(RegExp(r'([A-Za-zÜü]+)([0-5])'), (m) {
    final syllable = m.group(1) ?? '';
    final tone = int.tryParse(m.group(2) ?? '') ?? 0;
    return _applyToneToSyllable(syllable, tone);
  });
}

String _applyToneToSyllable(String syllable, int tone) {
  if (tone <= 0 || tone >= 5) {
    return syllable;
  }

  final lower = syllable.toLowerCase();

  int vowelIndex = -1;
  if (lower.contains('a')) {
    vowelIndex = lower.indexOf('a');
  } else if (lower.contains('e')) {
    vowelIndex = lower.indexOf('e');
  } else if (lower.contains('ou')) {
    vowelIndex = lower.indexOf('o');
  } else if (lower.contains('o')) {
    vowelIndex = lower.indexOf('o');
  } else if (lower.contains('iu')) {
    vowelIndex = lower.indexOf('u');
  } else if (lower.contains('ui')) {
    vowelIndex = lower.indexOf('i');
  } else {
    const vowels = 'aeiouü';
    for (var i = lower.length - 1; i >= 0; i--) {
      if (vowels.contains(lower[i])) {
        vowelIndex = i;
        break;
      }
    }
  }

  if (vowelIndex < 0) return syllable;
  final chars = syllable.split('');
  chars[vowelIndex] = _toneVowel(chars[vowelIndex], tone);
  return chars.join();
}

String _toneVowel(String vowel, int tone) {
  const toneMap = {
    'a': ['ā', 'á', 'ǎ', 'à'],
    'e': ['ē', 'é', 'ě', 'è'],
    'i': ['ī', 'í', 'ǐ', 'ì'],
    'o': ['ō', 'ó', 'ǒ', 'ò'],
    'u': ['ū', 'ú', 'ǔ', 'ù'],
    'ü': ['ǖ', 'ǘ', 'ǚ', 'ǜ'],
    'A': ['Ā', 'Á', 'Ǎ', 'À'],
    'E': ['Ē', 'É', 'Ě', 'È'],
    'I': ['Ī', 'Í', 'Ǐ', 'Ì'],
    'O': ['Ō', 'Ó', 'Ǒ', 'Ò'],
    'U': ['Ū', 'Ú', 'Ǔ', 'Ù'],
    'Ü': ['Ǖ', 'Ǘ', 'Ǚ', 'Ǜ'],
  };
  final list = toneMap[vowel];
  if (list == null) return vowel;
  final idx = tone - 1;
  if (idx < 0 || idx >= list.length) return vowel;
  return list[idx];
}

bool _isShengmuContent(LevelContent content) {
  final s = content.contentType.trim().toLowerCase();
  return s.contains('shengmu') || content.contentType.contains('声母');
}

bool _isWordContent(LevelContent content) {
  final s = content.contentType.trim().toLowerCase();
  return s.contains('word') || content.contentType.contains('词语');
}

String _shengmuAssetKey(String raw) {
  return raw.trim().toLowerCase();
}

String _shengmuImageAsset(String key) {
  return 'lib/assets/learn/shengmu/image/$key.webp';
}

String _shengmuAudioAsset(String key) {
  return 'lib/assets/learn/shengmu/audio/$key.mp3';
}

class LevelDetailPage extends StatefulWidget {
  final int? levelIndex;
  final int? totalLevels;
  final String? unitId;
  final String? levelId;
  final LevelContent? levelContent;
  final List<String>? levelIds;
  final YiIseAuthQuery? iseAuthQuery;

  const LevelDetailPage({
    super.key,
    this.levelIndex,
    this.totalLevels,
    this.unitId,
    this.levelId,
    this.levelContent,
    this.levelIds,
    this.iseAuthQuery,
  });

  static LevelDetailPage fromArgs(Object? args) {
    if (args is Map) {
      final levelIndex = args['levelIndex'];
      final totalLevels = args['totalLevels'];
      final unitId = args['unitId'];
      final levelId = args['levelId'];
      final levelContent = args['levelContent'];
      final levelIds = args['levelIds'];
      final iseAuth = args['iseAuth'];

      YiIseAuthQuery? authQuery;
      if (iseAuth is Map) {
        final authorization = iseAuth['authorization']?.toString();
        final host = iseAuth['host']?.toString();
        final date = iseAuth['date']?.toString();
        if (authorization != null &&
            authorization.isNotEmpty &&
            host != null &&
            host.isNotEmpty &&
            date != null &&
            date.isNotEmpty) {
          authQuery = YiIseAuthQuery(
            authorization: authorization,
            host: host,
            date: date,
          );
        }
      }

      final parsedLevelIds = levelIds is List
          ? levelIds
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList(growable: false)
          : null;
      return LevelDetailPage(
        levelIndex: levelIndex is int ? levelIndex : null,
        totalLevels: totalLevels is int ? totalLevels : null,
        unitId: unitId is String ? unitId : null,
        levelId: levelId is String ? levelId : null,
        levelContent: levelContent is LevelContent ? levelContent : null,
        levelIds: parsedLevelIds,
        iseAuthQuery: authQuery,
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
  List<String> _levelIds = const [];

  final AudioPlayer _audioPlayer = AudioPlayer();
  final YiRecorderController _recorder = YiRecorderController();
  StreamSubscription<Duration>? _recordDurationSub;

  bool _recording = false;
  String _recordStatus = '长按录音，学说 "b"';

  String _character = 'b';
  String _pinyin = '[p]';
  String _hintImage = 'lib/assets/father.webp';
  String _hintLabel = '爸爸';
  String _exampleText = '爸爸的 b';

  LevelContent? _content;
  int _tipIndex = 0;
  int _lastScore = 92;

  Future<IseAuthCache?> _ensureIseAuth() async {
    final cached = await UserPrefs.getIseAuthCache();
    if (cached != null) return cached;
    try {
      final auth = await getIseAuthAPI();
      await UserPrefs.setIseAuthCache(auth);
      return auth;
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.levelIndex ?? 1;
    _totalLevels = widget.totalLevels ?? 23;
    _levelIds = widget.levelIds ?? const [];
    _applyContent(widget.levelContent);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recordDurationSub?.cancel();
    _recordDurationSub = null;
    _recorder.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LevelDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentLevel = widget.levelIndex ?? _currentLevel;
    _totalLevels = widget.totalLevels ?? _totalLevels;
    if (oldWidget.levelIds != widget.levelIds) {
      _levelIds = widget.levelIds ?? _levelIds;
    }
    if (oldWidget.levelContent != widget.levelContent) {
      _applyContent(widget.levelContent);
    }
  }

  void _applyContent(LevelContent? content) {
    _content = content;
    if (content == null) return;

    _tipIndex = 0;
    _lastScore = 92;
    _character = content.contentValue;
    _pinyin = _formatPinyinForDisplay(content.pinyinText);
    _hintImage = 'lib/assets/father.webp';
    _hintLabel = content.exampleWord;
    _exampleText = '${content.exampleWord} 的 ${content.contentValue}';
    _recordStatus = '长按录音，学说 "${content.contentValue}"';

    if (_isShengmuContent(content)) {
      final key = _shengmuAssetKey(content.contentValue);
      if (key.isNotEmpty) {
        _hintImage = _shengmuImageAsset(key);
      }
    }
  }

  void _toast(String msg) {
    ToastUtils.showToast(context, msg);
  }

  void _playStandard() {
    final content = _content;
    if (content == null || !_isShengmuContent(content)) {
      _toast('播放标准音（示例）');
      return;
    }

    final key = _shengmuAssetKey(content.contentValue);
    if (key.isEmpty) {
      _toast('暂无标准音');
      return;
    }

    () async {
      try {
        final bytes = await rootBundle.load(_shengmuAudioAsset(key));
        await _audioPlayer.stop();
        await _audioPlayer.play(BytesSource(bytes.buffer.asUint8List()));
      } catch (_) {
        if (!mounted) return;
        ToastUtils.showToast(context, '播放失败');
      }
    }();
  }

  void _playTip() {
    final tips = _content?.tips ?? const <String>[];
    if (tips.isEmpty) {
      ToastUtils.showToast(context, '暂无提示');
      return;
    }

    final idx = _tipIndex % tips.length;
    ToastUtils.showToast(context, tips[idx]);
    _tipIndex = (_tipIndex + 1) % tips.length;
  }

  void _startRecording() {
    if (_recording) return;
    () async {
      try {
        if (!mounted) return;
        setState(() {
          _recording = true;
          _recordStatus = '正在录音中...';
        });

        _recordDurationSub?.cancel();
        _recordDurationSub = _recorder.durationStream.listen((d) {
          if (!mounted) return;
          if (!_recording) return;
          final ms = d.inMilliseconds;
          final sec = (ms / 1000).toStringAsFixed(1);
          setState(() {
            _recordStatus = '正在录音中... $sec s';
          });
        });

        await _recorder.start(
          config: const YiRecorderConfig(
            format: YiRecorderFormat.wav,
            sampleRate: 16000,
            numChannels: 1,
          ),
        );
      } catch (_) {
        _recordDurationSub?.cancel();
        _recordDurationSub = null;
        if (!mounted) return;
        setState(() {
          _recording = false;
          _recordStatus = '长按录音，学说 "$_character"';
        });
        ToastUtils.showToast(context, '录音失败');
      }
    }();
  }

  Future<void> _showEvaluateDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final score = _lastScore.clamp(0, 100).toInt();
        final stars = score >= 90
            ? 3
            : score >= 75
                ? 2
                : score >= 60
                    ? 1
                    : 0;
        final flowers = stars;
        final accuracyText = score >= 90
            ? '太棒了！'
            : score >= 75
                ? '不错哦！'
                : score >= 60
                    ? '继续加油！'
                    : '再试一次！';
        return LevelDetailEvalDialog(
          score: score,
          accuracyText: accuracyText,
          stars: stars,
          flowers: flowers,
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

    _recordDurationSub?.cancel();
    _recordDurationSub = null;

    YiRecorderResult? recordResult;
    try {
      recordResult = await _recorder.stop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _recording = false;
        _recordStatus = '长按录音，学说 "$_character"';
      });
      ToastUtils.showToast(context, '录音结束失败');
      return;
    }

    setState(() {
      _recording = false;
      _recordStatus = '录音结束，正在测评...';
    });

    final content = _content;
    if (recordResult == null || content == null) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      await _showEvaluateDialog();
      if (!mounted) return;
      setState(() {
        _recordStatus = '长按录音，学说 "$_character"';
      });
      return;
    }

    if (kIsWeb) {
      if (!mounted) return;
      ToastUtils.showToast(context, 'Web 暂不支持语音测评');
      await _showEvaluateDialog();

      if (!mounted) return;
      setState(() {
        _recordStatus = '长按录音，学说 "$_character"';
      });
      return;
    }

    final endpoint = Uri.parse(GlobalConstants.xfyunIseEndpoint);
    final authCache = await _ensureIseAuth();
    if (authCache == null) {
      if (!mounted) return;
      setState(() {
        _lastScore = 0;
      });
      ToastUtils.showToast(context, '获取语音测评鉴权失败');
      await _showEvaluateDialog();

      if (!mounted) return;
      setState(() {
        _recordStatus = '长按录音，学说 "$_character"';
      });
      return;
    }

    final authQuery = YiIseAuthQuery(
      authorization: authCache.authorization,
      host: authCache.host,
      date: authCache.date,
    );
    final appId = authCache.appId;
    final category = _isWordContent(content) ? 'read_word' : 'read_syllable';
    final evaluator = YiIseEvaluator(
      YiIseConfig(
        endpoint: endpoint,
        appId: appId,
        category: category,
        ent: 'cn_vip',
      ),
    );

    try {
      final result = await evaluator.evaluateFileToResult(
        filePath: recordResult.path,
        text: content.contentValue,
        authQuery: authQuery,
        timeout: const Duration(seconds: 20),
      );
      final score = (result.totalScore ?? 0).round().clamp(0, 100);
      if (!mounted) return;
      setState(() {
        _lastScore = score;
      });
      ToastUtils.showToast(context, '测评得分：$score');
    } catch (_) {
      if (!mounted) return;
      ToastUtils.showToast(context, '测评失败');
    }

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

    if (_levelIds.isEmpty) {
      _toast('无法获取下一关');
      return;
    }

    final nextPos = nextIndex - 1;
    if (nextPos < 0 || nextPos >= _levelIds.length) {
      _toast('暂无下一关');
      return;
    }

    final nextLevelId = _levelIds[nextPos];
    if (nextLevelId.isEmpty) {
      _toast('下一关未解锁');
      return;
    }

    () async {
      final localContext = context;
      final rootNavigator = Navigator.of(localContext, rootNavigator: true);
      showDialog<void>(
        context: localContext,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        final content = await getLevelDetailsAPI(nextLevelId);
        if (!localContext.mounted) return;

        if (rootNavigator.mounted && rootNavigator.canPop()) {
          rootNavigator.pop();
        }

        Navigator.of(localContext).pushReplacementNamed(
          '/learn/level-detail',
          arguments: {
            'unitId': widget.unitId,
            'levelId': nextLevelId,
            'levelIndex': nextIndex,
            'totalLevels': _totalLevels,
            'levelContent': content,
            'levelIds': _levelIds,
          },
        );
      } catch (_) {
        if (!localContext.mounted) return;

        if (rootNavigator.mounted && rootNavigator.canPop()) {
          rootNavigator.pop();
        }
        ToastUtils.showToast(localContext, '获取关卡详情失败');
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppTheme.yiYellow.value.withValues(alpha: 0.06);

    final title = _content?.levelName ?? '关卡 $_currentLevel';

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
                      child: SingleChildScrollView(
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
                            const SizedBox(height: 30),
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
                    ),
                  ),
                ),
              ),
            ],
          ),
          const YiSun(
            size: 120,
            top: 70,
            right: 15,
            imageAsset: 'lib/assets/sun.webp',
          ),
        ],
      ),
    );
  }
}
