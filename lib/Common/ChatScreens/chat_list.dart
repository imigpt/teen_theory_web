import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Common/ChatScreens/chat_detail_screen.dart';
import 'package:teen_theory/Providers/StudentProviders/student_chat_provider.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/StudentShimmer/chat_list_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Chat list screen that shows students, mentor and counselor from project chat API

class ChatListScreen extends StatefulWidget {
  final int projectId;
  const ChatListScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StudentChatProvider>().loadChatParticipants(context, projectId: widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '💬 ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Messages',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<StudentChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return ChatListShimmer();
          }
          if (chatProvider.errorMessage != null) {
            return _buildErrorView(chatProvider);
          }
          return _buildChatList(chatProvider, widget.projectId);
        },
      ),
    );
  }

  Widget _buildErrorView(StudentChatProvider chatProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'Error loading chats',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            chatProvider.errorMessage ?? 'Unknown error',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              chatProvider.loadChatParticipants(context, projectId: widget.projectId);
            },
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(StudentChatProvider chatProvider, int projectId) {
    final data = chatProvider.chatData!.data;
    final myEmail = data!.requestedByEmail!;
    
    final students = chatProvider.buildStudentChats(currentUserEmail: myEmail);
    final mentors = chatProvider.buildMentorChats(currentUserEmail: myEmail);
    final counsellor = chatProvider.buildCounsellorChat(currentUserEmail: myEmail);

    if (students.isEmpty && mentors.isEmpty && counsellor == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'No participants found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8),
      children: [
        // Counsellor Section
        if (counsellor != null) ...[
          _buildSectionHeader('Counsellor'),
          _buildChatTile(counsellor, projectId, chatProvider),
          SizedBox(height: 16),
        ],

        // Mentors Section
        if (mentors.isNotEmpty) ...[
          _buildSectionHeader('Mentor${mentors.length > 1 ? 's' : ''}'),
          ...mentors.map((mentor) => _buildChatTile(mentor, projectId, chatProvider)),
          SizedBox(height: 16),
        ],

        // Students Section
        if (students.isNotEmpty) ...[
          _buildSectionHeader('Student${students.length > 1 ? 's' : ''}'),
          ...students.map((student) => _buildChatTile(student, projectId, chatProvider)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildChatTile(ChatItem chat, int projectId, StudentChatProvider chatProvider) {
    final data = chatProvider.chatData!.data;
    final myEmail = data!.requestedByEmail!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    user1_email: myEmail,
                    user2_email: chat.email,
                    chat: chat, 
                    projectId: projectId
                  ),
                ),
              );

              print("$myEmail chatting with ${chat.email}");
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildAvatar(chat),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                chat.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          chat.role,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(chat.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF6B6B),
                                Color(0xFFFF8E53),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Color(0xFFFF6B6B).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatItem chat) {
    if (chat.avatarUrl != null && chat.avatarUrl!.isNotEmpty) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: chat.gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: "${Apis.baseUrl}${chat.avatarUrl}",
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: chat.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: chat.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  chat.emoji,
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: chat.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: chat.gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          chat.emoji,
          style: TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays >= 1) return '${difference.inDays}d';
    if (difference.inHours >= 1) return '${difference.inHours}h';
    if (difference.inMinutes >= 1) return '${difference.inMinutes}m';
    return 'now';
  }
}

class ChatItem {
  final String name;
  final String emoji;
  final String role;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;
  final String? avatarUrl;
  final List<Color> gradientColors;
  final String email;

  ChatItem({
    required this.name,
    required this.emoji,
    required this.role,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
    required this.gradientColors,
    required this.email,
  });
}