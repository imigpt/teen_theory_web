import 'package:flutter/material.dart';

class StudentMeetingProvider extends ChangeNotifier {
  // Upcoming Meetings Data
  final List<Map<String, dynamic>> upcomingMeetings = [
    {
      'title': 'Essay Review Sessions',
      'date': 'Tomorrow - 2:00 PM',
      'counselor': 'Sarah (Counselor)',
      'reminder': 'Reminder Set',
      'status': 'confirmed',
      'buttons': ['Reschedule', 'Cancel'],
    },
    {
      'title': 'Essay Review Sessions',
      'date': 'Tomorrow - 2:00 PM',
      'counselor': 'Sarah (Counselor)',
      'reminder': 'Reminder Set',
      'status': 'confirmed',
      'buttons': ['Reschedule', 'Cancel'],
    },
    {
      'title': 'Essay Review Sessions',
      'date': 'Tomorrow - 2:00 PM',
      'counselor': 'Sarah (Counselor)',
      'reminder': 'Reminder Set',
      'status': 'confirmed',
      'buttons': ['Reschedule', 'Cancel'],
    },
  ];

  // Past Meetings Data
  final List<Map<String, dynamic>> pastMeetings = [
    {
      'title': 'SDA Sessions',
      'date': 'Tomorrow - 2:00 PM',
      'counselor': 'Sarah (Counselor)',
      'status': 'Attended',
      'type': 'attended',
    },
    {
      'title': 'Counsellor Remarks',
      'date': 'Tomorrow - 2:00 PM',
      'counselor': 'Sarah (Counselor)',
      'remarks':
          'Student participated actively in the essay review session, showing strong analytical skills.',
      'type': 'remarks',
    },
    {
      'title': 'Discovery Session',
      'date': 'Tomorrow - 2:00 PM',
      'counselor': 'Sarah (Counselor)',
      'status': 'No-Show',
      'missedReason': 'Missed Meeting',
      'missedRemarks':
          'Student participated actively in the essay review session, showing strong analytical skills.',
      'type': 'no-show',
    },
  ];

  void requestMeeting() {
    // Logic to request a new meeting
    notifyListeners();
  }

  void rescheduleMeeting(String meetingTitle) {
    // Logic to reschedule meeting
    notifyListeners();
  }

  void cancelMeeting(String meetingTitle) {
    // Logic to cancel meeting
    notifyListeners();
  }

  void viewAllPastMeetings() {
    // Logic to view all past meetings
    notifyListeners();
  }
}
