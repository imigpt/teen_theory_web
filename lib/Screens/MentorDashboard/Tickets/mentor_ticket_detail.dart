import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/all_ticket_model.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Utils/helper.dart';

class MentorTicketDetailPage extends StatefulWidget {
  final Datum ticket;

  const MentorTicketDetailPage({Key? key, required this.ticket})
    : super(key: key);

  @override
  State<MentorTicketDetailPage> createState() => _MentorTicketDetailPageState();
}

class _MentorTicketDetailPageState extends State<MentorTicketDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _internalNotesController =
      TextEditingController();

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
      body: Consumer<MentorProvider>(
        builder: (context, pvd, child) {
        return SingleChildScrollView(
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
            ),
            _buildInfoRow('Project', widget.ticket.projectName ?? 'N/A'),
            _buildInfoRow(
              'Assigned To',
              widget.ticket.assignedTo ?? 'Not Assigned',
              hasAvatar: widget.ticket.assignedTo != null,
            ),
            _buildInfoRow(
              'Created On',
              widget.ticket.raisedByUser?.createdAt != null
                  ? _formatDate(widget.ticket.raisedByUser!.createdAt!)
                  : 'N/A',
            ),
            _buildInfoRow(
              'Status',
              widget.ticket.status ?? 'Opened',
              valueColor: widget.ticket.status?.toLowerCase() == 'completed'
                  ? Colors.green
                  : Colors.orange,
            ),

            Divider(),

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
            Divider(),
            hSpace(height: 24),

            // Attachments
            Text(
              'Attachments',
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 12),
            if (widget.ticket.attachments != null || widget.ticket.attachments!.isNotEmpty)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for(int i = 0; i < (widget.ticket.attachments?.length ?? 0); i++)
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    placeholder: (context, url) {
                      return LoadingAnimationWidget.inkDrop(
                        color: Colors.purple,
                        size: 24,
                      );
                    },
                    imageUrl: "${Apis.baseUrl}${widget.ticket.attachments![i]}"),
                ]
              ),

            hSpace(height: 24),

            // Actions
            Text(
              'Actions',
              style: textStyle(fontSize: 16, fontFamily: AppFonts.interBold),
            ),
            hSpace(height: 12),
            widget.ticket.status == "resolved"
                ? Center(
                  child: Text(
                      'This ticket has been resolved.',
                      style: textStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontFamily: AppFonts.interMedium,
                      ),
                    ),
                )
                :
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
                  onPressed: () {
                    _showDoneTicketDialog(context);
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
                    'Done Ticket',
                    style: textStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: AppFonts.interBold,
                    ),
                  ),
                ),
              ),
            ),
            hSpace(height: 24),
          ],
        ),
      ); 
      })
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDoneTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<MentorProvider>(
          builder: (context, pvd, child) {
            return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Mark Ticket as Done',
            style: textStyle(
              fontSize: 18,
              fontFamily: AppFonts.interBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a comment before marking this ticket as done:',
                style: textStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              hSpace(height: 12),
              TextField(
                controller: pvd.commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your comment here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: textStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
           pvd.ticketLoader ? LoadingAnimationWidget.fourRotatingDots(color: Colors.deepPurple, size: 18) : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (pvd.commentController.text.trim().isEmpty) {
                    showToast('Please add a comment', type: toastType.error);
                    return;
                  }
                  // TODO: Implement API call to mark ticket as done with comment
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  // showToast('Ticket marked as done', type: toastType.success);
                  pvd.ticketResolvedApiTap(context, ticket_id: widget.ticket.id!, status: "resolved");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: textStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: AppFonts.interBold,
                  ),
                ),
              ),
            ),
          ],
        );
        });
      },
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool hasAvatar = false,
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
                  CircleAvatar(
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
