import 'package:flutter/material.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Models/CommonModels/all_meeting_model.dart';
import 'package:teen_theory/Models/CommonModels/multi_participatemeeting_model.dart' as multi_participatemeeting_model;
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
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
      if (value) {
        getParentProfileApiCall();
      } else {
        showToast("Internet is not available", type: toastType.error);
      }
    });
  }

  getParentProfileApiCall() async {
    try {
      _isLoading = true;
      notifyListeners();

      DioClient.getProfile(
        onSuccess: (response) {
          _parentProfileData = response;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          showToast(error.toString(), type: toastType.error);
          notifyListeners();
        },
      );
    } catch (err) {
      _isLoading = false;
      showToast(err.toString(), type: toastType.error);
      notifyListeners();
    }
  }

  // ==================== MEETINGS LOGIC START ====================
  bool _meetingsLoading = false;
  bool get meetingsLoading => _meetingsLoading;

  AllMeetingModel? _allMeetingsData;
  AllMeetingModel? get allMeetingsData => _allMeetingsData;

  // Participant meetings state
  List<multi_participatemeeting_model.Datum> _participantMeetingsData = [];
  bool _participantMeetingsLoading = false;
  String? _participantMeetingsError;

  List<multi_participatemeeting_model.Datum> get participantMeetings => _participantMeetingsData;
  bool get participantMeetingsLoading => _participantMeetingsLoading;
  String? get participantMeetingsError => _participantMeetingsError;

  void fetchMeetingsApiTap() {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        fetchMeetingsApiCall();
      } else {
        showToast("Internet is not available", type: toastType.error);
      }
    });
  }

  fetchMeetingsApiCall() async {
    try {
      _meetingsLoading = true;
      notifyListeners();

      DioClient.allMeeting(
        onSuccess: (response) {
          _allMeetingsData = response;
          _meetingsLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _meetingsLoading = false;
          AppLogger.error(message: "fetchMeetingsApiCall error: $error");
          notifyListeners();
        },
      );
    } catch (err) {
      _meetingsLoading = false;
      AppLogger.error(message: "fetchMeetingsApiCall error: $err");
      notifyListeners();
    }
  }

  // Participant meetings methods
  void fetchParticipantMeetingsTap() {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        fetchParticipantMeetings();
      } else {
        showToast("Internet is not available", type: toastType.error);
      }
    });
  }

  Future<void> fetchParticipantMeetings() async {
    try {
      _participantMeetingsLoading = true;
      _participantMeetingsError = null;
      notifyListeners();

      DioClient.getMyParticipantMeetings(
        onSuccess: (response) {
          _participantMeetingsData = response.data ?? [];
          _participantMeetingsLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _participantMeetingsLoading = false;
          _participantMeetingsError = error.toString();
          AppLogger.error(message: "fetchParticipantMeetings error: $error");
          notifyListeners();
        },
      );
    } catch (err) {
      _participantMeetingsLoading = false;
      _participantMeetingsError = err.toString();
      AppLogger.error(message: "fetchParticipantMeetings error: $err");
      notifyListeners();
    }
  }

  Future<void> refreshParticipantMeetings() async {
    await fetchParticipantMeetings();
  }

  // ==================== MEETINGS LOGIC END ====================
}
