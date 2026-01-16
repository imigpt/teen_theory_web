import 'package:flutter/material.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Models/StudentModels/student_meeting_model.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class StudentMeetingProvider extends ChangeNotifier {
  final List<Datum> _upcomingMeetings = [];
  final List<Datum> _pastMeetings = [];

  bool _isLoading = false;
  bool _hasFetched = false;
  String? _errorMessage;
  String? _studentEmail;

  List<Datum> get upcomingMeetings => List.unmodifiable(_upcomingMeetings);
  List<Datum> get pastMeetings => List.unmodifiable(_pastMeetings);
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;
  String? get errorMessage => _errorMessage;
  bool get hasData => _upcomingMeetings.isNotEmpty || _pastMeetings.isNotEmpty;

  Future<void> fetchMeetings({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final email = await _ensureStudentEmail();
      if (email == null || email.isEmpty) {
        throw Exception('Unable to determine student email.');
      }

      StudentMeetingModel? apiResponse;
      String? apiError;
      await DioClient.studentMeetingLinks(
        email: email,
        onSuccess: (response) => apiResponse = response,
        onError: (error) => apiError = error,
      );

      if (apiError != null) throw Exception(apiError);
      _splitMeetings(apiResponse?.data ?? []);
      _hasFetched = true;
    } catch (e, stack) {
      _errorMessage = e.toString();
      AppLogger.error(message: 'StudentMeetingProvider fetchMeetings error: $e\n$stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMeetings() => fetchMeetings(forceRefresh: true);

  Future<String?> _ensureStudentEmail() async {
    if (_studentEmail != null && _studentEmail!.isNotEmpty) {
      return _studentEmail;
    }

    final cached = await SharedPref.getStringValue(SharedPref.userEmail);
    if (cached.isNotEmpty) {
      _studentEmail = cached;
      return _studentEmail;
    }

    ProfileModel? profileModel;
    String? profileError;
    await DioClient.getProfile(
      onSuccess: (response) => profileModel = response,
      onError: (error) => profileError = error,
    );

    if (profileError != null) throw Exception(profileError);
    final email = profileModel?.data?.email;
    if (email != null && email.isNotEmpty) {
      _studentEmail = email;
      await SharedPref.setStringValue(SharedPref.userEmail, email);
      return _studentEmail;
    }

    return null;
  }

  void _splitMeetings(List<Datum> meetings) {
    final now = DateTime.now();
    final List<Datum> upcoming = [];
    final List<Datum> past = [];

    for (final meeting in meetings) {
      final date = _parseDate(meeting.dateTime);
      if (date == null) {
        final status = meeting.status?.toLowerCase() ?? '';
        if (status.contains('complete') || status.contains('cancel')) {
          past.add(meeting);
        } else {
          upcoming.add(meeting);
        }
        continue;
      }

      if (date.isAfter(now)) {
        upcoming.add(meeting);
      } else {
        past.add(meeting);
      }
    }

    upcoming.sort((a, b) => _compareDates(a.dateTime, b.dateTime));
    past.sort((a, b) => _compareDates(b.dateTime, a.dateTime));

    _upcomingMeetings
      ..clear()
      ..addAll(upcoming);
    _pastMeetings
      ..clear()
      ..addAll(past);
  }

  int _compareDates(String? first, String? second) {
    final firstDate = _parseDate(first) ?? DateTime.now();
    final secondDate = _parseDate(second) ?? DateTime.now();
    return firstDate.compareTo(secondDate);
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value).toLocal();
    } catch (_) {
      return null;
    }
  }

  void requestMeeting() {
   requestMeetingApiTap();
    notifyListeners();
  }

  void rescheduleMeeting(String meetingTitle) {
    // TODO: Implement reschedule meeting flow when API is available.
    notifyListeners();
  }

  void cancelMeeting(String meetingTitle) {
    // TODO: Implement cancel meeting flow when API is available.
    notifyListeners();
  }

  void viewAllPastMeetings() {
    // TODO: Navigate to dedicated past meetings view when screen exists.
    notifyListeners();
  }

  //..................REQUEST MEETING..................//

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String? _selectedProject;
  String? get selectedProject => _selectedProject;
  set selectedProject(String? value) {
    _selectedProject = value;
    notifyListeners();
  }

 String? _selectedMentor;
  String? get selectedMentor => _selectedMentor;
  set selectedMentor(String? value) {
    _selectedMentor = value;
    notifyListeners();
  }

 String? _selectedCounsellor;
  String? get selectedCounsellor => _selectedCounsellor;
  set selectedCounsellor(String? value) {
    _selectedCounsellor = value;
    notifyListeners();
  }

  void requestMeetingApiTap() {
    ConnectionDetector.connectCheck().then((value) {
        if(value) {
          requestMeetingApiCall();
        } else {
          showToast("Internet not available", type: toastType.error);
        }
    });
  }

  requestMeetingApiCall() {
    Map<String, dynamic> body = {
      "project_name" : _selectedProject ?? "",
      "title" : titleController.text,
      "mentor" : _selectedMentor ?? "",
      "counsellor" :_selectedCounsellor ?? "",
      "message" : messageController.text,
    };
    try{
      DioClient.requestMeetingApi(
      body: body, 
      onSuccess: (response) {
        showToast("Meeting request send successfully", type: toastType.success);
      }, onError: (error) {
        
      });
    }catch(e){
      AppLogger.error(message: 'StudentMeetingProvider requestMeetingApiCall error: $e');
    }
  }

}
