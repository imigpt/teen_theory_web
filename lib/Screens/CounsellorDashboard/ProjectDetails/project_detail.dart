import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Common/ChatScreens/chat_list.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Models/CounsellorModels/all_my_project_model.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectDetailScreen extends StatefulWidget {
  final MyProject projects;

  const ProjectDetailScreen({super.key, required this.projects});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final counsellorProvider = context.watch<CounsellorProvider>();
    final projects = widget.projects;
    final String statusLabel = projects.status?.isNotEmpty == true
        ? projects.status!
        : "N/A";
    final normalizedStatus = statusLabel.toLowerCase();
    final bool isCompleted = normalizedStatus == 'completed';
    final bool isCompleting = counsellorProvider.isProjectCompletionInProgress(
      projects.id,
    );

    final Color statusBgColor = isCompleted
        ? Colors.green.shade100
        : normalizedStatus == 'active'
        ? Colors.orange.shade100
        : Colors.grey.shade100;
    final Color statusTextColor = isCompleted
        ? Colors.green.shade700
        : normalizedStatus == 'active'
        ? Colors.orange.shade700
        : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          projects.title ?? "N/A",
          style: textStyle(fontFamily: AppFonts.interBold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('📁',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                projects.title ?? "N/A",
                                style: textStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(statusLabel,
                                  style: textStyle(
                                    color: statusTextColor,
                                    fontSize: 12,
                                    fontFamily: AppFonts.interMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      "Project Type",
                      projects.projectType ?? "N/A",
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      "Description",
                      projects.projectDescription ?? "No description available",
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      "Created At",
                      projects.createdAt != null ? DateFormat('MMM dd, yyyy').format(projects.createdAt!) : "N/A",
                    ),
                    const SizedBox(height: 16),
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Project Completed",
                              style: textStyle(
                                color: Colors.green.shade700,
                                fontFamily: AppFonts.interBold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          Flexible(
                            child: CustomButton(
                              fontsize: 14,
                              title: "Completed",
                              onTap: () {
                                if (!isCompleting) {
                                  counsellorProvider.completeProjectStatus(context, projects);
                                }
                              },
                              isLoading: isCompleting,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Consumer<CounsellorProvider>(
                            builder: (context, pvd, child) {
                            return Flexible(
                            child: CustomButton(
                              isLoading: pvd.deleteProjectLoading,
                              bgColor: Colors.red,
                              fontsize: 14,
                              title: "delete",
                              onTap: () {
                                pvd.deleteProjectApiTap(context, project_id: widget.projects.id!);
                              },
                            ),
                          );
                          }),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Team Members',
                style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Project Counsellor",
                      style: textStyle(
                        color: AppColors.lightGrey2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text("👨‍💼", style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            projects.projectCounsellor ?? "N/A",
                            style: textStyle(fontFamily: AppFonts.interMedium), 
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Assigned Students",
                      style: textStyle(
                        color: AppColors.lightGrey2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (projects.assignedStudent?.isNotEmpty == true)...List.generate(projects.assignedStudent!.length, (i) {
                        final student = projects.assignedStudent![i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Text("🧑‍🎓", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  student.name ?? "N/A",
                                  style: textStyle(
                                    fontFamily: AppFonts.interMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                    else
                      Text(
                        "No students assigned",
                        style: textStyle(color: AppColors.lightGrey2),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      "Assigned Mentor",
                      style: textStyle(
                        color: AppColors.lightGrey2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (projects.assignedMentor != null)
                      Row(
                        children: [
                          const Text("👨‍🏫", style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              projects.assignedMentor?.name ?? "N/A",
                              style: textStyle(
                                fontFamily: AppFonts.interMedium,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        "No mentor assigned",
                        style: textStyle(color: AppColors.lightGrey2),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (projects.milestones?.isNotEmpty == true) ...[
                Text(
                  'Milestones',
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(projects.milestones!.length, (i) {
                      final milestone = projects.milestones![i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "🎯",
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    milestone.name ?? "Milestone ${i + 1}",
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (milestone.status != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  top: 4,
                                ),
                                child:
                                    milestone.status?.toLowerCase() ==
                                        'approved'
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.verified,
                                              size: 14,
                                              color: Colors.blue.shade700,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Approved',
                                              style: textStyle(
                                                color: Colors.blue.shade700,
                                                fontSize: 12,
                                                fontFamily:
                                                    AppFonts.interMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : milestone.status?.toLowerCase() ==
                                          'rejected'
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.cancel,
                                              size: 14,
                                              color: Colors.red.shade700,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Rejected',
                                              style: textStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 12,
                                                fontFamily:
                                                    AppFonts.interMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ) : milestone.status?.toLowerCase() == 'completed' ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.pending_actions,
                                                  size: 14,
                                                  color: Colors.orange.shade700,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Pending Approval',
                                                  style: textStyle(
                                                    color:
                                                        Colors.orange.shade700,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        AppFonts.interMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: ElevatedButton.icon(
                                                  onPressed: counsellorProvider.isApprovingMilestone(milestone.id ?? '') ? null : () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16),
                                                              ),
                                                              title: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.check_circle_outline,
                                                                    color: Colors.green.shade700,
                                                                    size: 28,
                                                                  ),
                                                                  const SizedBox(width: 12),
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Approve Milestone',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              content: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Are you sure you want to approve this milestone?',
                                                                    style: textStyle(fontSize: 14),
                                                                  ),
                                                                  const SizedBox(height: 12),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(12),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey.shade50,
                                                                      borderRadius:BorderRadius.circular(8),
                                                                      border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        const Text(
                                                                          "🎯",
                                                                          style: TextStyle(
                                                                            fontSize:20
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 8),
                                                                        Expanded(
                                                                          child: Text(
                                                                            milestone.name ?? "Milestone",
                                                                            style: textStyle(
                                                                              fontFamily: AppFonts.interMedium,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                        ctx,
                                                                      ).pop(),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: textStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .interMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton.icon(
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                      ctx,
                                                                    ).pop();
                                                                    if (projects.id !=
                                                                            null &&
                                                                        milestone.id !=
                                                                            null) {
                                                                      counsellorProvider.approveOrRejectMilestone(
                                                                        context:
                                                                            context,
                                                                        projectId:
                                                                            projects.id!,
                                                                        milestoneId:
                                                                            milestone.id!,
                                                                        status:
                                                                            "approved",
                                                                      );
                                                                    }
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  icon: const Icon(
                                                                    Icons.check,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  label: Text(
                                                                    'Approve',
                                                                    style: textStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .interMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                  ),
                                                  icon:counsellorProvider.isApprovingMilestone(milestone.id ?? '') ? const SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                          ),
                                                        ) : const Icon(
                                                          Icons.check,
                                                          size: 16,
                                                          color: Colors.white,
                                                        ),
                                                  label: Text(
                                                    'Approve',
                                                    style: textStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: AppFonts.interMedium,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: ElevatedButton.icon(
                                                  onPressed:
                                                      counsellorProvider.isApprovingMilestone(milestone.id ?? '') ? null : () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16),
                                                              ),
                                                              title: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.cancel_outlined,
                                                                    color: Colors.red.shade700,
                                                                    size: 28,
                                                                  ),
                                                                  const SizedBox(width: 12),
                                                                  const Expanded(
                                                                    child: Text('Reject Milestone',
                                                                      style: TextStyle(
                                                                        fontSize:18,
                                                                        fontWeight:FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:MainAxisSize.min,
                                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Are you sure you want to reject this milestone?',
                                                                    style: textStyle(fontSize:14),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 12,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          12,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade50,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                      border: Border.all(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        const Text(
                                                                          "🎯",
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Expanded(
                                                                          child: Text(
                                                                            milestone.name ??
                                                                                "Milestone",
                                                                            style: textStyle(
                                                                              fontFamily: AppFonts.interMedium,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(ctx).pop(),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: textStyle(
                                                                      color: Colors.grey.shade700,
                                                                      fontFamily: AppFonts.interMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton.icon(
                                                                  onPressed: () {
                                                                    Navigator.of(ctx).pop();
                                                                    if (projects.id != null && milestone.id != null) {
                                                                      counsellorProvider.approveOrRejectMilestone(
                                                                        context: context,
                                                                        projectId: projects.id!,
                                                                        milestoneId: milestone.id!,
                                                                        status: "rejected",
                                                                      );
                                                                    }
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        const Color.fromRGBO(244, 67, 54, 1),
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal: 20,
                                                                      vertical: 12),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                  ),
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                    size: 18,
                                                                    color: Colors.white
                                                                    ),
                                                                  label: Text(
                                                                    'Reject',
                                                                    style: textStyle(
                                                                      color: Colors.white,
                                                                      fontFamily: AppFonts.interMedium,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                  ),
                                                  icon:
                                                      counsellorProvider
                                                          .isApprovingMilestone(
                                                            milestone.id ?? '',
                                                          )
                                                      ? const SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                          ),
                                                        ) : const Icon(
                                                          Icons.close,
                                                          size: 16,
                                                          color: Colors.white,
                                                        ),
                                                  label: Text(
                                                    'Reject',
                                                    style: textStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          AppFonts.interMedium,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          milestone.status ?? "N/A",
                                          style: textStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12,
                                            fontFamily: AppFonts.interMedium,
                                          ),
                                        ),
                                      ),
                              ),
                            if (milestone.dueDate != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  top: 4,
                                ),
                                child: Text(
                                  "Due: ${DateFormat('MMM dd, yyyy').format(milestone.dueDate!)}",
                                  style: textStyle(
                                    color: AppColors.lightGrey2,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (milestone.weight != null &&
                                milestone.weight!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  top: 2,
                                ),
                                child: Text(
                                  "Weight: ${milestone.weight}%",
                                  style: textStyle(
                                    color: AppColors.lightGrey2,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              if(milestone.attachments != null && milestone.attachments!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: milestone.attachments!.map((attachmentUrl) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => FullScreenImageViewer(
                                                imageUrl: "${Apis.baseUrl}${attachmentUrl}",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage("${Apis.baseUrl}${attachmentUrl}"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          ],
                          ],
                        )
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (projects.deliverablesTitle != null) ...[
                Text(
                  'Deliverables',
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        "Title",
                        projects.deliverablesTitle ?? "N/A",
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type",
                            style: textStyle(
                              color: AppColors.lightGrey2,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (projects.deliverablesType != null && projects.deliverablesType!.isNotEmpty)
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: projects.deliverablesType!.map((type) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    type,
                                    style: textStyle(
                                      fontSize: 12,
                                      fontFamily: AppFonts.interMedium,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            Text(
                              "N/A",
                              style: textStyle(
                                fontFamily: AppFonts.interMedium,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        "Due Date",
                        projects.dueDate != null
                            ? DateFormat(
                                'MMM dd, yyyy',
                              ).format(projects.dueDate!)
                            : "N/A",
                      ),
                      if (projects.linkedMilestones?.isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          "Linked Milestone",
                          projects.linkedMilestones ?? "N/A",
                        ),
                      ],
                      if (projects.additionalInstructions?.isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          "Instructions",
                          projects.additionalInstructions ?? "N/A",
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (projects.resourcesTitle != null) ...[
                Text(
                  'Resources',
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Title", projects.resourcesTitle ?? "N/A"),
                      const SizedBox(height: 12),
                      _buildInfoRow("Type", projects.resourcesType ?? "N/A"),
                      if (projects.resourcesDescription?.isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          "Description",
                          projects.resourcesDescription ?? "N/A",
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (projects.sessionType != null) ...[
                Text(
                  'Session Details',
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        "Session Type",
                        projects.sessionType ?? "N/A",
                      ),
                      if (projects.purpose?.isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow("Purpose", projects.purpose ?? "N/A"),
                      ],
                      if (projects.preferredTime != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          "Preferred Time",
                          projects.preferredTime ?? "N/A",
                        ),
                      ],
                      if (projects.duration != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow("Duration", projects.duration ?? "N/A"),
                      ],
                    ],
                  ),
                ),
              ],

              hSpace(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatListScreen(projectId: projects.id!),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Color(0xFF667EEA).withOpacity(0.4),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '💬',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Messages",
                                  style: textStyle(
                                    fontFamily: AppFonts.interBold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Chat with mentors & counsellors",
                                  style: textStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyle(color: AppColors.lightGrey2, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(value, style: textStyle(fontFamily: AppFonts.interMedium)),
      ],
    );
  }
}

// Full Screen Image Viewer
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Attachment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load image',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
