import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Common/ChatScreens/chat_list.dart';
import 'package:teen_theory/Models/CommonModels/chat_messages_model.dart';
import 'package:teen_theory/Providers/StudentProviders/student_chat_provider.dart';
import 'package:teen_theory/Shimmer/CommonShimmer/chats_shimmer.dart';

/// Chat detail screen with a simple local message list and an input field.
class ChatDetailScreen extends StatefulWidget {
  final String user1_email;
  final String user2_email;
  final ChatItem chat;
  final int projectId;

  const ChatDetailScreen({Key? key, required this.user1_email, required this.user2_email, required this.chat, required this.projectId}) : super(key: key);
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _messagePollingTimer;

  late List<_Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [];
    
    // Load chat messages from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<StudentChatProvider>();
      
      // Clear any previous errors
      chatProvider.messagesError = null;
      
      if (widget.projectId != null && widget.user1_email.isNotEmpty && widget.user2_email.isNotEmpty) {
        // First, get/create conversation ID from backend with both user emails
        // This will automatically load messages after getting conversation ID
        chatProvider.conversionIdApiTap(
          user1_email: widget.user1_email,
          user2_email: widget.user2_email,
          project_id: widget.projectId,
          myEmail: widget.user1_email,
        );
        
        // Start polling messages every 2 seconds
        _startMessagePolling();
      }
    });
  }
  
  void _startMessagePolling() {
    _messagePollingTimer?.cancel();
    _messagePollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        final chatProvider = context.read<StudentChatProvider>();
        if (widget.projectId != null && widget.user1_email.isNotEmpty && widget.user2_email.isNotEmpty) {
          // Refresh messages silently without loader
          chatProvider.refreshMessagesWithoutLoader(
            user1_email: widget.user1_email,
            user2_email: widget.user2_email,
            project_id: widget.projectId,
            myEmail: widget.user1_email,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _messagePollingTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final chatProvider = context.read<StudentChatProvider>();
    final text = chatProvider.chatController.text.trim();
    if (text.isEmpty) return;

    // Validate required data
    if (widget.projectId == null || widget.user1_email.isEmpty || widget.user2_email.isEmpty) return;

    // Add message locally immediately
    final newMessage = ChatMessages(
      message: text,
      senderEmail: widget.user1_email,
      receiverEmail: widget.user2_email,
      createdAt: DateTime.now(),
    );
    
    chatProvider.messages.add(newMessage);
    chatProvider.chatController.clear();
    chatProvider.notifyListeners();
    
    // Scroll to bottom immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    // Call API in background (no loader)
    chatProvider.chatSendApiCall(widget.projectId, widget.user2_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.chat.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.chat.emoji,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.chat.role}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.videocam_rounded, color: Colors.white),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.phone, color: Colors.white),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Consumer<StudentChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.messagesLoading) {
            return const ChatsShimmer();
          }
          
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: chatProvider.messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.chat.emoji,
                                style: TextStyle(fontSize: 64),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start the conversation!',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: chatProvider.messages.length,
                          itemBuilder: (context, index) {
                            final msg = chatProvider.messages[index];
                            final isMe = chatProvider.isMyMessage(msg, widget.user1_email);
                            return _buildMessageBubble(msg, isMe);
                          },
                        ),
                ),
                _buildInput(),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildMessageBubble(ChatMessages msg, bool isMe) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 4),
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? LinearGradient(
                            colors: widget.chat.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMe
                            ? widget.chat.gradientColors[0].withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.message ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildBubble(_Message msg) {
    final align = msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: msg.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!msg.isMe) const SizedBox(width: 4),
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: msg.isMe
                        ? LinearGradient(
                            colors: widget.chat.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: msg.isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(msg.isMe ? 20 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: msg.isMe
                            ? widget.chat.gradientColors[0].withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _formatTime(msg.time),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (msg.isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: widget.chat.gradientColors,
            //     ),
            //     shape: BoxShape.circle,
            //   ),
            //   child: IconButton(
            //     icon: Icon(Icons.add, color: Colors.white, size: 22),
            //     onPressed: () {},
            //   ),
            // ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<StudentChatProvider>(
                        builder: (context, chatProvider, child) {
                          return TextField(
                            controller: chatProvider.chatController,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'Message... 💭',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            onSubmitted: (_) => _send(context),
                          );
                        },
                      ),
                    ),
                    Icon(Icons.emoji_emotions_outlined, 
                         color: Colors.grey.shade400, size: 22),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.chat.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.chat.gradientColors[0].withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: () => _send(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays >= 1) return '${diff.inDays}d';
    if (diff.inHours >= 1) return '${diff.inHours}h';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m';
    return 'now';
  }
}

class _Message {
  final String text;
  final bool isMe;
  final DateTime time;

  _Message({required this.text, required this.isMe, DateTime? time})
    : time = time ?? DateTime.now();
}
