import 'package:flutter/material.dart';

class TaskDueProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  final ScrollController scrollController = ScrollController();

  // Global keys for each section
  final GlobalKey overviewKey = GlobalKey();
  final GlobalKey dueTodayKey = GlobalKey();
  final GlobalKey upcomingKey = GlobalKey();
  final GlobalKey completedKey = GlobalKey();

  int get selectedTabIndex => _selectedTabIndex;

  final List<String> tabs = ['Overview', 'Due Today', 'Upcoming', 'Completed'];

  // Weekly Progress Data
  final String weeklyProgressTitle = 'Weekly Progress';
  final String weeklyProgressSubtitle = '6/10 of Tasks Completed';
  final String weeklyProgressPercentage = '60% Complete';
  final String weeklyProgressRemaining = '6 Pending';
  final double weeklyProgressValue = 0.6;

  // Overview Tasks Data
  final List<Map<String, dynamic>> overviewTasks = [
    {
      'title': 'Submit Essay Draft',
      'subject': 'Written Application',
      'dueDate': 'Due: Oct 14',
      'dueTime': 'Student Application',
      'status': 'overdue',
      'buttons': ['Mark Complete', 'Feedback', 'Info'],
    },
    {
      'title': 'Submit Essay Draft',
      'subject': 'Written Application',
      'dueDate': 'Due: Oct 24',
      'dueTime': 'Friday 10:00',
      'status': 'review',
      'buttons': ['Mark Complete', 'Feedback', 'Info'],
    },
  ];

  // Due Today Tasks
  final List<Map<String, dynamic>> dueTodayTasks = [
    {
      'title': 'Submit Essay Draft',
      'subject': 'Written Application',
      'dueDate': 'Due Today 11:30 PM',
      'dueTime': 'Priority: High',
      'status': 'pending',
      'buttons': ['Mark Complete', 'Feedback', 'Info'],
    },
    {
      'title': 'Submit Essay Draft',
      'subject': 'Written Application',
      'dueDate': 'Due Today 11:30 PM',
      'dueTime': 'Priority: High',
      'status': 'pending',
      'buttons': ['Mark Complete', 'Feedback', 'Info'],
    },
  ];

  // Upcoming Tasks
  final List<Map<String, dynamic>> upcomingTasks = [
    {
      'title': 'Practice Interview Session',
      'subject': 'Written Application',
      'dueDate': 'Due: Oct 30',
      'dueTime': 'Priority: Medium',
      'status': 'upcoming',
      'buttons': ['View Content', 'Set Reminder'],
    },
    {
      'title': 'Practice Interview Session',
      'subject': 'Written Application',
      'dueDate': 'Due: Nov 12',
      'dueTime': 'Priority: Medium',
      'status': 'upcoming',
      'buttons': ['View Content', 'Set Reminder'],
    },
  ];

  // Completed Tasks
  final List<Map<String, dynamic>> completedTasks = [
    {
      'title': 'Brainstorming Essay Writings',
      'completedDate': 'Completed on October 7,2025',
      'time': '5 Hours',
    },
    {
      'title': 'Brainstorming Essay Writings',
      'completedDate': 'Completed on October 7,2025',
      'time': '5 Hours',
    },
  ];

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
    scrollToSection(index);
  }

  void scrollToSection(int index) {
    GlobalKey? targetKey;

    switch (index) {
      case 0:
        targetKey = overviewKey;
        break;
      case 1:
        targetKey = dueTodayKey;
        break;
      case 2:
        targetKey = upcomingKey;
        break;
      case 3:
        targetKey = completedKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void markTaskComplete(String taskTitle) {
    // Add logic to mark task as complete
    notifyListeners();
  }

  void viewFeedback(String taskTitle) {
    // Add logic to view feedback
    notifyListeners();
  }

  void viewInfo(String taskTitle) {
    // Add logic to view task info
    notifyListeners();
  }

  void setReminder(String taskTitle) {
    // Add logic to set reminder
    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
