import 'package:flutter/material.dart';

class DetailProjectProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  final ScrollController scrollController = ScrollController();

  // Global keys for each section
  final GlobalKey tasksKey = GlobalKey();
  final GlobalKey deliverablesKey = GlobalKey();
  final GlobalKey resourcesKey = GlobalKey();
  final GlobalKey feedbacksKey = GlobalKey();

  int get selectedTabIndex => _selectedTabIndex;

  final List<String> tabs = ['Tasks', 'Deliverables', 'Resources', 'Feedbacks'];

  // Sample data
  final String milestoneTitle = 'Milestone: Research Phase';
  final String milestoneDate = 'Due: 22 Nov 2025';
  final double milestoneProgress = 0.5;

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Brainstorming Essay Writings',
      'status': 'completed',
      'date': 'Completed on October 7,2025',
      'time': '5 Hours Ago',
    },
    {
      'title': 'Write First Draft',
      'status': 'in-progress',
      'date': 'Due: 12 October',
      'progress': 0.5,
    },
    {
      'title': 'Brainstorming Essay Writings',
      'status': 'completed',
      'date': 'Completed on October 7,2025',
      'time': '5 Hours Ago',
    },
  ];

  final List<Map<String, dynamic>> deliverables = [
    {
      'title': 'Essay _ Draft-v2. Docx',
      'uploaded': 'Uploaded 2 hours Ago',
      'status': 'Approved',
      'size': '1.2MB',
    },
    {
      'title': 'Essay _ Draft-v2. Docx',
      'uploaded': 'Uploaded 7 hours Ago',
      'status': 'Approved',
      'size': '1.2MB',
    },
  ];

  final List<Map<String, dynamic>> resources = [
    {
      'title': 'Video Tutorial: Essay Writing',
      'duration': '45 min',
      'type': 'Recorded Session',
    },
    {
      'title': 'Video Tutorial: Essay Writing',
      'duration': '45 min',
      'type': 'Recorded Session',
    },
    {
      'title': 'Video Tutorial: Essay Writing',
      'duration': '45 min',
      'type': 'Recorded Session',
    },
  ];

  final List<Map<String, dynamic>> feedbacks = [
    {
      'name': 'Saakshi Jain',
      'role': 'Mentor',
      'feedback':
          '"Good progress on AI project, add more examples in your proposal."',
      'time': '5 Hours Ago',
      'avatar': '',
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
        targetKey = tasksKey;
        break;
      case 1:
        targetKey = deliverablesKey;
        break;
      case 2:
        targetKey = resourcesKey;
        break;
      case 3:
        targetKey = feedbacksKey;
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

  void updateTabOnScroll(double scrollPosition) {
    // This method can be called to update tab based on scroll position
    // Implement if needed for automatic tab change on manual scroll
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
