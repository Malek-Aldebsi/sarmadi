import 'package:flutter/material.dart';

// Provider.of<Receipt>(context, listen: false)
// .createReceipt()
//     .then((value) {
// });

//MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => Quiz()),
//       ],
//       child: const Sarmadi(),
//     ),

// class Quiz with ChangeNotifier {
//   List _questions = [];
//   // {
//   //       'id': '84a5bd9b-1490-4781-a757-da3c042d415a',
//   //       'body':
//   //           r'هل يمكن تحليل المقدار التالي بتجميع الحدود؟ $a\left(r-t\right)+m\left(t-r\right)$',
//   //       'correct_answer': 'نعم',
//   //       'image':
//   //           'https://nyc3.digitaloceanspaces.com/sarmadi-spaces/media/aaaab.jpg?AWSAccessKeyId=DO00Z64A7EGABL2QZEEA&Signature=ltgmiQJ5ZDVuPVU7JwyAHxcGN4o%3D&Expires=1673029193',
//   //       'choices': [
//   //         {'id': '107952b2-fb10-460b-8a2f-0754802dbd21', 'body': 'نعم'},
//   //         {'id': '8e0d020d-7e7d-44b8-be17-7e29b141b6bb', 'body': 'لا'},
//   //       ]
//   //     },
//   final Map _answers = {};
//   //     },
//
//   List get questions => _questions;
//   Map get answers => _answers;
//
//   void addQuestions(List questions) {
//     _questions = questions;
//     notifyListeners();
//   }
//
//   void addAnswer(String questionID, Map answer) {
//     _answers[questionID] = answer;
//     notifyListeners();
//   }
// }
