import 'package:flutter/material.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';

class ParentDashProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
  // Note: View progress data will be added from API in future
  // ==================== VIEW PROGRESS LOGIC END ====================

  ProfileModel? _parentProfileData;
  ProfileModel? get parentProfileData => _parentProfileData;

  void getParentProfileApiTap() {
    ConnectionDetector.connectCheck().then((value) {
        if(value) {
          getParentProfileApiCall();
        } else {
          showToast("Internet is not available", type: toastType.error);
        }
    });
  } 

  getParentProfileApiCall() async {
    try{
      _isLoading = true;
      notifyListeners();
      
      DioClient.getProfile(
      onSuccess: (response) {
        _parentProfileData = response;
        _isLoading = false;
        notifyListeners();
      }, onError: (error) {
        _isLoading = false;
        showToast(error.toString(), type: toastType.error);
        notifyListeners();
      });

    }catch(err) {
      _isLoading = false;
      showToast(err.toString(), type: toastType.error);
      notifyListeners();
    }
  }
}
