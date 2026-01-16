import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class MeetingDetailPage extends StatelessWidget {
  const MeetingDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Meeting Details',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meeting Information
              Text(
                'Meeting Information',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Meeting Type',
                            style: textStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Essay Review',
                            style: textStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      hSpace(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: textStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDFF7E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Confirmed',
                              style: textStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      hSpace(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date & Time',
                            style: textStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Oct 20, 2025 • 2:00 PM',
                            style: textStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      hSpace(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration',
                            style: textStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '45 min',
                            style: textStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              hSpace(height: 12),

              // Participants
              Text(
                'Participants',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _participantRow('Riya Shah', 'Student'),
                      hSpace(height: 8),
                      _participantRow('Dr. Sarah Chen', 'Mentor'),
                      hSpace(height: 8),
                      _participantRow('Emma Wilson', 'Counsellor'),
                    ],
                  ),
                ),
              ),

              hSpace(height: 12),

              // Purpose / Notes
              Text(
                'Purpose / Notes',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Review draft and discuss improvements.',
                    style: textStyle(fontSize: 13),
                  ),
                ),
              ),

              hSpace(height: 12),

              // Meeting Link / Location
              Text(
                'Meeting Link / Location',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Join Meeting',
                            style: textStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      hSpace(height: 8),
                      TextButton(
                        onPressed: () {},
                        child: Text('Add to Calendar', style: textStyle()),
                      ),
                    ],
                  ),
                ),
              ),

              hSpace(height: 12),

              // Pre-Meeting Actions
              Text(
                'Pre-Meeting Actions',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'View Student Task / Submission',
                        style: textStyle(fontSize: 13),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Review Resources',
                        style: textStyle(fontSize: 13),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Prepare Feedback',
                        style: textStyle(fontSize: 13),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              hSpace(height: 12),

              // Actions
              Text(
                'Actions',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    icon: Icons.remove_red_eye,
                    label: 'View / Join',
                  ),
                  _actionButton(
                    icon: Icons.calendar_today,
                    label: 'Reschedule',
                  ),
                  _actionButton(icon: Icons.close, label: 'Cancel'),
                ],
              ),

              hSpace(height: 12),

              // Post-Meeting Notes
              Text(
                'Post-Meeting Notes',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student needs to revise the introduction and submit updated draft by Oct 22.',
                        style: textStyle(fontSize: 13),
                      ),
                      hSpace(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Convert to Task',
                            style: textStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              hSpace(height: 12),

              // Reminders
              Text(
                'Reminders (Automatic • Read Only)',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _reminderRow('24 hours before'),
                      _reminderRow('1h before'),
                      _reminderRow('10m before'),
                      _reminderRow('Calendar sync enabled'),
                    ],
                  ),
                ),
              ),

              hSpace(height: 12),

              // Activity Log
              Text(
                'Activity Log',
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              hSpace(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _activityRow('Meeting scheduled by Mentor', 'Oct 18'),
                      const Divider(height: 12),
                      _activityRow('Student invited', 'Oct 18'),
                      const Divider(height: 12),
                      _activityRow('Reminder sent (24h)', 'Oct 19'),
                      const Divider(height: 12),
                      _activityRow('Reminder sent (1h)', 'Oct 20'),
                      const Divider(height: 12),
                      _activityRow('Mentor joined meeting', 'Oct 20, 2:00 PM'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _participantRow(String name, String role) {
    return Row(
      children: [
        const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
        wSpace(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: textStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              '($role)',
              style: textStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              hSpace(height: 6),
              Text(label, style: textStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reminderRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check, size: 18, color: Colors.black54),
          wSpace(width: 8),
          Text(text, style: textStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _activityRow(String text, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(text, style: textStyle(fontSize: 13))),
        Text(date, style: textStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
