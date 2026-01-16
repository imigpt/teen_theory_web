import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/all_meeting_model.dart';
import 'package:teen_theory/Models/CommonModels/all_ticket_model.dart';
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