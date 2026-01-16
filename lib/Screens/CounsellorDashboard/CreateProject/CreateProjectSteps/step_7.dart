import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class Step7 extends StatelessWidget {
  const Step7({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "Stay Connected & On Track",
              style: textStyle(fontSize: 20, fontFamily: AppFonts.interBold),
            ),
            Text(
              "Configure notifications to keep everyone informed and engaged throughout the project journey.",
              style: textStyle(
                fontSize: 14,
                fontFamily: AppFonts.interRegular,
                color: Colors.grey,
              ),
            ),
            hSpace(height: 24),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.black, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Due Date Reminders",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            hSpace(height: 12),
            CheckboxListTile(
              enabled: false,
              value: pvd.dueDateReminder24Hours,
              onChanged: (value) {
                pvd.setDueDateReminder24Hours = value ?? false;
              },
              title: Text("24 hours before", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 32),
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.dueDateReminder1Hour,
              onChanged: (value) {
                pvd.setDueDateReminder1Hour = value ?? false;
              },
              title: Text("1 hour before", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 32),
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.dueDateReminder10Minutes,
              onChanged: (value) {
                pvd.setDueDateReminder10Minutes = value ?? false;
              },
              title: Text("10 minutes before", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 32),
              dense: true,
            ),
            hSpace(height: 16),

            // Milestone Reminders
            Text(
              "Milestone Reminders",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            CheckboxListTile(
              enabled: false,
              value: pvd.deadlineApproaching,
              onChanged: (value) {
                pvd.setDeadlineApproaching = value ?? false;
              },
              title: Row(
                children: [
                  Icon(Icons.flag, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text("Deadline Approaching", style: textStyle(fontSize: 14)),
                ],
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 8),
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.overdueEscalation,
              onChanged: (value) {
                pvd.setOverdueEscalation = value ?? false;
              },
              title: Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.black),
                  const SizedBox(width: 8),
                  Text("Overdue Escalation", style: textStyle(fontSize: 14)),
                ],
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 8),
              dense: true,
            ),
            hSpace(height: 16),

            // Meeting Reminders
            Text(
              "Meeting Reminders",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            CheckboxListTile(
              enabled: false,
              value: pvd.sessionAlerts,
              onChanged: (value) {
                pvd.setSessionAlerts = value ?? false;
              },
              title: Row(
                children: [
                  Icon(
                    Icons.notification_important,
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text("Session Alerts", style: textStyle(fontSize: 14)),
                ],
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 8),
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.sessionAlert24Hours,
              onChanged: (value) {
                pvd.setSessionAlert24Hours = value ?? false;
              },
              title: Text("24 hours before", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 32),
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.sessionAlert1Hour,
              onChanged: (value) {
                pvd.setSessionAlert1Hour = value ?? false;
              },
              title: Text("1 hour before", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 32),
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.sessionAlert10Minutes,
              onChanged: (value) {
                pvd.setSessionAlert10Minutes = value ?? false;
              },
              title: Text("10 minutes before", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.only(left: 32),
              dense: true,
            ),
            hSpace(height: 24),

            // Email & In-App Notifications
            Text(
              "Email & In-App Notifications",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),

            // For Student
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Student",
                    style: textStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 14,
                    ),
                  ),
                  hSpace(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "Task updates & feedback",
                        style: textStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  hSpace(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "Deliverable status",
                        style: textStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            hSpace(height: 12),

            // For Mentor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Mentor",
                    style: textStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 14,
                    ),
                  ),
                  hSpace(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "Deliverable submissions",
                        style: textStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  hSpace(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text("Review requests", style: textStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            hSpace(height: 12),

            // For Parent
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Parent",
                    style: textStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 14,
                    ),
                  ),
                  hSpace(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "Weekly progress summary",
                        style: textStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  hSpace(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "Meeting confirmations",
                        style: textStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            hSpace(height: 24),

            // Calendar Sync
            Text(
              "Calendar Sync",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            CheckboxListTile(
              enabled: false,
              value: pvd.syncTasks,
              onChanged: (value) {
                pvd.setSyncTasks = value ?? false;
              },
              title: Text("Sync Tasks", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.syncMilestones,
              onChanged: (value) {
                pvd.setSyncMilestones = value ?? false;
              },
              title: Text("Sync Milestones", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              enabled: false,
              value: pvd.syncMeetings,
              onChanged: (value) {
                pvd.setSyncMeetings = value ?? false;
              },
              title: Text("Sync Meetings", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            hSpace(height: 24),

            // Escalation Rules
            Text(
              "Escalation Rules",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "1 missed deadline → Send reminder",
                style: textStyle(fontSize: 14),
              ),
            ),
            hSpace(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "2 missed deadlines → Notify mentor",
                style: textStyle(fontSize: 14),
              ),
            ),
            hSpace(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "3 missed deadlines → Escalate to counsellor",
                style: textStyle(fontSize: 14),
              ),
            ),
            hSpace(height: 24),
          ],
        );
      },
    );
  }
}
