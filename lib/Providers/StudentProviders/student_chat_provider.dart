import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:teen_theory/Common/ChatScreens/chat_list.dart';
import 'package:teen_theory/Models/CommonModels/chat_messages_model.dart';
import 'package:teen_theory/Models/CommonModels/conversion_id_model.dart';
import 'package:teen_theory/Models/CommonModels/project_chat_model.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class StudentChatProvider with ChangeNotifier {


  bool isLoading = true;
  ProjectChatModel? chatData;
  String? errorMessage;

  
  Future<void> loadChatParticipants(BuildContext context, {int? projectId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // If projectId is provided, use it directly
    int? finalProjectId = projectId;
    
    // Otherwise, try to get from profile provider
    if (finalProjectId == null) {
      final profileProvider = context.read<StudentProfileProvider>();
      final assignedProjects = profileProvider.studentProfile?.data?.assignedProjects ?? [];

      if (assignedProjects.isEmpty) {
        isLoading = false;
        errorMessage = "No projects found";
        notifyListeners();
        return;
      }

      // Get first project's ID
      finalProjectId = assignedProjects.first.projectId;
    }
    
    if (finalProjectId == null) {
      isLoading = false;
      errorMessage = "Invalid project ID";
      notifyListeners();
      return;
    }

    try {
      await DioClient.projectChatApi(
        project_id: finalProjectId,
        onSuccess: (response) {
          chatData = response;
          isLoading = false;
          errorMessage = null;
          notifyListeners();
        },
        onError: (error) {
          errorMessage = error;
          isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

    List<ChatItem> buildStudentChats({String? currentUserEmail}) {
    if (chatData?.data?.participants?.students == null) return [];
    
    return chatData!.data!.participants!.students!
      .where((student) => student.email != currentUserEmail) // Filter out current user
      .map((student) {
      return ChatItem(
        name: student.fullName ?? 'Student',
        emoji: '👨‍🎓',
        role: 'Student',
        lastMessage: 'Click to start conversation',
        time: DateTime.now(),
        unreadCount: 0,
        avatarUrl: student.profilePhoto,
        gradientColors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
        email: student.email ?? '',
      );
    }).toList();
  }

    List<ChatItem> buildMentorChats({String? currentUserEmail}) {
    if (chatData?.data?.participants?.mentors == null) return [];
    
    return chatData!.data!.participants!.mentors!
      .where((mentor) => mentor.email != currentUserEmail) // Filter out current user
      .map((mentor) {
      return ChatItem(
        name: mentor.fullName ?? 'Mentor',
        emoji: '👨‍🏫',
        role: 'Mentor',
        lastMessage: 'Click to start conversation',
        time: DateTime.now(),
        unreadCount: 0,
        avatarUrl: mentor.profilePhoto,
        gradientColors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
        email: mentor.email ?? '',
      );
    }).toList();
  }

    ChatItem? buildCounsellorChat({String? currentUserEmail}) {
    if (chatData?.data?.participants?.counsellor == null) return null;
    
    final counsellor = chatData!.data!.participants!.counsellor!;
    
    // Don't show counsellor if they are the current user
    if (counsellor.email == currentUserEmail) return null;
    
    return ChatItem(
      name: counsellor.fullName ?? 'Counsellor',
      emoji: '👨‍💼',
      role: 'Counsellor',
      lastMessage: 'Click to start conversation',
      time: DateTime.now(),
      unreadCount: 0,
      avatarUrl: counsellor.profilePhoto,
      gradientColors: [Color(0xFFFFA751), Color(0xFFFFE259)],
      email: counsellor.email ?? '',
    );
  }

//....................CHAT SEND APIs...................//

final TextEditingController chatController = TextEditingController();


bool _chatSendLoading = false;
bool get chatSendLoading => _chatSendLoading;

void setChatSendLoading(bool value) {
  _chatSendLoading = value;
  notifyListeners();
}

void chatSendApiTap ({required int projectId, required String receiverEmail}) {
  ConnectionDetector.connectCheck().then((value) {
      if(value) {
        chatSendApiCall(projectId, receiverEmail);
      } else {
        showToast("Internet not available", type: toastType.error);
      }
  });
}

chatSendApiCall(int projectId, String receiverEmail) {
  Map<String, dynamic> body = {
    "project_id" : projectId,
    "receiver_email" : receiverEmail,
    "message" : messages.last.message ?? ''
  };
  
  try{
    DioClient.chatSendApi(
    body: body, 
    onSuccess: (response) async {
      if(response["success"] == true) {
        // Save conversation_id to local storage with receiver email as key
        if(response["data"] != null && response["data"]["conversation_id"] != null) {
          String conversationId = response["data"]["conversation_id"];
          await saveConversationId(receiverEmail, conversationId);
        }
        
        // Message already added locally, just log success
        AppLogger.debug(message: "Message sent successfully");
        
      } else {
        // If API fails, remove the last message that was added locally
        if (messages.isNotEmpty) {
          messages.removeLast();
          notifyListeners();
        }
        showToast(response['message'], type: toastType.error);
      }
    }, onError: (error) {
      // If API fails, remove the last message that was added locally
      if (messages.isNotEmpty) {
        messages.removeLast();
        notifyListeners();
      }
      AppLogger.error(message: "chatSendApiCall onError: $error");
    });

  }catch(err) {
    // If API fails, remove the last message that was added locally
    if (messages.isNotEmpty) {
      messages.removeLast();
      notifyListeners();
    }
    AppLogger.error(message: "chatSendApiCall error: $err");
  }
}

//...................CHAT MESSAGES APIs..................//

// Helper methods for conversation ID management
Future<void> saveConversationId(String receiverEmail, String conversationId) async {
  try {
    // Get existing map from SharedPreferences
    String mapJson = await SharedPref.getStringValue(SharedPref.conversationIdMap);
    Map<String, dynamic> conversationMap = {};
    
    if (mapJson.isNotEmpty) {
      conversationMap = json.decode(mapJson);
    }
    
    // Add/Update conversation ID for this receiver
    conversationMap[receiverEmail] = conversationId;
    
    // Save back to SharedPreferences
    await SharedPref.setStringValue(SharedPref.conversationIdMap, json.encode(conversationMap));
    AppLogger.debug(message: "Conversation ID saved for $receiverEmail: $conversationId");
  } catch (e) {
    AppLogger.error(message: "Error saving conversation ID: $e");
  }
}

Future<String?> getConversationId(String receiverEmail) async {
  try {
    // Get existing map from SharedPreferences
    String mapJson = await SharedPref.getStringValue(SharedPref.conversationIdMap);
    
    if (mapJson.isEmpty) {
      AppLogger.debug(message: "No conversation map found");
      return null;
    }
    
    Map<String, dynamic> conversationMap = json.decode(mapJson);
    String? conversationId = conversationMap[receiverEmail];
    
    AppLogger.debug(message: "Retrieved conversation ID for $receiverEmail: $conversationId");
    return conversationId;
  } catch (e) {
    AppLogger.error(message: "Error getting conversation ID: $e");
    return null;
  }
}

bool _messagesLoading = false;
bool get messagesLoading => _messagesLoading;

ChatMessagesModel? chatMessagesData;
List<ChatMessages> messages = [];
String? messagesError;

void setMessagesLoading(bool value) {
  _messagesLoading = value;
  notifyListeners();
}

Future<void> loadChatMessages({
  required int projectId,
  required String myEmail,
  required String receiverEmail,
  bool fetchFromBackend = false,
}) async {
  messagesError = null;

  try {
    // Get conversation_id from local storage for this receiver
    String? conversationId = await getConversationId(receiverEmail);
    
    // If no conversation ID in local storage and fetchFromBackend is true, get it from backend
    if ((conversationId == null || conversationId.isEmpty) && fetchFromBackend) {
      AppLogger.debug(message: "No local conversation ID, fetching from backend for $receiverEmail");
      // This will trigger conversionIdApi which will save the ID and call loadChatMessages again
      return;
    }
    
    if (conversationId == null || conversationId.isEmpty) {
      AppLogger.debug(message: "No conversation ID found for $receiverEmail, showing empty state");
      messages = [];
      setMessagesLoading(false);
      return;
    }
    
    AppLogger.debug(message: "Loading messages for conversation: $conversationId with $receiverEmail");
    
    await DioClient.chatMessagesApi(
      conversion_id: conversationId,
      onSuccess: (response) {
        chatMessagesData = response;
        
        // Store messages directly from response
        messages = response.data ?? [];
        
        setMessagesLoading(false);
        AppLogger.debug(message: "Loaded ${messages.length} messages");
      },
      onError: (error) {
        messagesError = error;
        setMessagesLoading(false);
        AppLogger.error(message: "loadChatMessages error: $error");
      },
    );
  } catch (e) {
    messagesError = e.toString();
    setMessagesLoading(false);
    AppLogger.error(message: "loadChatMessages exception: $e");
  }
}

// Helper method to check if message is sent by me
bool isMyMessage(ChatMessages message, String myEmail) {
  return message.senderEmail?.toLowerCase() == myEmail.toLowerCase();
}


//....................CONVERSION ID APIs...................//

ConversionIdModel? _conversionIdData;
ConversionIdModel? get conversionIdData => _conversionIdData;

void conversionIdApiTap ({required String user1_email, required String user2_email, required int project_id, required String myEmail}) {
  ConnectionDetector.connectCheck().then((value) {
      if(value) {
        conversionIdApiCall(user1_email, user2_email, project_id, myEmail);
      }else {
        showToast("Internet not available", type: toastType.error);
      }
  });
}

conversionIdApiCall(String user1_email, String user2_email, int project_id, String myEmail) async {
  setMessagesLoading(true);
  messagesError = null;
  
  try{
    await DioClient.conversionIdApi(
    user1_email: user1_email, user2_email: user2_email, project_id: project_id,
    onSuccess: (response) async {
      if(response.success == true) {
        _conversionIdData = response;
        
        // Save conversation ID to local storage
        if(response.data?.conversationId != null) {
          String conversationId = response.data!.conversationId!;
          String receiverEmail = user1_email == myEmail ? user2_email : user1_email;
          await saveConversationId(receiverEmail, conversationId);
          
          AppLogger.debug(message: "Conversation ID fetched and saved: $conversationId for $receiverEmail");
          
          // Load messages after getting conversation ID
          await loadChatMessages(
            projectId: project_id,
            myEmail: myEmail,
            receiverEmail: receiverEmail,
          );
        } else {
          // No conversation ID means new conversation - show empty state
          messages = [];
          setMessagesLoading(false);
        }
      } else {
        // Don't show error for new conversations - just show empty state
        messages = [];
        setMessagesLoading(false);
        AppLogger.debug(message: "New conversation, no messages yet");
      }
      
    }, onError: (error) {
      // For new conversations, don't show error - just empty state
      messages = [];
      setMessagesLoading(false);
      AppLogger.debug(message: "New conversation: $error");
    });

  }catch(err) {
    // For new conversations, don't show error - just empty state
    messages = [];
    setMessagesLoading(false);
    AppLogger.debug(message: "New conversation exception: $err");
  }
}
}