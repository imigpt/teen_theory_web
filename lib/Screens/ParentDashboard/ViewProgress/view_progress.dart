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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Overview',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: AppFonts.interBold,
                fontSize: 18,
              ),
            ),
            Text(
              "Riya Shah's Progress",
              style: TextStyle(
                color: Colors.grey.shade600,
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Student Name and Performance
                // _buildHeader(provider),
                const SizedBox(height: 20),

                // Overall Progress Card
                _buildOverallProgressCard(provider),
                const SizedBox(height: 20),

                // Top Stats Cards (Completed, Pending, Overdue)
                _buildTopStatsCards(provider),
                const SizedBox(height: 24),

                // Project Progress Section
                _buildSectionTitle('Project Progress'),
                const SizedBox(height: 12),
                ...provider.projectProgressList
                    .map((project) => _buildProjectCard(project))
                    .toList(),
                const SizedBox(height: 16),

                // Custom Projects Section
                ...provider.customProjectsList
                    .map((project) => _buildProjectCard(project))
                    .toList(),
                const SizedBox(height: 20),

                // College Applications Section
                _buildSectionTitle('College Applications'),
                const SizedBox(height: 12),
                ...provider.collegeApplicationsList
                    .map((college) => _buildCollegeCard(college))
                    .toList(),
                const SizedBox(height: 24),

                // Task Analytics Section
                _buildSectionTitle('Task Analytics'),
                const SizedBox(height: 12),
                _buildTaskAnalytics(provider),
                const SizedBox(height: 20),

                // Overdue Tasks Section
                _buildTasksSection(
                  'Overdue Tasks (2)',
                  provider.overdueTasks,
                  AppColors.orange,
                ),
                const SizedBox(height: 20),

                // Due This Week Section
                _buildTasksSection(
                  'Due This Week (3)',
                  provider.dueThisWeekTasks,
                  AppColors.orange,
                ),
                const SizedBox(height: 24),

                // Meeting Analytics Section
                _buildSectionTitle('Meeting Analytics'),
                const SizedBox(height: 12),
                _buildMeetingAnalytics(provider),
                const SizedBox(height: 20),

                // Upcoming Meetings Section
                _buildSectionTitle('Upcoming Meetings'),
                const SizedBox(height: 12),
                ...provider.upcomingMeetingsViewProgress
                    .map((meeting) => _buildUpcomingMeetingCard(meeting))
                    .toList(),
                const SizedBox(height: 24),

                // Latest Feedback Section
                _buildSectionTitle('Latest Feedback'),
                const SizedBox(height: 12),
                ...provider.latestFeedbackList
                    .map((feedback) => _buildFeedbackCard(feedback))
                    .toList(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildHeader(ParentDashProvider provider) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               provider.childName,
  //               style: const TextStyle(
  //                 fontFamily: AppFonts.interBold,
  //                 fontSize: 20,
  //                 color: AppColors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               'Track Performance',
  //               style: TextStyle(
  //                 fontFamily: AppFonts.interRegular,
  //                 fontSize: 13,
  //                 color: Colors.grey.shade600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildOverallProgressCard(ParentDashProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Circular Progress Chart
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.black,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    provider.viewProgressOverallPercentage,
                    style: const TextStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 32,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Overall Progress',
            style: TextStyle(
              fontFamily: AppFonts.interBold,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            provider.weeksRemaining,
            style: TextStyle(
              fontFamily: AppFonts.interRegular,
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatsCards(ParentDashProvider provider) {
    return Row(
      children: provider.topStatsCards.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  stat['value'],
                  style: const TextStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 22,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['label'],
                  style: const TextStyle(
                    fontFamily: AppFonts.interRegular,
                    fontSize: 11,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: AppFonts.interBold,
        fontSize: 16,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project['title'],
                style: const TextStyle(
                  fontFamily: AppFonts.interBold,
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
              Text(
                project['progressPercentage'],
                style: const TextStyle(
                  fontFamily: AppFonts.interBold,
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Linear Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: project['progress'],
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.black),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project['subtitle'],
            style: TextStyle(
              fontFamily: AppFonts.interRegular,
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollegeCard(Map<String, dynamic> college) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              college['name'],
              style: const TextStyle(
                fontFamily: AppFonts.interMedium,
                fontSize: 13,
                color: AppColors.black,
              ),
            ),
          ),
          // Progress Bar
          Container(
            width: 100,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: college['progress'],
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            college['progressPercentage'],
            style: const TextStyle(
              fontFamily: AppFonts.interBold,
              fontSize: 12,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskAnalytics(ParentDashProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Text(
                  provider.onTimePercentage,
                  style: const TextStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 32,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.onTimeLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.interRegular,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Text(
                  provider.delayedPercentage,
                  style: const TextStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 32,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.delayedLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.interRegular,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksSection(
    String title,
    List<Map<String, dynamic>> tasks,
    Color dotColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppFonts.interBold,
                fontSize: 14,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(height: 12),
            ...tasks.map((task) => _buildTaskItem(task, dotColor)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task, Color dotColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    fontFamily: AppFonts.interMedium,
                    fontSize: 13,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  task['dueDate'],
                  style: TextStyle(
                    fontFamily: AppFonts.interRegular,
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingAnalytics(ParentDashProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance History',
                style: TextStyle(
                  fontFamily: AppFonts.interBold,
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
              Text(
                provider.attendancePercentage,
                style: const TextStyle(
                  fontFamily: AppFonts.interBold,
                  fontSize: 18,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${provider.attendedMeetings}',
                    style: const TextStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Attended',
                    style: TextStyle(
                      fontFamily: AppFonts.interRegular,
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${provider.missedMeetings}',
                    style: const TextStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 18,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Missed',
                    style: TextStyle(
                      fontFamily: AppFonts.interRegular,
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMeetingCard(Map<String, dynamic> meeting) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
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
                  meeting['title'],
                  style: const TextStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 13,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meeting['subtitle'],
                  style: TextStyle(
                    fontFamily: AppFonts.interRegular,
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    meeting['status'],
                    style: const TextStyle(
                      fontFamily: AppFonts.interMedium,
                      fontSize: 10,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                feedback['name'][0],
                style: const TextStyle(
                  fontFamily: AppFonts.interBold,
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${feedback['name']} - ${feedback['role']}',
                      style: const TextStyle(
                        fontFamily: AppFonts.interBold,
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      feedback['date'],
                      style: TextStyle(
                        fontFamily: AppFonts.interRegular,
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  feedback['feedback'],
                  style: TextStyle(
                    fontFamily: AppFonts.interRegular,
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
