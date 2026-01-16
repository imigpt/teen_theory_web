import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/ActiveProjects/detail_active_project.dart';
import 'package:teen_theory/Utils/helper.dart';

class DetailProjectShimmer extends StatelessWidget {
  const DetailProjectShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 12.0,
                        ),
                        child: Row(
                          children: [
                            // black bullet
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
      
                            // title + subtitle + progress
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "",
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "",
                                    style: textStyle(
                                      color: AppColors.lightGrey2,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
      
                                  // progress row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: 0.6,
                                          minHeight: 6,
                                          backgroundColor: Colors.grey.shade300,
                                          color: Colors.yellow.shade600,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                  hSpace(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '% Complete',
                                        style: textStyle(
                                          color: AppColors.lightGrey2,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '',
                                        style: textStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
      
                            const SizedBox(width: 12),
      
                            // due date
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}