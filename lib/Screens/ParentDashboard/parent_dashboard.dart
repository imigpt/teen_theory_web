import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/all_meeting_model.dart';
import 'package:teen_theory/Models/CommonModels/multi_participatemeeting_model.dart' as participate_model;
import 'package:url_launcher/url_launcher.dart';
import 'package:teen_theory/Providers/ParentProvider/parent_dash_provider.dart';
import 'package:teen_theory/Screens/ParentDashboard/ActiveProjects/detail_active_project.dart';
import 'package:teen_theory/Screens/ParentDashboard/ActiveProjects/parent_active_projects.dart';
import 'package:teen_theory/Screens/ParentDashboard/ParentTaskDue/parent_task_due.dart';
import 'package:teen_theory/Screens/ParentDashboard/ProfileScreens/profile_screen.dart';
import 'package:teen_theory/Screens/ParentDashboard/ViewProgress/view_progress.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/ParentShimmer/parent_dashboard_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> with SingleTickerProviderStateMixin {
  late TabController _meetingTabController;

  @override
  void initState() {
    super.initState();
    _meetingTabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentDashProvider>().getParentProfileApiTap();
      context.read<ParentDashProvider>().fetchMeetingsApiTap();
      context.read<ParentDashProvider>().fetchParticipantMeetingsTap();
    });
  }

  @override
  void dispose() {
    _meetingTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Consumer<ParentDashProvider>(
        builder: (context, provider, child) {
          // Show shimmer while loading
          if (provider.isLoading) {
            return const ParentDashboardShimmer();
          }

          // Show message if no data
          if (provider.parentProfileData == null) {
            return const Center(child: Text('No data available'));
          }

          final profileData = provider.parentProfileData!.data;
          if (profileData == null) {
            return const Center(child: Text('No profile data available'));
          }

          return RefreshIndicator(
            onRefresh: () {
              return Future.wait([
                Future.sync(
                  () => context
                      .read<ParentDashProvider>()
                      .getParentProfileApiTap(),
                ),
                Future.sync(
                  () =>
                      context.read<ParentDashProvider>().fetchMeetingsApiTap(),
                ),
                Future.sync(
                  () => context
                      .read<ParentDashProvider>()
                      .fetchParticipantMeetingsTap(),
                ),
              ]);
            },
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section with Parent Info and Notification
                      Row(
                        children: [
                          // Avatar
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ParentProfileScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF667EEA),
                                    Color(0xFF764BA2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFF667EEA,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '👨‍👩‍👧',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name and Role
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.parentProfileData?.data?.fullName ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Parent',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatListScreen(projectId: 1)));
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.all(8),
                          //     decoration: BoxDecoration(
                          //       color: Colors.grey.shade200,
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: const Icon(
                          //       Icons.chat,
                          //       size: 24,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          wSpace(width: 10),
                          // Notification Bell
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.notifications_none,
                              size: 22,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Child Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFFFF), Color(0xFFF9F9FB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Child Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors:
                                      profileData.child?.profilePhoto != null
                                      ? [Colors.transparent, Colors.transparent]
                                      : [Color(0xFF667EEA), Color(0xFF764BA2)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFF667EEA,
                                    ).withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: profileData.child?.profilePhoto != null
                                  ? CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                        "${Apis.baseUrl}${profileData.child!.profilePhoto!}",
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        '👨‍🎓',
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Child Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileData.child?.fullName ?? 'Child',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profileData.child?.school ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Overall Progress
                            Builder(
                              builder: (context) {
                                // Calculate overall progress from all project milestones
                                final assignedProjects =
                                    profileData.child?.assignedProjects ?? [];
                                int totalMilestones = 0;
                                int completedMilestones = 0;

                                for (var project in assignedProjects) {
                                  final milestones = project.milestones ?? [];
                                  totalMilestones += milestones.length;
                                  completedMilestones += milestones
                                      .where(
                                        (m) =>
                                            m.status == 'approved' ||
                                            m.status == 'completed',
                                      )
                                      .length;
                                }

                                final progressPercentage = totalMilestones > 0
                                    ? ((completedMilestones / totalMilestones) *
                                              100)
                                          .toStringAsFixed(0)
                                    : '0';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Overall Progress',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$progressPercentage%',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Stats Cards
                      Row(
                        children: [
                          // Active Projects Card
                          Expanded(
                            child: _buildStatCard(
                              'Active Projects',
                              (profileData.child?.assignedProjects?.length ?? 0)
                                  .toString(),
                              Colors.black,
                              Icons.folder_outlined,
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ParentActiveProjects(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Task Due Card
                          Expanded(
                            child: _buildStatCard(
                              'Project Due',
                              profileData.child?.assignedProjects
                                      ?.where(
                                        (element) =>
                                            element.status == "pending",
                                      )
                                      .length
                                      .toString() ??
                                  '0',
                              Colors.black,
                              Icons.assignment_outlined,
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ParentTaskDue(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Completed Tasks Card
                          // Expanded(
                          //   child: _buildStatCard(
                          //     'Completed Tasks',
                          //     '0',
                          //     Colors.black,
                          //     Icons.check_circle_outline,
                          //     () {
                          //       Navigator.of(context).push(
                          //         MaterialPageRoute(
                          //           builder: (context) => CompletedTask(),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Quick Actions Section
                      const Text(
                        '⚡ Quick Actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Request Meeting Button
                          // Expanded(
                          //   child: _buildQuickActionButton(
                          //     context,
                          //     'Request Meeting',
                          //     Icons.calendar_today_outlined,
                          //     () {
                          //       Navigator.of(context).push(
                          //         MaterialPageRoute(
                          //           builder: (context) => RequestMeeting(),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          const SizedBox(width: 12),
                          // View Progress Button
                          Expanded(
                            child: _buildQuickActionButton(
                              context,
                              'View Progress Detailed Analytics',
                              Icons.analytics_outlined,
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewProgress(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Current Projects Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '📁 Current Projects',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () => provider.viewAllProjects(),
                            child: const Text(
                              'View all',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Current Projects List
                      ..._buildAssignedProjectsList(profileData)
                          .map(
                            (project) =>
                                _buildProjectCard(context, provider, project),
                          )
                          .toList(),

                      const SizedBox(height: 24),

                      // Meetings section with Tabs
                      Consumer<ParentDashProvider>(
                        builder: (context, parentPvd, child) {
                          final counsellorMeetings = parentPvd.allMeetingsData?.data ?? [];
                          final participantMeetings = parentPvd.participantMeetings;
                          
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Header
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: Row(
                                    children: [
                                      Text('📅 ', style: TextStyle(fontSize: 20)),
                                      Text(
                                        'Meetings',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // TabBar
                                TabBar(
                                  controller: _meetingTabController,
                                  indicatorColor: Color(0xFF2980B9),
                                  labelColor: Color(0xFF2980B9),
                                  unselectedLabelColor: Colors.grey,
                                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  tabs: [
                                    Tab(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Counsellor Meetings'),
                                          if (participantMeetings.isNotEmpty) ...[
                                            SizedBox(width: 6),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF2980B9),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                '${participantMeetings.length}',
                                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Meeting'),
                                          if (counsellorMeetings.isNotEmpty) ...[
                                            SizedBox(width: 6),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF667EEA),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                '${counsellorMeetings.length}',
                                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // TabBarView
                                SizedBox(
                                  height: 400,
                                  child: TabBarView(
                                    controller: _meetingTabController,
                                    children: [
                                      // My Meetings Tab
                                      _buildParticipantMeetingsTab(participantMeetings),
                                      
                                      // Counsellor Meeting Tab
                                      _buildCounsellorMeetingsTab(counsellorMeetings),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color bgColor,
    IconData icon,
    VoidCallback onTap,
  ) {
    // Get gradient colors based on title
    List<Color> gradientColors;
    String emoji;

    if (title.contains('Active')) {
      gradientColors = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
      emoji = '📁';
    } else if (title.contains('Due')) {
      gradientColors = [Color(0xFFFFA751), Color(0xFFFFE259)];
      emoji = '⏰';
    } else {
      gradientColors = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
      emoji = '✅';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(emoji, style: TextStyle(fontSize: 18)),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _buildAssignedProjectsList(dynamic profileData) {
    final assignedProjects = profileData?.child?.assignedProjects ?? [];

    if (assignedProjects.isEmpty) {
      return [];
    }

    return assignedProjects.map<Map<String, dynamic>>((project) {
      // Calculate progress from milestones
      final milestones = project.milestones ?? [];
      final totalMilestones = milestones.length;
      final completedCount = milestones
          .where((m) => m.status == 'approved' || m.status == 'completed')
          .length;

      final progressValue = totalMilestones > 0
          ? completedCount / totalMilestones
          : 0.0;
      final progressPercentage = totalMilestones > 0
          ? '${((completedCount / totalMilestones) * 100).toStringAsFixed(0)}%'
          : '0%';

      return {
        'title': project.title ?? 'Untitled Project',
        'dueDate': project.dueDate != null
            ? 'Due: ${project.dueDate!.day}/${project.dueDate!.month}/${project.dueDate!.year}'
            : 'No due date',
        'status': project.status ?? 'Unknown',
        'tasksRemaining': '$totalMilestones Milestones',
        'progress': progressValue,
        'progressPercentage': progressPercentage,
        'statusColor': 'blue',
      };
    }).toList();
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    // Get gradient colors based on label
    List<Color> gradientColors;
    String emoji;

    if (label.contains('Meeting')) {
      gradientColors = [Color(0xFFFF758C), Color(0xFFFF7EB3)];
      emoji = '📅';
    } else if (label.contains('Progress')) {
      gradientColors = [Color(0xFF667EEA), Color(0xFF764BA2)];
      emoji = '📊';
    } else {
      gradientColors = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
      emoji = '⚡';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    ParentDashProvider provider,
    Map<String, dynamic> project,
  ) {
    return GestureDetector(
      onTap: () {
        // Get the actual AssignedProject object from API data
        final assignedProjects =
            provider.parentProfileData?.data?.child?.assignedProjects ?? [];
        final projectTitle = project['title'];

        // Find matching project
        final assignedProject = assignedProjects.firstWhere(
          (p) => p.title == projectTitle,
          orElse: () => assignedProjects.isNotEmpty
              ? assignedProjects.first
              : null as dynamic,
        );

        if (assignedProject != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DetailActiveProject(project: assignedProject),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF6DD5FA).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Progress Percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('📁 ', style: TextStyle(fontSize: 14)),
                          Expanded(
                            child: Text(
                              project['title'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          project['dueDate'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress Percentage Circle with AnimatedCircularChart
                Column(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: AnimatedCircularChart(
                        size: const Size(48.0, 48.0),
                        initialChartData: <CircularStackEntry>[
                          CircularStackEntry(<CircularSegmentEntry>[
                            CircularSegmentEntry(
                              project['progress'] * 100,
                              Colors.black,
                              rankKey: 'completed',
                            ),
                            CircularSegmentEntry(
                              (1 - project['progress']) * 100,
                              Colors.grey.shade300,
                              rankKey: 'remaining',
                            ),
                          ]),
                        ],
                        chartType: CircularChartType.pie,
                        holeLabel: '',
                        labelStyle: const TextStyle(fontSize: 0),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      project['progressPercentage'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status and Tasks Remaining
            Row(
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    project['status'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Tasks Remaining
                Row(
                  children: [
                    Text('📋 ', style: TextStyle(fontSize: 12)),
                    Text(
                      project['tasksRemaining'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(MeetingModel meeting) {
    // Parse the meeting date time
    DateTime? meetingDateTime;
    try {
      if (meeting.dateTime != null) {
        meetingDateTime = DateTime.parse(meeting.dateTime!);
      }
    } catch (e) {
      // Handle parse error
    }

    final formattedDate = meetingDateTime != null
        ? DateFormat('dd MMM • hh:mm a').format(meetingDateTime)
        : 'Date not available';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF667EEA).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Meeting Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667EEA).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text('📅', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),

          // Meeting Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.title ?? 'Meeting',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  meeting.projectName ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              meeting.status ?? 'Scheduled',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Participant Meetings Tab
  Widget _buildParticipantMeetingsTab(List<participate_model.Datum> meetings) {
    if (meetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No meetings yet',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: meetings.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFF8F9FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6DD5FA).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.videocam_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meeting.meetingTitle ?? 'No Title',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (meeting.meetingDescription != null && meeting.meetingDescription!.isNotEmpty)
                            Text(
                              meeting.meetingDescription!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          try {
                            String urlString = meeting.meetingLink!;
                            if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
                              urlString = 'https://$urlString';
                            }
                            final url = Uri.parse(urlString);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            } else {
                              showToast('Could not launch meeting link', type: toastType.error);
                            }
                          } catch (e) {
                            showToast('Invalid meeting link', type: toastType.error);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF758C).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
                if (meeting.studentEmails != null && meeting.studentEmails!.isNotEmpty ||
                    meeting.mentorEmails != null && meeting.mentorEmails!.isNotEmpty ||
                    meeting.parentEmails != null && meeting.parentEmails!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (meeting.studentEmails != null && meeting.studentEmails!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF6DD5FA).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${meeting.studentEmails!.length} Students',
                            style: TextStyle(fontSize: 11, color: Color(0xFF2980B9)),
                          ),
                        ),
                      if (meeting.mentorEmails != null && meeting.mentorEmails!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF667EEA).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${meeting.mentorEmails!.length} Mentors',
                            style: TextStyle(fontSize: 11, color: Color(0xFF667EEA)),
                          ),
                        ),
                      if (meeting.parentEmails != null && meeting.parentEmails!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFA751).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${meeting.parentEmails!.length} Parents',
                            style: TextStyle(fontSize: 11, color: Color(0xFFFF6B35)),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // Build Counsellor Meetings Tab
  Widget _buildCounsellorMeetingsTab(List<MeetingModel> meetings) {
    if (meetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No counsellor meetings yet',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return _buildMeetingCard(meeting);
      },
    );
  }
}
