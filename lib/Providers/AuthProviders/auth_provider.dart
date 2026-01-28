import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Screens/Auth/login_screen.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/counsellor_dashboard.dart';
import 'package:teen_theory/Screens/MentorDashboard/mentor_dashboard.dart';
import 'package:teen_theory/Screens/ParentDashboard/parent_dashboard.dart';
import 'package:teen_theory/Screens/StudentDashboard/student_home.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';
import 'package:teen_theory/Utils/connection_dectactor.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:teen_theory/Utils/shared_pref.dart';

class AuthProvider with ChangeNotifier {

  bool _isBtnLoading = false;
  bool get isBtnLoading => _isBtnLoading;

  void setBtnLoading(bool value) {
    _isBtnLoading = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
     notifyListeners();
  }

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController forgotPasswordEmailController = TextEditingController();

    void userLoginApiTap (BuildContext context) async {
      ConnectionDetector.connectCheck().then((isConnected) {
        if (isConnected) {
          userLoginApiCall(context);
        } else {
          showToast("No internet connection", type: toastType.error);
        }
      });
    }

    userLoginApiCall(BuildContext context) {

      Map<String, dynamic> body = {
        "email" : emailController.text,
        "password" : passwordController.text
      };
      setBtnLoading(true);
      try{
        DioClient.userLogin(
        body: body, 
        onSuccess: (response) async {
          if(response.success == true){
            await SharedPref.setStringValue(SharedPref.accessToken, response.token!);
            AppLogger.debug(message: "Token: ${response.token}");
            if(response.user!.userRole == "Student"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StudentHome()));
            } else if(response.user!.userRole == "Mentor"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MentorDashboard()));
            }else if (response.user!.userRole == "Parent"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ParentDashboard()));
            } else if (response.user!.userRole == "Counsellor"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CounsellorDashboard()));
            } else {
              return null;
            }
            getProfileApiCallAgain(context);
            emailController.clear();
            passwordController.clear();
          } else {
            showToast("${response.message}", type: toastType.error);
          }
          setBtnLoading(false);
          notifyListeners();
        }, onError: (error) {
          showToast(error, type: toastType.error);
          AppLogger.error(message: "error in user Login: ${error}");
          setBtnLoading(false);
          notifyListeners();
        });
      }catch(e) {
        AppLogger.error(message: "Exception in user Login: ${e.toString()}");
        setBtnLoading(false);
        notifyListeners();
      }
    }

    //.................GET PROFILE API CALL....................//

    ProfileModel? _profileData;
    ProfileModel? get profileData => _profileData;


    void getProfileApiTap (BuildContext context) async {
      ConnectionDetector.connectCheck().then((isConnected) {
        if (isConnected) {
          getProfileApiCall(context);
        } else {
          showToast("No internet connection", type: toastType.error);
        }
      });
    }

    getProfileApiCall (BuildContext context) {
      setLoading(true);
      try{
        DioClient.getProfile(
        onSuccess: (response) async {
          _profileData = await response;
          if(response.success == true) {
            if(response.data!.userRole == "Student"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StudentHome(),));
            } else if(response.data!.userRole == "Mentor"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MentorDashboard(),));
            } else if(response.data!.userRole == "Parent"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ParentDashboard(),));
            } else if(response.data!.userRole == "Counsellor"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CounsellorDashboard(),));
            } else {
              return null; 
            }
            
          }
          setLoading(false);
          notifyListeners();
        }, onError: (error) {
          // Navigate to login screen if token is invalid or missing
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
          AppLogger.error(message: "error in get Profile: $error");
          setLoading(false);
          notifyListeners();
        });

      } catch (e) {
        AppLogger.error(message: "Exception in get Profile: ${e.toString()}");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
        setLoading(false);
        notifyListeners();
      }
    }

    //.................FORGOT PASSWORD API CALL....................//

    void forgotPasswordApiTap(BuildContext context) async {
      ConnectionDetector.connectCheck().then((isConnected) {
        if (isConnected) {
          forgotPasswordApiCall(context);
        } else {
          showToast("No internet connection", type: toastType.error);
        }
      });
    }

    Future<bool> forgotPasswordApiCall(BuildContext context) async {
      Map<String, dynamic> body = {
        "email": forgotPasswordEmailController.text,
      };
      
      setBtnLoading(true);
      bool success = false;
      
      try {
        final completer = Completer<void>();
        
        await DioClient.forgotPassword(
          body: body,
          onSuccess: (response) async {
            // Save email locally
            await SharedPref.setStringValue(
              'forgot_password_email',
              forgotPasswordEmailController.text,
            );
            
            showToast(
              "Password reset link sent to ${forgotPasswordEmailController.text}",
              type: toastType.success,
            );
            
            AppLogger.debug(message: "Forgot password response: $response");
            success = true;
            completer.complete();
          },
          onError: (error) {
            showToast(
              error.isNotEmpty ? error : "Failed to send reset request",
              type: toastType.error,
            );
            AppLogger.error(message: "Error in forgot password: $error");
            success = false;
            completer.complete();
          },
        );
        
        // Wait for the callbacks to complete
        await completer.future;
      } catch (e) {
        showToast("Failed to send reset request", type: toastType.error);
        AppLogger.error(message: "Exception in forgot password: ${e.toString()}");
        success = false;
      }
      
      setBtnLoading(false);
      notifyListeners();
      return success;
    }

    //.................CHECK PASSWORD REQUEST STATUS....................//

    Future<String?> checkPasswordRequestStatus(String email) async {
      try {
        String? status;
        await DioClient.getPasswordChangeRequests(
          onSuccess: (response) {
            if (response.success == true && response.data != null) {
              // Find the request matching the email
              for (var request in response.data!) {
                if (request.email == email) {
                  status = request.status;
                  AppLogger.debug(message: "Found password request for $email with status: $status");
                  break;
                }
              }
            }
          },
          onError: (error) {
            AppLogger.error(message: "Error checking password request status: $error");
          },
        );
        return status;
      } catch (e) {
        AppLogger.error(message: "Exception in checkPasswordRequestStatus: ${e.toString()}");
        return null;
      }
    }

    //.................CHANGE PASSWORD API CALL....................//

    Future<bool> changePasswordApiCall(BuildContext context, String newPassword) async {
      // Get email from local storage
      String? email = await SharedPref.getStringValue('forgot_password_email');
      
      if (email == null || email.isEmpty) {
        showToast("Email not found. Please try again.", type: toastType.error);
        return false;
      }

      Map<String, dynamic> body = {
        "email": email,
        "new_password": newPassword,
      };
      
      setBtnLoading(true);
      bool success = false;
      
      try {
        await DioClient.changePassword(
          body: body,
          onSuccess: (response) async {
            showToast(
              "Password changed successfully",
              type: toastType.success,
            );
            
            // Clear the saved email
            await SharedPref.setStringValue('forgot_password_email', '');
            
            AppLogger.debug(message: "Change password response: $response");
            success = true;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
            setBtnLoading(false);
            notifyListeners();
          },
          onError: (error) {
            showToast(
              error.isNotEmpty ? error : "Failed to change password",
              type: toastType.error,
            );
            AppLogger.error(message: "Error in change password: $error");
            success = false;
            setBtnLoading(false);
            notifyListeners();
          },
        );
      } catch (e) {
        showToast("Failed to change password", type: toastType.error);
        AppLogger.error(message: "Exception in change password: ${e.toString()}");
        success = false;
        setBtnLoading(false);
        notifyListeners();
      }
      
      return success;
    }

    //.................GET PROFILE API CALL AGAIN....................//

 void getProfileApiTapAgain (BuildContext context) async {
      ConnectionDetector.connectCheck().then((isConnected) {
        if (isConnected) {
          getProfileApiCallAgain(context);
        } else {
          showToast("No internet connection", type: toastType.error);
        }
      });
    }

    getProfileApiCallAgain (BuildContext context) {
      setLoading(true);
      try{
        DioClient.getProfile(
        onSuccess: (response) async {
          if(response.success == true) {
            _profileData = await response;
          }
          setLoading(false);
          notifyListeners();
        }, onError: (error) {
          showToast("Something went wrong", type: toastType.error);
          AppLogger.error(message: "error in get Profile: $error");
          setLoading(false);
          notifyListeners();
        });

      } catch (e) {
        AppLogger.error(message: "Exception in get Profile: ${e.toString()}");
        setLoading(false);
        notifyListeners();
      }
    }
   
}