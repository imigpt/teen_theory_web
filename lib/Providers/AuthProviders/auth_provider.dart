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