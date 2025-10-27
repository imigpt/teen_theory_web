import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Customs/custom_dropdown.dart';
import 'package:teen_theory/Customs/custom_textfield.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Resources/assets.dart';
import 'package:teen_theory/Screens/ParentDashboard/parent_dashboard.dart';
import 'package:teen_theory/Screens/StudentDashboard/student_home.dart';
import 'package:teen_theory/Utils/helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, pvd, child) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hSpace(height: 50),
                    Text(
                      "Login",
                      style: textStyle(
                        fontFamily: AppFonts.interBold,
                        fontSize: 30,
                      ),
                    ),
                    Text("Login to Continue", style: textStyle()),
                    hSpace(height: 30),
                    CustomTextfield(
                      controller: pvd.emailController,
                      headerText: "Email Address:",
                    ),
                    hSpace(),
                    CustomTextfield(
                      controller: pvd.passwordController,
                      headerText: "Password:",
                    ),
                    hSpace(),
                    CustomDropdown(
                      headerText: "What is your role?",
                      items: [
                        DropdownMenuItem(
                          value: "Student",
                          child: Text("Student"),
                        ),
                        DropdownMenuItem(
                          value: "Teacher",
                          child: Text("Teacher"),
                        ),
                      ],
                      initialValue: "Student",
                      onChanged: (value) {
                        // Handle role change
                      },
                    ),
                    hSpace(height: 25),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onTap: () {
                          if (pvd.emailController.text.contains("student")) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const StudentHome(),
                              ),
                              (route) => false,
                            );
                          } else if (pvd.emailController.text.contains(
                            "parent",
                          )) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const ParentDashboard(),
                              ),
                              (route) => false,
                            );
                          } else {
                            return null;
                          }
                        },
                        title: "Login",
                      ),
                    ),
                    hSpace(height: 20),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Or Login with", style: textStyle()),
                        ),
                        Flexible(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.black),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    hSpace(height: 20),
                    CustomButton(
                      fontsize: 16,
                      title: "Sign in with Google",
                      showBackground: false,
                      titleColor: AppColors.black,
                      imagePath: AppIcons.googleLogo,
                    ),
                    hSpace(height: 20),
                    CustomButton(
                      fontsize: 16,
                      title: "Sign in with Apple",
                      showBackground: false,
                      titleColor: AppColors.black,
                      imagePath: AppIcons.appleLogo,
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
