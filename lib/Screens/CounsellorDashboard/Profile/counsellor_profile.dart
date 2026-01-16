import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Screens/Auth/login_screen.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/Profile/edit_profile.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Shimmer/CounsellorShimmer/counsellor_profile_shimmer.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class CounsellorProfilePage extends StatefulWidget {
  const CounsellorProfilePage({Key? key}) : super(key: key);

  @override
  State<CounsellorProfilePage> createState() => _CounsellorProfilePageState();
}

class _CounsellorProfilePageState extends State<CounsellorProfilePage> {

@override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().getProfileApiTapAgain(context);
    });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Counsellor Profile',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder:(context, pvd, child) {
          if(pvd.isLoading) {
            return CounsellorProfileShimmer();
          }
          final profileData = pvd.profileData?.data;
          return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 88,
                    height: 88,
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
                    child:  Center(
                      child: Builder(
                        builder: (context) {
                          final imageUrl = profileData?.profilePhoto != null 
                              ? "${Apis.baseUrl}${profileData!.profilePhoto}" 
                              : "";
                          
                          // Debug print
                          print("Profile Image URL: $imageUrl");
                          
                          if (imageUrl.isEmpty) {
                            return Text(
                              '👨‍💼',
                              style: TextStyle(fontSize: 44),
                            );
                          }
                          
                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 44,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.grey.shade200,
                              child: LoadingAnimationWidget.fallingDot(color: Colors.grey, size: 24),
                            ),
                            errorWidget: (context, url, error) {
                              print("Image load error: $error");
                              return CircleAvatar(
                                radius: 44,
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(Icons.person, size: 48, color: Colors.grey.shade400),
                              );
                            },
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileData?.fullName ?? "N/A",
                          style: textStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        hSpace(height: 6),
                        Text(
                          'Senior ${profileData?.userRole ?? "N/A"}',
                          style: textStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        hSpace(height: 8),
                      ],
                    ),
                  ),
                ],
              ),

              // spacing
              hSpace(height: 18),

              // About / Bio
              Text(
                'About',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Text(
                profileData?.aboutMe ?? "No bio available.",
                style: textStyle(fontSize: 14, color: Colors.grey.shade800),
              ),

              hSpace(height: 16),

              // Contact & Availability
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: 'Contact',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                profileData?.email ?? "N/A",
                                style: textStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          hSpace(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                profileData?.phoneNumber ?? "N/A",
                                style: textStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // wSpace(width: 12),
                  // Expanded(
                  //   child: _infoCard(
                  //     title: 'Availability',
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Mon - Fri',
                  //           style: textStyle(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //         hSpace(height: 6),
                  //         Text(
                  //           '9:00 AM - 5:00 PM',
                  //           style: textStyle(fontSize: 13),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              hSpace(height: 16),

              // Specialities / Tags
              Text(
                'Specialities',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for(int i = 0; i < (profileData?.achievements?.length ?? 0); i++)
                    _chip(profileData!.achievements![i].title ?? 'N/A'),
                ],
              ),

              hSpace(height: 18),

              // Reviews
              // Text(
              //   'Recent Reviews',
              //   style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              // ),
              // hSpace(height: 8),
              // _reviewItem(
              //   'Riya Shah',
              //   'Great mentor — helped structure my essay clearly.',
              //   'Oct 10, 2025',
              // ),
              // const Divider(),
              // _reviewItem(
              //   'Alex Johnson',
              //   'Very helpful feedback and follow-up resources.',
              //   'Sep 28, 2025',
              // ),

              hSpace(height: 18),

              // Actions
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('✏️', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text(
                          'Edit Profile',
                          style: textStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              hSpace(height: 12),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6B6B).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: ()  async{
                      await SharedPref.clearAll();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚪', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: textStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      })
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('📧', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                title,
                style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          hSpace(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
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
        label,
        style: textStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
