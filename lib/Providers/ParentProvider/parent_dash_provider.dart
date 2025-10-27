import 'package:flutter/material.dart';

class ParentDashProvider extends ChangeNotifier {
  // Parent Info
  final String parentName = 'Tanu Shah';
  final String parentRole = 'Parent Portal';

  // Child Info
  final String childName = 'Riya Shah';
  final String childGrade = 'Grade 11';
  final String overallProgress = '75%';

  // Quick Stats
  final int activeProjects = 5;
  final int tasksDue = 7;
  final int completedTasks = 12;

  // Current Projects Data
  final List<Map<String, dynamic>> currentProjects = [
    {
      'title': 'AI Projects Module 4',
      'dueDate': 'Due: Today, 11:59 PM',
      'status': 'In Progress',
      'tasksRemaining': '3 Tasks Remaining',
      'progress': 0.55,
      'progressPercentage': '55%',
      'statusColor': 'blue',
    },
    {
      'title': 'AI Projects Module 4',
      'dueDate': 'Due: Today, 11:59 PM',
      'status': 'In Progress',
      'tasksRemaining': '3 Tasks Remaining',
      'progress': 0.55,
      'progressPercentage': '55%',
      'statusColor': 'blue',
    },
  ];

  // Upcoming Meetings Data
  final List<Map<String, dynamic>> upcomingMeetings = [
    {
      'title': 'Parent Review Meeting',
      'subtitle': 'with View Application',
      'date': 'Tomorrow',
      'time': '2:00 PM',
      'buttonText': 'Join Meeting',
    },
  ];

  void requestMeeting() {
    // Logic to request a meeting
    notifyListeners();
  }

  void viewProgressReport() {
    // Logic to view detailed progress analytics
    notifyListeners();
  }

  void viewAllProjects() {
    // Logic to view all projects
    notifyListeners();
  }

  void viewAllMeetings() {
    // Logic to view all meetings
    notifyListeners();
  }

  void joinMeeting(String meetingTitle) {
    // Logic to join a meeting
    notifyListeners();
  }

  // ==================== VIEW PROGRESS LOGIC START ====================

  // Overall Progress Data
  final String viewProgressOverallPercentage = '75%';
  final String weeksRemaining = '4 weeks Remaining';

  // Top Stats Cards
  final List<Map<String, dynamic>> topStatsCards = [
    {'value': '12', 'label': 'Completed', 'backgroundColor': 'black'},
    {'value': '3', 'label': 'Pending', 'backgroundColor': 'black'},
    {'value': '2', 'label': 'Overdue', 'backgroundColor': 'black'},
  ];

  // Project Progress Data
  final List<Map<String, dynamic>> projectProgressList = [
    {
      'title': 'EDA Projects',
      'subtitle': 'Next Milestone: Essay Draft, Dec 15',
      'progress': 0.85,
      'progressPercentage': '85%',
    },
  ];

  // Custom Projects Data
  final List<Map<String, dynamic>> customProjectsList = [
    {
      'title': 'Custom Projects',
      'subtitle': 'Pending: Portfolio Review, Research Paper',
      'progress': 0.60,
      'progressPercentage': '60%',
    },
  ];

  // College Applications Data
  final List<Map<String, dynamic>> collegeApplicationsList = [
    {'name': 'MIT', 'progress': 0.85, 'progressPercentage': '85%'},
    {'name': 'UC Berkeley', 'progress': 0.60, 'progressPercentage': '60%'},
    {'name': 'Stanford', 'progress': 0.45, 'progressPercentage': '45%'},
  ];

  // Task Analytics Data
  final String onTimePercentage = '75%';
  final String delayedPercentage = '22%';
  final String onTimeLabel = 'On Time';
  final String delayedLabel = 'Delayed';

  // Overdue Tasks
  final List<Map<String, dynamic>> overdueTasks = [
    {'title': 'Common App Essay', 'dueDate': 'Due: Nov 28'},
    {'title': 'Letter of Recommendation Request', 'dueDate': 'Due: Dec 1'},
  ];

  // Due This Week Tasks
  final List<Map<String, dynamic>> dueThisWeekTasks = [
    {'title': 'Portfolio Review', 'dueDate': 'Due: Dec 12'},
    {'title': 'Interview Prep', 'dueDate': 'Due: Dec 13'},
    {'title': 'Transcript Request', 'dueDate': 'Due: Dec 15'},
  ];

  // Meeting Analytics Data
  final String attendancePercentage = '92%';
  final int attendedMeetings = 23;
  final int missedMeetings = 2;

  // Upcoming Meetings for View Progress
  final List<Map<String, dynamic>> upcomingMeetingsViewProgress = [
    {
      'title': 'Essay Review Session',
      'subtitle': 'Dec 15, 3:00 PM with Ms. XXXXXX',
      'status': 'Confirmed',
    },
  ];

  // Latest Feedback Data
  final List<Map<String, dynamic>> latestFeedbackList = [
    {
      'name': 'Ms. Johnson',
      'role': 'Counselor',
      'date': 'Dec 8',
      'feedback':
          '"Good progress on essay draft, add more examples to strengthen your argument."',
    },
    {
      'name': 'Ms. Johnson',
      'role': 'Counselor',
      'date': 'Dec 6',
      'feedback':
          '"Good progress on essay draft, add more examples to strengthen your argument."',
    },
  ];

  // ==================== VIEW PROGRESS LOGIC END ====================
}
