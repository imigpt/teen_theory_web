import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';

class ParentTaskDue extends StatefulWidget {
  const ParentTaskDue({super.key});

  @override
  State<ParentTaskDue> createState() => _ParentTaskDueState();
}

class _ParentTaskDueState extends State<ParentTaskDue> {
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
                        'Tasks Overview',
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
                        Expanded(child: _buildStatCard('67%', 'Completed')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('25%', 'Pending')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('8%', 'Overdue')),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Overdue Tasks Section
                    const Text(
                      'Overdue Tasks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.interBold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTaskCard(
                      title: 'Submit Essay Draft',
                      subtitle: 'Standford Application',
                      dueDate: 'Due: Oct 14',
                      status: 'Overdue',
                      statusColor: const Color(0xFFFFE5E5),
                      statusTextColor: const Color(0xFFE33629),
                    ),

                    const SizedBox(height: 12),

                    _buildTaskCard(
                      title: 'Submit Essay Draft',
                      subtitle: 'Standford Application',
                      dueDate: 'Due: Oct 14',
                      status: 'Overdue',
                      statusColor: const Color(0xFFFFE5E5),
                      statusTextColor: const Color(0xFFE33629),
                    ),

                    const SizedBox(height: 32),

                    // Due Today Section
                    const Text(
                      'Due Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.interBold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTaskCard(
                      title: 'Submit Essay Draft',
                      subtitle: 'Standford Application',
                      dueDate: 'Due: Today 11:59 PM',
                      status: 'Pending',
                      statusColor: const Color(0xFFE8E8E8),
                      statusTextColor: AppColors.lightGrey2,
                    ),

                    const SizedBox(height: 32),

                    // Upcoming Tasks Section
                    const Text(
                      'Upcoming Tasks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.interBold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildTaskCard(
                      title: 'Practice Interview Session',
                      subtitle: 'Harvard Application',
                      dueDate: 'Due: 21 Oct',
                      status: 'Upcoming',
                      statusColor: const Color(0xFFE8E8E8),
                      statusTextColor: AppColors.lightGrey2,
                    ),

                    const SizedBox(height: 12),

                    _buildTaskCard(
                      title: 'Practice Interview Session',
                      subtitle: 'Harvard Application',
                      dueDate: 'Due: 21 Oct',
                      status: 'Upcoming',
                      statusColor: const Color(0xFFE8E8E8),
                      statusTextColor: AppColors.lightGrey2,
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

  Widget _buildStatCard(String percentage, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            percentage,
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
            style: const TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.interRegular,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    required String dueDate,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Row(
        children: [
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
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.interRegular,
                    color: AppColors.lightGrey2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.black,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dueDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.interRegular,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.interMedium,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
