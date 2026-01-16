class Apis {
  static const String baseUrl = "https://teen-theory-backend-s4sv.onrender.com";

  // APIs Endpoints
  static const String login = "$baseUrl/users/user_login";
  static const String profile = "$baseUrl/users/me";
  static const String updateProfile = "$baseUrl/users/update";
  static const String createProject = "$baseUrl/projects/create";
  static const String allStudents = "$baseUrl/users/all_students";
  static const String allMentors = "$baseUrl/users/all_mentors";
  static const String myProjects = "$baseUrl/projects/my_projects";
  static const String createTicket = "$baseUrl/tickets/create";
  static const String completedTaskApi = "$baseUrl/projects/milestone_status";
  static const String meetingLinkApi = "$baseUrl/meetings/create";
  static const String userMeetingLink = "$baseUrl/meetings/mine";
  static const String mentorProjectApi = "$baseUrl/projects/by_mentor";
  static const String allTicketsApi = "$baseUrl/tickets/all_tickets";
  static const String allMeetingApi = "$baseUrl/meetings/all_meetings";
  static const String mentorMeetingApi = "$baseUrl/meetings/mentor_create_meeting";
  static const String studentMeetingApi = "$baseUrl/meetings/by_student";
  static const String studentNotificationScreenApi = "$baseUrl/projects/notifications/by_student";
  static const String projectCompleteApi = "$baseUrl/projects/status";
  static const String approvedOrRejectTaskApi = "$baseUrl/projects/milestone/status";
  static const String projectChatApi = "$baseUrl/projects/chat_participants";
  static const String chatSendApi = "$baseUrl/chat/send";
  static const String chatMessagesApi = "$baseUrl/chat/messages";
  static const String conversionIdApi = "$baseUrl/chat/conversation";
  static const String ticketStatusApi = "$baseUrl/tickets/update_status";
  static const String counsellorMeetingApi = "$baseUrl/meetings/counsellor_meetings";
  static const String allCounsellorApi = "$baseUrl/users/all_counsellors";
  static const String requestMeetingApi = "$baseUrl/meetings/request";
  static const String getrequestMeetingByTokenApi = "$baseUrl/meetings/requests/mine";
  static const String deleteProjectApi = "$baseUrl/projects";
}