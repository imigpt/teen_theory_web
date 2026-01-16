import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Models/CounsellorModels/counsellor_meeting_model.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({Key? key}) : super(key: key);

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch meetings and projects
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CounsellorProvider>();
      provider.fetchCounsellorMeetingsTap();
      provider.getAllMyProjectsApiCall();
    });
  }

  // provider handles fetching meetings

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Meetings',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Consumer<CounsellorProvider>(
        builder: (context, pvd, child) {
          return RefreshIndicator(
            onRefresh: () async => await pvd.fetchCounsellorMeetings(),
            child: pvd.meetingsLoading
                ? Center(
                    child: LoadingAnimationWidget.fallingDot(
                      color: Colors.black,
                      size: 50,
                    ),
                  )
                : pvd.meetingsError != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: ${pvd.meetingsError}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => pvd.fetchCounsellorMeetingsTap(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _buildMeetingsContent(pvd.counsellorMeetingData?.data ?? []),
          );
        },
      ),
    );
  }
  Widget _buildMeetingsContent(List<CounsellorMeeting> meetings) {
    // apply search filter
    final filteredMeetings = meetings.where((meeting) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = meeting.title?.toLowerCase() ?? '';
      final project = meeting.projectName?.toLowerCase() ?? '';
      final mentor = meeting.projectMentor?.name?.toLowerCase() ?? '';
      return title.contains(q) || project.contains(q) || mentor.contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                filled: false,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search by project',
                hintStyle: textStyle(color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
              ),
            ),
          ),

          hSpace(height: 12),

          // Consumer<CounsellorProvider>(builder: (context, pvd, child) {
          //   return Container(
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
          //       ),
          //       borderRadius: BorderRadius.circular(12),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Color(0xFFFF758C).withValues(alpha: 0.4),
          //           blurRadius: 12,
          //           offset: Offset(0, 4),
          //         ),
          //       ],
          //     ),
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.transparent,
          //         shadowColor: Colors.transparent,
          //         padding: EdgeInsets.symmetric(vertical: 14),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //       onPressed: () async {
          //         // Fetch projects if not already loaded
          //         if (pvd.allMyProjectData == null) {
          //           await pvd.getAllMyProjectsApiCall();
          //         }

          //         if (!context.mounted) return;

          //         showDialog(
          //           context: context,
          //           builder: (dialogContext) {
          //             final meetingTitles = ['General', 'Career Guidance', 'Academics', 'Personal'];
          //             final projectList = pvd.allMyProjectData?.data ?? [];

          //             String? selectedTitle = meetingTitles.first;
          //             int? selectedProjectId;
          //             List<String> selectedStudents = [];
          //             String? selectedMentor;
          //             final messageController = TextEditingController();

          //             // Auto-select first project and its students/mentor
          //             if (projectList.isNotEmpty) {
          //               selectedProjectId = projectList.first.id;
          //               final firstProject = projectList.first;
          //               selectedStudents = firstProject.assignedStudent?.map((s) => s.name ?? '').where((n) => n.isNotEmpty).toList() ?? [];
          //               selectedMentor = firstProject.assignedMentor?.name;
          //             }

          //             return StatefulBuilder(builder: (context, setState) {
          //               // Helper to update students/mentor when project changes
          //               void updateProjectSelection(int? projectId) {
          //                 if (projectId == null) return;
          //                 final project = projectList.firstWhere((p) => p.id == projectId);
          //                 setState(() {
          //                   selectedProjectId = projectId;
          //                   selectedStudents = project.assignedStudent?.map((s) => s.name ?? '').where((n) => n.isNotEmpty).toList() ?? [];
          //                   selectedMentor = project.assignedMentor?.name;
          //                 });
          //               }

          //               return AlertDialog(
          //                 title: Text('Create Meeting', style: textStyle(fontWeight: FontWeight.w600)),
          //                 content: SingleChildScrollView(
          //                   child: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       // Title
          //                       Text('Title', style: textStyle(fontWeight: FontWeight.w600)),
          //                       const SizedBox(height: 6),
          //                       DropdownButtonFormField<String>(
          //                         value: selectedTitle,
          //                         items: meetingTitles.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          //                         onChanged: (v) => setState(() => selectedTitle = v),
          //                         decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          //                       ),
          //                       const SizedBox(height: 12),

          //                       // Project
          //                       Text('Select Project', style: textStyle(fontWeight: FontWeight.w600)),
          //                       const SizedBox(height: 6),
          //                       DropdownButtonFormField<int>(
          //                         value: selectedProjectId,
          //                         items: projectList.isNotEmpty
          //                             ? projectList.map((p) => DropdownMenuItem(value: p.id, child: Text(p.title ?? 'Untitled Project'))).toList()
          //                             : [const DropdownMenuItem(value: null, child: Text('No projects available'))],
          //                         onChanged: projectList.isNotEmpty ? (v) => updateProjectSelection(v) : null,
          //                         decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          //                       ),
          //                       const SizedBox(height: 12),

          //                       // Students (auto-selected from project)
          //                       Text('Students', style: textStyle(fontWeight: FontWeight.w600)),
          //                       const SizedBox(height: 6),
          //                       Container(
          //                         padding: const EdgeInsets.all(12),
          //                         decoration: BoxDecoration(
          //                           border: Border.all(color: Colors.grey),
          //                           borderRadius: BorderRadius.circular(8),
          //                         ),
          //                         child: selectedStudents.isEmpty
          //                             ? Text('No students assigned', style: textStyle(color: Colors.grey))
          //                             : Wrap(
          //                                 spacing: 6,
          //                                 runSpacing: 6,
          //                                 children: selectedStudents.map((s) => Chip(label: Text(s, style: textStyle(fontSize: 12)))).toList(),
          //                               ),
          //                       ),
          //                       const SizedBox(height: 12),

          //                       // Mentor (auto-selected from project)
          //                       Text('Mentor', style: textStyle(fontWeight: FontWeight.w600)),
          //                       const SizedBox(height: 6),
          //                       Container(
          //                         padding: const EdgeInsets.all(12),
          //                         decoration: BoxDecoration(
          //                           border: Border.all(color: Colors.grey),
          //                           borderRadius: BorderRadius.circular(8),
          //                         ),
          //                         child: Text(
          //                           selectedMentor ?? 'No mentor assigned',
          //                           style: textStyle(color: selectedMentor != null ? Colors.black : Colors.grey),
          //                         ),
          //                       ),
          //                       const SizedBox(height: 12),

          //                       // Message
          //                       Text('Message', style: textStyle(fontWeight: FontWeight.w600)),
          //                       const SizedBox(height: 6),
          //                       TextField(
          //                         controller: messageController,
          //                         maxLines: 4,
          //                         decoration: InputDecoration(hintText: 'Add message for the student', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          //                       ),
          //                    ],
          //                   ),
          //                 ),
          //                 actions: [
          //                   TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          //                   ElevatedButton(
          //                     onPressed: () {
          //                       // Basic validation
          //                       if (selectedTitle == null || selectedProjectId == null) {
          //                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a title and project')));
          //                         return;
          //                       }

          //                       // TODO: call provider API to create meeting
          //                       Navigator.of(context).pop();
          //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meeting created: $selectedTitle')));
          //                     },
          //                     child: Text('Create'),
          //                   ),
          //                 ],
          //               );
          //             });
          //           },
          //         );
          //       },
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text('📅', style: TextStyle(fontSize: 18)),
          //           SizedBox(width: 8),
          //           Text(
          //             'Create Meeting',
          //             style: textStyle(color: Colors.white, fontWeight: FontWeight.w600),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );    
          // }),

          hSpace(height: 16),

          // Meetings label
          Text(
            'All Meetings',
            style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          hSpace(height: 8),

          if (filteredMeetings.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No meetings found',
                  style: textStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: filteredMeetings.length,
                separatorBuilder: (_, __) => hSpace(height: 12),
                itemBuilder: (context, index) {
                  final meeting = filteredMeetings[index];
                  return _meetingCard(context, meeting);
                },
              ),
            ),
        ],
      ),
    );
  }


  Widget _meetingCard(BuildContext context, CounsellorMeeting meeting) {
    Color badgeColor;
    List<Color> badgeGradient;
    String badgeText = meeting.status ?? 'Pending';
    switch (badgeText.toLowerCase()) {
      case 'confirmed':
        badgeGradient = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
        break;
      case 'scheduled':
        badgeGradient = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
        break;
      default:
        badgeGradient = [Color(0xFFFFA751), Color(0xFFFFE259)];
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.title ?? 'Meeting',
                        style: textStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      hSpace(height: 8),
                      if (meeting.projectName != null) ...[
                        Row(
                          children: [
                            Icon(Icons.folder_outlined, size: 14, color: Colors.grey),
                            wSpace(width: 4),
                            Expanded(
                              child: Text(
                                meeting.projectName!,
                                style: textStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        hSpace(height: 4),
                      ],
                      if (meeting.projectMentor?.name != null) ...[
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 14, color: Colors.grey),
                            wSpace(width: 4),
                            Expanded(
                              child: Text(
                                'Mentor: ${meeting.projectMentor!.name}',
                                style: textStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        hSpace(height: 4),
                      ],
                      if (meeting.dateTime != null) ...[
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.grey),
                            wSpace(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy • hh:mm a').format(meeting.dateTime!),
                              style: textStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: badgeGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: badgeGradient[0].withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    badgeText,
                    style: textStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),

            hSpace(height: 12),

            // Action buttons
            if (meeting.meetingLink != null)
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF667EEA).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse("https:${meeting.meetingLink!}");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🎥', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Text('Join Meeting', style: textStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
