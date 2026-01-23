import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teen_theory/Models/CommonModels/user_meeting_model.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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

  void disposeControllers () {
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

void setCreateTicketLoading (bool value){
    _createTicketLoading = value;
    notifyListeners();
}

  void createTicketApiTap (BuildContext context, String? projectName, String? mentor) {
    ConnectionDetector.connectCheck().then((value) async {
        if (value){
       createTicketApiCall(context, projectName, mentor);
        } else {
          showToast("No Internet Connection", type: toastType.error);
        }
    });
  }

  createTicketApiCall (BuildContext context, String? projectName, String? mentor) async {
     FormData body = FormData.fromMap({
        "title" : titleCtrl.text,
        "project_name" : projectName,
        "assigned_to" : mentor,
        "priority" : priorityCtrl.text,
        "explaination" : descriptionCtrl.text,
        "attachments" : [
          for (var file in attachments) 
            await MultipartFile.fromFile(file.path, filename: file.name)
        ],
      });

      print({
        "title" : titleCtrl.text,
        "project_name" : projectName,
        "assigned_to" : mentor,
        "priority" : priorityCtrl.text,
        "explaination" : descriptionCtrl.text,
        "attachments" : [
          for (var file in attachments) 
            await MultipartFile.fromFile(file.path, filename: file.name)
        ],
      });
      setCreateTicketLoading(true);

    try{
         DioClient.createTicket(
          body: body, 
          onSuccess: (response) {
            if(response["success"] == true) {
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
          }, onError: (error) {
            AppLogger.error(message: "createTicketApiCall onError: $error");
            setCreateTicketLoading(false);
            notifyListeners();
          });

    }catch(e) {
      AppLogger.error(message: "createTicketApiCall Error: $e");
      setCreateTicketLoading(false);
      notifyListeners();
    }
  }

  clearTicketData () {
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

  bool isCompletingTask(String milestoneId) => _completingTask && _completingTaskId == milestoneId;

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
      if(value){
        completedTaskApiCall(context, projectId, milestoneId, taskIndex, attachment);
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
      "project_id" : projectId.toString(),
      "milestone_id" : milestoneId,
      "status" : "completed",
      "attachment" : attachmentData,
    });
    
    try{
      DioClient.completeTaskApi(
        body: body, 
        onSuccess: (response) {
          if(response["success"] == true) {
            setTaskSubmissionState(taskIndex, true);
            setCompletingTask(false, null);
            showToast("Task submitted for approval successfully", type: toastType.success);
            notifyListeners();
          } else {
            showToast(response["message"] ?? "Failed to submit task", type: toastType.error);
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
        });

    } catch(e) {
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

   void setSelectedDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
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

void CreateMeetingLinkApiTap(BuildContext context, {required String projectName, required String counsellorEmail, required AssignedMentor projectMentor}) {
  ConnectionDetector.connectCheck().then((value) {
    if(value) {
      createMeetingLinkApiCall(context, projectName: projectName, counsellorEmail: counsellorEmail, projectMentor: projectMentor);
    } else {
      showToast("Internet not available", type: toastType.error);
    }
  });
}

createMeetingLinkApiCall(
  BuildContext context,
  {
  required String projectName,
  required String counsellorEmail,
  required AssignedMentor projectMentor
}) async {
  if(meetingTitleController.text.isEmpty) {
    showToast("Please enter meeting title", type: toastType.error);
    return;
  }

  if(_selectedDateTime == null) {
    showToast("Please select date and time", type: toastType.error);
    return;
  }

  if(meetingLinkController.text.isEmpty) {
    showToast("Please enter meeting link", type: toastType.error);
    return;
  }

  Map<String, dynamic> body = {
    "title" : meetingTitleController.text,
    "date_time" : _selectedDateTime!.toIso8601String(),
    "meeting_link" : meetingLinkController.text,
    "project_name" : projectName,
    "project_counsellor_email" : counsellorEmail,
    "project_mentor" : projectMentor,
  };

  setMeetingLoader(true);
  try{
    DioClient.createMeetingLink(
    body: body,
    onSuccess: (response) {
      if(response["success"] == true) {
        showToast("Meeting created successfully", type: toastType.success);
        Navigator.of(context).pop();
        filteredMeetingLinkApiTap(context);
        setMeetingLoader(false);
        notifyListeners();
      } else {
        showToast(response["message"] ?? "Failed to create meeting link", type: toastType.error);
        setMeetingLoader(false);
        notifyListeners();
      }
    }, onError: (error) {
      AppLogger.error(message: "createMeetingLinkApiCall onError: $error");
      showToast("Failed to create meeting link", type: toastType.error);
      setMeetingLoader(false);
      notifyListeners();
    });

  }catch (e) {
    AppLogger.error(message: "createMeetingLinkApiCall Error: $e");
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
      if(value){
        filteredMeetingLinkApiCall(context);
      } else {
        showToast("Intenet not available", type: toastType.error);
      }
    });
  }

  filteredMeetingLinkApiCall(BuildContext context) async {
    try{
      DioClient.filteredMeetingLink(
      onSuccess: (response) {
          if(response.success == true) {
            _filteredMeetingData = response;
            setFilteredMeetingLoader(false);
            notifyListeners();
          } else {
            showToast(response.message ?? "Failed to fetch meeting links", type: toastType.error);
            setFilteredMeetingLoader(false);
            notifyListeners();
          }
      }, onError: (error) {
        showToast("Sometings went wrong", type: toastType.error);
        AppLogger.error(message: "filteredMeetingLinkApiCall onError: $error");
        setFilteredMeetingLoader(false);
        notifyListeners();
      });
    }catch(e) {
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

            // Create blob and download
            final bytes = response.data;
            final blob = html.Blob([bytes]);
            final url = html.Url.createObjectUrlFromBlob(blob);
            final anchor = html.AnchorElement(href: url)
              ..setAttribute('download', fileName)
              ..style.display = 'none';
            
            html.document.body?.children.add(anchor);
            anchor.click();
            html.document.body?.children.remove(anchor);
            html.Url.revokeObjectUrl(url);
            
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
              print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
            }
          },
        );

        setDownloadingFile(false);
        showToast("File downloaded successfully to Downloads", type: toastType.success);
      }
    } catch (e) {
      AppLogger.error(message: "downloadFile Error: $e");
      setDownloadingFile(false);
      showToast("Failed to download file", type: toastType.error);
    }
  }
}