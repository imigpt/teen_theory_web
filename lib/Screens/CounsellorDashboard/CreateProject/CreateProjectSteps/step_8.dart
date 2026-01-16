import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class Step8 extends StatelessWidget {
  const Step8({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "Review & Create",
              style: textStyle(fontSize: 20, fontFamily: AppFonts.interBold),
            ),
            Text(
              "Review your project details carefully. You can edit any section by tapping on it.",
              style: textStyle(
                fontSize: 14,
                fontFamily: AppFonts.interRegular,
                color: Colors.grey,
              ),
            ),
            hSpace(height: 24),

            // Project Basics Section
            _buildSectionHeader(
              "Project Basics",
              onEdit: () {
                pvd.setCurrentStep = 1;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hSpace(height: 12),
                  _buildInfoRow("Title", pvd.projectTitleController.text),
                  _buildInfoRow("Category", pvd.selectedProjectType),
                  _buildInfoRow(
                    "Description",
                    pvd.descriptionController.text.isEmpty ? "No description" : pvd.descriptionController.text,
                  ),
                ],
              ),
            ),
            hSpace(height: 24),

            // Team & Access Section
            _buildSectionHeader(
              "People & Access",
              onEdit: () {
                pvd.setCurrentStep = 2;
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pvd.assignedStudents.isNotEmpty) ...[
                    Text(
                      "Assigned Students:",
                      style: textStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.interBold,
                      ),
                    ),
                    hSpace(height: 8),
                    ...pvd.assignedStudents.map((student) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student['name'] ?? '',
                                    style: textStyle(
                                      fontSize: 14,
                                      fontFamily: AppFonts.interBold,
                                    ),
                                  ),
                                  Text(
                                    student['grade'] ?? '',
                                    style: textStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                  if (pvd.assignedMentor != null) ...[
                    hSpace(height: 12),
                    Text(
                      "Assigned Mentor:",
                      style: textStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.interBold,
                      ),
                    ),
                    hSpace(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pvd.assignedMentor!['name'] ?? '',
                                style: textStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.interBold,
                                ),
                              ),
                              Text(
                                pvd.assignedMentor!['subtitle'] ?? '',
                                style: textStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (pvd.assignedStudents.isEmpty &&
                      pvd.assignedMentor == null)
                    Text(
                      "No team members assigned",
                      style: textStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            hSpace(height: 24),

            // Milestones & Tasks Section
            _buildSectionHeader(
              "Milestones & Tasks",
              onEdit: () {
                pvd.setCurrentStep = 3;
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pvd.milestones.where((m) => m.name.isNotEmpty).isEmpty)
                    Text(
                      "No milestones added",
                      style: textStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    )
                  else
                    ...pvd.milestones.where((m) => m.name.isNotEmpty).map((
                      milestone,
                    ) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.yellow, width: 4),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      Icons.flag,
                                      size: 16,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      milestone.name,
                                      style: textStyle(
                                        fontSize: 14,
                                        fontFamily: AppFonts.interBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (milestone.dueDate != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 28,
                                    top: 4,
                                  ),
                                  child: Text(
                                    "Due: ${DateFormat('MMM d, yyyy').format(milestone.dueDate!)}",
                                    style: textStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              if (milestone.tasks.isNotEmpty)
                                ...milestone.tasks
                                    .where((t) => t.title.isNotEmpty)
                                    .map((task) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: 28,
                                          top: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 6,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "${task.title} - ${task.type ?? 'Task'} - ${task.priority ?? 'Medium Priority'}",
                                                style: textStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
            hSpace(height: 24),

            // Deliverables Section
            _buildSectionHeader(
              "Deliverables",
              onEdit: () {
                pvd.setCurrentStep = 4;
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pvd.deliverables.isEmpty)
                    Text(
                      "No deliverables added",
                      style: textStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    )
                  else
                    ...pvd.deliverables.map((deliverable) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    deliverable.title,
                                    style: textStyle(
                                      fontSize: 14,
                                      fontFamily: AppFonts.interBold,
                                    ),
                                  ),
                                  // Text(
                                  //   "${deliverable.type} • Due: ${DateFormat('MMM d').format(deliverable.dueDate)} • Reviewer: ${deliverable.requiresMentorApproval
                                  //       ? 'Mentor'
                                  //       : deliverable.requiresCounsellorApproval
                                  //       ? 'Counsellor'
                                  //       : 'Self'}",
                                  //   style: textStyle(
                                  //     fontSize: 12,
                                  //     color: Colors.grey.shade600,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
            hSpace(height: 24),

            // Resources Section
            _buildSectionHeader(
              "Resources",
              onEdit: () {
                pvd.setCurrentStep = 5;
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pvd.resources.isEmpty)
                    Text(
                      "No resources added",
                      style: textStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    )
                  else
                    ...pvd.resources.map((resource) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              _getIconForResourceType(resource.type),
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resource.title,
                                    style: textStyle(
                                      fontSize: 14,
                                      fontFamily: AppFonts.interBold,
                                    ),
                                  ),
                                  Text(
                                    "${resource.type} • Visible to ${resource.visibleToStudent ? 'Student' : ''}${resource.visibleToStudent && resource.visibleToMentor ? ' & ' : ''}${resource.visibleToMentor ? 'Mentor' : ''}",
                                    style: textStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
            hSpace(height: 24),

            // Suggested Sessions Section
            _buildSectionHeader(
              "Suggested Sessions",
              onEdit: () {
                pvd.setCurrentStep = 6;
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSessionCard(
                    "SDA Session",
                    "Week 1 • 45 min • Student, Mentor",
                  ),
                  hSpace(height: 8),
                  _buildSessionCard(
                    "Essay Review",
                    "Week 4 • 30 min • Student, Mentor",
                  ),
                  hSpace(height: 8),
                  _buildSessionCard(
                    "Parent Review",
                    "Week 6 • 45 min • Student, Parent, Counsellor",
                  ),
                ],
              ),
            ),
            hSpace(height: 24),

            // Notifications & Reminders Section
            _buildSectionHeader(
              "Notifications & Reminders",
              onEdit: () {
                pvd.setCurrentStep = 7;
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationItem(
                    "Weekly task tracker nudges",
                    pvd.weeklyTaskTrackerNudges,
                  ),
                  _buildNotificationItem(
                    "Task due reminders (24h, 1h, 10m)",
                    pvd.dueDateReminder24Hours ||
                        pvd.dueDateReminder1Hour ||
                        pvd.dueDateReminder10Minutes,
                  ),
                  _buildNotificationItem(
                    "Milestone reminders + escalations",
                    pvd.deadlineApproaching || pvd.overdueEscalation,
                  ),
                  _buildNotificationItem(
                    "Meeting reminders",
                    pvd.sessionAlerts,
                  ),
                  _buildNotificationItem(
                    "Weekly parent/guardian updates",
                    true,
                  ),
                  _buildNotificationItem(
                    "Calendar sync (Tasks, Milestones, Meetings)",
                    pvd.syncTasks || pvd.syncMilestones || pvd.syncMeetings,
                  ),
                  _buildNotificationItem("Email summaries", true),
                  _buildNotificationItem("Escalation rules", true),
                ],
              ),
            ),
            hSpace(height: 24),

            // Final Confirmation Section
            Text(
              "Final Confirmation",
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 12),
            CheckboxListTile(
              value: pvd.confirmProjectDetails,
              onChanged: (value) {
                pvd.setConfirmProjectDetails = value ?? false;
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                "I confirm all project details are correct",
                style: textStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.interMedium,
                ),
              ),
            ),
            CheckboxListTile(
              value: pvd.confirmTimeline,
              onChanged: (value) {
                pvd.setConfirmTimeline = value ?? false;
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                "This Project will be assigned to the student and mentor",
                style: textStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.interMedium,
                ),
              ),
            ),
            hSpace(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onEdit}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text(
              "Edit",
              style: textStyle(
                fontSize: 14,
                fontFamily: AppFonts.interBold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "Not specified" : value,
            style: textStyle(fontSize: 14, fontFamily: AppFonts.interMedium),
          ),
        ],
      ),
    );
  }

  IconData _getIconForResourceType(String type) {
    switch (type) {
      case 'File Upload':
        return Icons.file_upload_outlined;
      case 'Link':
        return Icons.link_outlined;
      case 'Template':
        return Icons.description_outlined;
      case 'Reference':
        return Icons.book_outlined;
      case 'Spreadsheet':
        return Icons.table_chart_outlined;
      case 'Tool Link':
        return Icons.build_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  Widget _buildSessionCard(String title, String details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.yellow, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle(fontSize: 14, fontFamily: AppFonts.interBold),
          ),
          const SizedBox(height: 4),
          Text(
            details,
            style: textStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String text, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_box : Icons.check_box_outline_blank,
            size: 20,
            color: isEnabled ? Colors.green : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textStyle(
                fontSize: 14,
                color: isEnabled ? Colors.black : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              hSpace(height: 16),
              Text(
                "Project Created Successfully!",
                style: textStyle(fontSize: 18, fontFamily: AppFonts.interBold),
                textAlign: TextAlign.center,
              ),
              hSpace(height: 8),
              Text(
                "Your project has been created and is now ready to use.",
                style: textStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to dashboard
              },
              child: Text(
                "Done",
                style: textStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.interBold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
