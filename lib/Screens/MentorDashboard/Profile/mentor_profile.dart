import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_profile_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Screens/Auth/login_screen.dart';
import 'package:teen_theory/Screens/MentorDashboard/Profile/edit_mentor_profile.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/MentorShimmer/mentor_profile_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class MentorProfilePage extends StatefulWidget {
  const MentorProfilePage({Key? key}) : super(key: key);

  @override
  State<MentorProfilePage> createState() => _MentorProfilePageState();
}

class _MentorProfilePageState extends State<MentorProfilePage> {
initState() {
    super.initState();
    // Any initialization if needed
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    context.read<MentorProfileProvider>().MentorProfileApiTap(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: ()  async {
              await SharedPref.clearAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditMentorProfile(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F7FA),
      body: Consumer<MentorProfileProvider>(
        builder: (context, pvd, child) {
          if(pvd.isProfileLoading){
            return MentorProfileShimmer();
          }

          final mentorProfile = pvd.mentorProfileData?.data;

          return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF667EEA).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: mentorProfile?.profilePhoto == null
                            ? Center(
                                child: Text(
                                  '👨‍🏫',
                                  style: TextStyle(fontSize: 44),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: "${Apis.baseUrl}${mentorProfile!.profilePhoto}",
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Center(child: SizedBox(width: 24, height: 24, child: LoadingAnimationWidget.inkDrop(color: Colors.purple, size: 18))),
                                errorWidget: (context, url, error) =>
                                    Center(child: Icon(Icons.person, size: 54, color: Colors.black54)),
                              ),
                      ),
                    ),
                    hSpace(height: 12),
                    Text(
                      mentorProfile?.fullName ?? '',
                      style: textStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    hSpace(height: 6),
                    Text(
                      mentorProfile?.userRole ?? '',
                      style: textStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              hSpace(height: 20),

              Text(
                'About',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Text(
                mentorProfile?.aboutMe ?? 'No Bio available.',
                style: textStyle(color: Colors.black87),
              ),

              hSpace(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('📧', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 8),
                                Text(
                                  'Contact',
                                  style: textStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            hSpace(height: 8),
                            Text(
                              mentorProfile?.email ?? '',
                              style: textStyle(color: Colors.black54),
                            ),
                            hSpace(height: 6),
                            Text(
                              mentorProfile?.phoneNumber ?? '',
                              style: textStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  wSpace(width: 12),
                ],
              ),

              hSpace(height: 16),

              // Shift Time Card
              Container(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('⏰', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8),
                          Text(
                            'Shift Timing',
                            style: textStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                      hSpace(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Time',
                                  style: textStyle(fontSize: 12, color: Colors.black45),
                                ),
                                hSpace(height: 4),
                                Text(
                                  mentorProfile?.start_shift_time ?? 'Not set',
                                  style: textStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          wSpace(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Time',
                                  style: textStyle(fontSize: 12, color: Colors.black45),
                                ),
                                hSpace(height: 4),
                                Text(
                                  mentorProfile?.end_shift_time ?? 'Not set',
                                  style: textStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              hSpace(height: 16),

              Text(
                'Specialities',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for(int i = 0; i < (mentorProfile?.expertise?.length ?? 0); i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6DD5FA).withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        mentorProfile?.expertise?[i] ?? '',
                        style: textStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ]
              ),

              hSpace(height: 20),

              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              //           ),
              //           borderRadius: BorderRadius.circular(12),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Color(0xFF667EEA).withValues(alpha: 0.4),
              //               blurRadius: 12,
              //               offset: Offset(0, 4),
              //             ),
              //           ],
              //         ),
              //         child: ElevatedButton(
              //           onPressed: () {
              //             // message action
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(content: Text('Message action')),
              //             );
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.transparent,
              //             shadowColor: Colors.transparent,
              //             padding: const EdgeInsets.symmetric(vertical: 14),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text('💬', style: TextStyle(fontSize: 18)),
              //               SizedBox(width: 8),
              //               Text(
              //                 'Message',
              //                 style: textStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     wSpace(width: 12),
              //     Expanded(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)],
              //           ),
              //           borderRadius: BorderRadius.circular(12),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Color(0xFFFF758C).withValues(alpha: 0.4),
              //               blurRadius: 12,
              //               offset: Offset(0, 4),
              //             ),
              //           ],
              //         ),
              //         child: ElevatedButton(
              //           onPressed: () {
              //             // book meeting action
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(content: Text('Book Meeting')),
              //             );
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.transparent,
              //             shadowColor: Colors.transparent,
              //             padding: const EdgeInsets.symmetric(vertical: 14),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text('📅', style: TextStyle(fontSize: 18)),
              //               SizedBox(width: 8),
              //               Text(
              //                 'Book Meeting',
              //                 style: textStyle(fontWeight: FontWeight.w600, color: Colors.white),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      );
      })
    );
  }
}
