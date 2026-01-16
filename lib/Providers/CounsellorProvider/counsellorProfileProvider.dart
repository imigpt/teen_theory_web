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
    
}