import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Common/ChatScreens/chat_list.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/Ticket/create_ticket_screen.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Utils/helper.dart';

class DetailActiveProject extends StatelessWidget {
  final AssignedProject projectDetails;

  const DetailActiveProject({super.key, required this.projectDetails});

  @override
  Widget build(BuildContext context) {
    final title = projectDetails.title ?? '';
    final subtitle = projectDetails.projectType?.toUpperCase() ?? '';
    final overview = projectDetails.projectDescription ?? '';

    return _DetailActiveProjectView(
      title: title,
      subtitle: subtitle,
      overview: overview,
      projectDetails: projectDetails,
    );
  }
}

class _DetailActiveProjectView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String overview;
  final AssignedProject projectDetails;

  const _DetailActiveProjectView({
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.projectDetails,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetailProjectProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (projectDetails.status?.toLowerCase() == "completed") ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.wait([
            Future.sync(
              () => context
                  .read<StudentProfileProvider>()
                  .getStudentProfileApiTap(context),
            ),
          ]);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: provider.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Section with padding
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview header
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateTicketScreen(
                                    projectDetails: projectDetails,
                                  ),
                                ),
                              );
                            },
                            child: Text("Create Ticket"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Overview card / panel
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          overview,
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Builder(
                        builder: (context) {
                          final milestones = projectDetails.milestones ?? [];
                          final totalMilestones = milestones.length;
                          final completedMilestones = milestones.where((m) {
                            final status = m.status?.toLowerCase();
                            return status == 'approved' ||
                                status == 'completed';
                          }).length;
                          final pendingMilestones =
                              totalMilestones - completedMilestones;
                          final progressPercentage = totalMilestones > 0
                              ? completedMilestones / totalMilestones
                              : 0.0;

                          return Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Overall progress",
                                        style: textStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "$completedMilestones/$totalMilestones Tasks",
                                        style: textStyle(
                                          color: AppColors.lightGrey2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  hSpace(height: 10),
                                  LinearProgressIndicator(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    value: progressPercentage,
                                    backgroundColor: AppColors.lightGrey,
                                    color: AppColors.black,
                                    minHeight: 8,
                                  ),
                                  hSpace(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${(progressPercentage * 100).toStringAsFixed(0)}% completed",
                                        style: textStyle(
                                          color: AppColors.lightGrey2,
                                        ),
                                      ),
                                      Text(
                                        "$pendingMilestones pending",
                                        style: textStyle(
                                          color: AppColors.lightGrey2,
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

                // Tabs Section
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.tabs.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final isSelected = provider.selectedTabIndex == index;
                      return GestureDetector(
                        onTap: () => provider.setSelectedTab(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            provider.tabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade600,
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Content Sections with padding
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tasks Section
                      _buildSectionWithKey(
                        key: provider.tasksKey,
                        child: _TasksSection(
                          provider: provider,
                          projectDetails: projectDetails,
                        ),
                      ),

                      // const SizedBox(height: 30),

                      // // Deliverables Section
                      // _buildSectionWithKey(
                      //   key: provider.deliverablesKey,
                      //   child: _DeliverablesSection(provider: provider),
                      // ),
                      // const SizedBox(height: 30),

                      // // Resources Section
                      // _buildSectionWithKey(
                      //   key: provider.resourcesKey,
                      //   child: _ResourcesSection(provider: provider),
                      // ),
                      Row(
                        children: [
                          Text(
                            "Documentations",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      // Documentations list with simple PDF download UI (mock download)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Project Documentation',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: provider.downloadingFile
                                  ? null
                                  : () {
                                      provider.downloadFile(
                                        context,
                                        "${Apis.baseUrl}${projectDetails.attachedFiles}",
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                disabledBackgroundColor: Colors.grey,
                              ),
                              icon: provider.downloadingFile
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.download_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                provider.downloadingFile
                                    ? 'Downloading...'
                                    : 'Download',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 30),

                      // Feedbacks Section
                      // _buildSectionWithKey(
                      //   key: provider.feedbacksKey,
                      //   child: _FeedbacksSection(provider: provider),
                      // ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatListScreen(
                                projectId: projectDetails.projectId!,
                              ),
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
                                color: Color(0xFF667EEA).withValues(alpha: 0.4),
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
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithKey({required GlobalKey key, required Widget child}) {
    return Container(key: key, child: child);
  }
}

// Tasks Section Widget
class _TasksSection extends StatelessWidget {
  final DetailProjectProvider provider;
  final AssignedProject projectDetails;

  const _TasksSection({required this.provider, required this.projectDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Milestone Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.yellow.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.milestoneTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.milestoneDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.flag, color: Colors.yellow),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tasks List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projectDetails.milestones!.length,
          itemBuilder: (context, index) {
            final milestones = projectDetails.milestones![index];
            final taskIndex = index;

            final bool isLocallySubmitted = provider.isTaskSubmitted(taskIndex);
            final String? milestoneStatus = milestones.status?.toLowerCase();
            final bool apiMarkedCompleted =
                milestoneStatus == "completed" ||
                milestoneStatus == "approved" ||
                milestoneStatus == "rejected";
            final bool isSubmitted = isLocallySubmitted || apiMarkedCompleted;
            final bool hasFile = provider.taskFiles.containsKey(taskIndex);
            final bool isCompleted = hasFile || isSubmitted;
            final bool canSubmit = hasFile && !isSubmitted;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: isCompleted
                        ? null
                        : () async {
                            await provider.pickFileForTask(taskIndex);
                          },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2, right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? Colors.black
                                : Colors.transparent,
                            border: Border.all(
                              color: isCompleted
                                  ? Colors.black
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                milestones.name ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                milestones.dueDate == null
                                    ? "Due Date: -"
                                    : "Due Date: ${DateFormat("dd/MMMM/yyyy").format(milestones.dueDate!)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              // if (task['time'] != null) ...[
                              //   const SizedBox(height: 2),
                              //   Text(
                              //     task['time'],
                              //     style: TextStyle(
                              //       fontSize: 12,
                              //       color: Colors.grey.shade500,
                              //     ),
                              //   ),
                              // ],
                              if (hasFile) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.green.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.attach_file,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          provider.taskFiles[taskIndex]!.name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              // if (task['progress'] != null) ...[
                              //   const SizedBox(height: 8),
                              //   // LinearProgressIndicator(
                              //   //   value: task['progress'],
                              //   //   backgroundColor: Colors.grey.shade300,
                              //   //   color: Colors.yellow.shade600,
                              //   //   minHeight: 6,
                              //   //   borderRadius: BorderRadius.circular(10),
                              //   // ),
                              //   const SizedBox(height: 4),
                              //   Text(
                              //     '${(task['progress'] * 100).toInt()}% Complete',
                              //     style: TextStyle(
                              //       fontSize: 12,
                              //       color: Colors.grey.shade600,
                              //     ),
                              //   ),
                              // ],
                              if (!hasFile) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to upload file and mark complete',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Submit for Approval button for each task
                  if (canSubmit) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            provider.isCompletingTask(milestones.id ?? '')
                            ? null
                            : () {
                                if (projectDetails.projectId != null &&
                                    milestones.id != null) {
                                  provider.completeTaskApiTap(
                                    context,
                                    projectDetails.projectId!,
                                    milestones.id!,
                                    taskIndex,
                                    provider.taskFiles[taskIndex],
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: provider.isCompletingTask(milestones.id ?? '')
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Submit for Approval',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],

                  // Show submitted status
                  if (isSubmitted) ...[
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        // Show different UI based on status
                        if (milestones.status?.toLowerCase() == "approved") ...[
                          // Show approved status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (milestones.status?.toLowerCase() ==
                            "rejected") ...[
                          // Show rejected status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 16,
                                  color: Colors.red.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Rejected',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Default - Show pending approval
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.pending_actions,
                                  size: 16,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Pending Approval',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        hSpace(height: 8),
                        InkWell(
                          onTap: () {
                            // Fetch all meetings before opening dialog
                            context.read<DetailProjectProvider>().fetchAllMeetings().then((
                              _,
                            ) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      titlePadding: const EdgeInsets.fromLTRB(
                                        20,
                                        20,
                                        20,
                                        0,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Create Meeting',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Add meeting details for reviewer',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Consumer<DetailProjectProvider>(
                                        builder: (context, pvd, child) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: pvd
                                                      .meetingTitleController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Meeting Title',
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade50,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                  ),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      isExpanded: true,
                                                      hint: Text(
                                                        'Select Time Slot (30 min)',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                      value:
                                                          pvd.selectedTimeSlot,
                                                      icon: const Icon(
                                                        Icons.access_time,
                                                        size: 18,
                                                        color: Colors.black54,
                                                      ),
                                                      items: pvd.generateTimeSlots().map((
                                                        String slot,
                                                      ) {
                                                        final isBooked = pvd
                                                            .bookedTimeSlots
                                                            .contains(slot);
                                                        final isMentorAvailable = pvd.isMentorAvailable(
                                                          slot,
                                                          projectDetails.assignedMentor,
                                                        );
                                                        final isCounsellorAvailable = pvd.isCounsellorAvailable(
                                                          slot,
                                                          projectDetails.createdByUser,
                                                        );
                                                        return DropdownMenuItem<
                                                          String
                                                        >(
                                                          value: slot,
                                                          enabled: !isBooked,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  slot,
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color:
                                                                        isBooked
                                                                        ? Colors
                                                                              .grey
                                                                              .shade400
                                                                        : Colors
                                                                              .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  if (isMentorAvailable && !isBooked)
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.symmetric(
                                                                            horizontal: 6,
                                                                            vertical: 2,
                                                                          ),
                                                                      margin: const EdgeInsets.only(right: 4),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .green
                                                                            .shade100,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                      ),
                                                                      child: Text(
                                                                        'Mentor',
                                                                        style: TextStyle(
                                                                          fontSize: 10,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color: Colors
                                                                              .green
                                                                              .shade700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (isCounsellorAvailable && !isBooked)
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.symmetric(
                                                                            horizontal: 6,
                                                                            vertical: 2,
                                                                          ),
                                                                      margin: const EdgeInsets.only(right: 4),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .blue
                                                                            .shade100,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                      ),
                                                                      child: Text(
                                                                        'Counsellor',
                                                                        style: TextStyle(
                                                                          fontSize: 10,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color: Colors
                                                                              .blue
                                                                              .shade700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (isBooked)
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                6,
                                                                            vertical:
                                                                                2,
                                                                          ),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .red
                                                                            .shade100,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              4,
                                                                            ),
                                                                      ),
                                                                      child: Text(
                                                                        'Booked',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color: Colors
                                                                              .red
                                                                              .shade700,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? newValue) {
                                                        if (newValue != null &&
                                                            !pvd.bookedTimeSlots
                                                                .contains(
                                                                  newValue,
                                                                )) {
                                                          pvd.setSelectedTimeSlot(
                                                            newValue,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextField(
                                                  controller:
                                                      pvd.meetingLinkController,
                                                  keyboardType:
                                                      TextInputType.url,
                                                  decoration: InputDecoration(
                                                    labelText: 'Meeting Link',
                                                    hintText:
                                                        'https://example.com/meet/xyz',
                                                    filled: true,
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey[400],
                                                    ),
                                                    fillColor:
                                                        Colors.grey.shade50,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    pvd.openMeetNew();
                                                  },
                                                  child: Text(
                                                    "Generate Link and paste here",
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Note:- ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 180,
                                                      child: Text(
                                                        "This meeting will be shared with Project Mentor and Counsellor.",
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      actionsPadding: const EdgeInsets.fromLTRB(
                                        16,
                                        0,
                                        16,
                                        12,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        CustomButton(
                                          isLoading: context
                                              .watch<DetailProjectProvider>()
                                              .meetingLoader,
                                          height: 45,
                                          width: 150,
                                          title: "Create",
                                          onTap: () {
                                            context
                                                .read<DetailProjectProvider>()
                                                .CreateMeetingLinkApiTap(
                                                  context,
                                                  projectName:
                                                      projectDetails.title!,
                                                  counsellorEmail:
                                                      projectDetails
                                                          .createdByEmail!,
                                                  projectMentor: projectDetails
                                                      .assignedMentor!,
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Create Meeting',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// Deliverables Section Widget
// class _DeliverablesSection extends StatelessWidget {
//   final DetailProjectProvider provider;

//   const _DeliverablesSection({required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Recent Deliverables',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => AddRecentDeliverable(),
//                   ),
//                 );
//               },
//               child: const Text(
//                 'View all',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...provider.deliverables
//             .map((item) => _buildDeliverableItem(item))
//             .toList(),
//       ],
//     );
//   }

//   Widget _buildDeliverableItem(Map<String, dynamic> item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.description_outlined, size: 24),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['title'],
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 // const SizedBox(height: 4),
//                 // Text(
//                 //   item['uploaded'],
//                 //   style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                 // ),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           ),
//           IconButton(icon: const Icon(Icons.link), onPressed: () {}),
//         ],
//       ),
//     );
//   }
// }

// Resources Section Widget
// class _ResourcesSection extends StatelessWidget {
//   final DetailProjectProvider provider;

//   const _ResourcesSection({required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Links & Resources',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text(
//                 'View all',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...provider.resources.map((item) => _buildResourceItem(item)).toList(),
//       ],
//     );
//   }

//   Widget _buildResourceItem(Map<String, dynamic> item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.play_circle_outline, size: 24),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['title'],
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${item['duration']} • ${item['type']}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.file_upload_outlined),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// Feedbacks Section Widget
class _FeedbacksSection extends StatelessWidget {
  final DetailProjectProvider provider;

  const _FeedbacksSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Feedbacks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {},
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
        ...provider.feedbacks.map((item) => _buildFeedbackItem(item)).toList(),
      ],
    );
  }

  Widget _buildFeedbackItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  item['name'][0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item['role'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item['feedback'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['time'],
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
