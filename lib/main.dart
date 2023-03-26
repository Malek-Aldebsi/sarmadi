import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/providers/login_provider.dart';
import 'package:sarmadi/providers/quiz_provider.dart';
import 'package:sarmadi/providers/tasks_provider.dart';
import 'package:sarmadi/providers/user_info_provider.dart';
import 'package:sarmadi/providers/website_provider.dart';
import 'package:sarmadi/screens/log_in.dart';
import 'package:sarmadi/screens/quiz_result.dart';
import 'screens/advance_quiz_setting.dart';
import 'screens/dashboard.dart';
import 'screens/question.dart';
import 'screens/quiz_setting.dart';
import 'screens/welcome.dart';

// flutter build web --web-renderer html
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (_) => WebsiteProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const Sarmadi(),
    ),
  );
}

class Sarmadi extends StatelessWidget {
  const Sarmadi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LogIn.route,
      routes: {
        Welcome.route: (context) => const Welcome(),
        // SignUp.route: (context) => const SignUp(),
        LogIn.route: (context) => const LogIn(),
        Dashboard.route: (context) => const Dashboard(),
        QuizSetting.route: (context) => const QuizSetting(),
        QuizResult.route: (context) => const QuizResult(),
        AdvanceQuizSetting.route: (context) => const AdvanceQuizSetting(),
        Question.route: (context) => const Question(),
      },
    );
  }
}
