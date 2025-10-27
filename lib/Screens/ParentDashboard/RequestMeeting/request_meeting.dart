import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';

class RequestMeeting extends StatefulWidget {
  const RequestMeeting({super.key});

  @override
  State<RequestMeeting> createState() => _RequestMeetingState();
}

class _RequestMeetingState extends State<RequestMeeting> {
  int? selectedMeetingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Meeting',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.interBold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Parent\'s View',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppFonts.interRegular,
                          color: AppColors.lightGrey2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Section Title
                    const Text(
                      'Choose Meeting Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.interBold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Section Description
                    const Text(
                      'Select the type of meeting you\'d like to request with your counsellor.',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.interRegular,
                        color: AppColors.lightGrey2,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Meeting Type Cards
                    _buildMeetingTypeCard(
                      index: 0,
                      icon: Icons.group,
                      title: 'Parent Review Meeting',
                      description:
                          'Discuss your child\'s overall progress and upcoming Milestones',
                      duration: '30-45 Minutes',
                    ),

                    const SizedBox(height: 16),

                    _buildMeetingTypeCard(
                      index: 1,
                      icon: Icons.group,
                      title: 'Counsellor Check-in',
                      description:
                          'Regular check-in to discuss concerns and next steps',
                      duration: '30-45 Minutes',
                    ),

                    const SizedBox(height: 16),

                    _buildMeetingTypeCard(
                      index: 2,
                      icon: Icons.group,
                      title: 'Parent Review Meeting',
                      description:
                          'Discuss your child\'s overall progress and upcoming Milestones',
                      duration: '30-45 Minutes',
                    ),

                    const SizedBox(height: 16),

                    _buildMeetingTypeCard(
                      index: 3,
                      icon: Icons.group,
                      title: 'Parent Review Meeting',
                      description:
                          'Discuss your child\'s overall progress and upcoming Milestones',
                      duration: '30-45 Minutes',
                    ),

                    const SizedBox(height: 16),

                    _buildMeetingTypeCard(
                      index: 4,
                      icon: Icons.group,
                      title: 'Parent Review Meeting',
                      description:
                          'Discuss your child\'s overall progress and upcoming Milestones',
                      duration: '30-45 Minutes',
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingTypeCard({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required String duration,
  }) {
    final bool isSelected = selectedMeetingIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeetingIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.blue : const Color(0xFFE8E8E8),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightGrey3,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppColors.black),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.interBold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: AppFonts.interRegular,
                      color: AppColors.lightGrey2,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.lightGrey2,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: AppFonts.interRegular,
                          color: AppColors.lightGrey2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Radio Button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.blue : const Color(0xFFE8E8E8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
