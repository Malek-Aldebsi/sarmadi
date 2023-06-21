import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/providers/admin_provider.dart';
import 'package:sarmadi/providers/dashboard_provider.dart';
import 'package:sarmadi/providers/history_provider.dart';
import 'package:sarmadi/providers/shared_question_provider.dart';
import 'package:sarmadi/providers/similar_questions_provider.dart';
import 'package:sarmadi/providers/quiz_provider.dart';
import 'package:sarmadi/providers/quiz_setting_provider.dart';
import 'package:sarmadi/providers/review_provider.dart';
import 'package:sarmadi/providers/tasks_provider.dart';
import 'package:sarmadi/providers/user_info_provider.dart';
import 'package:sarmadi/providers/website_provider.dart';
import 'package:sarmadi/question_admin/edit_question.dart';
import 'package:sarmadi/question_admin/final_answer_question.dart';
import 'package:sarmadi/question_admin/multi_section_question.dart';
import 'package:sarmadi/question_admin/multiple_choice_question.dart';
import 'package:sarmadi/question_admin/question_admin.dart';
import 'package:sarmadi/screens/log_in.dart';
import 'package:sarmadi/screens/shared_question.dart';
import 'package:sarmadi/screens/similar_questions.dart';
import 'package:sarmadi/screens/quiz_review.dart';
import 'package:sarmadi/screens/sign_up.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import 'package:sarmadi/screens/welcome.dart';
import 'package:sarmadi/utils/authentication.dart';
import 'auth/firebase_options.dart';
import 'screens/advance_quiz_setting.dart';
import 'screens/quiz_history.dart';
import 'screens/quiz.dart';
import 'screens/quiz_setting.dart';
import 'package:device_preview/device_preview.dart';

// flutter build web --web-renderer canvaskit
// firebase deploy --only hosting
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    FacebookAuth.i.webAndDesktopInitialize(
      appId: "919316019445873", // Replace with your app id
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      Provider<FirebaseAuthMethods>(
        create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
      ),
      StreamProvider(
        create: (context) => context.read<FirebaseAuthMethods>().authState,
        initialData: null,
      ),
      ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ChangeNotifierProvider(create: (_) => WebsiteProvider()),
      ChangeNotifierProvider(create: (_) => SharedQuestionProvider()),
      ChangeNotifierProvider(create: (_) => TasksProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
      ChangeNotifierProvider(create: (_) => QuizProvider()),
      ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(create: (_) => QuizSettingProvider()),
      ChangeNotifierProvider(create: (_) => SimilarQuestionsProvider()),
      ChangeNotifierProvider(create: (_) => HistoryProvider()),
    ],
    child:
        // DevicePreview(
        //   enabled: !kReleaseMode,
        //   builder: (context) =>
        Sarmadi(), // Wrap your app
    // ),
  ));
}

class Sarmadi extends StatefulWidget {
  Sarmadi({super.key});

  @override
  State<Sarmadi> createState() => _SarmadiState();
}

class _SarmadiState extends State<Sarmadi> {
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // double width = MediaQuery.of(context).size.width;
          // double height = MediaQuery.of(context).size.height;
          // if (width < 750 || height < 400)
          //   return const UseLapTop();
          // else
          return const Welcome();
        },
        routes: <RouteBase>[
          GoRoute(
              path: 'SharedQuestion/:questionID',
              builder: (BuildContext context, GoRouterState state) {
                Provider.of<SharedQuestionProvider>(context, listen: false)
                    .setQuestionId(state.pathParameters['questionID']!);
                // double width = MediaQuery.of(context).size.width;
                // double height = MediaQuery.of(context).size.height;
                // if (width < 750 || height < 400)
                //   return const UseLapTop();
                // else
                return const SharedQuestion();
              }),
          GoRoute(
              path: 'RotateYourPhone',
              builder: (BuildContext context, GoRouterState state) {
                return const RotateYourPhone();
              }),
          GoRoute(
              path: 'Quiz/:QuizID',
              builder: (BuildContext context, GoRouterState state) {
                Provider.of<QuizProvider>(context, listen: false)
                    .setQuizID(state.pathParameters['QuizID'] ?? '');
                // double width = MediaQuery.of(context).size.width;
                // double height = MediaQuery.of(context).size.height;
                // if (width < 750 || height < 400)
                //   return const UseLapTop();
                // else
                return const Quiz();
              }),
          GoRoute(
            path: 'QuestionAdmin',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const QuestionAdmin();
            },
          ),
          GoRoute(
            path: 'MultipleChoiceQuestion',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const MultipleChoiceQuestion();
            },
          ),
          GoRoute(
            path: 'FinalAnswerQuestion',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const FinalAnswerQuestion();
            },
          ),
          GoRoute(
            path: 'MultiSectionQuestion',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const MultiSectionQuestion();
            },
          ),
          GoRoute(
            path: 'EditQuestion',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const EditQuestion();
            },
          ),
          GoRoute(
            path: 'Welcome',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const Welcome();
            },
          ),
          GoRoute(
            path: 'SignUp',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const SignUp();
            },
          ),
          GoRoute(
            path: 'LogIn',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const LogIn();
            },
          ),
          // GoRoute(
          //   path: 'Dashboard',
          //   builder: (BuildContext context, GoRouterState state) {
          //     return const Dashboard();
          //   },
          // ),
          GoRoute(
            path: 'QuizSetting',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const QuizSetting();
            },
          ),
          GoRoute(
            path: 'QuizReview',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const QuizReview();
            },
          ),
          GoRoute(
            path: 'QuizHistory',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const QuizHistory();
            },
          ),
          GoRoute(
            path: 'AdvanceQuizSetting',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const AdvanceQuizSetting();
            },
          ),
          GoRoute(
            path: 'Quiz',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const Quiz();
            },
          ),
          GoRoute(
            path: 'Question',
            builder: (BuildContext context, GoRouterState state) {
              // double width = MediaQuery.of(context).size.width;
              // double height = MediaQuery.of(context).size.height;
              // if (width < 750 || height < 400)
              //   return const UseLapTop();
              // else
              return const SimilarQuestions();
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
