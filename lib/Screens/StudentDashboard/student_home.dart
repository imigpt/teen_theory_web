import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/multi_participatemeeting_model.dart' as participate_model;
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_meeting_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_notification_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/ActiveProjects/active_projects.dart';
import 'package:teen_theory/Screens/StudentDashboard/Notes/notes.dart';
import 'package:teen_theory/Screens/StudentDashboard/Profile/student_profile.dart';
import 'package:teen_theory/Screens/StudentDashboard/StudentNotification/student_notification.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/active_project_shimmer.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/appbar_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> with SingleTickerProviderStateMixin {
  late TabController _meetingTabController;

@override
  void initState() {
    super.initState();
    _meetingTabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<StudentProfileProvider>().getStudentProfileApiTap(context);
        context.read<DetailProjectProvider>().filteredMeetingLinkApiTap(context);
      context.read<StudentMeetingProvider>().fetchMeetings();
      context.read<StudentMeetingProvider>().fetchParticipantMeetings();
      context.read<StudentNotificationProvider>().fetchNotifications();
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future.wait([
            Future.sync(() => context.read<StudentProfileProvider>().getStudentProfileApiTap(context)),
            Future.sync(() => context.read<DetailProjectProvider>().filteredMeetingLinkApiTap(context)),
            Future.sync(() => context.read<StudentMeetingProvider>().fetchMeetings()),
            Future.sync(() => context.read<StudentMeetingProvider>().fetchParticipantMeetings()),
            Future.sync(() => context.read<StudentNotificationProvider>().fetchNotifications()),
          ]);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Consumer<StudentProfileProvider>(
                    builder: (context, stdPvd, child) {
                      if(stdPvd.studentProfileLoading){
                        return AppbarShimmer();
                      }
        
                      final data = stdPvd.studentProfile?.data;
                    return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StudentProfile(),
                                ),
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667EEA).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: data?.profilePhoto == null 
                                ? Center(
                                    child: Text('👩‍🎓', style: TextStyle(fontSize: 26)),
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      "${Apis.baseUrl}${data!.profilePhoto}",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Text('👩‍🎓', style: TextStyle(fontSize: 26)),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                data?.fullName ?? "N/A",
                                style: textStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 18,
                                ),
                              ),
                              Text("Student")
                            ],
                          ),
                        ],
                      ),
        
                    Row(
                      children: [
                          wSpace(width: 16),
                          Consumer<StudentNotificationProvider>(
                            builder: (context, notiProvider, _) {
                              final bool loading = notiProvider.isLoading && !notiProvider.hasFetched;
                              final int count = notiProvider.notifications.length;
                              final String badgeText = loading ? '--' : (count > 99 ? '99+' : count.toString());
                              final bool showBadge = loading || count > 0;
        
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const StudentNotificationScreen(),
                                    ),
                                  );
                                  // Mark notifications as read after viewing
                                  if (mounted) {
                                    notiProvider.clearNotifications();
                                  }
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Center(child: Icon(Icons.notifications_none, size: 22)),
                                      if (showBadge)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.1),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              badgeText,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                  }),
                  hSpace(height: 24),
                  Consumer<StudentProfileProvider>(
                    builder: (context, stdPvd, child) {
                      final projects = stdPvd.studentProfile?.data?.assignedProjects ?? [];
                      
                      // Calculate overall progress based on project milestones
                      int totalMilestones = 0;
                      int completedMilestones = 0;
                      int totalProjects = projects.length;
                      int completedProjects = 0;
                      
                      for (final project in projects) {
                        if (project.status?.toLowerCase() == 'completed') {
                          completedProjects++;
                        }
                        
                        if (project.milestones != null) {
                          for (final milestone in project.milestones!) {
                            totalMilestones++;
                            if (milestone.status?.toLowerCase() == 'approved' || 
                                milestone.status?.toLowerCase() == 'completed') {
                              completedMilestones++;
                            }
                          }
                        }
                      }
                      
                      // Calculate progress percentage
                      double progressPercentage = 0.0;
                      if (totalMilestones > 0) {
                        progressPercentage = completedMilestones / totalMilestones;
                      } else if (totalProjects > 0) {
                        progressPercentage = completedProjects / totalProjects;
                      }
                      
                      // Calculate pending tasks
                      int pendingMilestones = totalMilestones - completedMilestones;
                      
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color.fromRGBO(71, 73, 81, 1), Color.fromARGB(255, 45, 37, 52)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF667EEA).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('📊 ', style: TextStyle(fontSize: 20)),
                                      Text(
                                        "Overall Progress",
                                        style: textStyle(
                                          fontSize: 16,
                                          fontFamily: AppFonts.interBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$completedMilestones/$totalMilestones Tasks",
                                      style: textStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: AppFonts.interMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              hSpace(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progressPercentage,
                                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 10,
                                ),
                              ),
                              hSpace(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('🎯 ', style: TextStyle(fontSize: 16)),
                                      Text(
                                        "${(progressPercentage * 100).toStringAsFixed(0)}% completed",
                                        style: textStyle(
                                          color: Colors.white,
                                          fontFamily: AppFonts.interMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('📋 ', style: TextStyle(fontSize: 16)),
                                      Text(
                                        "$pendingMilestones pending",
                                        style: textStyle(
                                          color: Colors.white,
                                          fontFamily: AppFonts.interMedium,
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
                    },
                  ),
                  hSpace(height: 24),
                  Row(
                    spacing: 10,
                    children: [
                      Flexible(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ActiveProjects(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF6DD5FA).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Active \nProjects",
                                            style: textStyle(
                                              fontSize: 12,
                                              fontFamily: AppFonts.interBold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text('📁', style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.read<StudentProfileProvider>().studentProfile?.data?.assignedProjects?.where((e) => e.status == "pending").length.toString() ?? "0",
                                          style: textStyle(
                                            fontSize: 20,
                                            fontFamily: AppFonts.interBold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "ongoing",
                                          style: textStyle(
                                            fontSize: 10,
                                            color: Colors.white.withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context) => TaskDue()),
                            // );
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFFA751), Color(0xFFFFE259)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFFA751).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Project \nDue",
                                            style: textStyle(
                                              fontSize: 12,
                                              fontFamily: AppFonts.interBold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text('✅', style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.read<StudentProfileProvider>().studentProfile?.data?.assignedProjects?.where((element) => element.status == "pending").length.toString() ?? "0",
                                          style: textStyle(
                                            fontSize: 20,
                                            fontFamily: AppFonts.interBold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "pending",
                                          style: textStyle(
                                            fontSize: 10,
                                            color: Colors.white.withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                           Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Notes(),
                              ),
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF758C).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text("Notes",
                                            style: textStyle(
                                              fontSize: 12,
                                              fontFamily: AppFonts.interBold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Consumer<StudentMeetingProvider>(
                                          builder: (context, meetingProvider, _) {
                                            final bool loading = meetingProvider.isLoading && !meetingProvider.hasFetched;
                                            final String countText = loading
                                                ? '--'
                                                : meetingProvider.upcomingMeetings.length.toString();
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  countText,
                                                  style: textStyle(
                                                    fontSize: 20,
                                                    fontFamily: AppFonts.interBold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  hSpace(height: 24),
                  Container(
                    width: double.infinity,
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('🚀 ', style: TextStyle(fontSize: 20)),
                                  Text(
                                    "Active Projects",
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ActiveProjects(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "View all",
                                    style: textStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.interMedium,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          // ...existing code...
                          Consumer<StudentProfileProvider>(
                            builder: (context, pvd, child) {
                              if(pvd.studentProfileLoading){
                                return ActiveProjectShimmer();
                              }
                              final projects = pvd.studentProfile?.data?.assignedProjects ?? [];
                              if(projects.isEmpty){
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    "You are not assigned to any project",
                                    style: textStyle(
                                      fontSize: 14,
                                      color: AppColors.lightGrey2,
                                    ),
                                  ),
                                );
                              }
                            return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              final projectList = projects[index];
                              
                              // Calculate progress for this project
                              final milestones = projectList.milestones ?? [];
                              final totalMilestones = milestones.length;
                              int completedCount = 0;
                              
                              for (final milestone in milestones) {
                                if (milestone.status?.toLowerCase() == 'approved' || 
                                    milestone.status?.toLowerCase() == 'completed') {
                                  completedCount++;
                                }
                              }
                              
                              final double completedPercentage = totalMilestones > 0 
                                  ? (completedCount / totalMilestones) * 100 
                                  : 0.0;
                              final double remainingPercentage = 100.0 - completedPercentage;
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // left: small circular chart + percentage
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: AnimatedCircularChart(
                                                size: const Size(48.0, 48.0),
                                                initialChartData:
                                                    <CircularStackEntry>[
                                                      CircularStackEntry(
                                                        <CircularSegmentEntry>[
                                                          CircularSegmentEntry(
                                                            completedPercentage,
                                                            Colors.black,
                                                            rankKey: 'completed',
                                                          ),
                                                          CircularSegmentEntry(
                                                            remainingPercentage,
                                                            Colors.grey.shade300,
                                                            rankKey: 'remaining',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                chartType: CircularChartType.pie,
                                                holeLabel: '',
                                                labelStyle: const TextStyle(
                                                  fontSize: 0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${completedPercentage.toStringAsFixed(0)}%',
                                              style: textStyle(
                                                fontFamily: AppFonts.interBold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
        
                                        const SizedBox(width: 12),
        
                                        // middle: title, due, mentor, badges
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                projectList.title ?? 'N/A',
                                                style: textStyle(
                                                  fontFamily: AppFonts.interBold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                projectList.dueDate == null ? "Due: -" : 'Due: ${DateFormat("dd-MM-yyyy").format(projectList.dueDate!)}',
                                                style: textStyle(
                                                  color: AppColors.lightGrey2,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                'Mentor: ${projectList.assignedMentor?.name ?? 'N/A'}',
                                                style: textStyle(
                                                  color: AppColors.lightGrey2,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              // badges
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow.shade100,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                      '${projectList.milestones?.where((milestone) => milestone.status != "pending").length} Task Completed',
                                                      style: textStyle(
                                                        color: Colors.yellow.shade900,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange.shade50,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                      '${projectList.milestones?.where((milestone) => milestone.status == "pending").length} Pending',
                                                      style: textStyle(
                                                        color: AppColors.orange,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
        
                                    const SizedBox(height: 12),
                                    Divider(
                                      color: AppColors.lightGrey3,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ); 
                          })
                        ],
                      ),
                    ),
                  ),
        
                  hSpace(height: 20),
                  // ...existing code...
                  hSpace(height: 20),
        
                  // Upcoming Meetings section with Tabs
                  Consumer<StudentMeetingProvider>(
                    builder: (context, meetingPvd, child) {
                      final counsellorMeetings = meetingPvd.upcomingMeetings;
                      final participantMeetings = meetingPvd.participantMeetings;
                      
                      return Container(
                        width: double.infinity,
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
                            // Header with Tabs
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Row(
                                children: [
                                  Text('👥 ', style: TextStyle(fontSize: 20)),
                                  Text(
                                    'Meetings',
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                      fontSize: 18,
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
                              labelStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              tabs: [
                                Tab(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Counsellor Meetings'),
                                      if (participantMeetings.isNotEmpty) ...[
                                        wSpace(width: 6),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2980B9),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${participantMeetings.length}',
                                            style: textStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
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
                                      Text('My Meeting'),
                                      if (counsellorMeetings.isNotEmpty) ...[
                                        wSpace(width: 6),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF667EEA),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${counsellorMeetings.length}',
                                            style: textStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
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
                                  _buildCounsellorMeetingsTab(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  hSpace(height: 20),
                ],
              ),
            ),
          ),
        ),
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
            hSpace(height: 12),
            Text(
              'No meetings yet',
              style: textStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: meetings.length,
      separatorBuilder: (_, __) => hSpace(height: 12),
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
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
                    wSpace(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meeting.meetingTitle ?? 'No Title',
                            style: textStyle(
                              fontFamily: AppFonts.interBold,
                              fontSize: 14,
                            ),
                          ),
                          hSpace(height: 4),
                          if (meeting.meetingDescription != null && meeting.meetingDescription!.isNotEmpty)
                            Text(
                              meeting.meetingDescription!,
                              style: textStyle(
                                color: AppColors.lightGrey2,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                hSpace(height: 12),
                // Action Buttons Row
                Row(
                  children: [
                    if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty)
                      Expanded(
                        child: InkWell(
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
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF758C).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.videocam, size: 16, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'Join',
                                  style: textStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.interMedium,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty)
                      wSpace(width: 8),
                    // Notes Button
                    Expanded(
                      child: InkWell(
                        onTap: () => _showAddNotesDialog(context, meeting.meetingTitle ?? 'Meeting Notes'),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF667EEA).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.note_add, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Notes',
                                style: textStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.interMedium,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    wSpace(width: 8),
                    InkWell(
                      onTap: () async {
                        // Show confirmation dialog
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Meeting'),
                            content: Text('Are you sure you want to delete this meeting?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && meeting.id != null) {
                          await DioClient.deleteMeetingApi(
                            meetingId: meeting.id!,
                            onSuccess: (response) {
                              showToast('Meeting deleted successfully', type: toastType.success);
                              context.read<StudentMeetingProvider>().fetchParticipantMeetings();
                            },
                            onError: (error) {
                              showToast('Failed to delete meeting', type: toastType.error);
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                hSpace(height: 12),
                Row(
                  children: [
                    Text('📅 ', style: TextStyle(fontSize: 14)),
                    Text(
                      meeting.createdAt != null
                          ? DateFormat('dd MMM yyyy, hh:mm a').format(meeting.createdAt!)
                          : '-',
                      style: textStyle(
                        color: AppColors.lightGrey2,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (meeting.studentEmails != null && meeting.studentEmails!.isNotEmpty ||
                    meeting.mentorEmails != null && meeting.mentorEmails!.isNotEmpty ||
                    meeting.parentEmails != null && meeting.parentEmails!.isNotEmpty) ...[
                  hSpace(height: 8),
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
                            style: textStyle(fontSize: 11, color: Color(0xFF2980B9)),
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
                            style: textStyle(fontSize: 11, color: Color(0xFF667EEA)),
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
                            style: textStyle(fontSize: 11, color: Color(0xFFFF6B35)),
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

  // Build Counsellor Meetings Tab (existing meetings from DetailProjectProvider)
  Widget _buildCounsellorMeetingsTab() {
    return Consumer<DetailProjectProvider>(
      builder: (context, pvd, child) {
        final meetings = pvd.filteredMeetingData?.data ?? [];
        
        if (meetings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 48, color: Colors.grey),
                hSpace(height: 12),
                Text(
                  'No counsellor meetings yet',
                  style: textStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: meetings.length,
          separatorBuilder: (_, __) => hSpace(height: 12),
          itemBuilder: (context, index) {
            final meetingData = meetings[index];
            final isJoinable = index == 0;
            
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isJoinable
                      ? Color(0xFFFF758C).withValues(alpha: 0.3)
                      : Colors.grey.shade200,
                ),
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
                              colors: isJoinable
                                  ? [Color(0xFFFF758C), Color(0xFFFF7EB3)]
                                  : [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: (isJoinable
                                        ? Color(0xFFFF758C)
                                        : Color(0xFF667EEA))
                                    .withValues(alpha: 0.3),
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
                        wSpace(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meetingData.projectName ?? 'N/A',
                                style: textStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 14,
                                ),
                              ),
                              hSpace(height: 6),
                              Text(
                                meetingData.title ?? 'N/A',
                                style: textStyle(
                                  color: AppColors.lightGrey2,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    hSpace(height: 12),
                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              pvd.openMeetLink(link: meetingData.meetingLink ?? "");
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF758C).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.videocam, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Join',
                                    style: textStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.interMedium,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        wSpace(width: 8),
                        // Notes Button
                        Expanded(
                          child: InkWell(
                            onTap: () => _showAddNotesDialog(context, meetingData.projectName ?? ''),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667EEA).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.note_add, size: 16, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Notes',
                                    style: textStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.interMedium,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        wSpace(width: 8),
                        InkWell(
                          onTap: () async {
                            // Show confirmation dialog
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Meeting'),
                                content: Text('Are you sure you want to delete this meeting?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && meetingData.id != null) {
                              await DioClient.deleteMeetingApi(
                                meetingId: meetingData.id!,
                                onSuccess: (response) {
                                  showToast('Meeting deleted successfully', type: toastType.success);
                                  context.read<DetailProjectProvider>().filteredMeetingLinkApiTap(context);
                                },
                                onError: (error) {
                                  showToast('Failed to delete meeting', type: toastType.error);
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    hSpace(height: 12),
                    Row(
                      children: [
                        Text('📅 ', style: TextStyle(fontSize: 14)),
                        Text(
                          meetingData.dateTime == null
                              ? '-'
                              : (() {
                                  try {
                                    final dt = DateTime.parse(meetingData.dateTime!);
                                    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                                  } catch (_) {
                                    return meetingData.dateTime!;
                                  }
                                })(),
                          style: textStyle(
                            color: AppColors.lightGrey2,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show Add Notes Dialog
  void _showAddNotesDialog(BuildContext context, String projectName) {
    final TextEditingController notesController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.note_add, color: Color(0xFF667EEA), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Add Notes',
                        style: textStyle(
                          fontFamily: AppFonts.interBold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  hSpace(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF667EEA).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.work_outline, size: 16, color: Color(0xFF667EEA)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            projectName.isEmpty ? 'No Project' : projectName,
                            style: textStyle(
                              fontSize: 13,
                              fontFamily: AppFonts.interMedium,
                              color: Color(0xFF667EEA),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: notesController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Write your notes here...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    if (notesController.text.trim().isEmpty) {
                      showToast('Please write some notes', type: toastType.error);
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      // Get user email from profile
                      final profileProvider = context.read<StudentProfileProvider>();
                      final userEmail = profileProvider.studentProfile?.data?.email ?? '';

                      if (userEmail.isEmpty) {
                        showToast('User email not found', type: toastType.error);
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }

                      final body = {
                        "project_name": projectName,
                        "created_by_user_email": userEmail,
                        "created_date": DateTime.now().toIso8601String(),
                        "notes": notesController.text.trim(),
                      };

                      await DioClient.createNotesApi(
                        body: body,
                        onSuccess: (response) {
                          showToast('Notes added successfully', type: toastType.success);
                          Navigator.pop(dialogContext);
                        },
                        onError: (error) {
                          showToast('Failed to add notes: $error', type: toastType.error);
                          setState(() {
                            isLoading = false;
                          });
                        },
                      );
                    } catch (e) {
                      showToast('Error: ${e.toString()}', type: toastType.error);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF667EEA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.save, size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Save Notes',
                              style: textStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.interMedium,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}