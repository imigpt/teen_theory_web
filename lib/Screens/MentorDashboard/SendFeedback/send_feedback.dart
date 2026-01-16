import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class SendFeedbackPage extends StatelessWidget {
  const SendFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Send Feedback',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Task Information
                    Text(
                      'Task Information',
                      style: textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    hSpace(height: 8),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            _infoRow('Task', 'Submit Essay Draft v1'),
                            _infoRow('Student', 'Riya Shah'),
                            _infoRow(
                              'Project',
                              'AI & Machine Learning - Module 4',
                            ),
                            _infoRow('Milestone', 'Research Phase'),
                            _infoRow('Due Date', 'Oct 16, 2025'),
                            _infoRow('Submitted On', 'Oct 15, 2:30 PM'),
                            _infoRow('Version', 'v1'),
                          ],
                        ),
                      ),
                    ),

                    hSpace(height: 12),

                    // Student Submission
                    Text(
                      'Student Submission',
                      style: textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    hSpace(height: 8),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                      child: Column(
                        children: [
                          _attachmentTile('Essay_Draft_v1.docx', '2.4 MB'),
                          const Divider(height: 1),
                          _attachmentTile('Screenshot.png', '1.2 MB'),
                        ],
                      ),
                    ),

                    hSpace(height: 12),

                    // Mentor Feedback
                    Text(
                      'Mentor Feedback',
                      style: textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    hSpace(height: 8),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Feedback',
                              style: textStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            hSpace(height: 8),
                            TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Good structure, but improve the introduction and add more supporting examples.',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    hSpace(height: 12),

                    // Attach File
                    Text(
                      'Attach File',
                      style: textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    hSpace(height: 8),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 36,
                                color: Colors.black45,
                              ),
                              hSpace(height: 6),
                              Text(
                                'Upload revised example or annotated file',
                                style: textStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    hSpace(height: 12),

                    // Submission History
                    Text(
                      'Submission History',
                      style: textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    hSpace(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'v1 submitted by Student',
                            style: textStyle(fontSize: 13),
                          ),
                          Text('Oct 15', style: textStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    hSpace(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1AA44B),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Send to Counsellor',
                          style: textStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    hSpace(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9534F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Request Changes (Send back to Student)',
                          style: textStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentTile(String name, String size) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.lightGrey3,
        ),
        child: const Icon(Icons.insert_drive_file, color: Colors.black54),
      ),
      title: Text(
        name,
        style: textStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        size,
        style: textStyle(fontSize: 12, color: Colors.black54),
      ),
      trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
    );
  }
}
