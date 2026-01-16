import 'package:dio/dio.dart';
import 'package:teen_theory/Models/AuthModels/user_login_model.dart';
import 'package:teen_theory/Models/CommonModels/all_counsellor_model.dart';
import 'package:teen_theory/Models/CommonModels/all_meeting_model.dart';
import 'package:teen_theory/Models/CommonModels/all_mentor_model.dart';
import 'package:teen_theory/Models/CommonModels/all_student_model.dart';
import 'package:teen_theory/Models/CommonModels/all_ticket_model.dart';
import 'package:teen_theory/Models/CommonModels/chat_messages_model.dart';
import 'package:teen_theory/Models/CommonModels/conversion_id_model.dart';
import 'package:teen_theory/Models/CommonModels/filter_requestmeeting_model.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Models/CommonModels/project_chat_model.dart';
import 'package:teen_theory/Models/CommonModels/user_meeting_model.dart';
import 'package:teen_theory/Models/CounsellorModels/all_my_project_model.dart';
import 'package:teen_theory/Models/CounsellorModels/counsellor_meeting_model.dart';
import 'package:teen_theory/Models/MentorModels/mentor_project_model.dart';
import 'package:teen_theory/Models/StudentModels/student_meeting_model.dart';
import 'package:teen_theory/Models/StudentModels/student_noti_model.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Apis.baseUrl,
      connectTimeout: Duration(seconds: 10000000),
      receiveTimeout: Duration(seconds: 10000000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }
    ),
  );

  // Helper method to get headers with token
  static Future<Map<String, String>> _getAuthHeaders() async {
    String? token = await SharedPref.getStringValue(SharedPref.accessToken);
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

 static Future<UserLoginModel> userLogin({
    required dynamic body,
    required Function(UserLoginModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      Response response = await dio.post(Apis.login, data: body);
      AppLogger.debug(message: "userLogin response: $response");
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: ${token}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response indicates failure
        
        UserLoginModel userLoginModel = UserLoginModel.fromJson(response.data);
        onSuccess(userLoginModel);
        return userLoginModel;
      
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    }  catch (e) {
      onError(e.toString());
      rethrow;
    }
  }

 
  static Future<ProfileModel> getProfile({
    required Function(ProfileModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      Map<String, String> headers = await _getAuthHeaders();
      Response response = await dio.get(
        Apis.profile,
        options: Options(headers: headers),
      );
      AppLogger.debug(message: "getProfile response: $response");
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.profile}");
      AppLogger.debug(message: "Token: $token");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response indicates failure

        ProfileModel profileModel = ProfileModel.fromJson(response.data);
        onSuccess(profileModel);
        return profileModel;

      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    }  catch (e) {
      onError(e.toString());
      rethrow;
    }
  }

  static Future<ProfileModel> updateProfile({
    required FormData body,
    required Function(ProfileModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Update Profile Token: $token");
      AppLogger.debug(message: "Update Profile Body: ${body.fields}");
      
      Response response = await dio.put(
        Apis.updateProfile,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically with boundary
          },
        ),
      );
      AppLogger.debug(message: "API: ${Apis.updateProfile}");
      AppLogger.debug(message: "Token: $token");
      AppLogger.debug(message: "updateProfile response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response indicates failure

        ProfileModel profileModel = ProfileModel.fromJson(response.data);
        onSuccess(profileModel);
        return profileModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      String errorMsg = "Update profile failed";
      
      if (e.response != null) {
        AppLogger.error(message: "updateProfile DioException response: ${e.response?.data}");
        AppLogger.error(message: "updateProfile DioException statusCode: ${e.response?.statusCode}");
        
        // Try to extract meaningful error message from response
        if (e.response?.data != null) {
          if (e.response?.data is Map) {
            errorMsg = e.response?.data['message'] ?? errorMsg;
            
            // Check for validation errors
            if (e.response?.data['errors'] != null) {
              Map<String, dynamic> errors = e.response?.data['errors'];
              errorMsg = errors.values.first.toString();
            }
          }
        }
      }
      
      AppLogger.error(message: "updateProfile error: $e");
      onError(errorMsg);
      rethrow;
    } catch (e) {
      AppLogger.error(message: "updateProfile error: $e");
      onError(e.toString());
      rethrow;
    }
  }


//.........................CREATE PROJECTS...........................//
  static Future<dynamic> createProject({
    required FormData body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Create Project Token: $token");
      
      Response response = await dio.post(
        Apis.createProject,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "createProject response: $response");
      AppLogger.debug(message: "API: ${Apis.createProject}");
      AppLogger.debug(message: "Token: $token");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "createProject error: $e");
      onError(e.toString());
      rethrow;
    }
  }


  //.........................GET ALL STUDENTS...........................//
   static Future<AllStudentModel> getAllStudents({
    required Function(AllStudentModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      Map<String, String> headers = await _getAuthHeaders();
      AppLogger.debug(message: "Calling API: ${Apis.allStudents}");
      Response response = await dio.get(
        Apis.allStudents,
        options: Options(headers: headers),
      );
      AppLogger.debug(message: "allStudent response status: ${response.statusCode}");
      AppLogger.debug(message: "allStudent response data: ${response.data}");
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: ${token}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response indicates failure

        AllStudentModel allStudentModel = AllStudentModel.fromJson(response.data);
        onSuccess(allStudentModel);
        return allStudentModel;

      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    }  catch (e) {
      onError(e.toString());
      rethrow;
    }
  }
 

 static Future<AllMentorModel> getAllMentors({
    required Function(AllMentorModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      Map<String, String> headers = await _getAuthHeaders();
      AppLogger.debug(message: "Calling API: ${Apis.allMentors}");
      Response response = await dio.get(
        Apis.allMentors,
        options: Options(headers: headers),
      );
      AppLogger.debug(message: "allMentor response status: ${response.statusCode}");
      AppLogger.debug(message: "allMentor response data: ${response.data}");
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: ${token}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response indicates failure

        AllMentorModel allMentorModel = AllMentorModel.fromJson(response.data);
        onSuccess(allMentorModel);
        return allMentorModel;

      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    }  catch (e) {
      onError(e.toString());
      rethrow;
    }
  }

   static Future<AllMyProjectModel> myProduct({
    required Function(AllMyProjectModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      Map<String, String> headers = await _getAuthHeaders();
      AppLogger.debug(message: "Calling API: ${Apis.myProjects}");
      Response response = await dio.get(
        Apis.myProjects,
        options: Options(headers: headers),
      );
      AppLogger.debug(message: "myProjects response status: ${response.statusCode}");
      AppLogger.debug(message: "myProjects response data: ${response.data}");
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: ${token}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response indicates failure

        AllMyProjectModel allMyProjectModel = AllMyProjectModel.fromJson(response.data);
        onSuccess(allMyProjectModel);
        return allMyProjectModel;

      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    }  catch (e) {
      onError(e.toString());
      rethrow;
    }
  }

  //..................CREATED TICKET...........................//

    static Future<dynamic> createTicket({
    required FormData body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Create Ticket Token: $token");
      
      Response response = await dio.post(
        Apis.createTicket,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "createProject error: $e");
      onError(e.toString());
      rethrow;
    }
  }


  // Complete Task API................
  
    static Future<dynamic> completeTaskApi({
    required FormData body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Complete Task Token: $token");
      
      Response response = await dio.put(
        Apis.completedTaskApi,
        data: body,
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer $token',
        //     // Don't set Content-Type for FormData, Dio will set it automatically
        //   },
        // ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "completeTaskApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }

    static Future<dynamic> createMeetingLink({
    required dynamic body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Create Meeting Link Token: $token");
      
      Response response = await dio.post(
        Apis.meetingLinkApi,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "createMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //....................user meeting link.........................//



    static Future<UserMeetingModel> filteredMeetingLink({
    required Function(UserMeetingModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "userMeeting Link Token: $token");
      
      Response response = await dio.get(
        Apis.userMeetingLink,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userMeetingModel = UserMeetingModel.fromJson(response.data);
        onSuccess(userMeetingModel);
        return userMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //....................mentor project api.........................//

    static Future<MentorProjectModel> mentorAssigned({
    required String email,
    required Function(MentorProjectModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "mentorAssigned Token: $token");
      
      Response response = await dio.get(
        "${Apis.mentorProjectApi}?email=$email",
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer $token',
        //     // Don't set Content-Type for FormData, Dio will set it automatically
        //   },
        // ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final mentorProjectModel = MentorProjectModel.fromJson(response.data);
        onSuccess(mentorProjectModel);
        return mentorProjectModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }


//....................All_Ticket_API.......................//

  static Future<AllTicketModel> allTicket({
    required Function(AllTicketModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.get(
        Apis.allTicketsApi,
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer $token',
        //     // Don't set Content-Type for FormData, Dio will set it automatically
        //   },
        // ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final allTicketModel = AllTicketModel.fromJson(response.data);
        onSuccess(allTicketModel);
        return allTicketModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //....................ALL MEETING API......................//

   static Future<AllMeetingModel> allMeeting({
    required Function(AllMeetingModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.get(
        Apis.allMeetingApi,
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer $token',
        //     // Don't set Content-Type for FormData, Dio will set it automatically
        //   },
        // ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final allMeetingModel = AllMeetingModel.fromJson(response.data);
        onSuccess(allMeetingModel);
        return allMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //...................CREATE MENTOR MEETING LINK..........................//

  static Future<void> mentorMeetingLink({
    required Map<String, dynamic> body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.post(
        Apis.mentorMeetingApi,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final allMeetingModel = response.data;
        onSuccess(allMeetingModel);
        return allMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //..................GET STUDENT MEETING LINKs............................//

  static Future<StudentMeetingModel> studentMeetingLinks({
    required String email,
    required Function(StudentMeetingModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");

      Response response = await dio.get(
        "${Apis.studentMeetingApi}?email=$email",
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer $token',
        //     // Don't set Content-Type for FormData, Dio will set it automatically
        //   },
        // ),
      );
      AppLogger.debug(message: "response: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final studentMeetingModel = StudentMeetingModel.fromJson(response.data);
        onSuccess(studentMeetingModel);
        return studentMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }


  //......................STUDENT NOTIFICATION SCREEN API......................//

  static Future<StudentNotificationModel> studentNotificationApi({
    required Function(StudentNotificationModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");

      Response response = await dio.get(
        Apis.studentNotificationScreenApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final studentNotificationModel = StudentNotificationModel.fromJson(response.data);
        onSuccess(studentNotificationModel);
        return studentNotificationModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }


  //................COMPLETE PROJECT API.....................//

  static Future<void> projectCompleteApi({
    required Map<String, dynamic> body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.put(
        Apis.projectCompleteApi,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final allMeetingModel = response.data;
        onSuccess(allMeetingModel);
        return allMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //................APPROVED OR REJECT TASK API.....................//
    static Future<dynamic> approvedOrRejectApi({
    required dynamic body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.put(
        Apis.approvedOrRejectTaskApi,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "approvedOrRejectApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }


  //........................PROJECT CHAT API........................//

  static Future<ProjectChatModel> projectChatApi({
    required int project_id,
    required Function(ProjectChatModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");

      Response response = await dio.get(
        "${Apis.projectChatApi}/$project_id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );

      AppLogger.debug(message: "API: ${Apis.projectChatApi}/$project_id");
      AppLogger.debug(message: "Token: $token");
      AppLogger.debug(message: "response: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final projectChatModel = ProjectChatModel.fromJson(response.data);
        onSuccess(projectChatModel);
        return projectChatModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //....................Chat Send API.........................//
    static Future<dynamic> chatSendApi({
    required dynamic body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.chatSendApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.post(
        Apis.chatSendApi,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "chatSendApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //.........................MESSAGES API TAP...........................//

    static Future<ChatMessagesModel> chatMessagesApi({
    required String conversion_id,
    // required int project_id,
    required Function(ChatMessagesModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");

      Response response = await dio.get(
        "${Apis.chatMessagesApi}/$conversion_id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      AppLogger.debug(message: "API: ${Apis.chatMessagesApi}/$conversion_id");
      AppLogger.debug(message: "Token: $token");
      AppLogger.debug(message: "response: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final chatMessagesModel = ChatMessagesModel.fromJson(response.data);
        onSuccess(chatMessagesModel);
        return chatMessagesModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "chatMessagesApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }
  

  //.........................CONVERSION ID API....................//

    static Future<ConversionIdModel> conversionIdApi({
    required String user1_email,
    required String user2_email,
    required int project_id,
    required Function(ConversionIdModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "Token: $token");

      Response response = await dio.get(
        "${Apis.conversionIdApi}?user1_email=$user1_email&user2_email=$user2_email&project_id=$project_id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );

      AppLogger.debug(message: "API: ${Apis.conversionIdApi}?user1_email=$user1_email&user2_email=$user2_email&project_id=$project_id");
      AppLogger.debug(message: "Token: $token");
      AppLogger.debug(message: "response: $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final conversionIdModel = ConversionIdModel.fromJson(response.data);
        onSuccess(conversionIdModel);
        return conversionIdModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "userMeetingLink error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //....................TICKET RESOLVED API TAP.....................//

  static Future<dynamic> ticketStatusApi({
    required dynamic ticket_id,
    required dynamic body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.ticketStatusApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.put(
        "${Apis.ticketStatusApi}/$ticket_id",
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "chatSendApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }


  //.......................GET COUNSELLOR MEETING API......................//

    static Future<CounsellorMeetingModel> counsellorMeetingApi({
    required Function(CounsellorMeetingModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.chatSendApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.get(
        Apis.counsellorMeetingApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final counsellorMeetingModel = CounsellorMeetingModel.fromJson(response.data);
        onSuccess(counsellorMeetingModel);
        return counsellorMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "chatSendApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //...................ALL COUNSELLOR API.........................//

    static Future<AllCounsellorModel> allCounsellorsApi({
    required Function(AllCounsellorModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.chatSendApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.get(
        Apis.allCounsellorApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final allCounsellorModel = AllCounsellorModel.fromJson(response.data);
        onSuccess(allCounsellorModel);
        return allCounsellorModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "allCounsellorApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //....................CREATE MEETING REQUEST.....................//

    static Future<dynamic> requestMeetingApi({
    required dynamic body,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.chatSendApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.post(
        Apis.requestMeetingApi,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.data);
        return response.data;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "chatSendApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //...................REQUEST MEETING LIST API.........................//

    static Future<FilterRequestMeetingModel> requestMeetingByTokenApi({
    required Function(FilterRequestMeetingModel response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.chatSendApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.get(
        Apis.getrequestMeetingByTokenApi,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final filterRequestMeetingModel = FilterRequestMeetingModel.fromJson(response.data);
        onSuccess(filterRequestMeetingModel);
        return filterRequestMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "allCounsellorApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }

  //................DELETE PROJECT API.......................//

  static Future<dynamic> deleteProjectApi({
    required int project_id,
    required Function(dynamic response) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      String? token = await SharedPref.getStringValue(SharedPref.accessToken);
      AppLogger.debug(message: "API: ${Apis.deleteProjectApi}");
      AppLogger.debug(message: "Token: $token");
      
      Response response = await dio.delete(
        "${Apis.deleteProjectApi}/$project_id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Don't set Content-Type for FormData, Dio will set it automatically
          },
        ),
      );
      AppLogger.debug(message: "response: $response");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final filterRequestMeetingModel = response.data;
        onSuccess(filterRequestMeetingModel);
        return filterRequestMeetingModel;
      } else {
        onError("Error: ${response.statusCode}");
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      AppLogger.error(message: "allCounsellorApi error: $e");
      onError(e.toString());
      rethrow;
    }
  }
}