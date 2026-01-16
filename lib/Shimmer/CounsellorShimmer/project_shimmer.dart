import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';

class ProjectShimmer extends StatelessWidget {
  const ProjectShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "AI Ethics Research Paper",
              style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Complete college applications package including essays and recommendations.",
              style: textStyle(fontSize: 12, color: Colors.grey),
            ),
            leading: Icon(CupertinoIcons.folder, color: Colors.black),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          );
        },
      ),
    );
  }
}
