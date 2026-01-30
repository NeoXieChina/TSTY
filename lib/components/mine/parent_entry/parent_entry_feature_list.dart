import 'package:flutter/material.dart';

class ParentEntryFeatureList extends StatelessWidget {
  const ParentEntryFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final red = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FeatureItem(
          icon: Icons.insights_rounded,
          iconColor: red,
          text: '查看孩子学习报告和进度',
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.timer_rounded,
          iconColor: red,
          text: '设置每日使用时长限制',
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.visibility_rounded,
          iconColor: red,
          text: '了解薄弱环节和改进建议',
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
