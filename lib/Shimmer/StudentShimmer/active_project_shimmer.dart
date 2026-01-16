import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class ActiveProjectShimmer extends StatelessWidget {
  const ActiveProjectShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // left: small circular chart + percentage
                    Column(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: AnimatedCircularChart(
                            size: const Size(48.0, 48.0),
                            initialChartData: <CircularStackEntry>[
                              CircularStackEntry(<CircularSegmentEntry>[
                                CircularSegmentEntry(
                                  75.0,
                                  Colors.black,
                                  rankKey: 'completed',
                                ),
                                CircularSegmentEntry(
                                  25.0,
                                  Colors.grey.shade300,
                                  rankKey: 'remaining',
                                ),
                              ]),
                            ],
                            chartType: CircularChartType.pie,
                            holeLabel: '',
                            labelStyle: const TextStyle(fontSize: 0),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '75%',
                          style: textStyle(
                            fontFamily: AppFonts.interBold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // middle: title, due, mentor, badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI & Machine Learning',
                            style: textStyle(
                              fontFamily: AppFonts.interBold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Due: Dec 15, 2025',
                            style: textStyle(
                              color: AppColors.lightGrey2,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Mentor: Alex Watson',
                            style: textStyle(
                              color: AppColors.lightGrey2,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // badges
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '3 Task Completed',
                                  style: textStyle(
                                    color: Colors.yellow.shade900,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '2 Pending',
                                  style: textStyle(
                                    color: AppColors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(color: AppColors.lightGrey3, height: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
