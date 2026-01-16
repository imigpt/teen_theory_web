import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Utils/helper.dart';

class CustomBoxes extends StatelessWidget {
  final String title;
  final String imageIcon;
  final String subtitle;
  final VoidCallback? onTap;
  const CustomBoxes({super.key, required this.title, required this.imageIcon, required this.subtitle, this.onTap});

  // Get gradient colors based on title
  List<Color> _getGradientColors() {
    if (title.contains('Active') || title.contains('Project')) {
      return [Color(0xFF6DD5FA), Color(0xFF2980B9)];
    } else if (title.contains('Pending') || title.contains('Task')) {
      return [Color(0xFFFFA751), Color(0xFFFFE259)];
    } else if (title.contains('Meeting')) {
      return [Color(0xFFFF758C), Color(0xFFFF7EB3)];
    } else if (title.contains('Ticket')) {
      return [Color(0xFF56CCF2), Color(0xFF2F80ED)];
    }
    return [Color(0xFF667EEA), Color(0xFF764BA2)];
  }

  String _getEmoji() {
    if (title.contains('Active') || title.contains('Project')) {
      return '📁';
    } else if (title.contains('Pending') || title.contains('Task')) {
      return '✅';
    } else if (title.contains('Meeting')) {
      return '📅';
    } else if (title.contains('Ticket')) {
      return '🎫';
    }
    return '📊';
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(_getEmoji(), style: TextStyle(fontSize: 28)),
              ],
            ),
            Text(
              subtitle,
              style: textStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
