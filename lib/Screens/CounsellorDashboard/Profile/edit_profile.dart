import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellorProfileProvider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AuthProvider>().getProfileApiCallAgain(context);
      context.read<Counsellorprofileprovider>().inputDataFromApi(context.read<AuthProvider>().profileData!);
    });
  }

  @override
  void dispose() {
    context.read<Counsellorprofileprovider>().disposeControllers();
    super.dispose();
  }
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
          'Edit Profile',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer2<Counsellorprofileprovider, AuthProvider>(
        builder: (context, pvd, authPvd, child) {
        return SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: pvd.profileImage != null 
                            ? FileImage(File(pvd.profileImage!.path))
                            : pvd.profileImageUrl != null
                                ? NetworkImage(pvd.profileImageUrl!)
                                : null,
                        child: (pvd.profileImage == null && pvd.profileImageUrl == null)
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: pick profile image
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                pvd.pickProfileImage();
                              },
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                hSpace(height: 18),

                TextFormField(
                  controller: pvd.nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                ),

                hSpace(height: 12),

                TextFormField(
                  readOnly: true,
                  controller: pvd.roleCtrl,
                  decoration: const InputDecoration(labelText: 'Role / Title'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter role' : null,
                ),

                hSpace(height: 12),

                TextFormField(
                  controller: pvd.bioCtrl,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 4,
                ),

                hSpace(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: pvd.emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter email'
                            : null,
                      ),
                    ),
                    wSpace(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: pvd.phoneCtrl,
                        decoration: const InputDecoration(labelText: 'Phone'),
                      ),
                    ),
                  ],
                ),

                // hSpace(height: 12),

                // Row(
                //   children: [
                //     Expanded(
                //       child: TextFormField(
                //         controller: pvd.availabilityDaysCtrl,
                //         decoration: const InputDecoration(
                //           labelText: 'Availability Days',
                //         ),
                //       ),
                //     ),
                //     wSpace(width: 12),
                //     Expanded(
                //       child: TextFormField(
                //         controller: pvd.availabilityTimeCtrl,
                //         decoration: const InputDecoration(
                //           labelText: 'Availability Time',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                hSpace(height: 12),

                Text(
                  'Specialities',
                  style: textStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                hSpace(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pvd.achievements.map((s) => InputChip(
                          label: Text(s),
                          onDeleted: () => setState(() => pvd.achievements.remove(s)))).toList(),
                ),

                hSpace(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    // Add new speciality (simple prompt)
                    final value = await showDialog<String>(
                      context: context,
                      builder: (ctx) {
                        final ctrl = TextEditingController();
                        return AlertDialog(
                          title: const Text('Add Speciality'),
                          content: TextField(
                            controller: ctrl,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Study Skills',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(ctx).pop(ctrl.text.trim()),
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                    if (value != null && value.isNotEmpty)
                      setState(() => pvd.achievements.add(value));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Speciality'),
                ),

                hSpace(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    isLoading: pvd.isBtnLoading,
                    onTap: () {
                      print("Achievements: ${pvd.achievements}");
                      if (_formKey.currentState?.validate() ?? false) {
                        pvd.updateProfileApiTap(context);
                      }
                    },
                    title: "Save")
                ),
              ],
            ),
          ),
        ),
      ); 
      })
    );
  }
}
