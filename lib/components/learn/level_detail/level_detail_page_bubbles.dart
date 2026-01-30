import 'package:flutter/material.dart';
import 'package:tsty_app/components/common/YiRadialBubble.dart';
import 'package:tsty_app/style/app_theme.dart';

class LevelDetailPageBubbles extends StatelessWidget {
  const LevelDetailPageBubbles({super.key});

  @override
  Widget build(BuildContext context) {
    final red = Theme.of(context).colorScheme.primary;
    final yellow = AppTheme.yiYellow.value;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              right: w * 0.21,
              top: -10,
              child: YiRadialBubble(
                size: 120,
                color: const Color(0xFF6AD192).withValues(alpha: 0.16),
                highlightAlignment: const Alignment(-0.2, 0.4),
                highlightCenterBias: 0.45,
                highlightAlpha: 0.95,
                highlightStop: 0.62,
                highlightRadius: 1.08,
              ),
            ),
            Positioned(
              right: w * 0.24 + 140,
              top: -15,
              child: YiRadialBubble(
                size: 135,
                color: yellow.withValues(alpha: 0.16),
                highlightAlignment: const Alignment(0.2, 0.4),
                highlightCenterBias: 0.45,
                highlightAlpha: 0.95,
                highlightStop: 0.62,
                highlightRadius: 1.08,
              ),
            ),
            Positioned(
              left: -w * 0.12,
              top: h * 0.01,
              child: YiRadialBubble(
                size: 150,
                color: red.withValues(alpha: 0.10),
                highlightAlignment: const Alignment(0.4, 0.4),
              ),
            ),
            Positioned(
              right: -w * 0.12,
              top: h * 0.08,
              child: YiRadialBubble(
                size: 170,
                color: yellow.withValues(alpha: 0.16),
                highlightAlignment: const Alignment(-0.4, 0.0),
                highlightCenterBias: 0.35,
                highlightAlpha: 0.95,
                highlightStop: 0.60,
                highlightRadius: 1.05,
              ),
            ),
            Positioned(
              left: -w * 0.22,
              top: h * 0.55,
              child: YiRadialBubble(
                size: 200,
                color: const Color(0xFF6AD192).withValues(alpha: 0.16),
                highlightAlignment: const Alignment(0.4, 0.0),
                highlightCenterBias: 0.35,
                highlightAlpha: 0.95,
                highlightStop: 0.60,
                highlightRadius: 1.05,
              ),
            ),
            Positioned(
              right: -w * 0.22,
              top: h * 0.62,
              child: YiRadialBubble(
                size: 210,
                color: red.withValues(alpha: 0.08),
                highlightAlignment: const Alignment(-0.4, 0.0),
                highlightCenterBias: 0.35,
                highlightAlpha: 0.95,
                highlightStop: 0.60,
                highlightRadius: 1.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
