import 'package:flutter/material.dart';
import 'package:sarmadi/const/colors.dart';
import 'package:sarmadi/const/fonts.dart';
import 'components/custom_container.dart';
import 'screens/advance_quiz_setting.dart';
import 'screens/dashboard.dart';
import 'screens/log_in.dart';
import 'screens/question.dart';
import 'screens/quiz_setting.dart';
import 'screens/sign_up.dart';
import 'screens/welcome.dart';

void main() {
  runApp(const Sarmadi());
}

class Sarmadi extends StatelessWidget {
  const Sarmadi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: QuizSetting.route,
      routes: {
        Welcome.route: (context) => const Welcome(),
        // SignUp.route: (context) => const SignUp(),
        // LogIn.route: (context) => const LogIn(),
        Dashboard.route: (context) => const Dashboard(),
        QuizSetting.route: (context) => const QuizSetting(),
        AdvanceQuizSetting.route: (context) => const AdvanceQuizSetting(),
        Question.route: (context) => const Question(),
      },
    );
  }
}
