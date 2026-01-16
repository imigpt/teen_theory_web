import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Customs/custom_textfield.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class StudentEditProfile extends StatefulWidget {
  const StudentEditProfile({super.key});

  @override
  State<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StudentProfileProvider>().getStudentProfileApiTap(context);
      context.read<StudentProfileProvider>().initializeStudentProfileData(context.read<StudentProfileProvider>().studentProfile!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: textStyle(
            fontFamily: AppFonts.interBold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<StudentProfileProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.lightGrey,
                        backgroundImage: provider.profileImage != null
                            ? FileImage(File(provider.profileImage!.path))
                            : ((provider.studentProfile?.data?.profilePhoto ?? '').isNotEmpty)
                                ? NetworkImage('${Apis.baseUrl}${provider.studentProfile?.data?.profilePhoto ?? ''}')
                                : null,
                        child: (provider.profileImage == null && (provider.studentProfile?.data?.profilePhoto ?? '').isEmpty)
                            ? Text(
                                provider.getInitials(),
                                style: textStyle(
                                  fontSize: 36,
                                  fontFamily: AppFonts.interBold,
                                  color: AppColors.black,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => provider.pickProfileImage(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                hSpace(height: 24),
    
                // Personal Information Section
                Text(
                  'Personal Information',
                  style: textStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.interBold,
                  ),
                ),
                hSpace(height: 16),
    
                CustomTextfield(
                  controller: provider.nameController,
                  headerText: 'Full Name',
                ),
                hSpace(height: 12),
    
                CustomTextfield(
                  readOnly: true,
                  controller: provider.emailController,
                  headerText: 'Email',
                ),
                hSpace(height: 12),
    
                CustomTextfield(
                  controller: provider.phoneController,
                  headerText: 'Phone Number',
                ),
                hSpace(height: 12),
    
                CustomTextfield(
                  controller: provider.ageController,
                  headerText: 'Age',
                ),
                hSpace(height: 12),
    
                CustomTextfield(
                  controller: provider.addressController,
                  headerText: 'Address',
                ),
                hSpace(height: 24),
    
                // Academic Information Section
                Text(
                  'Academic Information',
                  style: textStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.interBold,
                  ),
                ),
                hSpace(height: 16),
    
                CustomTextfield(
                  controller: provider.schoolController,
                  headerText: 'School Name',
                ),
                hSpace(height: 12),
    
                CustomTextfield(
                  controller: provider.gradeController,
                  headerText: 'Grade',
                ),
                hSpace(height: 24),
    
                // Activities Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Activities',
                      style: textStyle(
                        fontSize: 18,
                        fontFamily: AppFonts.interBold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => provider.addActivity(),
                      icon: const Icon(Icons.add_circle, color: AppColors.black),
                    ),
                  ],
                ),
                hSpace(height: 12),
    
                ...List.generate(provider.editableActivities.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextfield(
                            controller: provider.activityControllers[index],
                            headerText: 'Activity ${index + 1}',
                          ),
                        ),
                        wSpace(width: 8),
                        IconButton(
                          onPressed: () => provider.removeActivity(index),
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }),
                hSpace(height: 24),
    
                // Achievements Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Achievements',
                      style: textStyle(
                        fontSize: 18,
                        fontFamily: AppFonts.interBold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => provider.addAchievement(),
                      icon: const Icon(Icons.add_circle, color: AppColors.black),
                    ),
                  ],
                ),
                hSpace(height: 12),
    
                ...List.generate(provider.editableAchievements.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Achievement ${index + 1}',
                                style: textStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => provider.removeAchievement(index),
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        hSpace(height: 8),
                        CustomTextfield(
                          controller: provider.achievementTitleControllers[index],
                          headerText: 'Title',
                        ),
                        hSpace(height: 8),
                        CustomTextfield(
                          controller: provider.achievementDescriptionControllers[index],
                          headerText: 'Description',
                        ),
                        hSpace(height: 8),
                        CustomTextfield(
                          controller: provider.achievementDateControllers[index],
                          headerText: 'Date',
                        ),
                      ],
                    ),
                  );
                }),
                hSpace(height: 32),
    
                // Save Button
                CustomButton(
                  title: 'Save Changes',
                  isLoading: provider.updateProfileLoading,
                  onTap: () {
                    provider.updateProfileApiTap(context);
                  },
                ),
                hSpace(height: 16),
    
                // Cancel Button
                CustomButton(
                  title: 'Cancel',
                  bgColor: Colors.grey.shade200,
                  titleColor: AppColors.white,
                  isEnabled: !provider.isSaving,
                  onTap: () => Navigator.of(context).pop(),
                ),
                hSpace(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
