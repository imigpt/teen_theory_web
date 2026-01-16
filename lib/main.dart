import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellorProfileProvider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_profile_provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_chat_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_profile_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/taskdue_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_meeting_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/student_notification_provider.dart';
import 'package:teen_theory/Providers/ParentProvider/parent_dash_provider.dart';
import 'package:teen_theory/Screens/Auth/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskDueProvider()),
        ChangeNotifierProvider(create: (_) => DetailProjectProvider()),
        ChangeNotifierProvider(create: (_) => StudentMeetingProvider()),
        ChangeNotifierProvider(create: (_) => StudentNotificationProvider()),
        ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
        ChangeNotifierProvider(create: (_) => ParentDashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CounsellorProvider()),
        ChangeNotifierProvider(create: (_) => MentorProvider()),
        ChangeNotifierProvider(create: (_) => Counsellorprofileprovider()),
        ChangeNotifierProvider(create: (_) => DetailProjectProvider()),
        ChangeNotifierProvider(create: (_) => MentorProfileProvider()),
        ChangeNotifierProvider(create: (_) => StudentChatProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
