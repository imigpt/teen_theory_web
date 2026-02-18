import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_profile_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Services/apis.dart';
import 'package:teen_theory/Utils/helper.dart';

class EditMentorProfile extends StatefulWidget {
  const EditMentorProfile({Key? key}) : super(key: key);

  @override
  State<EditMentorProfile> createState() => _EditMentorProfileState();
}

class _EditMentorProfileState extends State<EditMentorProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentorProfileProvider>().initializeEditForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: AppColors.white,
      body: Consumer<MentorProfileProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Picker
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              image: provider.profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(File(provider.profileImage!.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : provider.mentorProfileData?.data?.profilePhoto != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              "${Apis.baseUrl}${provider.mentorProfileData!.data!.profilePhoto!}"),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                            child: provider.profileImage == null &&
                                    provider.mentorProfileData?.data?.profilePhoto == null
                                ? const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 54,
                                      color: Colors.black54,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => provider.pickProfileImage(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    hSpace(height: 24),

                    // Full Name Field
                    Text(
                      'Full Name',
                      style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    hSpace(height: 8),
                    TextFormField(
                      controller: provider.fullNameCtrl,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    hSpace(height: 16),

                    // Phone Number Field
                    Text(
                      'Phone Number',
                      style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    hSpace(height: 8),
                    TextFormField(
                      controller: provider.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.blue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.trim().length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),

                    hSpace(height: 16),

                    // About Me Field
                    Text(
                      'About Me',
                      style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    hSpace(height: 8),
                    TextFormField(
                      controller: provider.aboutMeCtrl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Tell us about yourself...',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.blue),
                        ),
                      ),
                    ),

                    hSpace(height: 16),

                    // Expertise Section
                    Text(
                      'Expertise',
                      style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    hSpace(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: provider.expertiseInputCtrl,
                            decoration: InputDecoration(
                              hintText: 'Add expertise',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.blue),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              provider.addExpertise(value);
                            },
                          ),
                        ),
                        wSpace(width: 8),
                        IconButton(
                          onPressed: () {
                            provider.addExpertise(provider.expertiseInputCtrl.text);
                          },
                          icon: const Icon(Icons.add_circle, color: AppColors.blue),
                          iconSize: 32,
                        ),
                      ],
                    ),
                    hSpace(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (int i = 0; i < provider.expertise.length; i++)
                          Chip(
                            label: Text(
                              provider.expertise[i],
                              style: textStyle(
                                color: Colors.blue.shade900,
                                fontSize: 13,
                              ),
                            ),
                            backgroundColor: Colors.blue.shade50,
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => provider.removeExpertise(i),
                          ),
                      ],
                    ),

                    hSpace(height: 24),

                    // Shift Time Section
                    Text(
                      'Meeting Availability',
                      style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                                style: textStyle(fontSize: 12, color: Colors.black54),
                              ),
                              hSpace(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: provider.startShiftTime ?? TimeOfDay(hour: 9, minute: 0),
                                  );
                                  if (picked != null) {
                                    provider.setStartShiftTime(picked);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        provider.startShiftTime != null
                                            ? provider.formatTimeOfDay(provider.startShiftTime)
                                            : 'Select',
                                        style: textStyle(
                                          color: provider.startShiftTime != null
                                              ? Colors.black87
                                              : Colors.black45,
                                        ),
                                      ),
                                      Icon(Icons.access_time, color: AppColors.blue, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        wSpace(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Time',
                                style: textStyle(fontSize: 12, color: Colors.black54),
                              ),
                              hSpace(height: 6),
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: provider.endShiftTime ?? TimeOfDay(hour: 17, minute: 0),
                                  );
                                  if (picked != null) {
                                    provider.setEndShiftTime(picked);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        provider.endShiftTime != null
                                            ? provider.formatTimeOfDay(provider.endShiftTime)
                                            : 'Select',
                                        style: textStyle(
                                          color: provider.endShiftTime != null
                                              ? Colors.black87
                                              : Colors.black45,
                                        ),
                                      ),
                                      Icon(Icons.access_time, color: AppColors.blue, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    hSpace(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isUpdating
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  // Update profile first
                                  provider.mentorProfileUpdateApiTap(context);
                                  // Then update shift time
                                  await provider.updateShiftTimeApiTap(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: provider.isUpdating
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: textStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
