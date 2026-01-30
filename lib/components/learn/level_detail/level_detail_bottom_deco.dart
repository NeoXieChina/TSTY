import 'package:flutter/material.dart';
import 'package:tsty_app/components/common/YiRadialBubble.dart';

class LevelDetailBottomDeco extends StatelessWidget {
  const LevelDetailBottomDeco({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: SizedBox(
          height: 160,
          child: Stack(
            children: [
              Positioned(
                left: -80,
                bottom: -120,
                child: YiRadialBubble(
                  size: 220,
                  color: const Color(0xFFF0C000).withValues(alpha: 0.35),
                  highlightAlignment: const Alignment(0.4, -0.4),
                ),
              ),
              Positioned(
                right: -60,
                bottom: -90,
                child: YiRadialBubble(
                  size: 170,
                  color: const Color(0xFF6AD192).withValues(alpha: 0.35),
                  highlightAlignment: const Alignment(-0.4, -0.4),
                ),
              ),
              Positioned(
                left: 140,
                bottom: -70,
                child: YiRadialBubble(
                  size: 120,
                  color: const Color(0xFFCC0000).withValues(alpha: 0.18),
                  highlightAlignment: const Alignment(0.0, -0.4),
                  highlightCenterBias: 0.35,
                  highlightAlpha: 0.95,
                  highlightStop: 0.60,
                  highlightRadius: 1.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
