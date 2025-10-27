import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';

class CompletedTask extends StatefulWidget {
  const CompletedTask({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
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
                        'Completed Tasks',
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
                    const SizedBox(height: 16),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('15', 'Total\nCompleted'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('12', 'On-Time')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('3', 'Late')),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Recently Completed Tasks Section
                    const Text(
                      'Recently Completed Tasks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.interBold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildCompletedTaskCard(
                      title: 'Brainstorming Essay Writings',
                      completedDate: 'Completed on October 7,2025',
                      description: 'Great Structure and clarity.',
                      isOnTime: true,
                    ),

                    const SizedBox(height: 12),

                    _buildCompletedTaskCard(
                      title: 'Brainstorming Essay Writings',
                      completedDate: 'Completed on October 7,2025',
                      description: 'Great Structure and clarity.',
                      isOnTime: false,
                    ),

                    const SizedBox(height: 12),

                    _buildCompletedTaskCard(
                      title: 'Brainstorming Essay Writings',
                      completedDate: 'Completed on October 7,2025',
                      description: 'Great Structure and clarity.',
                      isOnTime: true,
                    ),

                    const SizedBox(height: 12),

                    _buildCompletedTaskCard(
                      title: 'Brainstorming Essay Writings',
                      completedDate: 'Completed on October 7,2025',
                      description: 'Great Structure and clarity.',
                      isOnTime: false,
                    ),

                    const SizedBox(height: 32),

                    // What You Can View Section
                    _buildInfoSection(
                      icon: Icons.visibility_outlined,
                      iconColor: AppColors.blue,
                      title: 'What You Can View',
                      items: [
                        'Task Title & Project Details',
                        'Completion Date & Status',
                        'On-Time or Late Information',
                        'Mentor/Counsellor Feedback',
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Read-Only Access Section
                    _buildInfoSection(
                      icon: Icons.lock_outline,
                      iconColor: AppColors.orange,
                      title: 'Read-Only Access',
                      items: [
                        'Cannot mark tasks complete',
                        'Cannot edit or upload files',
                        'Cannot reopen completed tasks',
                      ],
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

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.interBold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.interRegular,
              color: AppColors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTaskCard({
    required String title,
    required String completedDate,
    required String description,
    required bool isOnTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

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
                const SizedBox(height: 4),
                Text(
                  completedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: AppFonts.interRegular,
                    color: AppColors.lightGrey2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ImageIcon(
                      AssetImage(AppIcons.chatIcon),
                      size: 14,
                      color: Colors.green[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.interRegular,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOnTime
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isOnTime ? 'On time' : '1 day late',
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.interMedium,
                color: isOnTime ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.interBold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, size: 16, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: AppFonts.interRegular,
                        color: AppColors.lightGrey2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
