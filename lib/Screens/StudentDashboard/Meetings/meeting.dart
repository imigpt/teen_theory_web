import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teen_theory/Models/StudentModels/student_meeting_model.dart';
import 'package:teen_theory/Providers/StudentProviders/student_meeting_provider.dart';
import 'package:teen_theory/Resources/colors.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<StudentMeetingProvider>().fetchMeetings();
      context.read<StudentProfileProvider>().getStudentProfileApiTap(context);
      context.read<CounsellorProvider>().allMentorsApiTap(context);
      context.read<CounsellorProvider>().allCounsellorsApiTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Meetings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<StudentMeetingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return _buildLoadingState();
          }

          if (provider.errorMessage != null && !provider.hasData) {
            return _buildErrorState(provider);
          }

          if (!provider.isLoading && !provider.hasData) {
            return _buildEmptyState(provider);
          }

          return RefreshIndicator(
            color: AppColors.yellow600,
            onRefresh: () => provider.refreshMeetings(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildHeroTile(provider),
                const SizedBox(height: 24),
                _buildSectionTitle('Upcoming Meetings', provider.upcomingMeetings.length),
                const SizedBox(height: 12),
                if (provider.upcomingMeetings.isEmpty)
                  _buildMiniPlaceholder('No upcoming meetings yet. Request one to get started!')
                else
                  ...provider.upcomingMeetings
                      .map((meeting) => _buildUpcomingMeetingCard(context, provider, meeting))
                      .toList(),
                const SizedBox(height: 12),
                if (provider.pastMeetings.isEmpty)
                  _buildMiniPlaceholder('Once meetings are completed they will show up here.')
                else
                  ...provider.pastMeetings
                      .map((meeting) => _buildPastMeetingCard(context, provider, meeting))
                      .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroTile(StudentMeetingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF181818), Color(0xFF2D2D2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.video_call_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  provider.isLoading ? 'Syncing schedule…' : 'Stay ahead with your mentor',
                  style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer3<StudentProfileProvider, StudentMeetingProvider, CounsellorProvider>(builder: (context, pvd, meetingProvider, counsellorProvider, child) {
            final data = pvd.studentProfile?.data?.assignedProjects;
            return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return StatefulBuilder(builder: (ctx, setState) {
                      return SingleChildScrollView(
                        child: AlertDialog(
                          title: const Text('Request Meeting'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: meetingProvider.titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Meeting Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              TextFormField(
                                controller: meetingProvider.messageController,
                                decoration: const InputDecoration(
                                  labelText: 'Message',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Project'),
                                value: meetingProvider.selectedProject,
                                items: [
                                  for(int i = 0; i < (data?.length ?? 0); i++)
                                  DropdownMenuItem(value: data?[i].title, child: Text(data?[i].title ?? '')),
                                ],
                                onChanged: (v) {
                                  meetingProvider.selectedProject = v;
                                },
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Mentor'),
                                value: meetingProvider.selectedMentor,
                                items: [
                                  for (int i = 0; i < (counsellorProvider.allMentorData?.data?.length ?? 0); i++)
                                  DropdownMenuItem(value: counsellorProvider.allMentorData?.data?[i].email, child: Text(counsellorProvider.allMentorData?.data?[i].fullName ?? '')),
                                ],
                                onChanged: (v) {
                                  meetingProvider.selectedMentor = v;
                                },
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Counsellor'),
                                value: meetingProvider.selectedCounsellor,
                                items: [
                                  for(int i = 0; i < (counsellorProvider.allCounsellorData?.data?.length ?? 0); i++)
                                  DropdownMenuItem(value: counsellorProvider.allCounsellorData?.data?[i].email, child: Text(counsellorProvider.allCounsellorData?.data?[i].fullName ?? '')),
                                ],
                                onChanged: (v) {
                                  meetingProvider.selectedCounsellor = v;
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                try {
                                  provider.requestMeeting();
                                } catch (_) {}
                                final summary = 'Project: ${meetingProvider.selectedProject ?? "-"}, Mentor: ${meetingProvider.selectedMentor ?? "-"}, Counsellor: ${meetingProvider.selectedCounsellor ?? "-"}';
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meeting requested. $summary')));
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
              icon: const Icon(Icons.add_circle_outline, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              label: const Text('Request Meeting', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          );
          })
        ],
      ),
    );
  }


  Widget _buildSectionTitle(String title, int count, {Widget? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildMiniPlaceholder(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline, color: Colors.blue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMeetingCard(
    BuildContext context,
    StudentMeetingProvider provider,
    Datum meeting,
  ) {
    final date = _parseMeetingDate(meeting.dateTime);
    final formattedDate = date != null ? DateFormat('EEE, dd MMM • hh:mm a').format(date) : 'Date TBD';
    final displayDate = meeting.dateTime ?? formattedDate;
    final status = meeting.status ?? 'Scheduled';
    final Color statusColor = _statusColor(status);
    final meetingType = meeting.meetingType ?? 'Mentor Session';
    final purpose = meeting.purpose ?? 'Guided discussion';
    final assignedStudent = meeting.assignedStudents ?? 'You';
    final createdBy = meeting.linkCreatedBy ?? 'Counsellor';
    final duration = meeting.duration ?? '30 mins';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 20,
            offset: const Offset(0, 12),
          )
        ],
      ),
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
                      purpose,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        meetingType,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayDate,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                duration,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.people_alt_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Student: $assignedStudent',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.verified_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Created by $createdBy',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.link_outlined, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meeting.meetingLink!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 13, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchMeetingLink(meeting.meetingLink),
                  icon: const Icon(Icons.play_circle_outline),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  label: const Text('Join'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastMeetingCard(
    BuildContext context,
    StudentMeetingProvider provider,
    Datum meeting,
  ) {
    final date = _parseMeetingDate(meeting.dateTime);
    final formattedDate = date != null ? DateFormat('dd MMM yyyy • hh:mm a').format(date) : 'Date unavailable';
    final displayDate = meeting.dateTime ?? formattedDate;
    final status = meeting.status ?? 'Completed';
    final Color statusColor = _statusColor(status);
    final meetingType = meeting.meetingType ?? 'Mentor Session';
    final purpose = meeting.purpose ?? 'Session with counsellor';
    final assignedStudent = meeting.assignedStudents ?? 'You';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  purpose,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  displayDate,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Student: $assignedStudent',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.category_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  meetingType,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: index == 0 ? 180 : 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [Colors.grey.shade200, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(StudentMeetingProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.fetchMeetings(forceRefresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(StudentMeetingProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No meetings yet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ready to connect with your mentor? Start by requesting a session.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show a simple static dialog with fixed options
                // final projectList = ['Project A', 'Project B', 'Project C'];
                // final mentorList = ['Mentor X', 'Mentor Y'];
                // final counsellorList = ['Counsellor 1', 'Counsellor 2'];

                // String? selectedProject;
                // String? selectedMentor;
                // String? selectedCounsellor;

                showDialog(
                  context: context,
                  builder: (ctx) {
                    return StatefulBuilder(builder: (ctx, setState) {
                      return Consumer3<StudentProfileProvider, StudentMeetingProvider, CounsellorProvider>(builder: (context, pvd, meetingProvider, counsellorProvider, child) {
                          final data = pvd.studentProfile?.data?.assignedProjects;
                          return AlertDialog(
                          title: const Text('Request Meeting'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: meetingProvider.titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Meeting Title',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                TextFormField(
                                  controller: meetingProvider.messageController,
                                  decoration: const InputDecoration(
                                    labelText: 'Message',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(labelText: 'Project'),
                                  value: meetingProvider.selectedProject,
                                  items: [
                                    for(int i = 0; i < (data?.length ?? 0); i++)
                                    DropdownMenuItem(value: data?[i].title, child: Text(data?[i].title ?? '')),
                                  ],
                                  onChanged: (v) {
                                    meetingProvider.selectedProject = v;
                                  },
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(labelText: 'Mentor'),
                                  value: meetingProvider.selectedMentor,
                                  items: [
                                    for (int i = 0; i < (counsellorProvider.allMentorData?.data?.length ?? 0); i++)
                                    DropdownMenuItem(value: counsellorProvider.allMentorData?.data?[i].email, child: Text(counsellorProvider.allMentorData?.data?[i].fullName ?? '')),
                                  ],
                                  onChanged: (v) {
                                    meetingProvider.selectedMentor = v;
                                  },
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(labelText: 'Counsellor'),
                                  value: meetingProvider.selectedCounsellor,
                                  items: [
                                    for(int i = 0; i < (counsellorProvider.allCounsellorData?.data?.length ?? 0); i++)
                                    DropdownMenuItem(value: counsellorProvider.allCounsellorData?.data?[i].email, child: Text(counsellorProvider.allCounsellorData?.data?[i].fullName ?? '')),
                                  ],
                                  onChanged: (v) {
                                    meetingProvider.selectedCounsellor = v;
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                try {
                                  provider.requestMeeting();
                                } catch (_) {}
                                final summary = 'Project: ${meetingProvider.selectedProject ?? "-"}, Mentor: ${meetingProvider.selectedMentor ?? "-"}, Counsellor: ${meetingProvider.selectedCounsellor ?? "-"}';
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meeting requested. $summary')));
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        );
                      });
                    });
                  },
                );
              },
              child: const Text('Request Meeting'),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseMeetingDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw).toLocal();
    } catch (_) {
      return null;
    }
  }

  Color _statusColor(String? status) {
    final value = status?.toLowerCase() ?? '';
    if (value.contains('cancel')) return Colors.redAccent;
    if (value.contains('complete') || value.contains('done')) return Colors.green.shade600;
    if (value.contains('live') || value.contains('start')) return AppColors.yellow600;
    return Colors.blueGrey;
  }

  Future<void> _launchMeetingLink(String? url) async {
    if (url == null || url.isEmpty) {
      _showSnack('Meeting link not available');
      return;
    }
    final Uri? uri = Uri.tryParse("https:$url");
    if (uri == null) {
      _showSnack('Invalid meeting link');
      return;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      _showSnack('Unable to open meeting link');
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}