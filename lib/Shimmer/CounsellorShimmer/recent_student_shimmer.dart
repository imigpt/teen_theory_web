import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class RecentStudentShimmer extends StatelessWidget {
  const RecentStudentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100, child: ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ListTile(
                      onTap: () {
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Michael Johnson",
                            style: textStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text("AI Projects Module 4", style: textStyle()),
                          hSpace(),
                          LinearProgressIndicator(
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                            value: 0.7,
                            color: AppColors.yellow600,
                            backgroundColor: AppColors.lightGrey,
                          ),
                          hSpace(height: 4),
                          Text(
                            "75% Completed",
                            style: textStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(AppImages.personLogo),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ),
                  );
                },
              ));
  }
}