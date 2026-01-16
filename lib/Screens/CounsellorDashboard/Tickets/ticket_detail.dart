import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/all_ticket_model.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Utils/helper.dart';

class TicketDetailPage extends StatefulWidget {
  final Datum ticket;

  const TicketDetailPage({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _internalNotesController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _internalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tickets Details',
          style: textStyle(fontSize: 20, fontFamily: AppFonts.interBold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and ticket number
            Text(
              widget.ticket.title ?? 'No Title',
              style: textStyle(fontSize: 18, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 4),
            Text(
              '#${widget.ticket.id ?? 'N/A'}',
              style: textStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            hSpace(height: 8),

            // Priority badge
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.ticket.priority?.toLowerCase() == 'high'
                        ? [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
                        : widget.ticket.priority?.toLowerCase() == 'medium'
                            ? [Color(0xFFFFA751), Color(0xFFFFE259)]
                            : [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.ticket.priority?.toLowerCase() == 'high'
                              ? Color(0xFFFF6B6B)
                              : widget.ticket.priority?.toLowerCase() == 'medium'
                                  ? Color(0xFFFFA751)
                                  : Color(0xFF6DD5FA))
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.ticket.priority ?? 'Low',
                  style: textStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: AppFonts.interBold,
                  ),
                ),
              ),
            ),

            hSpace(height: 20),
            const Divider(),
            // Ticket Information Section
            Text(
              'Ticket Information',
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 12),
            _buildInfoRow(
              'Raised by',
              '${widget.ticket.raisedByUser?.fullName ?? 'Unknown'} (${widget.ticket.raisedByUser?.userRole ?? 'User'})',
              hasAvatar: true,
              avatarUrl: widget.ticket.raisedByUser?.profilePhoto,
            ),
            _buildInfoRow('Email', widget.ticket.raisedByUser?.email ?? 'N/A'),
            _buildInfoRow('Phone', widget.ticket.raisedByUser?.phoneNumber ?? 'N/A'),
            _buildInfoRow('Project', widget.ticket.projectName ?? 'No Project'),
            _buildInfoRow('Assigned To', widget.ticket.assignedTo?.toString() ?? 'Not Assigned'),
            if (widget.ticket.raisedByUser?.createdAt != null)
              _buildInfoRow(
                'Created On',
                _formatDate(widget.ticket.raisedByUser!.createdAt!),
              ),
            _buildInfoRow(
              'Status',
              widget.ticket.status ?? 'Opened',
              valueColor: widget.ticket.status?.toLowerCase() == 'resolved'
                  ? Colors.green
                  : Colors.orange,
            ),

            hSpace(height: 24),
            Divider(),
            hSpace(height: 24),

            // Description
            Text(
              'Description',
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 8),
            Text(
              widget.ticket.explaination ?? 'No description provided',
              style: textStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            hSpace(height: 24),
            Divider(),
            hSpace(height: 24),

            // Attachments
            if (widget.ticket.attachments != null && widget.ticket.attachments!.isNotEmpty) ...[
              Text(
                'Attachments',
                style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
              ),
              hSpace(height: 12),
              ...widget.ticket.attachments!.map(
                (attachment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildAttachment(attachment),
                ),
              ),
              // hSpace(height: 24),
            ],

            // Conversation
            // Text(
            //   'Conversation',
            //   style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            // ),
            // hSpace(height: 12),
            // _buildConversationMessage(
            //   'Need help understanding the comments.',
            //   'You - 2hours ago',
            //   isUser: true,
            // ),
            // hSpace(height: 8),
            // _buildConversationMessage(
            //   'Need help understanding the comments.',
            //   'Dr. Sarah Chen - 1hour ago',
            //   isUser: false,
            // ),
            // hSpace(height: 8),
            // _buildConversationMessage(
            //   'Need help understanding the comments.',
            //   'You - 30min ago',
            //   isUser: true,
            // ),

            // hSpace(height: 12),

            // // Message input
            // Row(
            //   children: [
            //     CircleAvatar(
            //       radius: 18,
            //       backgroundColor: Colors.grey.shade300,
            //       child: Icon(
            //         Icons.person,
            //         color: Colors.grey.shade600,
            //         size: 20,
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: TextField(
            //         controller: _messageController,
            //         decoration: InputDecoration(
            //           hintText: 'Type your message...',
            //           isDense: true,
            //           contentPadding: const EdgeInsets.symmetric(
            //             vertical: 12,
            //             horizontal: 12,
            //           ),
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide: BorderSide(color: Colors.grey.shade300),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8),
            //             borderSide: BorderSide(color: Colors.grey.shade300),
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Container(
            //       decoration: BoxDecoration(
            //         color: Colors.black,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: IconButton(
            //         icon: const Icon(Icons.send, color: Colors.white, size: 20),
            //         onPressed: () {},
            //       ),
            //     ),
            //   ],
            // ),

            hSpace(height: 24),

            // Internal Notes
            Text(
              'Internal Notes',
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 8),
            TextField(
              controller: _internalNotesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add internal notes (visible only to staff)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            hSpace(height: 24),

            // Actions
            Text(
              'Actions',
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 12),

            if (widget.ticket.status?.toLowerCase() != 'resolved')
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF56CCF2).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Resolve Ticket'),
                          content: Text('Are you sure you want to resolve this ticket?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                              child: Text('Resolve'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && mounted) {
                        // Call API to resolve ticket
                        context.read<MentorProvider>().ticketResolvedApiTap(
                          context,
                          ticket_id: widget.ticket.id!,
                          status: 'resolved',
                        );
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Resolve Ticket',
                      style: textStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: AppFonts.interBold,
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Center(
                  child: Text(
                    'Ticket Resolved',
                    style: textStyle(
                      fontSize: 15,
                      color: Colors.green,
                      fontFamily: AppFonts.interBold,
                    ),
                  ),
                ),
              ),

            // hSpace(height: 12),

            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red.shade400,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: Text(
            //       'Escalated to Admin',
            //       style: textStyle(
            //         fontSize: 15,
            //         color: Colors.white,
            //         fontFamily: AppFonts.interBold,
            //       ),
            //     ),
            //   ),
            // ),
            // hSpace(height: 24),
            // Text(
            //   "Activity Logs",
            //   style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            // ),
            // ListView.separated(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   separatorBuilder: (context, index) {
            //     return Divider();
            //   },
            //   itemCount: 3,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       leading: Icon(Icons.donut_small_rounded, size: 5),
            //       title: Text(
            //         "Ticket created by Riya Shah",
            //         style: textStyle(fontFamily: AppFonts.interBold),
            //       ),
            //       subtitle: Text(
            //         "Oct 13, 2025 - 10:00 AM",
            //         style: textStyle(color: Colors.grey),
            //       ),
            //     );
            //   },
            // ),
            hSpace(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool hasAvatar = false,
    String? avatarUrl,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                if (hasAvatar) ...[
                  avatarUrl != null
                      ? CircleAvatar(
                          radius: 12,
                          backgroundImage: CachedNetworkImageProvider(
                            '${Apis.baseUrl}$avatarUrl',
                          ),
                        )
                      : CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey.shade600,
                            size: 14,
                          ),
                        ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: textStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.interMedium,
                      color: valueColor ?? Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(String fileUrl) {
    final fileName = fileUrl.split('/').last;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.grey.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: textStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.interBold,
                  ),
                ),
                Text(
                  '${Apis.baseUrl}$fileUrl',
                  style: textStyle(fontSize: 10, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.blue),
            onPressed: () {
              // Add download functionality if needed
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  Widget _buildConversationMessage(
    String message,
    String meta, {
    required bool isUser,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 18),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: textStyle(fontSize: 14, color: Colors.black87),
                ),
                hSpace(height: 4),
                Text(
                  meta,
                  style: textStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.grey.shade600, size: 18),
          ),
        ],
      ],
    );
  }
}
