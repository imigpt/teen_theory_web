import 'package:flutter/widgets.dart';

class AuthProvider with ChangeNotifier {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
}