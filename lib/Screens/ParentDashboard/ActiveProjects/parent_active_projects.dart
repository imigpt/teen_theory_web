import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Providers/ParentProvider/parent_dash_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/ParentDashboard/ActiveProjects/detail_active_project.dart';
import 'package:teen_theory/Utils/helper.dart';

class ParentActiveProjects extends StatefulWidget {
  const ParentActiveProjects({super.key});

  @override
  State<ParentActiveProjects> createState() => _ParentActiveProjectsState();
}

class _ParentActiveProjectsState extends State<ParentActiveProjects> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentDashProvider>().getParentProfileApiTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.wait([
          Future.sync(() => context.read<ParentDashProvider>().getParentProfileApiTap()),
        ]);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          title: Text(
            'Active Projects',
            style: textStyle(fontFamily: AppFonts.interBold, fontSize: 18),
          ),
        ),
        body: Consumer<ParentDashProvider>(
          builder: (context, provider, child) {
            final assignedProjects = provider.parentProfileData?.data?.child?.assignedProjects ?? [];
            
            // Calculate overall progress from all projects
            int totalMilestones = 0;
            int completedMilestones = 0;
            for (var project in assignedProjects) {
              if (project.milestones != null) {
                totalMilestones += project.milestones!.length;
                completedMilestones += project.milestones!.where((m) => m.status?.toLowerCase() == 'completed').length;
              }
            }
            final overallProgress = totalMilestones > 0 ? completedMilestones / totalMilestones : 0.0;
            final overallPercent = (overallProgress * 100).round();
      
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                "${assignedProjects.length} Projects",
                                style: textStyle(color: AppColors.lightGrey2),
                              ),
                            ],
                          ),
                          hSpace(height: 10),
                          LinearProgressIndicator(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            value: overallProgress,
                            backgroundColor: AppColors.lightGrey,
                            color: AppColors.black,
                            minHeight: 8,
                          ),
                          hSpace(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$overallPercent% completed",
                                style: textStyle(color: AppColors.lightGrey2),
                              ),
                              Text(
                                "$totalMilestones Milestones",
                                style: textStyle(color: AppColors.lightGrey2),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
      
                  // Assigned Projects title
                  Text(
                    'Assigned Projects',
                    style: textStyle(fontFamily: AppFonts.interMedium, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
      
                  // projects list from API
                  if (assignedProjects.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          'No projects assigned',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppFonts.interRegular,
                            color: AppColors.lightGrey2,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: assignedProjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final project = assignedProjects[index];
                        
                        // Calculate project progress based on milestones
                        int projectMilestones = project.milestones?.length ?? 0;
                        int projectCompletedMilestones = project.milestones?.where((m) => m.status?.toLowerCase() == 'completed').length ?? 0;
                        double progress = projectMilestones > 0 ? projectCompletedMilestones / projectMilestones : 0.0;
                        final progressPercent = (progress * 100).round();
                        
                        // Format due date
                        String dueDate = 'No due date';
                        if (project.dueDate != null) {
                          final date = project.dueDate!;
                          final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          dueDate = '${date.day} ${months[date.month - 1]}';
                        }
      
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailActiveProject(
                                  project: project,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                children: [
                                  // black bullet
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
      
                                  // title + subtitle + progress
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project.title ?? 'Untitled Project',
                                          style: textStyle(
                                            fontFamily: AppFonts.interBold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          project.projectDescription ?? 'No description',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textStyle(
                                            color: AppColors.lightGrey2,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
      
                                        // progress row
                                        Row(
                                          children: [
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                value: progress,
                                                minHeight: 6,
                                                backgroundColor: Colors.grey.shade300,
                                                color: Colors.green,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                          ],
                                        ),
                                        hSpace(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$progressPercent% Complete',
                                              style: textStyle(
                                                color: AppColors.lightGrey2,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Due: $dueDate',
                                              style: textStyle(
                                                color: Colors.redAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
      
                                  const SizedBox(width: 12),
      
                                  // due date
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      
                  const SizedBox(height: 16),
      
                  hSpace(height: 20),
              // Container(
              //   height: 100,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.black,
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Need to discuss a Progress?",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(
              //               "Request a meeting with counsellor?",
              //               style: TextStyle(color: Colors.white, fontSize: 7),
              //             ),
              //           ],
              //         ),
              //         CustomButton(
              //           showBackground: true,
              //           bgColor: Colors.white,
              //           title: "Request Meeting",
              //           fontsize: 12,
              //           height: 30,
              //           titleColor: Colors.black,
              //           width: 120,
              //         ),
              //       ],
              //     ),
              //   ),
              //     ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
