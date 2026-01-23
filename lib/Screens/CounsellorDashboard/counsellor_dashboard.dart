import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_boxes.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/ApprovedTasks/approved_tasks.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CounsellorNotification/counsellor_notification.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/create_project_main.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/Meetings/meeting.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/Profile/counsellor_profile.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/ProjectDetails/project_detail.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/RecentStudent/details_recent_student.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/Tickets/ticket.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/CounsellorShimmer/project_shimmer.dart';
import 'package:teen_theory/Shimmer/CounsellorShimmer/recent_student_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';

class CounsellorDashboard extends StatefulWidget {
  const CounsellorDashboard({super.key});

  @override
  State<CounsellorDashboard> createState() => _CounsellorDashboardState();
}

class _CounsellorDashboardState extends State<CounsellorDashboard> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _projectsKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CounsellorProvider>().allStundentsApiTap(context);
      context.read<CounsellorProvider>().getAllMyProjectsApiTap(context);
      context.read<MentorProvider>().allTicketApiTap();
      context.read<CounsellorProvider>().fetchCounsellorMeetingsTap();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: PreferredSize(preferredSize: Size(double.infinity, 40), 
      child: Consumer<AuthProvider>(builder: (context, pvd, child) {
        if(pvd.isLoading){
          return AppBar(
            title: Text("Loading..."),
          );
        }
        
        return AppBar(
        title: Row(
          spacing: 10,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CounsellorProfilePage()),
                );
              },
              child: CachedNetworkImage(
                imageUrl:  "${Apis.baseUrl}${pvd.profileData!.data!.profilePhoto}",
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 20,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: LoadingAnimationWidget.fallingDot(color: Colors.grey, size: 16),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 20,
                  child: Stack(
                    children: [
                      Icon(Icons.person, size: 24),
                      CircleAvatar(
                        radius: 8,
                        child: Text("!"),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pvd.profileData?.data?.fullName ?? "Counsellor Name",
                  style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Chief Counsellor",
                  style: textStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CounsellorNotificationListPage()));
                },
                icon: const Icon(Icons.notifications_none, size: 22),
              ),
            ),
          ),
        ],
      );
      })),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.wait([
            Future.sync(() => context.read<CounsellorProvider>().allStundentsApiTap(context)),
            Future.sync(() => context.read<CounsellorProvider>().getAllMyProjectsApiTap(context)),
          ]);
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<CounsellorProvider>(
                  builder: (context, pvd, child) {
                    return GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: 160, crossAxisCount: 2),
                  children: [
                    CustomBoxes(
                      onTap: _scrollToProjects,
                      title: "Active\nProject",
                      imageIcon: AppIcons.openFolder,
                      subtitle: pvd.allMyProjectData?.data?.length.toString() ?? "0",
                    ),
                    CustomBoxes(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApprovedTasksPage()));
                      },
                      title: "Pending\nTasks",
                      imageIcon: AppIcons.openFolder,
                      subtitle: "0",
                    ),
                    CustomBoxes(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MeetingsPage(),));
                      },
                      title: "Meetings",
                      imageIcon: AppIcons.openFolder,
                      subtitle: pvd.counsellorMeetingData?.data?.length.toString() ?? "0",
                    ),
                    CustomBoxes(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TicketsPage()));
                      },
                      title: "Total\nTickets",
                      imageIcon: AppIcons.openFolder,
                      subtitle: context.watch<MentorProvider>().allTicketData?.data?.length.toString() ?? "0",
                    ),
                  ],
                );
                }),
        
                Text(
                  "⚡ Quick Actions",
                  style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Divider(),
                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 120),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateProjectMain(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF6DD5FA).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('➕', style: TextStyle(fontSize: 28)),
                            hSpace(height: 8),
                            Text(
                              "Create Project",
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MeetingsPage()));
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
                          MaterialPageRoute(builder: (context) => TicketsPage()),
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
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ApprovedTasksPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF56CCF2).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('✅', style: TextStyle(fontSize: 28)),
                            hSpace(height: 8),
                            Text(
                              "Approved Tasks",
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🎓 Recent Students",
                      style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "View All",
                      style: textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Consumer<CounsellorProvider>(builder: (context, pvd, child) {
                  if(pvd.isLoadingStudents) {
                    return RecentStudentShimmer();
                  }
                  if(pvd.allStudentData == null || pvd.allStudentData!.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Students Found",
                        style: textStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }
        
                  final students = pvd.allStudentData?.data;
                  return ListView.builder(
                  itemCount: students!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                  final student = students[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StudentDetailScreen(student: student),
                            ),
                          );
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              students[index].fullName ?? "N/A",
                              style: textStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(students[index].school ?? "N/A", style: textStyle()),
                            // hSpace(),
                            // LinearProgressIndicator(
                            //   minHeight: 6,
                            //   borderRadius: BorderRadius.circular(3),
                            //   value: (students[index].assignedProjects?.length ?? 0) / students[index].as,
                            //   color: AppColors.yellow600,
                            //   backgroundColor: AppColors.lightGrey,
                            // ),
                            hSpace(height: 4),
                            Text(
                              students[index].location ?? "",
                              style: textStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                          leading: students[index].profilePhoto == null
                            ? CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.person),
                            )
                            : CachedNetworkImage(
                              imageUrl: "${Apis.baseUrl}${students[index].profilePhoto}",
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 24,
                              backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey.shade200,
                              child: LoadingAnimationWidget.fallingDot(
                                color: Colors.grey,
                                size: 16,
                              ),
                              ),
                              errorWidget: (context, url, error) => CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.person),
                              ),
                            ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      ),
                    );
                  },
                );
                }),
                hSpace(),
        
                Container(
                  key: _projectsKey,
                  child: Text(
                    "📁 Projects",
                    style: textStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(),
        
               Consumer<CounsellorProvider>(
                builder: (context, pvd, child) {
                  if(pvd.myProjectsLoading){
                    return ProjectShimmer();
                  }
        
                final my_project = pvd.allMyProjectData?.data;
        
                if(my_project == null || my_project.isEmpty) {
                  return Center(
                    child: Text(
                      "No Projects Created",
                      style: textStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }
        
                 return  ListView.builder(
                  itemCount: my_project.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final projects = my_project[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetailScreen(
                          projects: projects,
                        )));
                      },
                      title: Text(
                        projects.title ?? "No Title",
                        style: textStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        projects.projectDescription ?? "No Description",
                        style: textStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Icon(
                        CupertinoIcons.folder,
                        color: Colors.black,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    );
                  },
                );
               })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToProjects() {
    final context = _projectsKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      alignment: 0,
    );
  }
}
