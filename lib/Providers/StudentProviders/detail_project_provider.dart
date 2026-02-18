import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teen_theory/Models/CommonModels/user_meeting_model.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Services/google_calendar_service.dart';
import 'package:teen_theory/Services/google_auth_service.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Models/CommonModels/all_meeting_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// Conditional import for web
import 'package:teen_theory/Utils/web_file_download.dart'
    if (dart.library.html) 'package:teen_theory/Utils/web_file_download_web.dart'
    as web_download;

import '../../Models/CommonModels/profile_model.dart';

class DetailProjectProvider extends ChangeNotifier {
  int _selectedTabIndex = 0;
  final ScrollController scrollController = ScrollController();

  // Global keys for each section
  final GlobalKey tasksKey = GlobalKey();
  final GlobalKey deliverablesKey = GlobalKey();
  final GlobalKey resourcesKey = GlobalKey();
  final GlobalKey feedbacksKey = GlobalKey();

  int get selectedTabIndex => _selectedTabIndex;

  // Google Sign-In state
  bool _isGoogleSignedIn = false;
  String? _googleUserEmail;
  bool get isGoogleSignedIn => _isGoogleSignedIn;
  String? get googleUserEmail => _googleUserEmail;

  final List<String> tabs = ['Tasks', 'Feedbacks'];

  // Task completion tracking
  Map<int, PlatformFile?> _taskFiles = {};
  final Set<int> _submittedTasks = {};

  Map<int, PlatformFile?> get taskFiles => _taskFiles;

  bool isTaskSubmitted(int taskIndex) => _submittedTasks.contains(taskIndex);
  bool canSubmitTask(int taskIndex) =>
      _taskFiles[taskIndex] != null && !_submittedTasks.contains(taskIndex);

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

  // Task completion methods
  Future<void> pickFileForTask(int taskIndex) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
        withData: kIsWeb, // Load bytes for web platform
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // On web, check for bytes; on mobile, check for path
        if (kIsWeb ? file.bytes != null : file.path != null) {
          _taskFiles[taskIndex] = file;

          // Mark task as completed
          if (taskIndex < tasks.length) {
            tasks[taskIndex]['status'] = 'completed';
            tasks[taskIndex]['date'] =
                'Completed on ${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}';
            tasks[taskIndex]['time'] = 'Just now';
            tasks[taskIndex].remove('progress');
          }

          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  void setTaskSubmissionState(int taskIndex, bool submitted) {
    final changed = submitted
        ? _submittedTasks.add(taskIndex)
        : _submittedTasks.remove(taskIndex);
    if (changed) {
      debugPrint('Task $taskIndex submission state: $submitted');
      notifyListeners();
    }
  }

  void removeTaskFile(int taskIndex) {
    _taskFiles.remove(taskIndex);
    setTaskSubmissionState(taskIndex, false);

    // Revert task status if needed
    if (taskIndex < tasks.length) {
      tasks[taskIndex]['status'] = 'in-progress';
      tasks[taskIndex]['progress'] = 0.5;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //.................... CREATE TICKETS LOGICS......................//

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController raisedByCtrl = TextEditingController();
  final TextEditingController projectCtrl = TextEditingController();
  final TextEditingController assignedToCtrl = TextEditingController();
  final TextEditingController priorityCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  void disposeControllers() {
    titleCtrl.dispose();
    raisedByCtrl.dispose();
    projectCtrl.dispose();
    assignedToCtrl.dispose();
    priorityCtrl.dispose();
    descriptionCtrl.dispose();
  }

  DateTime createdOn = DateTime.now();

  List<XFile> _attachments = [];
  List<XFile> get attachments => _attachments;

  set attachments(List<XFile> value) {
    _attachments = value;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAttachment(BuildContext context) async {
    // Show dialog to choose camera or gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (file != null) {
        _attachments.add(file);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  void removeAttachment(int index) {
    _attachments.removeAt(index);
    notifyListeners();
  }

  //........ CREATE TICKETS API CALLS

  bool _createTicketLoading = false;
  bool get createTicketLoading => _createTicketLoading;

  void setCreateTicketLoading(bool value) {
    _createTicketLoading = value;
    notifyListeners();
  }

  void createTicketApiTap(
    BuildContext context,
    String? projectName,
    String? mentor,
  ) {
    ConnectionDetector.connectCheck().then((value) async {
      if (value) {
        createTicketApiCall(context, projectName, mentor);
      } else {
        showToast("No Internet Connection", type: toastType.error);
      }
    });
  }

  createTicketApiCall(
    BuildContext context,
    String? projectName,
    String? mentor,
  ) async {
    FormData body = FormData.fromMap({
      "title": titleCtrl.text,
      "project_name": projectName,
      "assigned_to": mentor,
      "priority": priorityCtrl.text,
      "explaination": descriptionCtrl.text,
      "attachments": [
        for (var file in attachments)
          await MultipartFile.fromFile(file.path, filename: file.name),
      ],
    });

    print({
      "title": titleCtrl.text,
      "project_name": projectName,
      "assigned_to": mentor,
      "priority": priorityCtrl.text,
      "explaination": descriptionCtrl.text,
      "attachments": [
        for (var file in attachments)
          await MultipartFile.fromFile(file.path, filename: file.name),
      ],
    });
    setCreateTicketLoading(true);

    try {
      DioClient.createTicket(
        body: body,
        onSuccess: (response) {
          if (response["success"] == true) {
            setCreateTicketLoading(false);
            Navigator.of(context).pop();
            clearTicketData();
            showToast("Ticket Create successfully", type: toastType.success);
            notifyListeners();
          } else {
            showToast(response["message"], type: toastType.error);
            setCreateTicketLoading(false);
            notifyListeners();
          }
        },
        onError: (error) {
          AppLogger.error(message: "createTicketApiCall onError: $error");
          setCreateTicketLoading(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "createTicketApiCall Error: $e");
      setCreateTicketLoading(false);
      notifyListeners();
    }
  }

  clearTicketData() {
    titleCtrl.clear();
    raisedByCtrl.clear();
    projectCtrl.clear();
    assignedToCtrl.clear();
    priorityCtrl.clear();
    descriptionCtrl.clear();
    attachments.clear();
    createdOn = DateTime.now();
    notifyListeners();
  }

  //..................COMPLETED TASK API.......................//

  bool _completingTask = false;
  String? _completingTaskId;

  bool isCompletingTask(String milestoneId) =>
      _completingTask && _completingTaskId == milestoneId;

  void setCompletingTask(bool value, String? milestoneId) {
    _completingTask = value;
    _completingTaskId = milestoneId;
    notifyListeners();
  }

  void completeTaskApiTap(
    BuildContext context,
    int projectId,
    String milestoneId,
    int taskIndex,
    PlatformFile? attachment,
  ) async {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        completedTaskApiCall(
          context,
          projectId,
          milestoneId,
          taskIndex,
          attachment,
        );
      } else {
        showToast("Internet not available", type: toastType.error);
      }
    });
  }

  completedTaskApiCall(
    BuildContext context,
    int projectId,
    String milestoneId,
    int taskIndex,
    PlatformFile? attachment,
  ) async {
    setCompletingTask(true, milestoneId);

    // Prepare attachment based on platform
    dynamic attachmentData = "";
    if (attachment != null) {
      if (kIsWeb) {
        // For web, use bytes
        if (attachment.bytes != null) {
          attachmentData = MultipartFile.fromBytes(
            attachment.bytes!,
            filename: attachment.name,
          );
        }
      } else {
        // For mobile/desktop, use path
        if (attachment.path != null) {
          attachmentData = await MultipartFile.fromFile(
            attachment.path!,
            filename: attachment.name,
          );
        }
      }
    }

    FormData body = FormData.fromMap({
      "project_id": projectId.toString(),
      "milestone_id": milestoneId,
      "status": "completed",
      "attachment": attachmentData,
    });

    try {
      DioClient.completeTaskApi(
        body: body,
        onSuccess: (response) {
          if (response["success"] == true) {
            setTaskSubmissionState(taskIndex, true);
            setCompletingTask(false, null);
            showToast(
              "Task submitted for approval successfully",
              type: toastType.success,
            );
            notifyListeners();
          } else {
            showToast(
              response["message"] ?? "Failed to submit task",
              type: toastType.error,
            );
            setCompletingTask(false, null);
            notifyListeners();
          }
        },
        onError: (error) {
          AppLogger.error(message: "completedTaskApiCall onError: $error");
          showToast("Failed to submit task", type: toastType.error);
          setTaskSubmissionState(taskIndex, false);
          setCompletingTask(false, null);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "completedTaskApiCall Error: $e");
      showToast("Failed to submit task", type: toastType.error);
      setTaskSubmissionState(taskIndex, false);
      setCompletingTask(false, null);
      notifyListeners();
    }
  }

  //.......................MEETING SECTION.......................//
  TextEditingController meetingTitleController = TextEditingController();
  TextEditingController meetingLinkController = TextEditingController();
  DateTime? _selectedDateTime;
  DateTime? get selectedDateTime => _selectedDateTime;

  String? _selectedTimeSlot;
  String? get selectedTimeSlot => _selectedTimeSlot;

  AllMeetingModel? _allMeetingsData;
  bool _loadingMeetings = false;
  Set<String> _bookedTimeSlots = {};

  Set<String> get bookedTimeSlots => _bookedTimeSlots;

  void setSelectedDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  void setSelectedTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    // Parse the time slot and create a DateTime for today with that time
    final now = DateTime.now();
    final timeParts = timeSlot.split(' - ')[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    final isPM = timeSlot.contains('PM');

    int adjustedHour = hour;
    if (isPM && hour != 12) {
      adjustedHour = hour + 12;
    } else if (!isPM && hour == 12) {
      adjustedHour = 0;
    }

    _selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      adjustedHour,
      minute,
    );
    notifyListeners();
  }

  // Meeting duration state
  int _selectedMeetingDuration = 30; // Default 30 minutes
  int get selectedMeetingDuration => _selectedMeetingDuration;
  
  void setMeetingDuration(int duration) {
    _selectedMeetingDuration = duration;
    _selectedTimeSlot = null; // Reset time slot when duration changes
    notifyListeners();
  }
  
  List<String> generateTimeSlots() {
    final List<String> slots = [];
    final int duration = _selectedMeetingDuration;
    
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final startTime = TimeOfDay(hour: hour, minute: minute);
        
        // Calculate end time based on selected duration
        int totalMinutes = hour * 60 + minute + duration;
        if (totalMinutes >= 24 * 60) continue; // Skip if end time exceeds 24 hours
        
        final endHour = totalMinutes ~/ 60;
        final endMinute = totalMinutes % 60;
        final endTime = TimeOfDay(hour: endHour, minute: endMinute);

        final startFormatted = _formatTimeOfDay(startTime);
        final endFormatted = _formatTimeOfDay(endTime);
        slots.add('$startFormatted - $endFormatted');
      }
    }
    return slots;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // Check if a time slot is within mentor's shift time
  bool isMentorAvailable(String timeSlot, AssignedMentor? mentor) {
    if (mentor == null) {
      print('DEBUG: Mentor is null');
      return false;
    }

    print('DEBUG: Checking slot: $timeSlot');
    print('DEBUG: Mentor data: ${mentor.name}, ${mentor.email}');
    print('DEBUG: Mentor start_shift_time: ${mentor.start_shift_time}');
    print('DEBUG: Mentor end_shift_time: ${mentor.end_shift_time}');

    if (mentor.start_shift_time == null || mentor.end_shift_time == null) {
      print('DEBUG: Shift times are null');
      return false;
    }

    if (mentor.start_shift_time!.isEmpty || mentor.end_shift_time!.isEmpty) {
      print('DEBUG: Shift times are empty strings');
      return false;
    }

    try {
      // Parse the time slot (e.g., "9:00 AM - 9:30 AM")
      final parts = timeSlot.split(' - ');
      if (parts.length != 2) {
        print('DEBUG: Invalid slot format - parts: ${parts.length}');
        return false;
      }

      final slotStart = _parseTimeString(parts[0].trim());
      final slotEnd = _parseTimeString(parts[1].trim());
      final mentorStart = _parseTimeString(mentor.start_shift_time!);
      final mentorEnd = _parseTimeString(mentor.end_shift_time!);

      print('DEBUG: Parsed slot start: ${slotStart?.hour}:${slotStart?.minute}');
      print('DEBUG: Parsed slot end: ${slotEnd?.hour}:${slotEnd?.minute}');
      print('DEBUG: Parsed mentor start: ${mentorStart?.hour}:${mentorStart?.minute}');
      print('DEBUG: Parsed mentor end: ${mentorEnd?.hour}:${mentorEnd?.minute}');

      if (slotStart == null || slotEnd == null || mentorStart == null || mentorEnd == null) {
        print('DEBUG: Failed to parse times');
        return false;
      }

      // Convert to minutes for easier comparison
      final slotStartMinutes = slotStart.hour * 60 + slotStart.minute;
      final slotEndMinutes = slotEnd.hour * 60 + slotEnd.minute;
      final mentorStartMinutes = mentorStart.hour * 60 + mentorStart.minute;
      final mentorEndMinutes = mentorEnd.hour * 60 + mentorEnd.minute;

      print('DEBUG: Slot minutes: $slotStartMinutes - $slotEndMinutes');
      print('DEBUG: Mentor minutes: $mentorStartMinutes - $mentorEndMinutes');

      // Check if slot overlaps with mentor's shift time
      final isAvailable = slotStartMinutes >= mentorStartMinutes &&
          slotEndMinutes <= mentorEndMinutes;
      
      print('DEBUG: Is available: $isAvailable');
      print('---');
      return isAvailable;
    } catch (e) {
      AppLogger.error(message: 'Error checking mentor availability: $e');
      print('DEBUG: Exception: $e');
      return false;
    }
  }

  // Check if a time slot is within counsellor's shift time
  bool isCounsellorAvailable(String timeSlot, CreatedByUser? counsellor) {
    if (counsellor == null) {
      print('DEBUG: Counsellor is null');
      return false;
    }

    print('DEBUG: Checking counsellor for slot: $timeSlot');
    print('DEBUG: Counsellor data: ${counsellor.full_name}, ${counsellor.email}');
    print('DEBUG: Counsellor start_shift_time: ${counsellor.start_shift_time}');
    print('DEBUG: Counsellor end_shift_time: ${counsellor.end_shift_time}');

    if (counsellor.start_shift_time == null || counsellor.end_shift_time == null) {
      print('DEBUG: Counsellor shift times are null');
      return false;
    }

    if (counsellor.start_shift_time!.isEmpty || counsellor.end_shift_time!.isEmpty) {
      print('DEBUG: Counsellor shift times are empty strings');
      return false;
    }

    try {
      // Parse the time slot (e.g., "9:00 AM - 9:30 AM")
      final parts = timeSlot.split(' - ');
      if (parts.length != 2) {
        print('DEBUG: Invalid slot format - parts: ${parts.length}');
        return false;
      }

      final slotStart = _parseTimeString(parts[0].trim());
      final slotEnd = _parseTimeString(parts[1].trim());
      final counsellorStart = _parseTimeString(counsellor.start_shift_time!);
      final counsellorEnd = _parseTimeString(counsellor.end_shift_time!);

      print('DEBUG: Parsed slot start: ${slotStart?.hour}:${slotStart?.minute}');
      print('DEBUG: Parsed slot end: ${slotEnd?.hour}:${slotEnd?.minute}');
      print('DEBUG: Parsed counsellor start: ${counsellorStart?.hour}:${counsellorStart?.minute}');
      print('DEBUG: Parsed counsellor end: ${counsellorEnd?.hour}:${counsellorEnd?.minute}');

      if (slotStart == null || slotEnd == null || counsellorStart == null || counsellorEnd == null) {
        print('DEBUG: Failed to parse counsellor times');
        return false;
      }

      // Convert to minutes for easier comparison
      final slotStartMinutes = slotStart.hour * 60 + slotStart.minute;
      final slotEndMinutes = slotEnd.hour * 60 + slotEnd.minute;
      final counsellorStartMinutes = counsellorStart.hour * 60 + counsellorStart.minute;
      final counsellorEndMinutes = counsellorEnd.hour * 60 + counsellorEnd.minute;

      print('DEBUG: Slot minutes: $slotStartMinutes - $slotEndMinutes');
      print('DEBUG: Counsellor minutes: $counsellorStartMinutes - $counsellorEndMinutes');

      // Check if slot overlaps with counsellor's shift time
      final isAvailable = slotStartMinutes >= counsellorStartMinutes &&
          slotEndMinutes <= counsellorEndMinutes;
      
      print('DEBUG: Counsellor is available: $isAvailable');
      print('---');
      return isAvailable;
    } catch (e) {
      AppLogger.error(message: 'Error checking counsellor availability: $e');
      print('DEBUG: Counsellor Exception: $e');
      return false;
    }
  }

  // Parse time string (e.g., "12:47 PM") to TimeOfDay
  TimeOfDay? _parseTimeString(String timeString) {
    try {
      final parts = timeString.trim().split(' ');
      if (parts.length != 2) return null;

      final timeParts = parts[0].split(':');
      if (timeParts.length != 2) return null;

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      final period = parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      AppLogger.error(message: 'Error parsing time string: $e');
      return null;
    }
  }

  // Fetch all meetings and extract booked time slots for today
  Future<void> fetchAllMeetings() async {
    if (_loadingMeetings) return;

    final isConnected = await ConnectionDetector.connectCheck();
    if (!isConnected) {
      showToast("Internet not available", type: toastType.error);
      return;
    }

    _loadingMeetings = true;
    try {
      await DioClient.allMeeting(
        onSuccess: (response) {
          _allMeetingsData = response;
          _extractBookedTimeSlots();
          _loadingMeetings = false;
          notifyListeners();
        },
        onError: (error) {
          AppLogger.error(message: "fetchAllMeetings onError: $error");
          _loadingMeetings = false;
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "fetchAllMeetings Error: $e");
      _loadingMeetings = false;
      notifyListeners();
    }
  }

  // Extract booked time slots from all meetings for today
  void _extractBookedTimeSlots() {
    _bookedTimeSlots.clear();

    if (_allMeetingsData?.data == null) return;

    final today = DateTime.now();

    for (var meeting in _allMeetingsData!.data!) {
      if (meeting.dateTime == null) continue;

      try {
        final meetingDateTime = DateTime.parse(meeting.dateTime!);

        // Check if meeting is today
        if (meetingDateTime.year == today.year &&
            meetingDateTime.month == today.month &&
            meetingDateTime.day == today.day) {
          // Extract the time slot
          final meetingTime = TimeOfDay(
            hour: meetingDateTime.hour,
            minute: meetingDateTime.minute,
          );

          // Calculate the 30-minute slot
          final slotMinute = meetingTime.minute < 30 ? 0 : 30;
          final startTime = TimeOfDay(
            hour: meetingTime.hour,
            minute: slotMinute,
          );
          final endTime = slotMinute == 0
              ? TimeOfDay(hour: meetingTime.hour, minute: 30)
              : TimeOfDay(hour: meetingTime.hour + 1, minute: 0);

          final startFormatted = _formatTimeOfDay(startTime);
          final endFormatted = _formatTimeOfDay(endTime);
          final timeSlot = '$startFormatted - $endFormatted';

          _bookedTimeSlots.add(timeSlot);
        }
      } catch (e) {
        AppLogger.error(message: "Error parsing meeting dateTime: $e");
      }
    }
  }

  Future<void> openMeetNew() async {
    await openExternalLink("https://meet.google.com/new");
  }

  Future<void> openMeetLink({required String link}) async {
    await openExternalLink(link);
  }

  bool _meetingLoader = false;
  bool get meetingLoader => _meetingLoader;

  void setMeetingLoader(bool value) {
    _meetingLoader = value;
    notifyListeners();
  }

  // Check Google Sign-In status
  Future<void> checkGoogleSignInStatus() async {
    final googleAuthService = GoogleAuthService();
    _isGoogleSignedIn = await googleAuthService.checkAuthStatus();
    if (_isGoogleSignedIn && googleAuthService.currentUser != null) {
      _googleUserEmail = googleAuthService.currentUser!.email;
    } else {
      _googleUserEmail = null;
    }
    notifyListeners();
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final googleAuthService = GoogleAuthService();
      final account = await googleAuthService.signIn();
      
      if (account != null) {
        _isGoogleSignedIn = true;
        _googleUserEmail = account.email;
        notifyListeners();
        showToast("Signed in as ${account.email}", type: toastType.success);
        return true;
      } else {
        showToast("Sign-in cancelled", type: toastType.error);
        return false;
      }
    } catch (e) {
      AppLogger.error(message: "Google Sign-In Error: $e");
      showToast("Failed to sign in with Google", type: toastType.error);
      return false;
    }
  }

  // Sign out from Google
  Future<void> signOutFromGoogle() async {
    try {
      final googleAuthService = GoogleAuthService();
      await googleAuthService.signOut();
      _isGoogleSignedIn = false;
      _googleUserEmail = null;
      notifyListeners();
      showToast("Signed out successfully", type: toastType.success);
    } catch (e) {
      AppLogger.error(message: "Google Sign-Out Error: $e");
    }
  }

  void CreateMeetingLinkApiTap(
    BuildContext context, {
    required String projectName,
    required String counsellorEmail,
    required AssignedMentor projectMentor,
  }) {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        createMeetingLinkApiCall(
          context,
          projectName: projectName,
          counsellorEmail: counsellorEmail,
          projectMentor: projectMentor,
        );
      } else {
        showToast("Internet not available", type: toastType.error);
      }
    });
  }

  createMeetingLinkApiCall(
    BuildContext context, {
    required String projectName,
    required String counsellorEmail,
    required AssignedMentor projectMentor,
  }) async {
    if (meetingTitleController.text.isEmpty) {
      showToast("Please enter meeting title", type: toastType.error);
      return;
    }

    if (_selectedDateTime == null) {
      showToast("Please select time slot", type: toastType.error);
      return;
    }

    if (_selectedMeetingDuration == null) {
      showToast("Please select meeting duration", type: toastType.error);
      return;
    }

    setMeetingLoader(true);

    try {
      // Check if user is signed in with Google
      final googleAuthService = GoogleAuthService();
      final isSignedIn = await googleAuthService.checkAuthStatus();

      String meetingLink = meetingLinkController.text;

      // If signed in, create Google Calendar event with Meet link
      if (isSignedIn) {
        final googleCalendarService = GoogleCalendarService();
        final endDateTime = _selectedDateTime!.add(Duration(minutes: _selectedMeetingDuration!));

        final calendarEvent = await googleCalendarService.createCalendarEventWithMeet(
          summary: meetingTitleController.text,
          description: "Discussion with mentor - $projectName",
          startDateTime: _selectedDateTime!,
          endDateTime: endDateTime,
        );

        if (calendarEvent != null && calendarEvent['hangoutLink'] != null) {
          meetingLink = calendarEvent['hangoutLink'];
          showToast("Google Meet link created successfully", type: toastType.success);
        } else {
          // If calendar event creation failed but user provided manual link
          if (meetingLinkController.text.isEmpty) {
            showToast("Failed to create Google Meet link. Please enter meeting link manually", type: toastType.error);
            setMeetingLoader(false);
            return;
          }
        }
      } else {
        // User not signed in with Google, use manual link
        if (meetingLinkController.text.isEmpty) {
          showToast("Please sign in with Google or enter meeting link manually", type: toastType.error);
          setMeetingLoader(false);
          return;
        }
      }

      Map<String, dynamic> body = {
        "title": meetingTitleController.text,
        "date_time": _selectedDateTime!.toIso8601String(),
        "meeting_link": meetingLink,
        "project_name": projectName,
        "project_counsellor_email": counsellorEmail,
        "project_mentor": projectMentor,
      };

      DioClient.createMeetingLink(
        body: body,
        onSuccess: (response) {
          if (response["success"] == true) {
            showToast("Meeting created successfully", type: toastType.success);
            Navigator.of(context).pop();
            filteredMeetingLinkApiTap(context);
            setMeetingLoader(false);
            notifyListeners();
          } else {
            showToast(
              response["message"] ?? "Failed to create meeting link",
              type: toastType.error,
            );
            setMeetingLoader(false);
            notifyListeners();
          }
        },
        onError: (error) {
          AppLogger.error(message: "createMeetingLinkApiCall onError: $error");
          showToast("Failed to create meeting link", type: toastType.error);
          setMeetingLoader(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "createMeetingLinkApiCall Error: $e");
      showToast("Error creating meeting", type: toastType.error);
      setMeetingLoader(false);
      notifyListeners();
    }
  }

  //.............filtered Meeting Link...................//

  bool _filteredMeetingLoader = false;
  bool get filteredMeetingLoader => _filteredMeetingLoader;

  void setFilteredMeetingLoader(bool value) {
    _filteredMeetingLoader = value;
    notifyListeners();
  }

  UserMeetingModel? _filteredMeetingData;
  UserMeetingModel? get filteredMeetingData => _filteredMeetingData;

  void filteredMeetingLinkApiTap(BuildContext context) {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        filteredMeetingLinkApiCall(context);
      } else {
        showToast("Intenet not available", type: toastType.error);
      }
    });
  }

  filteredMeetingLinkApiCall(BuildContext context) async {
    try {
      DioClient.filteredMeetingLink(
        onSuccess: (response) {
          if (response.success == true) {
            _filteredMeetingData = response;
            setFilteredMeetingLoader(false);
            notifyListeners();
          } else {
            showToast(
              response.message ?? "Failed to fetch meeting links",
              type: toastType.error,
            );
            setFilteredMeetingLoader(false);
            notifyListeners();
          }
        },
        onError: (error) {
          showToast("Sometings went wrong", type: toastType.error);
          AppLogger.error(
            message: "filteredMeetingLinkApiCall onError: $error",
          );
          setFilteredMeetingLoader(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "filteredMeetingLinkApiCall Error: $e");
      setFilteredMeetingLoader(false);
      notifyListeners();
    }
  }

  //.............Download File...................//

  bool _downloadingFile = false;
  bool get downloadingFile => _downloadingFile;

  void setDownloadingFile(bool value) {
    _downloadingFile = value;
    notifyListeners();
  }

  Future<void> downloadFile(BuildContext context, String? fileUrl) async {
    if (fileUrl == null || fileUrl.isEmpty) {
      showToast("No file available to download", type: toastType.error);
      return;
    }

    final isConnected = await ConnectionDetector.connectCheck();
    if (!isConnected) {
      showToast("Internet not available", type: toastType.error);
      return;
    }

    setDownloadingFile(true);

    try {
      if (kIsWeb) {
        // Web platform - download file via Dio and create blob
        try {
          final dio = Dio();

          // Download file as bytes
          final response = await dio.get(
            fileUrl,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: true,
              validateStatus: (status) => status! < 500,
            ),
          );

          if (response.statusCode == 200) {
            // Extract filename from URL
            String fileName = fileUrl.split('/').last;
            if (!fileName.contains('.')) {
              fileName = 'documentation.pdf';
            }

            // Download file on web
            await web_download.downloadFile(response.data, fileName);

            setDownloadingFile(false);
            showToast("File downloaded successfully", type: toastType.success);
          } else {
            setDownloadingFile(false);
            showToast("File not found on server", type: toastType.error);
          }
        } catch (e) {
          AppLogger.error(message: "Web download error: $e");
          setDownloadingFile(false);
          showToast("Failed to download file", type: toastType.error);
        }
      } else {
        // Mobile/Desktop platform - download to file system
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
          // Navigate to Downloads folder on Android
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int i = 1; i < paths.length; i++) {
            String folder = paths[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Download";
          directory = Directory(newPath);
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Extract filename from URL
        String fileName = fileUrl.split('/').last;
        if (!fileName.contains('.')) {
          fileName = 'documentation.pdf';
        }

        String filePath = '${directory.path}/$fileName';

        // Download the file
        final dio = Dio();
        await dio.download(
          fileUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print(
                'Download progress: ${(received / total * 100).toStringAsFixed(0)}%',
              );
            }
          },
        );

        setDownloadingFile(false);
        showToast(
          "File downloaded successfully to Downloads",
          type: toastType.success,
        );
      }
    } catch (e) {
      AppLogger.error(message: "downloadFile Error: $e");
      setDownloadingFile(false);
      showToast("Failed to download file", type: toastType.error);
    }
  }
}
