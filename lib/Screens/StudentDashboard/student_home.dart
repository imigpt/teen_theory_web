import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_meeting_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_notification_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/ActiveProjects/active_projects.dart';
import 'package:teen_theory/Screens/StudentDashboard/Meetings/meeting.dart';
import 'package:teen_theory/Screens/StudentDashboard/Profile/student_profile.dart';
import 'package:teen_theory/Screens/StudentDashboard/StudentNotification/student_notification.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/active_project_shimmer.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/appbar_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<StudentProfileProvider>().getStudentProfileApiTap(context);
        context.read<DetailProjectProvider>().filteredMeetingLinkApiTap(context);
      context.read<StudentMeetingProvider>().fetchMeetings();
      context.read<StudentNotificationProvider>().fetchNotifications();
    });
  
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
                              child:data?.profilePhoto == null ? Center(
                                child: Text('👩‍🎓', style: TextStyle(fontSize: 26)),
                              ) : CircleAvatar(backgroundImage: NetworkImage("${Apis.baseUrl}${data!.profilePhoto}")),
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
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => TokenListScreen()));
                      //   },
                      //   child: Container(
                      //     width: 44,
                      //     height: 44,
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       shape: BoxShape.circle,
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.black.withValues(alpha: 0.06),
                      //           blurRadius: 8,
                      //           offset: Offset(0, 2),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Stack(
                      //       children: [
                      //         Center(child: Icon(Icons.token, size: 22)),
                      //         Positioned(
                      //           right: 10,
                      //           top: 10,
                      //           child: Container(
                      //             width: 8,
                      //             height: 8,
                      //             decoration: BoxDecoration(
                      //               gradient: LinearGradient(
                      //                 colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      //               ),
                      //               shape: BoxShape.circle,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                          wSpace(width: 16),
                          Consumer<StudentNotificationProvider>(
                            builder: (context, notiProvider, _) {
                              final bool loading = notiProvider.isLoading && !notiProvider.hasFetched;
                              final int count = notiProvider.notifications.length;
                              final String badgeText = loading ? '--' : (count > 99 ? '99+' : count.toString());
                              final bool showBadge = loading || count > 0;
        
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const StudentNotificationScreen(),
                                    ),
                                  );
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
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => MeetingScreen(),
                            //   ),
                            // );
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Meetings",
                                            style: textStyle(
                                              fontSize: 12,
                                              fontFamily: AppFonts.interBold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text('📅', style: TextStyle(fontSize: 20)),
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
                                                Text(
                                                  "scheduled",
                                                  style: textStyle(
                                                    fontSize: 10,
                                                    color: Colors.white.withValues(alpha: 0.9),
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
        
                  // Upcoming Meetings section
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
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('👥 ', style: TextStyle(fontSize: 20)),
                                  Text(
                                    'My Meetings',
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyMeetingScreen()));
                              //   },
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              //     decoration: BoxDecoration(
                              //       gradient: LinearGradient(
                              //         colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                              //       ),
                              //       borderRadius: BorderRadius.circular(20),
                              //     ),
                              //     child: Text(
                              //       'View all',
                              //       style: textStyle(
                              //         color: Colors.white,
                              //         fontFamily: AppFonts.interMedium,
                              //         fontSize: 13,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const Divider(),
        
                          // Meetings list
                          Consumer<DetailProjectProvider>(builder: (context, pvd, child) {
                            final meetings = pvd.filteredMeetingData?.data ?? [];
                            return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: meetings.length,
                            separatorBuilder: (_, __) => hSpace(height: 8),
                            itemBuilder: (context, index) {
                              final meetingData = meetings[index];
                              final isJoinable = index == 0;
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
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
                                      // Title row: icon, title + subtitle, action
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // meeting icon with gradient
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: isJoinable
                                                  ? [Color(0xFFFF758C), Color(0xFFFF7EB3)]
                                                  : [Color(0xFF667EEA), Color(0xFF764BA2)],
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: (isJoinable 
                                                    ? Color(0xFFFF758C)
                                                    : Color(0xFF667EEA)).withValues(alpha: 0.3),
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
                                          const SizedBox(width: 12),
        
                                          // title & subtitle
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  meetingData.projectName ?? 'N/A',
                                                  style: textStyle(
                                                    fontFamily:
                                                        AppFonts.interBold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
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
                           
                                          // action text/button
                                          
                                              InkWell(
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
                                                    child: Text(
                                                      'Join 🎥',
                                                      style: textStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            AppFonts.interMedium,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                              )
                                        ],
                                      ),
        
                                      const SizedBox(height: 12),
        
                                      // date/time row
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
                          })
                        ],
                      ),
                    ),
                  ),
        
                  hSpace(height: 20),
                  // ...existing code...
                  // ...existing code...
                  // Recent Activity
                  // Container(
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(16),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withValues(alpha: 0.06),
                  //         blurRadius: 12,
                  //         offset: Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Text('⚡ ', style: TextStyle(fontSize: 20)),
                  //                 Text(
                  //                   'Recent Activity',
                  //                   style: textStyle(
                  //                     fontFamily: AppFonts.interBold,
                  //                     fontSize: 18,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Container(
                  //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //               decoration: BoxDecoration(
                  //                 gradient: LinearGradient(
                  //                   colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(20),
                  //               ),
                  //               child: Text(
                  //                 'View all',
                  //                 style: textStyle(
                  //                   color: Colors.white,
                  //                   fontFamily: AppFonts.interMedium,
                  //                   fontSize: 13,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const Divider(),
        
                  //         // single activity card (repeat / map for multiple items)
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //           child: Container(
                  //             width: double.infinity,
                  //             decoration: BoxDecoration(
                  //               color: Color(0xFFF8F9FC),
                  //               borderRadius: BorderRadius.circular(12),
                  //               border: Border.all(
                  //                 color: Colors.green.shade100,
                  //               ),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(14.0),
                  //               child: Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   // green check circle with gradient
                  //                   Container(
                  //                     width: 40,
                  //                     height: 40,
                  //                     decoration: BoxDecoration(
                  //                       gradient: LinearGradient(
                  //                         colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                  //                       ),
                  //                       shape: BoxShape.circle,
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Color(0xFF56CCF2).withValues(alpha: 0.3),
                  //                           blurRadius: 8,
                  //                           offset: Offset(0, 2),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     child: const Icon(
                  //                       Icons.check_rounded,
                  //                       color: Colors.white,
                  //                       size: 22,
                  //                     ),
                  //                   ),
        
                  //                   const SizedBox(width: 12),
        
                  //                   // text column
                  //                   Expanded(
                  //                     child: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           'Task completed: "Research Paper Outline" ✨',
                  //                           style: textStyle(
                  //                             fontFamily: AppFonts.interMedium,
                  //                             fontSize: 14,
                  //                           ),
                  //                         ),
                  //                         const SizedBox(height: 6),
                  //                         Row(
                  //                           children: [
                  //                             Text('🕐 ', style: TextStyle(fontSize: 12)),
                  //                             Text(
                  //                               '2 Hours ago',
                  //                               style: textStyle(
                  //                                 color: AppColors.lightGrey2,
                  //                                 fontSize: 13,
                  //                               ),
                  //                             ),
                  //                             Text(' • ', style: TextStyle(color: AppColors.lightGrey2)),
                  //                             Text('📚 ', style: TextStyle(fontSize: 12)),
                  //                             Flexible(
                  //                               child: Text(
                  //                                 'AI & ML Project',
                  //                                 style: textStyle(
                  //                                   color: AppColors.lightGrey2,
                  //                                   fontSize: 13,
                  //                                 ),
                  //                                 overflow: TextOverflow.ellipsis,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  hSpace(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}