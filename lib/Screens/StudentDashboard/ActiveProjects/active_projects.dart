import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/ActiveProjects/detail_active_project.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/detail_project_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';

class ActiveProjects extends StatefulWidget {
  const ActiveProjects({super.key});

  @override
  State<ActiveProjects> createState() => _ActiveProjectsState();
}

class _ActiveProjectsState extends State<ActiveProjects> {
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
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          'Active Projects',
          style: textStyle(fontFamily: AppFonts.interBold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.wait([
            Future.sync(() => Future.sync(() => context.read<StudentProfileProvider>().getStudentProfileApiTap(context)))
          ]);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<StudentProfileProvider>(
                builder: (context, pvd, child) {
                  final data = pvd.studentProfile?.data;
                  if (pvd.studentProfileLoading) {
                    return const SizedBox();
                  }
                return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SDA Projects',
                    style: textStyle(
                      fontFamily: AppFonts.interMedium,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track your progress',
                    style: textStyle(color: AppColors.lightGrey2),
                  ),
                  const SizedBox(height: 12),
        
                  // summary chips row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _summaryChip(data?.assignedProjects?.length.toString() ?? "0", 'Active'),
                      _summaryChip(data?.assignedProjects?.where((e) => e.status == "completed").length.toString() ?? "", 'Completed'),
                      _summaryChip(data?.assignedProjects?.where((e) => e.status == "pending").length.toString() ?? "", 'Pending'),
                    ],
                  ),
                  const SizedBox(height: 20),
        
                  // SDA Projects title
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              );
              }),
              // Your Projects header
              Text(
                'Your Projects',
                style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
              ),
              // projects list
              Consumer<StudentProfileProvider>(
                builder: (context, pvd, child) {
                  if (pvd.studentProfileLoading) {
                    return DetailProjectShimmer();
                  }
        
                  final projectFromApi = pvd.studentProfile?.data;
        
                  if (projectFromApi == null) {
                    return Center(
                      child: Text(
                        'No Active Projects Found',
                        style: textStyle(
                          color: AppColors.lightGrey2,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
        
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: projectFromApi.assignedProjects!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final projects = projectFromApi.assignedProjects?[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailActiveProject(projectDetails: projects!),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Color(0xFFF8F9FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                            child: Row(
                              children: [
                                // gradient bullet
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF6DD5FA).withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
        
                                // title + subtitle + progress
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        projects?.title ?? '',
                                        style: textStyle(
                                          fontFamily: AppFonts.interBold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        projects?.projectDescription ?? "",
                                        style: textStyle(
                                          color: AppColors.lightGrey2,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
        
                                      // progress row
                                      Row(
                                        children: [
                                          // Expanded(
                                          //   child: LinearProgressIndicator(
                                          //     value: progress,
                                          //     minHeight: 6,
                                          //     backgroundColor: Colors.grey.shade300,
                                          //     color: Colors.yellow.shade600,
                                          //   ),
                                          // ),
                                          const SizedBox(width: 12),
                                        ],
                                      ),
                                      hSpace(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Color(0xFFFFA751), Color(0xFFFFE259)],
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                8,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFFFA751).withValues(alpha: 0.3),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 6.0,
                                              ),
                                              child: Text(
                                                projects?.projectType
                                                        ?.toUpperCase() ??
                                                    "",
                                                style: textStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            projects?.dueDate == null
                                                ? "Due: -"
                                                : 'Due: ${DateFormat('dd MMM yyyy').format(projects!.dueDate!)}',
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
                  );
                },
              ),
        
              const SizedBox(height: 16),
        
              // view all CTA
              Center(
                child: Text(
                  'View all SDA Projects',
                  style: textStyle(
                    color: AppColors.black,
                    fontFamily: AppFonts.interMedium,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // Header
              //     Text(
              //       'Custom Projects',
              //       style: textStyle(
              //         fontFamily: AppFonts.interBold,
              //         fontSize: 16,
              //       ),
              //     ),
              //     const SizedBox(height: 8),
              //     const Divider(),
        
              //     // projects list (UI only)
              //     ListView.separated(
              //       physics: const NeverScrollableScrollPhysics(),
              //       shrinkWrap: true,
              //       itemCount: 3,
              //       separatorBuilder: (_, __) => const SizedBox(height: 12),
              //       itemBuilder: (context, index) {
              //         return Container(
              //           decoration: BoxDecoration(
              //             color: AppColors.white,
              //             borderRadius: BorderRadius.circular(12),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.black.withOpacity(0.03),
              //                 blurRadius: 6,
              //                 offset: const Offset(0, 2),
              //               ),
              //             ],
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 14.0,
              //               vertical: 14.0,
              //             ),
              //             child: Column(
              //               children: [
              //                 Row(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     // black bullet
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: Container(
              //                         width: 12,
              //                         height: 12,
              //                         decoration: const BoxDecoration(
              //                           color: Colors.black,
              //                           shape: BoxShape.circle,
              //                         ),
              //                       ),
              //                     ),
              //                     const SizedBox(width: 12),
        
              //                     // title + subtitle
              //                     Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           "Science Fair Competition",
              //                           style: textStyle(
              //                             fontFamily: AppFonts.interBold,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                         const SizedBox(height: 6),
              //                         Text(
              //                           "Enviromental Impact Research",
              //                           style: textStyle(
              //                             color: AppColors.lightGrey2,
              //                             fontSize: 13,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
        
              //                 const SizedBox(height: 12),
        
              //                 // tag (left) and status/due (right)
              //                 Row(
              //                   children: [
              //                     // tag
              //                     Padding(
              //                       padding: const EdgeInsets.only(left: 25.0),
              //                       child: Text(
              //                         "Competition",
              //                         style: textStyle(
              //                           fontFamily: AppFonts.interMedium,
              //                           color: Colors.green,
              //                           fontSize: 12,
              //                         ),
              //                       ),
              //                     ),
        
              //                     const Spacer(),
        
              //                     // status / due
              //                     Text(
              //                       "on Going",
              //                       style: textStyle(
              //                         fontFamily: AppFonts.interMedium,
              //                         color: Colors.redAccent,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
        
              //     const SizedBox(height: 16),
        
              //     // view all CTA
              //     Center(
              //       child: Text(
              //         'View all Custom Projects',
              //         style: textStyle(
              //           color: AppColors.black,
              //           fontFamily: AppFonts.interMedium,
              //         ),
              //       ),
              //     ),
              //     const SizedBox(height: 24),
              //   ],
              // ),
        
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       'College Applications',
              //       style: textStyle(
              //         fontFamily: AppFonts.interMedium,
              //         fontSize: 16,
              //       ),
              //     ),
              //     const SizedBox(height: 8),
              //     const Divider(),
              //     const SizedBox(height: 8),
        
              //     // cards list
              //     ListView.separated(
              //       physics: const NeverScrollableScrollPhysics(),
              //       shrinkWrap: true,
              //       itemCount: 3,
              //       separatorBuilder: (_, __) => const SizedBox(height: 12),
              //       itemBuilder: (context, index) {
              //         return Container(
              //           decoration: BoxDecoration(
              //             color: AppColors.white,
              //             borderRadius: BorderRadius.circular(12),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.black.withOpacity(0.03),
              //                 blurRadius: 6,
              //                 offset: const Offset(0, 2),
              //               ),
              //             ],
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 14.0,
              //               vertical: 14,
              //             ),
              //             child: Column(
              //               children: [
              //                 Row(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     // icon circle
              //                     Container(
              //                       width: 42,
              //                       height: 42,
              //                       decoration: BoxDecoration(
              //                         color: Colors.black,
              //                         borderRadius: BorderRadius.circular(12),
              //                       ),
              //                       child: const Icon(
              //                         Icons.school,
              //                         color: Colors.white,
              //                         size: 20,
              //                       ),
              //                     ),
              //                     const SizedBox(width: 12),
        
              //                     // title and small meta row
              //                     Expanded(
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             "Stanford University",
              //                             style: textStyle(
              //                               fontFamily: AppFonts.interBold,
              //                               fontSize: 15,
              //                             ),
              //                           ),
              //                           const SizedBox(height: 8),
              //                           Row(
              //                             children: [
              //                               Icon(
              //                                 Icons.article_outlined,
              //                                 size: 14,
              //                                 color: AppColors.lightGrey2,
              //                               ),
              //                               const SizedBox(width: 6),
              //                               Text(
              //                                 'Essays: 3/4',
              //                                 style: textStyle(
              //                                   color: AppColors.lightGrey2,
              //                                   fontSize: 12,
              //                                 ),
              //                               ),
              //                               const SizedBox(width: 12),
              //                               Icon(
              //                                 Icons.mail_outline,
              //                                 size: 14,
              //                                 color: AppColors.lightGrey2,
              //                               ),
              //                               const SizedBox(width: 6),
              //                               Text(
              //                                 'LORs: 2/3',
              //                                 style: textStyle(
              //                                   color: AppColors.lightGrey2,
              //                                   fontSize: 12,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ),
        
              //                     // status / due
              //                     Text(
              //                       "Due: Jan 1",
              //                       style: textStyle(
              //                         color: Colors.redAccent,
              //                         fontFamily: AppFonts.interMedium,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
        
              //                 const SizedBox(height: 12),
        
              //                 // progress bar + percent row
              //                 Row(
              //                   children: [
              //                     Expanded(
              //                       child: LinearProgressIndicator(
              //                         value: 0.5,
              //                         minHeight: 6,
              //                         backgroundColor: Colors.grey.shade300,
              //                         color: Colors.yellow.shade600,
              //                       ),
              //                     ),
              //                     const SizedBox(width: 12),
              //                   ],
              //                 ),
              //                 hSpace(),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                       '60% Complete',
              //                       style: textStyle(
              //                         color: AppColors.lightGrey2,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                     const SizedBox(width: 8),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
        
              //     const SizedBox(height: 12),
              //     Center(
              //       child: Text(
              //         'View all College Applications',
              //         style: textStyle(
              //           color: AppColors.black,
              //           fontFamily: AppFonts.interMedium,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              hSpace(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryChip(String number, String label) {
    // Get gradient based on label
    List<Color> gradient;
    String emoji;
    if (label == 'Active') {
      gradient = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
      emoji = '📁';
    } else if (label == 'Completed') {
      gradient = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
      emoji = '✅';
    } else {
      gradient = [Color(0xFFFFA751), Color(0xFFFFE259)];
      emoji = '⏰';
    }
    
    return Expanded(
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                number,
                style: textStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.interBold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: textStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
