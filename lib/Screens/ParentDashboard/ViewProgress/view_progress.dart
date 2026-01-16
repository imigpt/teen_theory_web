import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/ParentProvider/parent_dash_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';

class ViewProgress extends StatelessWidget {
  const ViewProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Overview',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.interBold,
                fontSize: 18,
              ),
            ),
            Text(
              'Detailed Analytics',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: AppFonts.interRegular,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Consumer<ParentDashProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Progress Analytics',
                    style: TextStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 20,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Detailed progress analytics and insights will be available soon from the API.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.interRegular,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
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
