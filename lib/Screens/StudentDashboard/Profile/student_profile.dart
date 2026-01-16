import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Screens/Auth/login_screen.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/student_profile_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<StudentProfileProvider>().getStudentProfileApiTap(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<StudentProfileProvider>(
        builder: (context, provider, child) {
          if(provider.studentProfileLoading){
            return StudentProfileShimmer();
          }
    
         
          final profileData = provider.studentProfile?.data;
    
          return CustomScrollView(
            slivers: [
              // App Bar with Pro
              //file Header
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                   IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                       await SharedPref.clearAll();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                    },
                  ),
                  wSpace(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => provider.editProfile(context),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.black, Color(0xFF2A2A2A)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        // Profile Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: "${Apis.baseUrl}${profileData?.profilePhoto ?? ''}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: LoadingAnimationWidget.fallingDot(color: Colors.grey, size: 24),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          profileData?.fullName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // School
                        Text(
                          profileData?.school ?? 'N/A',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${"CGPA ${profileData?.cgpa ?? "-"}"} • Age ${profileData?.age ?? '-'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    
              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
    
                    // Analytics Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard(
                              'Projects',
                              '${provider.completedProjects}/${profileData?.assignedProjects?.length ?? 0}',
                              'Completed',
                              Icons.folder_outlined,
                              Colors.blue,
                              provider.projectCompletionRate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildAnalyticsCard(
                              'Tasks',
                              '${provider.completedTasks}/${provider.totalTasks}',
                              'Completed',
                              Icons.task_alt,
                              AppColors.yellow100,
                              provider.taskCompletionRate,
                            ),
                          ),
                        ],
                      ),
                    ),
    
                    const SizedBox(height: 20),
    
                    // Contact Information Section
                    _buildSection(
                      title: 'Contact Information',
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.email_outlined,
                            'Email',
                            profileData?.email ?? 'N/A',
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            Icons.phone_outlined,
                            'Phone',
                            profileData?.phoneNumber ?? 'N/A',
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'Address',
                            profileData?.location ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
    
                    const SizedBox(height: 20),
    
                    // Current Project Section
                    _buildSection(
                      title: 'Current Projects',
                      child: Column(
                        children: [
                          for(int i = 0; i < (profileData?.assignedProjects?.length ?? 0); i++)...[
                            hSpace(height: 12),
                          _buildInfoRow(
                            Icons.work_outline,
                            profileData?.assignedProjects?[i].title ?? 'N/A',
                            profileData?.assignedProjects?[i].projectDescription ?? 'N/A',
                          ),
                          ]
                        ],
                      ),
                    ),
    
                    // const SizedBox(height: 20),
    
                    // // Mentors Section
                    // _buildSection(
                    //   title: 'My Team',
                    //   child: Column(
                    //     children: [
                    //       _buildContactRow(
                    //         Icons.school_outlined,
                    //         'Mentor',
                    //         provider.mentorName,
                    //         () => provider.contactMentor(),
                    //       ),
                    //       _buildDivider(),
                    //       _buildContactRow(
                    //         Icons.person_outline,
                    //         'Counsellor',
                    //         provider.counsellorName,
                    //         () => provider.contactCounsellor(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
    
                    const SizedBox(height: 20),
    
                    // Activities SectionY
                    if(profileData?.expertise != null && profileData!.expertise!.isNotEmpty)
                    _buildSection(
                      title: 'Activities',
                      child: Column(
                        children: profileData.expertise!.asMap().entries.map((
                          entry,
                        ) {
                          final isLast =
                              entry.key == profileData.expertise!.length - 1;
                          return Column(
                            children: [
                              _buildActivityItem(entry.value),
                              if (!isLast) _buildDivider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
    
                    const SizedBox(height: 20),
    
                    // Achievements Section
                    if(profileData?.achievements != null && profileData!.achievements!.isNotEmpty)
                    _buildSection(
                      title: 'Achievements',
                      child: Column(
                        children: profileData.achievements!.asMap().entries.map((
                          entry,
                        ) {
                          final isLast =
                              entry.key == profileData.achievements!.length - 1;
                          return Column(
                            children: [
                              _buildAchievementItem(entry.value),
                              if (!isLast) _buildDivider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
    
                    const SizedBox(height: 20),
    
                    // Task Analytics Section
                    // _buildSection(
                    //   title: 'Task Analytics',
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           _buildTaskStat(
                    //             'Completed',
                    //             provider.completedTasks.toString(),
                    //             Colors.green,
                    //           ),
                    //           _buildTaskStat(
                    //             'Pending',
                    //             provider.pendingTasks.toString(),
                    //             Colors.orange,
                    //           ),
                    //           _buildTaskStat(
                    //             'Overdue',
                    //             provider.overdueTasks.toString(),
                    //             Colors.red,
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 16),
                    //       _buildProgressBar(
                    //         'Overall Completion',
                    //         provider.taskCompletionRate,
                    //       ),
                    //       const SizedBox(height: 12),
                    //       _buildProgressBar(
                    //         'This Week',
                    //         provider.weeklyProductivity,
                    //       ),
                    //     ],
                    //   ),
                    // ),
    
                    // const SizedBox(height: 20),
    
                    // // Recent Projects Section
                    // _buildSection(
                    //   title: 'Recent Projects',
                    //   child: Column(
                    //     children: provider.recentProjects.asMap().entries.map(
                    //       (entry) {
                    //         final isLast =
                    //             entry.key ==
                    //             provider.recentProjects.length - 1;
                    //         return Column(
                    //           children: [
                    //             _buildProjectItem(
                    //               entry.value,
                    //               () => provider.viewProjectDetails(
                    //                 entry.value['name'],
                    //               ),
                    //             ),
                    //             if (!isLast) const SizedBox(height: 12),
                    //           ],
                    //         );
                    //       },
                    //     ).toList(),
                    //   ),
                    // ),
    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    double percentage,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.message_outlined, size: 20),
          color: AppColors.black,
          onPressed: onTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(achievement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.amber.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.date ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: AppColors.lightGrey,
          color: AppColors.black,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildProjectItem(Map<String, dynamic> project, VoidCallback onTap) {
    final progress = project['progress'] as double;
    final status = project['status'] as String;
    final isCompleted = status == 'Completed';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Due: ${project['dueDate']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: isCompleted ? Colors.green : Colors.blue,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% Complete',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Colors.grey.shade300),
    );
  }
}
