import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:teen_theory/Models/CounsellorModels/counsellor_meeting_model.dart';
import 'package:teen_theory/Models/CounsellorModels/multi_user_meeting_model.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/create_meeting.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({Key? key}) : super(key: key);

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> with SingleTickerProviderStateMixin {
  String? _errorMessage;
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch meetings and projects
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CounsellorProvider>();
      provider.fetchCounsellorMeetingsTap();
      provider.fetchMyMeetingsTap();
      provider.getAllMyProjectsApiCall();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // provider handles fetching meetings

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF2980B9),
        label: Text("Create Meeting"), onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMeetingScreen()));
        }),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w400),
          tabs: const [
            Tab(text: 'All Meetings'),
            Tab(text: 'My Meetings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllMeetingsTab(),
          _buildMyMeetingsTab(),
        ],
      ),
    );
  }

  // All Meetings Tab
  Widget _buildAllMeetingsTab() {
    return Consumer<CounsellorProvider>(
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
    );
  }

  // My Meetings Tab
  Widget _buildMyMeetingsTab() {
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
        return RefreshIndicator(
          onRefresh: () async => await pvd.fetchMyMeetings(),
          child: pvd.myMeetingsLoading
              ? Center(
                  child: LoadingAnimationWidget.fallingDot(
                    color: Colors.black,
                    size: 50,
                  ),
                )
              : pvd.myMeetingsError != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${pvd.myMeetingsError}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => pvd.fetchMyMeetingsTap(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _buildMyMeetingsContent(pvd.myMeetingsData?.data ?? []),
        );
      },
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

  // Build My Meetings Content
  Widget _buildMyMeetingsContent(List<Datum> myMeetings) {
    if (myMeetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey),
            hSpace(height: 16),
            Text(
              'No meetings created yet',
              style: textStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: ListView.separated(
        itemCount: myMeetings.length,
        separatorBuilder: (_, __) => hSpace(height: 12),
        itemBuilder: (context, index) {
          final meeting = myMeetings[index];
          return _buildMyMeetingCard(context, meeting);
        },
      ),
    );
  }

  // Build My Meeting Card
  Widget _buildMyMeetingCard(BuildContext context, Datum meeting) {
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
                        meeting.meetingTitle ?? 'No Title',
                        style: textStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      hSpace(height: 8),
                      if (meeting.meetingDescription != null && meeting.meetingDescription!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.description, size: 14, color: Colors.grey.shade600),
                            wSpace(width: 6),
                            Expanded(
                              child: Text(
                                meeting.meetingDescription!,
                                style: textStyle(fontSize: 13, color: Colors.grey.shade700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        hSpace(height: 4),
                      ],
                      if (meeting.createdAt != null) ...[
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                            wSpace(width: 6),
                            Text(
                              DateFormat('MMM dd, yyyy • hh:mm a').format(meeting.createdAt!),
                              style: textStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        hSpace(height: 8),
                      ],
                      // Participant counts
                      Row(
                        children: [
                          if (meeting.studentEmails != null && meeting.studentEmails!.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF6DD5FA).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${meeting.studentEmails!.length} Students',
                                style: textStyle(fontSize: 11, color: Color(0xFF2980B9), fontWeight: FontWeight.w500),
                              ),
                            ),
                            wSpace(width: 6),
                          ],
                          if (meeting.mentorEmails != null && meeting.mentorEmails!.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF667EEA).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${meeting.mentorEmails!.length} Mentors',
                                style: textStyle(fontSize: 11, color: Color(0xFF667EEA), fontWeight: FontWeight.w500),
                              ),
                            ),
                            wSpace(width: 6),
                          ],
                          if (meeting.parentEmails != null && meeting.parentEmails!.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFA751).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${meeting.parentEmails!.length} Parents',
                                style: textStyle(fontSize: 11, color: Color(0xFFFF6B35), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                wSpace(width: 12),
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
                        color: badgeGradient[0].withValues(alpha: 0.4),
                        blurRadius: 8,
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

            // Join Meeting button
            if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty)
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
                      try {
                        String urlString = meeting.meetingLink!;
                        if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
                          urlString = 'https://$urlString';
                        }
                        final url = Uri.parse(urlString);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          showToast('Could not launch meeting link', type: toastType.error);
                        }
                      } catch (e) {
                        showToast('Invalid meeting link', type: toastType.error);
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
