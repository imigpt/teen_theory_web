import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_boxes.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_profile_provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Screens/MentorDashboard/MentorMeeting/mentor_meeting.dart';
import 'package:teen_theory/Screens/MentorDashboard/Profile/mentor_profile.dart';
import 'package:teen_theory/Screens/MentorDashboard/Projects/project_details.dart';
import 'package:teen_theory/Screens/MentorDashboard/Tickets/ticket.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/MentorShimmer/assign_project_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({super.key});

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pvd = context.read<MentorProfileProvider>();
      final mentorPvd = context.read<MentorProvider>();
      // First load profile
      await pvd.MentorProfileApiTap(context);
      // Then load projects with the email
      final email = pvd.mentorProfileData?.data?.email;
      if (email != null && email.isNotEmpty) {
        pvd.mentorProjectApiTap(context, email: email);
      }
      // Load meetings
      mentorPvd.allMeetingApiTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: PreferredSize(
      preferredSize: Size(double.infinity, 50),
       child: Consumer<MentorProfileProvider>(
        builder: (context, pvd, child) {
          if (pvd.isProfileLoading) {
            return Text("Loading...");
          }
          final data = pvd.mentorProfileData?.data;
        return AppBar(
        title: Row(
          spacing: 10,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MentorProfilePage()),
                );
              },
              child: data?.profilePhoto == null
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                      ),
                      child: Center(child: Text('👨‍🏫', style: TextStyle(fontSize: 20))),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                        "${Apis.baseUrl}${data!.profilePhoto!}",
                      ),
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?.fullName ?? '',
                  style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Mentor",
                  style: textStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatListScreen()));
          //   },
          //   icon: const Icon(Icons.chat),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.notifications_rounded),
          // ),
        ],
      );
      })),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MentorProfileProvider>().MentorProfileApiTap(context);
          final email = context.read<MentorProfileProvider>().mentorProfileData?.data?.email;
          if (email != null && email.isNotEmpty) {
             context.read<MentorProfileProvider>().mentorProjectApiTap(context, email: email);
          }
           context.read<MentorProvider>().allMeetingApiTap();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: 160, crossAxisCount: 2),
                  children: [
                    CustomBoxes(
                      title: "Active\nProject",
                      imageIcon: AppIcons.openFolder,
                      subtitle: context.watch<MentorProfileProvider>().mentorProjectData?.data?.length.toString() ?? "0",
                    ),
                    CustomBoxes(
                      title: "Pending\nProjects",
                      imageIcon: AppIcons.openFolder,
                      subtitle: context.watch<MentorProfileProvider>().mentorProjectData?.data?.where((element) => element.status != "pending").length.toString() ?? "0",
                    ),
                  ],
                ),
        
                Text(
                  "⚡ Quick Actions",
                  style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Divider(),
                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 120),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => UploadResources(),
                    //       ),
                    //     );
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.all(8),
                    //     padding: EdgeInsets.all(16),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.lightGrey,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(Icons.add, color: Colors.black, size: 30),
                    //         hSpace(height: 10),
                    //         Text(
                    //           "Upload Resources",
                    //           style: textStyle(
                    //             color: Colors.black,
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MentorMeetingScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF758C).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('📅', style: TextStyle(fontSize: 28)),
                            hSpace(height: 8),
                            Text(
                              "Schedule Meeting",
                              style: textStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MentorTicketsPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFA751), Color(0xFFFFE259)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFA751).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🎫', style: TextStyle(fontSize: 28)),
                            hSpace(height: 8),
                            Text(
                              "View Tickets",
                              style: textStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => SendFeedbackPage(),
                    //       ),
                    //     );
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.all(8),
                    //     padding: EdgeInsets.all(16),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.lightGrey,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         ImageIcon(
                    //           AssetImage(AppIcons.ticketCircleIcon),
                    //           color: Colors.black,
                    //           size: 30,
                    //         ),
                    //         hSpace(height: 10),
                    //         Text(
                    //           "My Meetings",
                    //           style: textStyle(
                    //             color: Colors.black,
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "📁 Assigned Projects",
                      style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    // Text(
                    //   "View All",
                    //   style: textStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: Colors.blue,
                    //   ),
                    // ),
                  ],
                ),
                Divider(),
                Consumer<MentorProfileProvider>(
                  builder: (context, pvd, child) {
                    if(pvd.mentorProjectLoading){
                      return AssignProjectShimmer();
                    }
                    if(pvd.mentorProjectData == null || pvd.mentorProjectData!.data!.isEmpty){
                      return Center(child: Text("No Projects Assigned"));
                    }
                    
                    final data = pvd.mentorProjectData!.data!;
                    return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Projectdata = pvd.mentorProjectData?.data?[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetails(projectData: Projectdata)));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
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
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF6DD5FA).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text('📁', style: TextStyle(fontSize: 24)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Projectdata?.title ?? "Project Title",
                                    style: textStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    Projectdata?.projectDescription ?? "-",
                                    style: textStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                );
                }),
                hSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "📅 Meetings",
                      style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    // Text(
                    //   "View all",
                    //   style: textStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: Colors.blue,
                    //   ),
                    // ),
                  ],
                ),
                Divider(),
        
                Consumer<MentorProvider>(
                  builder: (context, mentorPvd, child) {
                    if (mentorPvd.allMeetingLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
        
                    if (mentorPvd.allMeetingData == null ||
                        mentorPvd.allMeetingData!.data == null ||
                        mentorPvd.allMeetingData!.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "No Meetings Scheduled",
                            style: textStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
        
                    final meetings = mentorPvd.allMeetingData!.data!;
                    return ListView.builder(
                      itemCount: meetings.length > 3 ? 3 : meetings.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final meeting = meetings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Color(0xFFF8F9FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: meeting.status?.toLowerCase() == 'pending'
                                  ? Color(0xFFFF758C).withValues(alpha: 0.3)
                                  : Colors.grey.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: meeting.status?.toLowerCase() == 'pending'
                                        ? [Color(0xFFFF758C), Color(0xFFFF7EB3)]
                                        : meeting.status?.toLowerCase() == 'completed'
                                            ? [Color(0xFF56CCF2), Color(0xFF2F80ED)]
                                            : [Color(0xFFD3D3D3), Color(0xFFA9A9A9)],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (meeting.status?.toLowerCase() == 'pending'
                                              ? Color(0xFFFF758C)
                                              : Color(0xFF56CCF2))
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '📊',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meeting.title ?? 'Meeting',
                                      style: textStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      meeting.projectName ?? 'No Project',
                                      style: textStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text('📅 ', style: TextStyle(fontSize: 12)),
                                        Text(
                                          meeting.dateTime != null
                                              ? meeting.dateTime!
                                              : 'No Date',
                                          style: textStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (meeting.meetingLink != null && meeting.meetingLink!.isNotEmpty && meeting.status != "completed")
                                Consumer<DetailProjectProvider>(
                                  builder: (context, pvd, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        print("Joining meeting link: https:${meeting.meetingLink ?? ""}");
                                      await pvd.openMeetLink(link: "https:${meeting.meetingLink ?? ""}");
                                      },
                                      icon: const Icon(
                                        Icons.videocam,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      tooltip: 'Join Meeting',
                                    ),
                                  ); 
                                })
                                else 
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                    child: Text(
                                      "Done",
                                      style: textStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
