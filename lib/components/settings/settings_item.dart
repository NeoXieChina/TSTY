import 'package:flutter/material.dart';
import 'package:tsty_app/style/app_theme.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final yellow = AppTheme.yiYellow.value;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: yellow, width: 2),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3D2800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing ??
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFCC0000),
                size: 26,
              ),
        ],
      ),
    );

    if (onTap == null && trailing != null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
