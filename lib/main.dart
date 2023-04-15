import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/providers/dashboard_provider.dart';
import 'package:sarmadi/providers/history_provider.dart';
import 'package:sarmadi/providers/question_provider.dart';
import 'package:sarmadi/providers/quiz_question_provider.dart';
import 'package:sarmadi/providers/quiz_provider.dart';
import 'package:sarmadi/providers/quiz_setting_provider.dart';
import 'package:sarmadi/providers/review_provider.dart';
import 'package:sarmadi/providers/tasks_provider.dart';
import 'package:sarmadi/providers/user_info_provider.dart';
import 'package:sarmadi/providers/website_provider.dart';
import 'package:sarmadi/question_admin/final_answer_question.dart';
import 'package:sarmadi/question_admin/multi_section_question.dart';
import 'package:sarmadi/question_admin/multiple_choice_question.dart';
import 'package:sarmadi/question_admin/question_admin.dart';
import 'package:sarmadi/screens/log_in.dart';
import 'package:sarmadi/screens/question.dart';
import 'package:sarmadi/screens/quiz_review.dart';
import 'screens/advance_quiz_setting.dart';
import 'screens/quiz_history.dart';
import 'screens/dashboard.dart';
import 'screens/quiz.dart';
import 'screens/quiz_setting.dart';
import 'screens/welcome.dart';

// flutter build web --web-renderer canvaskit
// firebase deploy --only hosting
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (_) => WebsiteProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => QuizSettingProvider()),
        ChangeNotifierProvider(create: (_) => QuizQuestionProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
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
        QuestionAdmin.route: (context) => const QuestionAdmin(),
        MultipleChoiceQuestion.route: (context) =>
            const MultipleChoiceQuestion(),
        FinalAnswerQuestion.route: (context) => const FinalAnswerQuestion(),
        MultiSectionQuestion.route: (context) => const MultiSectionQuestion(),
        Welcome.route: (context) => const Welcome(),
        // SignUp.route: (context) => const SignUp(),
        LogIn.route: (context) => const LogIn(),
        Dashboard.route: (context) => const Dashboard(),
        QuizSetting.route: (context) => const QuizSetting(),
        QuizReview.route: (context) => const QuizReview(),
        QuizHistory.route: (context) => const QuizHistory(),
        AdvanceQuizSetting.route: (context) => const AdvanceQuizSetting(),
        Quiz.route: (context) => const Quiz(),
        Question.route: (context) => const Question(),
      },
    );
  }
}
