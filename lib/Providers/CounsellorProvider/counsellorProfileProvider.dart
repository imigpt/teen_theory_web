import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';

class  Counsellorprofileprovider with ChangeNotifier {

  bool _isBtnLoading = false;
  bool get isBtnLoading => _isBtnLoading;

  void setBtnLoading(bool value){
    _isBtnLoading = value;
    notifyListeners();
  }

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController roleCtrl = TextEditingController();
  final TextEditingController bioCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController availabilityDaysCtrl = TextEditingController();
  final TextEditingController availabilityTimeCtrl = TextEditingController();

  List<String> achievements = [];

  XFile? _profileImage;
  XFile? get profileImage => _profileImage;

  String? _profileImageUrl;
  String? get profileImageUrl => _profileImageUrl;

  // Shift Time Fields
  TimeOfDay? _startShiftTime;
  TimeOfDay? get startShiftTime => _startShiftTime;

  TimeOfDay? _endShiftTime;
  TimeOfDay? get endShiftTime => _endShiftTime;

  Future pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _profileImage = image;
        _profileImageUrl = null; // Clear URL when new image is picked
        notifyListeners();
      }
    } catch (e) {
      AppLogger.debug(message: "pickProfileImage error: $e");
    }
  }

  void disposeControllers() {
    nameCtrl.dispose();
    roleCtrl.dispose();
    bioCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    availabilityDaysCtrl.dispose();
    availabilityTimeCtrl.dispose();
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


  
    void inputDataFromApi(ProfileModel profile) {
      nameCtrl.text = profile.data?.fullName ?? '';
      roleCtrl.text = profile.data?.userRole ?? '';
      bioCtrl.text = profile.data?.aboutMe ?? '';
      _profileImageUrl = profile.data?.profilePhoto != null 
          ? "${Apis.baseUrl}${profile.data!.profilePhoto}" 
          : null;
      _profileImage = null; // Clear local image when loading from API
      emailCtrl.text = profile.data?.email ?? '';
      phoneCtrl.text = profile.data?.phoneNumber ?? '';
      achievements = profile.data?.achievements?.map((a) => a.title ?? '').where((s) => s.isNotEmpty).toList() ?? [];
      // Parse shift times from API
      _startShiftTime = _parseTimeString(profile.data?.start_shift_time) ?? TimeOfDay(hour: 9, minute: 0);
      _endShiftTime = _parseTimeString(profile.data?.end_shift_time) ?? TimeOfDay(hour: 17, minute: 0);
      notifyListeners();
    }


  void updateProfileApiTap(BuildContext context) {
    ConnectionDetector.connectCheck().then((value) {
      if(value) {
        updateProfileApiCall(context);
      } else {
        showToast("Please check your internet", type: toastType.error);
      }
    });
  }

  updateProfileApiCall (BuildContext context) async {
    print("Achievement: ${achievements}");
    MultipartFile? _profileImageFile;

    if(_profileImage != null) {
      _profileImageFile = await MultipartFile.fromFile(
        _profileImage!.path,
        filename: _profileImage!.name,
      );
    }

    // Convert string list to Achievement format for API
    List<Map<String, String>> achievementsList = achievements.map((title) => {
      'title': title,
      'description': '',
      'date': '',
    }).toList();

    Map<String, dynamic> formMap = {
      if(_profileImageFile != null) "profile_photo" : _profileImageFile,
      "full_name": nameCtrl.text,
      "about_me": bioCtrl.text,
      "phone_number": phoneCtrl.text,
      "achievements": jsonEncode(achievementsList),
    };

    FormData body = FormData.fromMap(formMap);
    
    AppLogger.debug(message: "FormData fields: ${body.fields}");
    AppLogger.debug(message: "Achievements JSON: ${jsonEncode(achievements)}");
    setBtnLoading(true);

    try {
      DioClient.updateProfile(
      body: body, 
      onSuccess: (response) {
        if(response.success == true){
        context.read<AuthProvider>().getProfileApiCallAgain(context);
        Navigator.of(context).pop();
        showToast("Profile updated successfully", type: toastType.success);
        setBtnLoading(false);
        notifyListeners();
        } else {
          showToast("${response.message}", type: toastType.error);
          setBtnLoading(false);
          notifyListeners();
        }
      }, onError: (error) {
        AppLogger.debug(message: "updateProfileApiCall error: $error");
        setBtnLoading(false);
        notifyListeners();
      });

    } catch(e) {
      AppLogger.debug(message: "updateProfileApiCall error: $e");
    }
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

    setBtnLoading(true);
    try {
      Map<String, dynamic> body = {
        "start_shift_time": _formatTimeForApi(_startShiftTime!),
        "end_shift_time": _formatTimeForApi(_endShiftTime!),
      };

      await DioClient.updateShiftTime(
        body: body,
        onSuccess: (response) {
          if (response.success == true) {
            showToast("Shift time updated successfully", type: toastType.success);
            context.read<AuthProvider>().getProfileApiCallAgain(context);
            setBtnLoading(false);
            notifyListeners();
          } else {
            showToast(response.message ?? "Failed to update shift time", type: toastType.error);
            setBtnLoading(false);
            notifyListeners();
          }
        },
        onError: (error) {
          AppLogger.error(message: "updateShiftTimeApiCall onError: $error");
          showToast("Failed to update shift time", type: toastType.error);
          setBtnLoading(false);
          notifyListeners();
        },
      );
    } catch (e) {
      AppLogger.error(message: "updateShiftTimeApiCall Error: $e");
      showToast("Failed to update shift time", type: toastType.error);
      setBtnLoading(false);
      notifyListeners();
    }
  }
    
}