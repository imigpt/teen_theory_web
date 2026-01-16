import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Screens/StudentDashboard/Profile/student_edit_profile.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';

class StudentProfileProvider extends ChangeNotifier {
  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Activity Controllers
  List<TextEditingController> activityControllers = [];
  List<String> editableActivities = [];

  // Achievement Controllers
  List<TextEditingController> achievementTitleControllers = [];
  List<TextEditingController> achievementDescriptionControllers = [];
  List<TextEditingController> achievementDateControllers = [];
  List<Map<String, String>> editableAchievements = [];

  bool isSaving = false;

  StudentProfileProvider() {
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController.text = studentName;
    emailController.text = studentEmail;
    phoneController.text = studentPhone;
    ageController.text = age.toString();
    schoolController.text = school;
    gradeController.text = grade;
    addressController.text = address;

    // Initialize activities
    editableActivities = List.from(activities);
    activityControllers = editableActivities
        .map((activity) => TextEditingController(text: activity))
        .toList();

    // Initialize achievements
    editableAchievements = achievements.map((a) => Map<String, String>.from(a)).toList();
    achievementTitleControllers = editableAchievements
        .map((a) => TextEditingController(text: a['title']))
        .toList();
    achievementDescriptionControllers = editableAchievements
        .map((a) => TextEditingController(text: a['description']))
        .toList();
    achievementDateControllers = editableAchievements
        .map((a) => TextEditingController(text: a['date']))
        .toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    schoolController.dispose();
    gradeController.dispose();
    addressController.dispose();

    for (var controller in activityControllers) {
      controller.dispose();
    }
    for (var controller in achievementTitleControllers) {
      controller.dispose();
    }
    for (var controller in achievementDescriptionControllers) {
      controller.dispose();
    }
    for (var controller in achievementDateControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  String getInitials() {
    final names = studentName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S';
  }

  XFile? _profileImage;
  XFile? get profileImage => _profileImage;
  

  Future pickProfileImage() async {
    ImagePicker _picker = await ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      _profileImage = image;
      notifyListeners();
    }
    notifyListeners();
  }

  void addActivity() {
    editableActivities.add('');
    activityControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeActivity(int index) {
    if (editableActivities.length > 1) {
      editableActivities.removeAt(index);
      activityControllers[index].dispose();
      activityControllers.removeAt(index);
      notifyListeners();
    }
  }

  void addAchievement() {
    editableAchievements.add({
      'title': '',
      'description': '',
      'date': '',
    });
    achievementTitleControllers.add(TextEditingController());
    achievementDescriptionControllers.add(TextEditingController());
    achievementDateControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeAchievement(int index) {
    if (editableAchievements.length > 1) {
      editableAchievements.removeAt(index);
      achievementTitleControllers[index].dispose();
      achievementTitleControllers.removeAt(index);
      achievementDescriptionControllers[index].dispose();
      achievementDescriptionControllers.removeAt(index);
      achievementDateControllers[index].dispose();
      achievementDateControllers.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    isSaving = true;
    notifyListeners();

    try {
      // Validate inputs
      if (nameController.text.trim().isEmpty) {
        _showError(context, 'Name cannot be empty');
        isSaving = false;
        notifyListeners();
        return;
      }

      if (phoneController.text.trim().isEmpty) {
        _showError(context, 'Phone number cannot be empty');
        isSaving = false;
        notifyListeners();
        return;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Make actual API call to save profile
      // Example:
      // await ApiService.updateProfile({
      //   'name': nameController.text,
      //   'phone': phoneController.text,
      //   'age': ageController.text,
      //   'school': schoolController.text,
      //   'grade': gradeController.text,
      //   'address': addressController.text,
      //   'activities': activityControllers.map((c) => c.text).toList(),
      //   'achievements': List.generate(editableAchievements.length, (i) => {
      //     'title': achievementTitleControllers[i].text,
      //     'description': achievementDescriptionControllers[i].text,
      //     'date': achievementDateControllers[i].text,
      //   }),
      // });

      isSaving = false;
      notifyListeners();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      isSaving = false;
      notifyListeners();
      _showError(context, 'Failed to update profile. Please try again.');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Personal Information
  final String studentName = '';
  final String studentEmail = '';
  final String studentPhone = '';
  final int age = 17;
  final String school = '';
  final String grade = '';
  final String address = '';
  final String profileImageUrl = ''; // Add image URL or asset path

  // Academic Information
  final String mentorName = '';
  final String counsellorName = '';
  final String currentProject = '';

  // Activities
  List<String> activities = [];

  // Achievements
 List<Map<String, String>> achievements = [];

  // Project Analytics
  final int totalProjects = 5;
  final int completedProjects = 0;
  final int ongoingProjects = 2;
  final double projectCompletionRate = 0.0;

  // Task Analytics
  final int totalTasks = 0;
  final int completedTasks = 0;
  final int pendingTasks = 0;
  final int overdueTasks = 0;
  final double taskCompletionRate = 0.0;
  // This Week Stats
  final int tasksCompletedThisWeek = 8;
  final int tasksThisWeek = 12;
  final double weeklyProductivity = 67.0;

  // Recent Projects
  final List<Map<String, dynamic>> recentProjects = [
    {
      'name': 'College Application Project',
      'progress': 0.75,
      'status': 'In Progress',
      'dueDate': 'Nov 15, 2025',
    },
    {
      'name': 'Scholarship Application',
      'progress': 0.45,
      'status': 'In Progress',
      'dueDate': 'Dec 1, 2025',
    },
    {
      'name': 'Personal Statement Review',
      'progress': 1.0,
      'status': 'Completed',
      'dueDate': 'Oct 20, 2025',
    },
  ];

  void editProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => StudentEditProfile()),
    );
    notifyListeners();
  }

  void viewProjectDetails(String projectName) {
    // Navigate to project details
    notifyListeners();
  }

  void viewTaskDetails() {
    // Navigate to tasks screen
    notifyListeners();
  }

  void contactMentor() {
    // Open chat or contact mentor
    notifyListeners();
  }

  void contactCounsellor() {
    // Open chat or contact counsellor
    notifyListeners();
  }

  //....................GET PROFILE API CALL....................//

  bool _studentProfileLoading = false;
  bool get studentProfileLoading => _studentProfileLoading;

  void setStudentProfileLoading(bool value) {
    _studentProfileLoading = value;
    notifyListeners();
  }

  ProfileModel? _studentProfile;
  ProfileModel? get studentProfile => _studentProfile;

  void getStudentProfileApiTap(BuildContext context){
    ConnectionDetector.connectCheck().then((value) {
      if(value) {
        getStudentProfileApiCall(context);
      } else {
        showToast("Please check your internet", type: toastType.error);
      }
    });
  }

  void initializeStudentProfileData (ProfileModel profile) {
    nameController.text = profile.data?.fullName ?? '';
    emailController.text = profile.data?.email ?? '';
    phoneController.text = profile.data?.phoneNumber ?? '';
    ageController.text = profile.data?.age?.toString() ?? '';
    addressController.text = profile.data?.location ?? "";
    schoolController.text = profile.data?.school ?? ""; 
    gradeController.text = profile.data?.cgpa ?? "";
    
    // Clear existing controllers
    for (var controller in activityControllers) {
      controller.dispose();
    }
    for (var controller in achievementTitleControllers) {
      controller.dispose();
    }
    for (var controller in achievementDescriptionControllers) {
      controller.dispose();
    }
    for (var controller in achievementDateControllers) {
      controller.dispose();
    }
    
    // Initialize activities
    activities = profile.data?.expertise != null ? List<String>.from(profile.data!.expertise!) : [];
    editableActivities = List.from(activities);
    activityControllers = editableActivities
        .map((activity) => TextEditingController(text: activity))
        .toList();
    
    // Initialize achievements
    achievements = profile.data?.achievements != null 
        ? profile.data!.achievements!.map((achievement) {
            return {
              'title': achievement.title ?? '',
              'description': achievement.description ?? '',
              'date': achievement.date ?? '',
            };
          }).toList()
        : [];
    editableAchievements = achievements.map((a) => Map<String, String>.from(a)).toList();
    achievementTitleControllers = editableAchievements
        .map((a) => TextEditingController(text: a['title']))
        .toList();
    achievementDescriptionControllers = editableAchievements
        .map((a) => TextEditingController(text: a['description']))
        .toList();
    achievementDateControllers = editableAchievements
        .map((a) => TextEditingController(text: a['date']))
        .toList();
    
    notifyListeners();
  }

  getStudentProfileApiCall (BuildContext context) {
    setStudentProfileLoading(true);
    try{
      DioClient.getProfile(
      onSuccess: (response) async {
        if(response.success == true){
        _studentProfile = await response;
        setStudentProfileLoading(false);
        notifyListeners();
        } else {
          showToast(response.message.toString(), type: toastType.error);
          setStudentProfileLoading(false);
          notifyListeners();
        }
      }, onError: (error) {
        showToast("Something went wrong", type: toastType.error);
        AppLogger.error(message: "error in get Student Profile: $error");
        setStudentProfileLoading(false);
        notifyListeners();
      });
    }catch(e) {
      AppLogger.error(message: "Exception in get Student Profile: ${e.toString()}");
      setStudentProfileLoading(false);
      notifyListeners();
    }
  }


  //...................Update Profile API.....................//
    bool _updateProfileLoading = false;
  bool get updateProfileLoading => _updateProfileLoading;

  void setUpdateProfileLoading(bool value) {
    _updateProfileLoading = value;
    notifyListeners();
  }


  void updateProfileApiTap(BuildContext context) {
    ConnectionDetector.connectCheck().then((value) {
        if(value){
          updateProfileApiCall(context);
        } else {
          showToast("Please check your internet", type: toastType.error);
        }
    });
  }

updateProfileApiCall (BuildContext context) {

    // Update activities from controllers
    List<String> updatedActivities = activityControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    // Update achievements from controllers
    List<Map<String, String>> updatedAchievements = List.generate(
      achievementTitleControllers.length,
      (index) => {
        'title': achievementTitleControllers[index].text.trim(),
        'description': achievementDescriptionControllers[index].text.trim(),
        'date': achievementDateControllers[index].text.trim(),
      },
    ).where((achievement) => 
        achievement['title']!.isNotEmpty || 
        achievement['description']!.isNotEmpty
    ).toList();

    // Prepare body data
    Map<String, dynamic> bodyMap = {
      "full_name" : nameController.text.trim(),
      "phone_number" : phoneController.text.trim(),
      "age" : ageController.text.trim(),
      "location" : addressController.text.trim(),
      "school" : schoolController.text.trim(),
      "cgpa" : gradeController.text.trim(),
      "expertise" : jsonEncode(updatedActivities),
      "achievements" : jsonEncode(updatedAchievements),
    };

    // Only add profile_photo if a new image was selected
    if(_profileImage != null) {
      MultipartFile profileImageFile = MultipartFile.fromFileSync(
        _profileImage!.path,
        filename: _profileImage!.name,
      );
      bodyMap["profile_photo"] = profileImageFile;
    }

    FormData body = FormData.fromMap(bodyMap);
    setUpdateProfileLoading(true);
    try{
      DioClient.updateProfile(
      body: body, 
      onSuccess: (response) {
        if(response.success == true){
          getStudentProfileApiTap(context);
          Navigator.of(context).pop();
          showToast("Profile updated successfully", type: toastType.success);
          setUpdateProfileLoading(false);
          notifyListeners();
        } else {
          showToast("${response.message}", type: toastType.error);
          setUpdateProfileLoading(false);
          notifyListeners();
        }
        
      }, onError: (error) {
        setUpdateProfileLoading(false);
        showToast(error, type: toastType.error);
        AppLogger.debug(message: "updateProfileApiCall error: $error");
        notifyListeners();
      });
    }catch(e) {
      AppLogger.error(message: "Exception in update Student Profile: ${e.toString()}");
      showToast("Failed to update profile", type: toastType.error);
      setUpdateProfileLoading(false);
      notifyListeners();
    }
  }

}
