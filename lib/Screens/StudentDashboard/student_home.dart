import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/ActiveProjects/active_projects.dart';
import 'package:teen_theory/Screens/StudentDashboard/Meetings/meeting.dart';
import 'package:teen_theory/Screens/StudentDashboard/TaskDue/task_due.dart';
import 'package:teen_theory/Utils/helper.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage(AppImages.personLogo),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Riya Shah",
                              style: textStyle(fontFamily: AppFonts.interBold),
                            ),
                            Text("Student", style: textStyle()),
                          ],
                        ),
                      ],
                    ),
                    Icon(Icons.notifications),
                  ],
                ),
                hSpace(height: 30),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Overall progress",
                              style: textStyle(fontSize: 16),
                            ),
                            Text(
                              "Week 12/16",
                              style: textStyle(color: AppColors.lightGrey2),
                            ),
                          ],
                        ),
                        hSpace(height: 10),
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          value: 0.7,
                          backgroundColor: AppColors.lightGrey,
                          color: AppColors.black,
                          minHeight: 8,
                        ),
                        hSpace(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "75% completed",
                              style: textStyle(color: AppColors.lightGrey2),
                            ),
                            Text(
                              "4 weeks Remaining",
                              style: textStyle(color: AppColors.lightGrey2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                hSpace(height: 30),
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Active \nProjects",
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  ImageIcon(
                                    AssetImage(AppIcons.openFolder),
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                              hSpace(height: 10),
                              Text(
                                "5",
                                style: textStyle(
                                  fontSize: 30,
                                  fontFamily: AppFonts.interBold,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TaskDue()),
                          );
                        },
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Task \nDue",
                                      style: textStyle(
                                        fontFamily: AppFonts.interBold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    ImageIcon(
                                      AssetImage(AppIcons.completeTask),
                                      color: AppColors.white,
                                    ),
                                  ],
                                ),
                                hSpace(height: 10),
                                Text(
                                  "7",
                                  style: textStyle(
                                    fontSize: 30,
                                    fontFamily: AppFonts.interBold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
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
                              builder: (context) => MeetingScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Meeting",
                                      style: textStyle(
                                        fontFamily: AppFonts.interBold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.calendar,
                                      color: AppColors.white,
                                    ),
                                  ],
                                ),
                                hSpace(height: 10),
                                Text(
                                  "5",
                                  style: textStyle(
                                    fontSize: 30,
                                    fontFamily: AppFonts.interBold,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                hSpace(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey3,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightGrey3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Projects",
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 18,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ActiveProjects(),
                                  ),
                                );
                              },
                              child: Text(
                                "View all",
                                style: textStyle(
                                  color: AppColors.blue,
                                  fontFamily: AppFonts.interMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        // ...existing code...
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
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
                                                          75.0,
                                                          Colors.black,
                                                          rankKey: 'completed',
                                                        ),
                                                        CircularSegmentEntry(
                                                          25.0,
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
                                            '75%',
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
                                              'AI & Machine Learning',
                                              style: textStyle(
                                                fontFamily: AppFonts.interBold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Due: Dec 15, 2025',
                                              style: textStyle(
                                                color: AppColors.lightGrey2,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Mentor: Alex Watson',
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
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '3 Task Completed',
                                                    style: textStyle(
                                                      color:
                                                          Colors.green.shade700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.orange.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '2 Pending',
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
                        ),
                      ],
                    ),
                  ),
                ),
                // ...existing code...
                hSpace(height: 30),

                // Upcoming Tasks section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upcoming  Tasks',
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'View all',
                              style: textStyle(
                                color: AppColors.blue,
                                fontFamily: AppFonts.interMedium,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final isPrimary = index == 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 14.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // black bullet
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // title + due
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Submit AI Projects  Module 4',
                                                style: textStyle(
                                                  fontFamily:
                                                      AppFonts.interMedium,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                isPrimary
                                                    ? 'Due: Today, 11:59 PM'
                                                    : 'Due: Tomorrow, 5:00 PM',
                                                style: textStyle(
                                                  color: AppColors.lightGrey2,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // action button (primary vs outline)
                                        isPrimary
                                            ? Container(
                                                height: 36,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Start',
                                                    style: textStyle(
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : OutlinedButton(
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 6,
                                                      ),
                                                ),
                                                child: Text(
                                                  'View',
                                                  style: textStyle(),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                hSpace(height: 20),
                // ...existing code...
                // ...existing code...
                hSpace(height: 20),

                // Upcoming Meetings section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upcoming Meetings',
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'View all',
                              style: textStyle(
                                color: AppColors.blue,
                                fontFamily: AppFonts.interMedium,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Meetings list
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 2,
                          separatorBuilder: (_, __) => hSpace(height: 8),
                          itemBuilder: (context, index) {
                            final isJoinable = index == 0;
                            return Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 14.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title row: icon, title + subtitle, action
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // meeting icon
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrey,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.videocam,
                                            size: 18,
                                            color: Colors.black,
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
                                                'Meeting With Alex Watson',
                                                style: textStyle(
                                                  fontFamily:
                                                      AppFonts.interBold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'AI Project Review & Next Steps',
                                                style: textStyle(
                                                  color: AppColors.lightGrey2,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // action text/button
                                        isJoinable
                                            ? TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                                child: Text(
                                                  'Join',
                                                  style: textStyle(
                                                    color: AppColors.blue,
                                                    fontFamily:
                                                        AppFonts.interMedium,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 2.0,
                                                ),
                                                child: Text(
                                                  'Pending',
                                                  style: textStyle(
                                                    color: AppColors.lightGrey2,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // date/time row
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: AppColors.lightGrey2,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isJoinable
                                              ? 'Today, 3:00 PM'
                                              : 'Tomorrow, 7:00 PM',
                                          style: textStyle(
                                            color: AppColors.lightGrey2,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 18),
                                        Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: AppColors.lightGrey2,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '45 min',
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
                        ),
                      ],
                    ),
                  ),
                ),

                hSpace(height: 20),
                // ...existing code...
                // ...existing code...
                // Recent Activity
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Activity',
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'View all',
                              style: textStyle(
                                color: AppColors.blue,
                                fontFamily: AppFonts.interMedium,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // single activity card (repeat / map for multiple items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // green check circle
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // text column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Task completed: "Reseach Paper Outline"',
                                          style: textStyle(
                                            fontFamily: AppFonts.interMedium,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '2 Hours ago  -  AI & ML Project',
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                hSpace(height: 20),
                // ...existing code...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
