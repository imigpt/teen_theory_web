import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/ParentProvider/parent_dash_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';

class ParentTaskDue extends StatefulWidget {
  const ParentTaskDue({super.key});

  @override
  State<ParentTaskDue> createState() => _ParentTaskDueState();
}

class _ParentTaskDueState extends State<ParentTaskDue> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentDashProvider>().getParentProfileApiTap();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<ParentDashProvider>(
        builder: (context, provider, child) {
          // Get all projects
          final assignedProjects = provider.parentProfileData?.data?.child?.assignedProjects ?? [];
          
          // Calculate overall stats
          int totalTasks = 0;
          int completedTasks = 0;
          int pendingTasks = 0;
          
          for (var project in assignedProjects) {
            if (project.milestones != null) {
              for (var milestone in project.milestones!) {
                if (milestone.tasks != null) {
                  totalTasks += milestone.tasks!.length;
                  completedTasks += milestone.tasks!.where((t) => t.status?.toLowerCase() == 'completed').length;
                  pendingTasks += milestone.tasks!.where((t) => t.status?.toLowerCase() != 'completed').length;
                }
              }
            }
          }

          // // Calculate percentages
          // final completedPercentage = totalTasks > 0 ? ((completedTasks / totalTasks) * 100).toStringAsFixed(0) : '0';
          // final pendingPercentage = totalTasks > 0 ? ((pendingTasks / totalTasks) * 100).toStringAsFixed(0) : '0';
          // final overduePercentage = '0'; // Can be calculated if needed

          return SafeArea(
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
                    // Row(
                    //   children: [
                    //     Expanded(child: _buildStatCard('$completedPercentage%', 'Completed')),
                    //     const SizedBox(width: 12),
                    //     Expanded(child: _buildStatCard('$pendingPercentage%', 'Pending')),
                    //     const SizedBox(width: 12),
                    //     Expanded(child: _buildStatCard('$overduePercentage%', 'Overdue')),
                    //   ],
                    // ),

                    // const SizedBox(height: 32),

                    // Projects with Milestones and Tasks
                    if (assignedProjects.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text(
                            'No projects available',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppFonts.interRegular,
                              color: AppColors.lightGrey2,
                            ),
                          ),
                        ),
                      )
                    else
                      ...assignedProjects.map((project) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project Name Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.folder_outlined,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      project.title ?? 'Untitled Project',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFonts.interBold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Milestones
                            if (project.milestones != null && project.milestones!.isNotEmpty)
                              ...project.milestones!.map((milestone) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16, bottom: 24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Milestone Name
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.black,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              milestone.name ?? 'Untitled Milestone',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppFonts.interBold,
                                                color: AppColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Tasks in this milestone
                                      if (milestone.tasks != null && milestone.tasks!.isNotEmpty)
                                        ...milestone.tasks!.map((task) {
                                          final dueDate = task.dueDate != null 
                                              ? DateTime.tryParse(task.dueDate.toString())
                                              : milestone.dueDate;
                                          final status = task.status?.toLowerCase() == 'completed' 
                                              ? 'Completed' 
                                              : 'Pending';
                                          
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 16, bottom: 12),
                                            child: _buildTaskCard(
                                              title: task.title ?? 'Untitled Task',
                                              subtitle: milestone.name ?? 'Milestone',
                                              dueDate: _formatDueDate(dueDate),
                                              status: status,
                                              statusColor: status == 'Completed' 
                                                  ? const Color(0xFFE8F5E9) 
                                                  : const Color(0xFFE8E8E8),
                                              statusTextColor: status == 'Completed' 
                                                  ? const Color(0xFF4CAF50) 
                                                  : AppColors.lightGrey2,
                                            ),
                                          );
                                        })
                                      else
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16),
                                          child: Text(
                                            'No tasks in this milestone',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: AppFonts.interRegular,
                                              color: AppColors.lightGrey2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              })
                            else
                              const Padding(
                                padding: EdgeInsets.only(left: 16, bottom: 16),
                                child: Text(
                                  'No milestones in this project',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: AppFonts.interRegular,
                                    color: AppColors.lightGrey2,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),
                          ],
                        );
                      }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),],)
          );
        },
      ),
    );
  }

  String _formatDueDate(DateTime? date) {
    if (date == null) return 'No due date';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Due: ${date.day} ${months[date.month - 1]}';
  }

  // Widget _buildStatCard(String percentage, String label) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: AppColors.black,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           percentage,
  //           style: const TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             fontFamily: AppFonts.interBold,
  //             color: AppColors.white,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           label,
  //           style: const TextStyle(
  //             fontSize: 12,
  //             fontFamily: AppFonts.interRegular,
  //             color: AppColors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
