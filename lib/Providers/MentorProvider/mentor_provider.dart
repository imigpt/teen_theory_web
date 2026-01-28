import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/all_meeting_model.dart';
import 'package:teen_theory/Models/CommonModels/all_ticket_model.dart';
import 'package:teen_theory/Models/CommonModels/multi_participatemeeting_model.dart' as multi_participatemeeting_model;
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';

class MentorProvider with ChangeNotifier {
 //.....................UPLOAD RESOURCES SESSION...........................//

 File? _resourceFile;
  File? get resourceFile => _resourceFile;

  Future pickResourceFile() async {
    try{
      File? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
    ).then((result) {
      if (result != null && result.files.isNotEmpty) {
        return File(result.files.single.path!);
      }
      return null;
    });
    _resourceFile = pickedFile;
    notifyListeners();
    }catch(err){
      print("Error picking file: $err");
      notifyListeners();
    }
  }


//....................ALL TICKET API.......................//
bool _ticketLoading = false;
bool get ticketLoading => _ticketLoading;

void setTicketLoading(bool value) {
  _ticketLoading = value;
  notifyListeners();
}

AllTicketModel? _allTicketData;
AllTicketModel? get allTicketData => _allTicketData;



  void allTicketApiTap () {
    ConnectionDetector.connectCheck().then((value) {
        if(value) {
          allTicketApiCall();
        } else {
          showToast("Internet not available", type: toastType.error);
        }
    });
  }

  allTicketApiCall () {
    setTicketLoading(true);
    try{
      DioClient.allTicket(
      onSuccess: (response) {
        _allTicketData = response;
        setTicketLoading(false);
        notifyListeners();
      }, onError:(error) {
        AppLogger.error(message: "allTicketApiCall onError: $error");
        setTicketLoading(false);
        notifyListeners();
      });

    } catch(err){
      AppLogger.error(message: "allTicketApiCall Error: $err");
      setTicketLoading(false);
      notifyListeners();
    }
  }

  //.................ALL_MEETING API.....................//

  bool _allMeetingLoading = false;
  bool get allMeetingLoading => _allMeetingLoading;

  void setAllMeetingLoading(bool value) {
    _allMeetingLoading = value;
    notifyListeners();
  }

  AllMeetingModel? _allMeetingData;
  AllMeetingModel? get allMeetingData => _allMeetingData;

  // Participant Meetings State
  multi_participatemeeting_model.ParticipateMeetingModel? _participantMeetingsData;
  bool _participantMeetingsLoading = false;
  String? _participantMeetingsError;

  // Participant Meetings Getters
  multi_participatemeeting_model.ParticipateMeetingModel? get participantMeetingsData => _participantMeetingsData;
  bool get participantMeetingsLoading => _participantMeetingsLoading;
  String? get participantMeetingsError => _participantMeetingsError;
  List<multi_participatemeeting_model.Datum> get participantMeetings => _participantMeetingsData?.data ?? [];

  void allMeetingApiTap () {
    ConnectionDetector.connectCheck().then((value) {
        if(value) {
          allMeetingApiCall();
        } else {
          showToast("No internet connection", type: toastType.error);
        }
    });
  }

  allMeetingApiCall () {
    setAllMeetingLoading(true);
    try{
      DioClient.allMeeting(
      onSuccess: (response) {
        _allMeetingData = response;
        setAllMeetingLoading(false);
        notifyListeners();
      }, onError: (error) {
        showToast("No internet connection", type: toastType.error);
        AppLogger.error(message: "allMeetingApiCall onError: $error");
        setAllMeetingLoading(false);
        notifyListeners();
      });
    }catch(err) {
      AppLogger.error(message: "allMeetingApiCall Error: $err");
      setAllMeetingLoading(false);
      notifyListeners();
    }
  }

  // Fetch Participant Meetings
  void fetchParticipantMeetingsTap() {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        fetchParticipantMeetings();
      } else {
        _participantMeetingsError = "Internet not available";
        notifyListeners();
      }
    });
  }

  Future<void> fetchParticipantMeetings({bool forceRefresh = false}) async {
    if (_participantMeetingsLoading) return;

    _participantMeetingsLoading = true;
    _participantMeetingsError = null;
    notifyListeners();

    try {
      multi_participatemeeting_model.ParticipateMeetingModel? apiResponse;
      String? apiError;

      await DioClient.getMyParticipantMeetings(
        onSuccess: (response) => apiResponse = response,
        onError: (error) => apiError = error,
      );

      if (apiError != null) throw Exception(apiError);
      _participantMeetingsData = apiResponse;
    } catch (e, stack) {
      _participantMeetingsError = e.toString();
      AppLogger.error(message: 'MentorProvider fetchParticipantMeetings error: $e\n$stack');
    } finally {
      _participantMeetingsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshParticipantMeetings() => fetchParticipantMeetings(forceRefresh: true);

  //....................CREATE MENTOR MEETING API.......................//

  bool _createMentorMeetingLoading = false;
  bool get createMentorMeetingLoading => _createMentorMeetingLoading;

  void setCreateMentorMeetingLoading(bool value) {
    _createMentorMeetingLoading = value;
    notifyListeners();
  }

  void createMentorMeetingApiTap({
    required String meetingType,
    required String assignedStudents,
    required String dateTime,
    required String duration,
    required String purpose,
    required String meetingLink,
    required BuildContext context,
  }) {
    ConnectionDetector.connectCheck().then((value) {
      if (value) {
        createMentorMeetingApiCall(
          meetingType: meetingType,
          assignedStudents: assignedStudents,
          dateTime: dateTime,
          duration: duration,
          purpose: purpose,
          meetingLink: meetingLink,
          context: context,
        );
      } else {
        showToast("No internet connection", type: toastType.error);
      }
    });
  }

  createMentorMeetingApiCall({
    required String meetingType,
    required String assignedStudents,
    required String dateTime,
    required String duration,
    required String purpose,
    required String meetingLink,
    required BuildContext context,
  }) {
    setCreateMentorMeetingLoading(true);
    try {
      Map<String, dynamic> body = {
        "meeting_type": meetingType,
        "assigned_students": assignedStudents,
        "date_time": dateTime,
        "duration": duration,
        "purpose": purpose,
        "meeting_link": meetingLink,
      };

      DioClient.mentorMeetingLink(
        body: body,
        onSuccess: (response) {
          showToast("Meeting created successfully", type: toastType.success);
          setCreateMentorMeetingLoading(false);
          Navigator.pop(context);
          notifyListeners();
        },
        onError: (error) {
          showToast("Failed to create meeting", type: toastType.error);
          AppLogger.error(message: "createMentorMeetingApiCall onError: $error");
          setCreateMentorMeetingLoading(false);
          notifyListeners();
        },
      );
    } catch (err) {
      AppLogger.error(message: "createMentorMeetingApiCall Error: $err");
      setCreateMentorMeetingLoading(false);
      notifyListeners();
    }
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

    setApprovingMilestone(true, milestoneId);

    // Call API
    try {
      Map<String, dynamic> body = {
        "project_id": projectId,
        "milestone_id": milestoneId,
        "status": status,
      };
      
      await DioClient.approvedOrRejectApi(
        body: body,
        onSuccess: (_) {
          showToast(
            status == "approved" 
              ? "Milestone approved successfully" 
              : "Milestone rejected",
            type: toastType.success,
          );
          AppLogger.debug(message: "Milestone status updated successfully");
        },
        onError: (error) {
          showToast(
            error.isNotEmpty ? error : "Failed to update milestone status",
            type: toastType.error,
          );
        },
      );
    } catch (e) {
      showToast("Failed to update milestone status", type: toastType.error);
      AppLogger.error(message: "approveOrRejectMilestone exception: $e");
    } finally {
      setApprovingMilestone(false, null);
    }
  }

  //.....................MENTOR TICKET RESOLVE API.....................//

  TextEditingController commentController = TextEditingController();

  bool _ticketLoader = false;
  bool get ticketLoader => _ticketLoader;

  void setTicketLoader(bool value) {
    _ticketLoader = value;
    notifyListeners();
  }

  void ticketResolvedApiTap(BuildContext context,{required String ticket_id, required String status}) {
    ConnectionDetector.connectCheck().then((value) {
        if(value) {
          ticketResolvedApiCall(context,ticket_id, status);
        } else {
          showToast("Internet not available", type: toastType.error);
        }
    });
  }

  ticketResolvedApiCall(BuildContext context,String ticket_id, String status) {
    FormData body = FormData.fromMap({
      "status" : status,
      "message" : commentController.text,
    });
    setTicketLoader(true);
    try{
      DioClient.ticketStatusApi(
      ticket_id: ticket_id, 
      body: body, 
      onSuccess: (response) {
        showToast("Ticket send successfully", type: toastType.success);
        setTicketLoader(false);
        context.read<MentorProvider>().allTicketApiTap();
        notifyListeners();
      }, onError: (error) {
        AppLogger.error(message: "ticketResolvedApiCall onError: $error");
        setTicketLoader(false);
        notifyListeners();
      });
    }catch(err) {
      AppLogger.error(message: "ticketResolvedApiCall Error: $err");
      setTicketLoader(false);
      notifyListeners();
    }
  }

}