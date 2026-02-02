import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Models/MentorModels/mentor_project_model.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';

class MentorProfileProvider with ChangeNotifier {
  ProfileModel? _mentorProfileData;
  ProfileModel? get mentorProfileData => _mentorProfileData;

  bool _isProfileLoading = false;
  bool get isProfileLoading => _isProfileLoading;

  void setProfileLoading(bool value) {
    _isProfileLoading = value;
    notifyListeners();
  }

  // Edit Profile Controllers and State
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController aboutMeCtrl = TextEditingController();
  final TextEditingController expertiseInputCtrl = TextEditingController();

  XFile? _profileImage;
  XFile? get profileImage => _profileImage;

  List<String> _expertise = [];
  List<String> get expertise => _expertise;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  // Shift Time Fields
  TimeOfDay? _startShiftTime;
  TimeOfDay? get startShiftTime => _startShiftTime;

  TimeOfDay? _endShiftTime;
  TimeOfDay? get endShiftTime => _endShiftTime;

  final ImagePicker _picker = ImagePicker();

  void setUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  // Initialize edit form with current profile data
  void initializeEditForm() {
    if (_mentorProfileData?.data != null) {
      final data = _mentorProfileData!.data!;
      fullNameCtrl.text = data.fullName ?? '';
      phoneCtrl.text = data.phoneNumber ?? '';
      aboutMeCtrl.text = data.aboutMe?.toString() ?? '';
      _expertise = List<String>.from(data.expertise ?? []);
      // Parse shift times from API
      _startShiftTime = _parseTimeString(data.start_shift_time) ?? TimeOfDay(hour: 9, minute: 0);
      _endShiftTime = _parseTimeString(data.end_shift_time) ?? TimeOfDay(hour: 17, minute: 0);
      notifyListeners();
    }
  }

  // Parse time string from API (e.g., "12:47 PM") to TimeOfDay
  TimeOfDay? _parseTimeString(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      final parts = timeString.split(' ');
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

  // Pick profile image
  Future<void> pickProfileImage(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _profileImage = image;
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  // Add expertise chip
  void addExpertise(String value) {
    if (value.trim().isNotEmpty && !_expertise.contains(value.trim())) {
      _expertise.add(value.trim());
      expertiseInputCtrl.clear();
      notifyListeners();
    }
  }

  // Remove expertise chip
  void removeExpertise(int index) {
    if (index >= 0 && index < _expertise.length) {
      _expertise.removeAt(index);
      notifyListeners();
    }
  }

  // Set start shift time
  void setStartShiftTime(TimeOfDay time) {
    _startShiftTime = time;
    notifyListeners();
  }

  // Set end shift time
  void setEndShiftTime(TimeOfDay time) {
    _endShiftTime = time;
    notifyListeners();
  }

  // Format TimeOfDay to string for display (24-hour format)
  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Not set';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Format TimeOfDay to API format (12-hour with AM/PM)
  String _formatTimeForApi(TimeOfDay time) {
    int hour = time.hour;
    String period = 'AM';
    
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;
    
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  // Update shift time via API
  Future<void> updateShiftTimeApiTap(BuildContext context) async {
    final hasConnection = await ConnectionDetector.connectCheck();
    if (hasConnection) {
      await updateShiftTimeApiCall(context);
    } else {
      showToast("No Internet Connection", type: toastType.error);
    }
  }

  Future<void> updateShiftTimeApiCall(BuildContext context) async {
    if (_startShiftTime == null || _endShiftTime == null) {
      showToast("Please select both start and end shift times", type: toastType.error);
      return;
    }

    setUpdating(true);
    try {
      Map<String, dynamic> body = {
        "start_shift_time": _formatTimeForApi(_startShiftTime!),
        "end_shift_time": _formatTimeForApi(_endShiftTime!),
      };

      await DioClient.updateShiftTime(
        body: body,
        onSuccess: (response) {
          if (response.success == true) {
            _mentorProfileData = response;
            showToast("Shift time updated successfully", type: toastType.success);
            setUpdating(false);
            notifyListeners();
          } else {
            showToast(response.message ?? "Failed to update shift time", type: toastType.error);
            setUpdating(false);
            notifyListeners();
          }
        },
        onError: (error) {
          AppLogger.error(message: "updateShiftTimeApiCall onError: $error");
          showToast("Failed to update shift time", type: toastType.error);
          setUpdating(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "updateShiftTimeApiCall Error: $e");
      showToast("Failed to update shift time", type: toastType.error);
      setUpdating(false);
      notifyListeners();
    }
  }

  // Clear edit form
  void clearEditForm() {
    fullNameCtrl.clear();
    phoneCtrl.clear();
    aboutMeCtrl.clear();
    expertiseInputCtrl.clear();
    _profileImage = null;
    _expertise.clear();
    _startShiftTime = null;
    _endShiftTime = null;
    notifyListeners();
  }

  Future<void> MentorProfileApiTap(BuildContext context) async {
    final hasConnection = await ConnectionDetector.connectCheck();
    if (hasConnection) {
      await mentorProfileApiCall();
    } else {
      showToast("No Internet Connection", type: toastType.error);
    }
  }

  Future<void> mentorProfileApiCall() async {
    setProfileLoading(true);
    try {
      await DioClient.getProfile(
        onSuccess: (response) {
          _mentorProfileData = response;
          setProfileLoading(false);
          notifyListeners();
        },
        onError: (error) {
          AppLogger.error(message: 'mentor profile api error $error');
          setProfileLoading(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: 'error in mentor profile api call $e');
      setProfileLoading(false);
      notifyListeners();
    }
  }


void mentorProfileUpdateApiTap(BuildContext context) {
    ConnectionDetector.connectCheck().then((value) async {
      if (value) {
        await mentorProfileUpdateApiCall(context);
      } else {
        showToast("No internet connection", type: toastType.error);
      }
    });
  }

  Future<void> mentorProfileUpdateApiCall(BuildContext context) async {
    setUpdating(true);

    try {
      // Build FormData with basic fields
      FormData body = FormData.fromMap({
        "full_name": fullNameCtrl.text.trim(),
        "phone_number": phoneCtrl.text.trim(),
        "about_me": aboutMeCtrl.text.trim(),
        "expertise": jsonEncode(_expertise), // Send as list directly - Dio will handle it
      });

      // Add profile photo if selected
      if (_profileImage != null && _profileImage!.path.isNotEmpty) {
        body.files.add(
          MapEntry(
            "profile_photo",
            await MultipartFile.fromFile(
              _profileImage!.path,
              filename: _profileImage!.name,
            ),
          ),
        );
      }

      // Debug print to check what's being sent
      print("Expertise being sent: $_expertise");
      print("Expertise length: ${_expertise.length}");

      DioClient.updateProfile(
        body: body,
        onSuccess: (response) {
          if (response.success == true) {
            setUpdating(false);
            showToast("Profile updated successfully", type: toastType.success);
            // Refresh profile data
            MentorProfileApiTap(context);
            Navigator.of(context).pop();
            notifyListeners();
          } else {
            showToast(response.message ?? "Failed to update profile",
                type: toastType.error);
            setUpdating(false);
            notifyListeners();
          }
        },
        onError: (error) {
          AppLogger.error(message: "mentorProfileUpdateApiCall onError: $error");
          showToast("Failed to update profile", type: toastType.error);
          setUpdating(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "mentorProfileUpdateApiCall Error: $e");
      showToast("Failed to update profile", type: toastType.error);
      setUpdating(false);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    aboutMeCtrl.dispose();
    expertiseInputCtrl.dispose();
    super.dispose();
  }

  //....................MENTOR PROJECTS API........................//

  bool _mentorProjectLoading = false;
  bool get mentorProjectLoading => _mentorProjectLoading;

  void setMentorProjectLoading(bool value) {
    _mentorProjectLoading = value;
    notifyListeners();
  }

  MentorProjectModel? _mentorProjectData;
  MentorProjectModel? get mentorProjectData => _mentorProjectData;

  void mentorProjectApiTap(BuildContext context, {required String email}) {
    ConnectionDetector.connectCheck().then((value) {
        if(value){
          mentorProjectApiCall(context, email);
        } else {
          showToast("Please check your internet", type: toastType.error);
        }
    });
  }

  mentorProjectApiCall(BuildContext context, String email) {
    // Validate email parameter
    if (email.isEmpty) {
      AppLogger.error(message: 'mentor project api call - email is empty');
      setMentorProjectLoading(false);
      return;
    }
    
    setMentorProjectLoading(true);
    try{
      DioClient.mentorAssigned(
      email: email, 
      onSuccess: (response) async {
        if(response.success == true){
        _mentorProjectData = await response;
        setMentorProjectLoading(false);
        notifyListeners();
        } else {
          showToast(response.message ?? "Failed to fetch mentor projects", type: toastType.error);
          setMentorProjectLoading(false);
        }
      }, onError: (error) {
        AppLogger.error(message: 'mentor project api error $error');
        setMentorProjectLoading(false);
        notifyListeners();
      });
    }catch(e) {
      AppLogger.error(message: 'error in mentor project api call $e');
      setMentorProjectLoading(false);
      notifyListeners();
    }
  }
}
