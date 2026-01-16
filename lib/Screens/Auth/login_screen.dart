import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Customs/custom_textfield.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  _key = GlobalKey<FormState>();
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, pvd, child) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _key,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        controller: pvd.emailController,
                        headerText: "Email Address:",
                      ),
                      hSpace(),
                      CustomTextfield(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        controller: pvd.passwordController,
                        headerText: "Password:",
                      ),
                      hSpace(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          isLoading: pvd.isBtnLoading,
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              pvd.userLoginApiTap(context);
                            }
                          },
                          title: "Login",
                        ),
                      ),
                      hSpace(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
