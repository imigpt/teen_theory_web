import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:teen_theory/Models/CommonModels/all_counsellor_model.dart';
import 'package:teen_theory/Models/CommonModels/all_mentor_model.dart' as mentor_model;
import 'package:teen_theory/Models/CommonModels/all_student_model.dart' as student_model;
import 'package:teen_theory/Models/CommonModels/filter_requestmeeting_model.dart';
import 'package:teen_theory/Models/CounsellorModels/all_my_project_model.dart';
import 'package:teen_theory/Models/CounsellorModels/counsellor_meeting_model.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/create_project_main.dart' as create_project;
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';

class CounsellorProvider with ChangeNotifier {

  bool _isBtnLoading = false;
  bool get isBtnLoading => _isBtnLoading;

  void setBtnLoading(bool value) {
    _isBtnLoading = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController studentSearchController = TextEditingController();
  final TextEditingController mentorSearchController = TextEditingController();

  void dispose() {
    projectTitleController.dispose();
    descriptionController.dispose();
    studentSearchController.dispose();
    mentorSearchController.dispose();
    deliverableTitleController.dispose();
    additionalInstructionsController.dispose();
    resourceTitleController.dispose();
    resourceDescriptionController.dispose();
    sessionPurposeController.dispose();
    super.dispose();
  }

  String _selectedProjectType = "SDA Project";
  String get selectedProjectType => _selectedProjectType;

  void setSelectedProjectType(String type) {
    _selectedProjectType = type;
    notifyListeners();
  }

  List<Map<String, String>> assignedStudents = [];

  int _currentStep = 1;
  int get currentStep => _currentStep;

  set setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  int _totalSteps = 8;
  int get totalSteps => _totalSteps;

  // Calculate total weightage
  int get totalWeightage {
    int total = 0;
    for (var milestone in milestones) {
      final weight = int.tryParse(milestone.weight) ?? 0;
      total += weight;
    }
    return total;
  }

  // ==================== STEP VALIDATION METHODS ====================
  
  /// Validates Step 1: Project Basics
  /// Returns error message if validation fails, null if valid
  String? validateStep1() {
    if (projectTitleController.text.trim().isEmpty) {
      return 'Please enter project title';
    }
    if (_selectedProjectType.isEmpty) {
      return 'Please select project type';
    }
    if (descriptionController.text.trim().isEmpty) {
      return 'Please enter project description';
    }
    return null;
  }

  /// Validates Step 2: Assign People & Access
  String? validateStep2() {
    if (assignedStudents.isEmpty) {
      return 'Please assign at least one student';
    }
    if (assignedMentor == null) {
      return 'Please assign a mentor';
    }
    return null;
  }

  /// Validates Step 3: Milestones & Tasks
  String? validateStep3() {
    if (milestones.isEmpty) {
      return 'Please add at least one milestone';
    }
    
    for (int i = 0; i < milestones.length; i++) {
      final milestone = milestones[i];
      if (milestone.name.trim().isEmpty) {
        return 'Please enter name for Milestone ${i + 1}';
      }
      if (milestone.dueDate == null) {
        return 'Please select due date for Milestone ${i + 1}';
      }
      if (milestone.weight.isEmpty || int.tryParse(milestone.weight) == null) {
        return 'Please enter valid weightage for Milestone ${i + 1}';
      }
    }
    
    if (totalWeightage != 100) {
      return 'Total weightage must be exactly 100%. Currently $totalWeightage%';
    }
    
    return null;
  }

  /// Validates Step 4: Deliverables (optional - can skip)
  String? validateStep4() {
    // Deliverables are optional, so no strict validation
    // But if user is adding one, validate the current form
    return null;
  }

  /// Validates Step 5: Resources (optional - can skip)
  String? validateStep5() {
    // Resources are optional, so no strict validation
    return null;
  }

  /// Validates Step 6: Scheduling & Sessions
  String? validateStep6() {
    if (_selectedSessionType == null || _selectedSessionType!.isEmpty) {
      return 'Please select a session type';
    }
    if (_preferredTiming == null || _preferredTiming!.isEmpty) {
      return 'Please select preferred timing';
    }
    if (_selectedDuration == null || _selectedDuration!.isEmpty) {
      return 'Please select session duration';
    }
    return null;
  }

  /// Validates Step 7: Notifications (no validation needed - checkboxes)
  String? validateStep7() {
    // No strict validation needed for notification settings
    return null;
  }

  /// Master validation method - validates current step
  String? validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        return validateStep1();
      case 2:
        return validateStep2();
      case 3:
        return validateStep3();
      case 4:
        return validateStep4();
      case 5:
        return validateStep5();
      case 6:
        return validateStep6();
      case 7:
        return validateStep7();
      default:
        return null;
    }
  }

  void nextStep() {
    // Validate step 3 (Milestones) before proceeding
    if (currentStep == 3 && totalWeightage > 100) {
      // Don't allow moving to next step if weightage exceeds 100
      return;
    }
    
    if (currentStep < totalSteps) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep(BuildContext context) {
    if (currentStep > 1) {
      _currentStep--;
      notifyListeners();
    } else {
      Navigator.pop(context);
    }
  }

  Map<String, dynamic>? assignedMentor;
  
  Map<String, String>? projectCounsellor = {
    'name': 'You ( Emma Wilson)',
    'subtitle': 'Chief Counsellor Auto- Assigned',
  };

  List<create_project.Milestone> milestones = [];

  // Add milestone
  void addMilestone() {
    milestones.add(
      create_project.Milestone(
        name: '',
        dueDate: null,
        weight: '',
        tasks: [
          create_project.Task(title: '', type: null, dueDate: null, priority: null),
        ],
      ),
    );
    notifyListeners();
  }

  // Remove milestone
  void removeMilestone(int index) {
    if (milestones.length > 0) {
      milestones.removeAt(index);
      notifyListeners();
    }
  }

  // Add task to specific milestone
  void addTaskToMilestone(int milestoneIndex) {
    if (milestoneIndex < milestones.length) {
      milestones[milestoneIndex].tasks.add(
        create_project.Task(title: '', type: null, dueDate: null, priority: null),
      );
      notifyListeners();
    }
  }

  // Remove task from specific milestone
  void removeTaskFromMilestone(int milestoneIndex, int taskIndex) {
    if (milestoneIndex < milestones.length &&
        taskIndex < milestones[milestoneIndex].tasks.length &&
        milestones[milestoneIndex].tasks.length > 0) {
      milestones[milestoneIndex].tasks.removeAt(taskIndex);
      notifyListeners();
    }
  }

  //..................... STEP-4 LOGICS..............................//

  TextEditingController deliverableTitleController = TextEditingController();
  TextEditingController additionalInstructionsController = TextEditingController();

  List<String> _selectedDeliverableTypes = [];
  List<String> get selectedDeliverableTypes => _selectedDeliverableTypes;

  void toggleDeliverableType(String type) {
    if (_selectedDeliverableTypes.contains(type)) {
      _selectedDeliverableTypes.remove(type);
    } else {
      _selectedDeliverableTypes.add(type);
    }
    notifyListeners();
  }

  DateTime? _selectedDueDate;
  DateTime? get selectedDueDate => _selectedDueDate;

  set setSelectedDueDate(DateTime? date) {
    _selectedDueDate = date;
    notifyListeners();
  }

  String? _selectedLinkedMilestone;
  String? get selectedLinkedMilestone => _selectedLinkedMilestone;

  set setSelectedLinkedMilestone(String? milestone) {
    _selectedLinkedMilestone = milestone;
    notifyListeners();
  }

  String? _selectedFileNamingConvention;
  String? get selectedFileNamingConvention => _selectedFileNamingConvention;

  set setSelectedFileNamingConvention(String? convention) {
    _selectedFileNamingConvention = convention;
    notifyListeners();
  }

  String? _selectedWordLimit;
  String? get selectedWordLimit => _selectedWordLimit;

  set setSelectedWordLimit(String? limit) {
    _selectedWordLimit = limit;
    notifyListeners();
  }

  bool _allowMultipleSubmissions = true;
  bool get allowMultipleSubmissions => _allowMultipleSubmissions;

  set setAllowMultipleSubmissions(bool value) {
    _allowMultipleSubmissions = value;
    notifyListeners();
  }

  bool _keepHistoryOfVersions = true;
  bool get keepHistoryOfVersions => _keepHistoryOfVersions;

  set setKeepHistoryOfVersions(bool value) {
    _keepHistoryOfVersions = value;
    notifyListeners();
  }

  bool _studentCannotDeleteVersions = true;
  bool get studentCannotDeleteVersions => _studentCannotDeleteVersions;

  set setStudentCannotDeleteVersions(bool value) {
    _studentCannotDeleteVersions = value;
    notifyListeners();
  }

  bool _requiresMentorApproval = false;
  bool get requiresMentorApproval => _requiresMentorApproval;

  set setRequiresMentorApproval(bool value) {
    _requiresMentorApproval = value;
    notifyListeners();
  }

  bool _requiresCounsellorApproval = false;
  bool get requiresCounsellorApproval => _requiresCounsellorApproval;

  set setRequiresCounsellorApproval(bool value) {
    _requiresCounsellorApproval = value;
    notifyListeners();
  }

  List<Deliverable> deliverables = [];

  void addDeliverable() {
    if (deliverableTitleController.text.isEmpty ||
        _selectedDeliverableTypes.isEmpty ||
        _selectedDueDate == null) {
      return; // Don't add if required fields are empty
    }

    deliverables.add(
      Deliverable(
        title: deliverableTitleController.text,
        types: List.from(_selectedDeliverableTypes),
        dueDate: _selectedDueDate!,
        linkedMilestone: _selectedLinkedMilestone,
        fileNamingConvention: _selectedFileNamingConvention,
        wordLimit: _selectedWordLimit,
        additionalInstructions: additionalInstructionsController.text,
        allowMultipleSubmissions: _allowMultipleSubmissions,
        keepHistoryOfVersions: _keepHistoryOfVersions,
        studentCannotDeleteVersions: _studentCannotDeleteVersions,
        requiresMentorApproval: _requiresMentorApproval,
        requiresCounsellorApproval: _requiresCounsellorApproval,
      ),
    );

    // Reset fields after adding
    deliverableTitleController.clear();
    _selectedDeliverableTypes.clear();
    _selectedDueDate = null;
    _selectedLinkedMilestone = null;
    _selectedFileNamingConvention = null;
    _selectedWordLimit = null;
    additionalInstructionsController.clear();
    _allowMultipleSubmissions = true;
    _keepHistoryOfVersions = true;
    _studentCannotDeleteVersions = true;
    _requiresMentorApproval = false;
    _requiresCounsellorApproval = false;

    notifyListeners();
  }

  void removeDeliverable(int index) {
    deliverables.removeAt(index);
    notifyListeners();
  }

  //..................... STEP-5 LOGICS..............................//

  TextEditingController resourceTitleController = TextEditingController();
  TextEditingController resourceDescriptionController = TextEditingController();

  String? _selectedResourceType;
  String? get selectedResourceType => _selectedResourceType;

  set setSelectedResourceType(String? type) {
    _selectedResourceType = type;
    notifyListeners();
  }

  bool _enableResourceVersioning = false;
  bool get enableResourceVersioning => _enableResourceVersioning;

  set setEnableResourceVersioning(bool value) {
    _enableResourceVersioning = value;
    notifyListeners();
  }

  bool _visibleToStudent = true;
  bool get visibleToStudent => _visibleToStudent;

  set setVisibleToStudent(bool value) {
    _visibleToStudent = value;
    notifyListeners();
  }

  bool _visibleToMentor = true;
  bool get visibleToMentor => _visibleToMentor;

  set setVisibleToMentor(bool value) {
    _visibleToMentor = value;
    notifyListeners();
  }

  List<Resource> resources = [
    Resource(
      title: 'Project Guidelines',
      type: 'Document',
      description: 'Detailed guidelines for the project.',
      enableVersioning: true,
      visibleToStudent: true,
      visibleToMentor: true,
    ),
  ];

  void addResource() {
    if (resourceTitleController.text.isEmpty || _selectedResourceType == null) {
      return; // Don't add if required fields are empty
    }

    resources.add(
      Resource(
        title: resourceTitleController.text,
        type: _selectedResourceType!,
        description: resourceDescriptionController.text,
        enableVersioning: _enableResourceVersioning,
        visibleToStudent: _visibleToStudent,
        visibleToMentor: _visibleToMentor,
      ),
    );

    // Reset fields after adding
    resourceTitleController.clear();
    resourceDescriptionController.clear();
    _selectedResourceType = null;
    _enableResourceVersioning = false;
    _visibleToStudent = true;
    _visibleToMentor = true;

    notifyListeners();
  }

  void removeResource(int index) {
    resources.removeAt(index);
    notifyListeners();
  }

  FilePickerResult? _pickedFiles;
  FilePickerResult? get pickedFiles => _pickedFiles;


  Future pickedFileFromDevice () async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: kIsWeb,
    );
    if (result != null) {
      _pickedFiles = result;
      notifyListeners();
    }
  }

  //..................... STEP-6 LOGICS..............................//

  TextEditingController sessionPurposeController = TextEditingController();

  String? _selectedSessionType;
  String? get selectedSessionType => _selectedSessionType;

  set setSelectedSessionType(String? type) {
    _selectedSessionType = type;
    notifyListeners();
  }

  String? _preferredTiming;
  String? get preferredTiming => _preferredTiming;

  set setPreferredTiming(String? timing) {
    _preferredTiming = timing;
    notifyListeners();
  }

  String? _selectedDuration;
  String? get selectedDuration => _selectedDuration;

  set setSelectedDuration(String? duration) {
    _selectedDuration = duration;
    notifyListeners();
  }

  bool _automatedReminders = true;
  bool get automatedReminders => _automatedReminders;

  set setAutomatedReminders(bool value) {
    _automatedReminders = value;
    notifyListeners();
  }

  bool _reminder24Hours = true;
  bool get reminder24Hours => _reminder24Hours;

  set setReminder24Hours(bool value) {
    _reminder24Hours = value;
    notifyListeners();
  }

  bool _reminder1Hour = true;
  bool get reminder1Hour => _reminder1Hour;

  set setReminder1Hour(bool value) {
    _reminder1Hour = value;
    notifyListeners();
  }

  bool _reminder10Minutes = true;
  bool get reminder10Minutes => _reminder10Minutes;

  set setReminder10Minutes(bool value) {
    _reminder10Minutes = value;
    notifyListeners();
  }

  bool _calendarSync = true;
  bool get calendarSync => _calendarSync;

  set setCalendarSync(bool value) {
    _calendarSync = value;
    notifyListeners();
  }

  //..................... STEP-7 LOGICS..............................//

  bool _weeklyTaskTrackerNudges = true;
  bool get weeklyTaskTrackerNudges => _weeklyTaskTrackerNudges;

  set setWeeklyTaskTrackerNudges(bool value) {
    _weeklyTaskTrackerNudges = value;
    notifyListeners();
  }

  bool _dueDateReminder24Hours = true;
  bool get dueDateReminder24Hours => _dueDateReminder24Hours;

  set setDueDateReminder24Hours(bool value) {
    _dueDateReminder24Hours = value;
    notifyListeners();
  }

  bool _dueDateReminder1Hour = true;
  bool get dueDateReminder1Hour => _dueDateReminder1Hour;

  set setDueDateReminder1Hour(bool value) {
    _dueDateReminder1Hour = value;
    notifyListeners();
  }

  bool _dueDateReminder10Minutes = true;
  bool get dueDateReminder10Minutes => _dueDateReminder10Minutes;

  set setDueDateReminder10Minutes(bool value) {
    _dueDateReminder10Minutes = value;
    notifyListeners();
  }

  bool _deadlineApproaching = true;
  bool get deadlineApproaching => _deadlineApproaching;

  set setDeadlineApproaching(bool value) {
    _deadlineApproaching = value;
    notifyListeners();
  }

  bool _overdueEscalation = true;
  bool get overdueEscalation => _overdueEscalation;

  set setOverdueEscalation(bool value) {
    _overdueEscalation = value;
    notifyListeners();
  }

  bool _sessionAlerts = true;
  bool get sessionAlerts => _sessionAlerts;

  set setSessionAlerts(bool value) {
    _sessionAlerts = value;
    notifyListeners();
  }

  bool _sessionAlert24Hours = true;
  bool get sessionAlert24Hours => _sessionAlert24Hours;

  set setSessionAlert24Hours(bool value) {
    _sessionAlert24Hours = value;
    notifyListeners();
  }

  bool _sessionAlert1Hour = true;
  bool get sessionAlert1Hour => _sessionAlert1Hour;

  set setSessionAlert1Hour(bool value) {
    _sessionAlert1Hour = value;
    notifyListeners();
  }

  bool _sessionAlert10Minutes = true;
  bool get sessionAlert10Minutes => _sessionAlert10Minutes;

  set setSessionAlert10Minutes(bool value) {
    _sessionAlert10Minutes = value;
    notifyListeners();
  }

  bool _syncTasks = true;
  bool get syncTasks => _syncTasks;

  set setSyncTasks(bool value) {
    _syncTasks = value;
    notifyListeners();
  }

  bool _syncMilestones = true;
  bool get syncMilestones => _syncMilestones;

  set setSyncMilestones(bool value) {
    _syncMilestones = value;
    notifyListeners();
  }

  bool _syncMeetings = true;
  bool get syncMeetings => _syncMeetings;

  set setSyncMeetings(bool value) {
    _syncMeetings = value;
    notifyListeners();
  }

  // Step 8: Final Confirmation
  bool _confirmProjectDetails = false;
  bool get confirmProjectDetails => _confirmProjectDetails;

  set setConfirmProjectDetails(bool value) {
    _confirmProjectDetails = value;
    notifyListeners();
  }

  bool _confirmTimeline = false;
  bool get confirmTimeline => _confirmTimeline;

  set setConfirmTimeline(bool value) {
    _confirmTimeline = value;
    notifyListeners();
  }

  // Check if all confirmations are completed
  bool get canCreateProject => _confirmProjectDetails && _confirmTimeline;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  void setCreating(bool value) {
    _isCreating = value;
    notifyListeners();
  }

  //..........................Create Project API Call.............................//
  void createProjectApiTap(BuildContext context, {String? counsellorEmail}) {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        createProjectApiCall(context, counsellorEmail: counsellorEmail);
      } else {
        showToast("Please check your internet", type: toastType.error);
      }
    });
  }

  Future<void> createProjectApiCall(BuildContext context, {String? counsellorEmail}) async {

    MultipartFile? _attachedFiles;

    if (_pickedFiles != null && _pickedFiles!.files.isNotEmpty) {
      final file = _pickedFiles!.files.first;
      if (kIsWeb) {
        _attachedFiles = MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        );
      } else {
        _attachedFiles = await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        );
      }
    }
    setBtnLoading(true);
    try {
      setCreating(true);

      // Prepare FormData
      Map<String, dynamic> formMap = {
        "title": projectTitleController.text,
        "project_type": _selectedProjectType,
        "project_description": descriptionController.text,
        "status": "Pending",
        "project_counsellor": counsellorEmail ?? "",
        "milestones": jsonEncode(milestones),
        "session_type": _selectedSessionType ?? "",
        "purpose": sessionPurposeController.text,
        "preferred_time": _preferredTiming ?? "",
        "duration": _selectedDuration ?? "",
        "allow_multiple_submissions": _allowMultipleSubmissions.toString(),
        "mentor_approval": _requiresMentorApproval,
        "counsellor_approval": _requiresCounsellorApproval,
        "student_visibility": _visibleToStudent,
        "mentor_visibility": _visibleToMentor,
        "assigned_student" : assignedMentor != null ? jsonEncode(assignedStudents) : "",
        "assigned_mentor" : assignedMentor != null ? jsonEncode(assignedMentor) : "",
        "deliverables_title" : deliverableTitleController.text,
        "deliverables_type": _selectedDeliverableTypes,
        "due_date" : _selectedDueDate,
        "linked_milestones" : null,
        "metadata_and_req" : null,
        "page_limit" : _selectedWordLimit,
        "additional_instructions" : additionalInstructionsController.text,
        "resources_type"  : _selectedResourceType,
        "resources_title" : resourceTitleController.text,
        "resources_description" : resourceDescriptionController.text,
        "attached_files" : _attachedFiles,
        
      };

      FormData body = FormData.fromMap(formMap);
      
      AppLogger.debug(message: "Create Project FormData: ${body.fields}");

      await DioClient.createProject(
        body: body,
        onSuccess: (response) {
          setCreating(false);
          showToast("Project created successfully!", type: toastType.success);
          getAllMyProjectsApiTap(context);
          Navigator.of(context).pop();
          
          setBtnLoading(false);
          clearCreateProjectData();
          notifyListeners();
        },
        onError: (error) {
          setCreating(false);
          showToast("Failed to create project: $error", type: toastType.error);
          AppLogger.error(message: "createProject error: $error");
          setBtnLoading(false);
          notifyListeners();
        },
      );
    } catch (e) {
      setCreating(false);
      showToast("An error occurred", type: toastType.error);
      AppLogger.error(message: "createProjectApiCall exception: $e");
      setBtnLoading(false);
      notifyListeners();
    }
  }

  clearCreateProjectData() {
    projectTitleController.clear();
    descriptionController.clear();
    assignedStudents.clear();
    assignedMentor = null;
    _selectedProjectType = "SDA Project";
    _selectedSessionType = null;
    _preferredTiming = null;
    deliverableTitleController.clear();
    _selectedDuration = null;
    _selectedDueDate = null;
    _selectedDeliverableTypes = [];
    setCurrentStep = 1;
    milestones.clear();
    deliverables.clear();
    resourceTitleController.clear();
    resourceDescriptionController.clear();
    _selectedResourceType = null;
    additionalInstructionsController.clear();
    resources.clear();
    sessionPurposeController.clear();
    _pickedFiles = null;
    notifyListeners();
  }

  //..........................Get All Students API Call.............................//

  student_model.AllStudentModel? _allStudentData;
  student_model.AllStudentModel? get allStudentData => _allStudentData;

  bool _isLoadingStudents = false;
  bool get isLoadingStudents => _isLoadingStudents;

  void allStundentsApiTap(BuildContext context) {
    ConnectionDetector.connectCheck().then((value) {
        if(value){
          allStudentApiCall();
        } else {
          showToast("Please check your internet", type: toastType.error);
        }
    });
  }

  allStudentApiCall () {
    try{
      _isLoadingStudents = true;
      notifyListeners();
      AppLogger.debug(message: "Fetching all students...");
      DioClient.getAllStudents(
        onSuccess: (response)  async{
        if(response.success == true){
          _allStudentData = await response;
          AppLogger.debug(message: "Students API success. Total users: ${_allStudentData?.data?.length ?? 0}");
          _isLoadingStudents = false;
          notifyListeners();
        } else {
          AppLogger.error(message: "Students API failed: ${response.message}");
          showToast(response.message.toString(), type: toastType.error);
          _isLoadingStudents = false;
          notifyListeners();
        }
      }, onError: (error) {
        _isLoadingStudents = false;
        notifyListeners();
        AppLogger.error(message: "allStudentApiCall error: $error");
        showToast("Failed to fetch students", type: toastType.error);
      });
    }catch(e) {
      _isLoadingStudents = false;
      notifyListeners();
      AppLogger.error(message: "allStudentApiCall exception: ${e.toString()}");
    }
  }

  // Filter students based on search query
  List<student_model.AllStudentDatum> getFilteredStudents(String query) {
    if (_allStudentData == null || _allStudentData!.data == null) {
      AppLogger.debug(message: "No student data available");
      return [];
    }
    
    // Filter only users with user_role = 'student'
    final students = _allStudentData!.data!.where((user) {
      return user.userRole?.toLowerCase() == 'student';
    }).toList();
    
    AppLogger.debug(message: "Total students found: ${students.length}");
    
    if (query.isEmpty) {
      return students;
    }
    
    final filtered = students.where((student) {
      final name = student.fullName?.toLowerCase() ?? '';
      final email = student.email?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) || email.contains(searchQuery);
    }).toList();
    
    AppLogger.debug(message: "Filtered students: ${filtered.length} for query: $query");
    return filtered;
  }

  // Add student to assigned list
  void addStudentToProject(student_model.AllStudentDatum student) {
    // Check if already assigned
    bool alreadyAssigned = assignedStudents.any((s) => s['id'] == student.id);
    
    if (!alreadyAssigned) {
      assignedStudents.add({
        'id': student.id ?? '',
        'name': student.fullName ?? '',
        'grade': 'ID: ${student.datumId ?? ''}',
      });
      notifyListeners();
      showToast("Student added successfully", type: toastType.success);
    } else {
      showToast("Student already assigned", type: toastType.info);
    }
  }

  // Remove student from assigned list
  void removeStudentFromProject(String studentId) {
    assignedStudents.removeWhere((s) => s['id'] == studentId);
    notifyListeners();
    showToast("Student removed", type: toastType.success);
  }

  //..........................Get All Mentors API Call.............................//

  mentor_model.AllMentorModel? _allMentorData;
  mentor_model.AllMentorModel? get allMentorData => _allMentorData;

  bool _isLoadingMentors = false;
  bool get isLoadingMentors => _isLoadingMentors;

  void allMentorsApiTap(BuildContext context) {
    ConnectionDetector.connectCheck().then((value) {
        if(value){
          allMentorApiCall();
        } else {
          showToast("Please check your internet", type: toastType.error);
        }
    });
  }

  allMentorApiCall () {
    try{
      _isLoadingMentors = true;
      notifyListeners();
      AppLogger.debug(message: "Fetching all mentors...");
      DioClient.getAllMentors(
        onSuccess: (response)  async{
        if(response.success == true){
          _allMentorData = await response;
          AppLogger.debug(message: "Mentors API success. Total users: ${_allMentorData?.data?.length ?? 0}");
          _isLoadingMentors = false;
          notifyListeners();
        } else {
          AppLogger.error(message: "Mentors API failed: ${response.message}");
          showToast(response.message.toString(), type: toastType.error);
          _isLoadingMentors = false;
          notifyListeners();
        }
      }, onError: (error) {
        _isLoadingMentors = false;
        notifyListeners();
        AppLogger.error(message: "allMentorApiCall error: $error");
        showToast("Failed to fetch mentors", type: toastType.error);
      });
    }catch(e) {
      _isLoadingMentors = false;
      notifyListeners();
      AppLogger.error(message: "allMentorApiCall exception: ${e.toString()}");
    }
  }

  // Filter mentors based on search query
  List<mentor_model.Datum> getFilteredMentors(String query) {
    if (_allMentorData == null || _allMentorData!.data == null) {
      AppLogger.debug(message: "No mentor data available");
      return [];
    }
    
    // Filter only users with user_role = 'mentor'
    final mentors = _allMentorData!.data!.where((user) {
      return user.userRole?.toLowerCase() == 'mentor';
    }).toList();
    
    AppLogger.debug(message: "Total mentors found: ${mentors.length}");
    
    if (query.isEmpty) {
      return mentors;
    }
    
    final filtered = mentors.where((mentor) {
      final name = mentor.fullName?.toLowerCase() ?? '';
      final email = mentor.email?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) || email.contains(searchQuery);
    }).toList();
    
    AppLogger.debug(message: "Filtered mentors: ${filtered.length} for query: $query");
    return filtered;
  }

  // Add mentor to assigned list
  void addMentorToProject(mentor_model.Datum mentor) {
    assignedMentor = {
      'id': mentor.id ?? '',
      'name': mentor.fullName ?? '',
      'email': mentor.email ?? '',
      'subtitle': '${mentor.expertise?.isNotEmpty == true ? mentor.expertise![0] : "Mentor"} - ${mentor.exp ?? "Experience N/A"}',
      'rating': mentor.rating?.toString() ?? '0.0',
      'reviews': '${mentor.totalStudents ?? 0} students',
    };
    notifyListeners();
    showToast("Mentor assigned successfully", type: toastType.success);
  }

  // Remove mentor from assigned list
  void removeMentorFromProject() {
    assignedMentor = null;
    notifyListeners();
    showToast("Mentor removed", type: toastType.success);
  }

  //......................GET ALL MY PROJECT API CALL...........................//

  bool _myProjectsLoading = false;
  bool get myProjectsLoading => _myProjectsLoading;

  void setMyProjectLoading(bool value){
    _myProjectsLoading = value;
    notifyListeners();
  } 

  AllMyProjectModel? _allMyProjectData;
  AllMyProjectModel? get allMyProjectData => _allMyProjectData;

  void getAllMyProjectsApiTap(BuildContext context) {

    ConnectionDetector.connectCheck().then((value) {
      if(value) {
        getAllMyProjectsApiCall();
      } else {
        showToast("Please check your internet", type: toastType.error);
      }
    });
  }

  getAllMyProjectsApiCall () {
    setMyProjectLoading(true);
    try{
      DioClient.myProduct(
      onSuccess: (response) async {
        if(response.success == true) {
          _allMyProjectData = await response;
        } else {
          AppLogger.error(message: "getAllMyProjectsApiCall failed: ${response.message}");
          showToast(response.message.toString(), type: toastType.error);
        }
        setMyProjectLoading(false);
        notifyListeners();
      }, onError: (error) {
        setMyProjectLoading(false);
        notifyListeners();
        AppLogger.error(message: "getAllMyProjectsApiCall error: $error");
      });
    } catch(e) {
      AppLogger.error(message: "getAllMyProjectsApiCall exception: ${e.toString()}");
      setMyProjectLoading(false);
      notifyListeners();
    }
  }

  //......................COMPLETE PROJECT API CALL...........................//

  bool _completingProject = false;
  int? _completingProjectId;

  bool isProjectCompletionInProgress(int? projectId) {
    if (projectId == null) return false;
    return _completingProject && _completingProjectId == projectId;
  }

  void _setProjectCompletionState(bool value, int? projectId) {
    _completingProject = value;
    _completingProjectId = projectId;
    notifyListeners();
  }

  Future<void> completeProjectStatus(BuildContext context, MyProject project) async {
    final projectId = project.id;
    if (projectId == null) {
      showToast("Project information missing", type: toastType.error);
      return;
    }

    if (_completingProject && _completingProjectId == projectId) {
      return; // Avoid duplicate taps when already processing
    }

    final hasConnection = await ConnectionDetector.connectCheck();
    if (!hasConnection) {
      showToast("Please check your internet", type: toastType.error);
      return;
    }

    _setProjectCompletionState(true, projectId);
    bool errorHandled = false;

    try {
      await DioClient.projectCompleteApi(
        body: {
          "project_id": projectId,
          "status": "completed",
        },
        onSuccess: (_) {
          project.status = 'completed';
          _updateCachedProjectStatus(projectId, 'completed');
          showToast("Project marked as completed", type: toastType.success);
        },
        onError: (error) {
          errorHandled = true;
          showToast(error.isNotEmpty ? error : "Failed to complete project", type: toastType.error);
        },
      );
    } catch (e) {
      if (!errorHandled) {
        showToast("Failed to complete project", type: toastType.error);
      }
      AppLogger.error(message: "completeProjectStatus exception: $e");
    } finally {
      _setProjectCompletionState(false, null);
    }
  }

  void _updateCachedProjectStatus(int projectId, String status) {
    if (_allMyProjectData?.data == null) {
      notifyListeners();
      return;
    }

    for (final item in _allMyProjectData!.data!) {
      if (item.id == projectId) {
        item.status = status;
        break;
      }
    }
    notifyListeners();
  }

  //................APPROVE OR REJECT MILESTONE.....................//

  bool _approvingMilestone = false;
  String? _approvingMilestoneId;

  bool isApprovingMilestone(String milestoneId) => 
      _approvingMilestone && _approvingMilestoneId == milestoneId;

  void setApprovingMilestone(bool value, String? milestoneId) {
    _approvingMilestone = value;
    _approvingMilestoneId = milestoneId;
    notifyListeners();
  }

  Future<void> approveOrRejectMilestone({
    required BuildContext context,
    required int projectId,
    required String milestoneId,
    required String status, // "approved" or "rejected"
  }) async {
    if (_approvingMilestone && _approvingMilestoneId == milestoneId) {
      return; // Avoid duplicate calls
    }

    final hasConnection = await ConnectionDetector.connectCheck();
    if (!hasConnection) {
      showToast("Please check your internet", type: toastType.error);
      return;
    }

    // Store previous status for rollback if API fails
    String? previousStatus;
    
    // Update UI immediately (optimistic update)
    if (_allMyProjectData?.data != null) {
      for (final project in _allMyProjectData!.data!) {
        if (project.id == projectId && project.milestones != null) {
          for (final milestone in project.milestones!) {
            if (milestone.id == milestoneId) {
              previousStatus = milestone.status;
              milestone.status = status;
              break;
            }
          }
          break;
        }
      }
    }
    
    showToast(
      status == "approved" 
        ? "Milestone approved successfully" 
        : "Milestone rejected",
      type: toastType.success,
    );
    notifyListeners();

    setApprovingMilestone(true, milestoneId);

    // Call API in background
    try {
      Map<String, dynamic> body = {
        "project_id": projectId,
        "milestone_id": milestoneId,
        "status": status,
      };
      
      await DioClient.approvedOrRejectApi(
        body: body,
        onSuccess: (_) {
          // API success - data already updated locally
          AppLogger.debug(message: "Milestone status updated successfully in backend");
        },
        onError: (error) {
          // API failed - revert local changes
          if (_allMyProjectData?.data != null && previousStatus != null) {
            for (final project in _allMyProjectData!.data!) {
              if (project.id == projectId && project.milestones != null) {
                for (final milestone in project.milestones!) {
                  if (milestone.id == milestoneId) {
                    milestone.status = previousStatus;
                    break;
                  }
                }
                break;
              }
            }
            notifyListeners();
          }
          showToast(
            error.isNotEmpty ? error : "Failed to update milestone status",
            type: toastType.error,
          );
        },
      );
    } catch (e) {
      // API failed - revert local changes
      if (_allMyProjectData?.data != null && previousStatus != null) {
        for (final project in _allMyProjectData!.data!) {
          if (project.id == projectId && project.milestones != null) {
            for (final milestone in project.milestones!) {
              if (milestone.id == milestoneId) {
                milestone.status = previousStatus;
                break;
              }
            }
            break;
          }
        }
        notifyListeners();
      }
      showToast("Failed to update milestone status", type: toastType.error);
      AppLogger.error(message: "approveOrRejectMilestone exception: $e");
    } finally {
      setApprovingMilestone(false, null);
    }
  }
  //....................COUNSELLOR API..........................//

  AllCounsellorModel? _allCounsellorData;
  AllCounsellorModel? get allCounsellorData => _allCounsellorData;

  void allCounsellorsApiTap(){
    ConnectionDetector.connectCheck().then((value) {
      if(value){
        allCounsellorApiCall();
      } else {
        showToast("Internet not available", type: toastType.error);
      }
    });
  }

  allCounsellorApiCall() {
    try{
      DioClient.allCounsellorsApi(
        onSuccess: (response) {
          _allCounsellorData = response;
          notifyListeners();
      }, onError: (error) {
        AppLogger.error(message: "allCounsellorApiCall error: $error");
        notifyListeners();
      });
    }catch(e){
      AppLogger.error(message: "allCounsellorApiCall exception: ${e.toString()}");
    }
  }

  //.......................FILTER MEETING API........................//

  FilterRequestMeetingModel? _filterRequestMeetingData;
  FilterRequestMeetingModel? get filterRequestMeetingData => _filterRequestMeetingData;

  bool _requestMeetingLoading = false;
  bool get requestMeetingLoading => _requestMeetingLoading;

  void setRequestMeetingLoading(bool value){
    _requestMeetingLoading = value;
    notifyListeners();
  }

  void filterMeetingApiTap() {
    ConnectionDetector.connectCheck().then((value) {
        if(value) {
          filterMeetingApiCall();
        } else {
          showToast("Internet not available", type: toastType.error);
        }
    });
  }
  filterMeetingApiCall() {
    setRequestMeetingLoading(true);
    try{
      DioClient.requestMeetingByTokenApi(
      onSuccess: (response) {
        _filterRequestMeetingData = response;
        setRequestMeetingLoading(false);
        notifyListeners();
      }, onError: (error) {
        AppLogger.error(message: "filterMeetingApiCall error: $error");
        setRequestMeetingLoading(false);
        notifyListeners();
      });
    }catch(err){
      AppLogger.error(message: "filterMeetingApiCall exception: ${err.toString()}");
      setRequestMeetingLoading(false);
      notifyListeners();
    }
  }

  //....................COUNSELLOR MEETINGS API........................//

  bool _meetingsLoading = false;
  bool get meetingsLoading => _meetingsLoading;

  CounsellorMeetingModel? _counsellorMeetingData;
  CounsellorMeetingModel? get counsellorMeetingData => _counsellorMeetingData;

  String? _meetingsError;
  String? get meetingsError => _meetingsError;

  void setMeetingsLoading(bool value) {
    _meetingsLoading = value;
    notifyListeners();
  }

  void fetchCounsellorMeetingsTap() {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        fetchCounsellorMeetings();
      } else {
        _meetingsError = "Internet not available";
        notifyListeners();
      }
    });
  }

  Future<void> fetchCounsellorMeetings() async {
    setMeetingsLoading(true);
    _meetingsError = null;
    try {
      await DioClient.counsellorMeetingApi(
        onSuccess: (response) {
          _counsellorMeetingData = response;
          setMeetingsLoading(false);
        },
        onError: (error) {
          _meetingsError = error;
          setMeetingsLoading(false);
        },
      );
    } catch (e) {
      _meetingsError = e.toString();
      setMeetingsLoading(false);
      AppLogger.error(message: "fetchCounsellorMeetings exception: $e");
    }
  }

  //....................DELETE PROJECT API TAP........................//

  bool _deleteProjectLoading = false;
  bool get deleteProjectLoading => _deleteProjectLoading;

  void setDeleteProjectLoading(bool value) {
    _deleteProjectLoading = value;
    notifyListeners();
  }



  void deleteProjectApiTap(BuildContext context,{required int project_id}) {
    ConnectionDetector.connectCheck().then((value) {
      if(value) {
        deleteProjectApiCall(context, project_id);
      } else {
        showToast("Internet not available", type: toastType.error);
      }
    });
  }

  deleteProjectApiCall(BuildContext context, int project_id) {
    setDeleteProjectLoading(true);
    try{
      DioClient.deleteProjectApi(
        project_id: project_id, 
        onSuccess: (response) {
        showToast("Project delete successfully", type: toastType.success);
        getAllMyProjectsApiTap(context);
        setDeleteProjectLoading(false);
        Navigator.pop(context);
        notifyListeners();
      }, onError: (error) {
        AppLogger.error(message: "deleteProjectApiCall error: $error");
        setDeleteProjectLoading(false);
        notifyListeners();
      });
    }catch(e) {
      AppLogger.error(message: "deleteProjectApiCall exception: ${e.toString()}");
      setDeleteProjectLoading(false);
      notifyListeners();
    }
  }

  //........................CREATE MEETINGS API CALL...........................//


  
}

class Resource {
  final String title;
  final String type;
  final String description;
  final bool enableVersioning;
  final bool visibleToStudent;
  final bool visibleToMentor;

  Resource({
    required this.title,
    required this.type,
    required this.description,
    required this.enableVersioning,
    required this.visibleToStudent,
    required this.visibleToMentor,
  });
}

class Deliverable {
  final String title;
  final List<String> types;
  final DateTime dueDate;
  final String? linkedMilestone;
  final String? fileNamingConvention;
  final String? wordLimit;
  final String additionalInstructions;
  final bool allowMultipleSubmissions;
  final bool keepHistoryOfVersions;
  final bool studentCannotDeleteVersions;
  final bool requiresMentorApproval;
  final bool requiresCounsellorApproval;

  Deliverable({
    required this.title,
    required this.types,
    required this.dueDate,
    this.linkedMilestone,
    this.fileNamingConvention,
    this.wordLimit,
    required this.additionalInstructions,
    required this.allowMultipleSubmissions,
    required this.keepHistoryOfVersions,
    required this.studentCannotDeleteVersions,
    required this.requiresMentorApproval,
    required this.requiresCounsellorApproval,
  });
}
