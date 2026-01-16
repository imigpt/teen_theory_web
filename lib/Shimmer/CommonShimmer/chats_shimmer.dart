import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/colors.dart';

/// Skeleton placeholder displayed while chat messages are loading.
class ChatsShimmer extends StatelessWidget {
  const ChatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 7,
        itemBuilder: (context, index) {
          final isMe = index % 3 == 0;
          final bubbleWidth = width * (isMe ? 0.55 : 0.7);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  width: bubbleWidth,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}