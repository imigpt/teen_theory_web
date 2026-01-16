import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class AssignProjectShimmer extends StatelessWidget {
  const AssignProjectShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Fundamentals Project",
                    style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text("Sana Watson - Grade 11", style: textStyle()),
                  hSpace(),
                  LinearProgressIndicator(
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                    value: 0.7,
                    color: Colors.yellow,
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
      ),
    );
  }
}
