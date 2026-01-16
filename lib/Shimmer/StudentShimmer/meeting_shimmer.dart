import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class MeetingShimmer extends StatelessWidget {
  const MeetingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        separatorBuilder: (_, __) => hSpace(height: 8),
        itemBuilder: (context, index) {
          final isJoinable = index == 0;
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isJoinable
                    ? Color(0xFFFF758C).withValues(alpha: 0.3)
                    : Colors.grey.shade200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row: icon, title + subtitle, action
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // meeting icon with gradient
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isJoinable
                                ? [Color(0xFFFF758C), Color(0xFFFF7EB3)]
                                : [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isJoinable
                                          ? Color(0xFFFF758C)
                                          : Color(0xFF667EEA))
                                      .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.videocam_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
      
                      // title & subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meeting With Alex Watson',
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'AI Project Review & Next Steps',
                              style: textStyle(
                                color: AppColors.lightGrey2,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
      
                      // action text/button
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF758C).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Join 🎥',
                          style: textStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.interMedium,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 12),
      
                  // date/time row
                  Row(
                    children: [
                      Text('📅 ', style: TextStyle(fontSize: 14)),
                      Text(
                        isJoinable ? 'Today, 3:00 PM' : 'Tomorrow, 7:00 PM',
                        style: textStyle(
                          color: AppColors.lightGrey2,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text('⏱️ ', style: TextStyle(fontSize: 14)),
                      Text(
                        '45 min',
                        style: textStyle(
                          color: AppColors.lightGrey2,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
