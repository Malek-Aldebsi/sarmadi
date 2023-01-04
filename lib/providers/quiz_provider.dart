// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => Stock()),
//         ChangeNotifierProvider(create: (_) => Receipt()),
//         // ChangeNotifierProvider(create: (_) => Insight()),
//       ],
//       child: BIAS(),
//     ),
//   );
// }

// Provider.of<Receipt>(context, listen: false)
// .createReceipt()
//     .then((value) {
// Provider.of<Stock>(context, listen: false)
//     .getStocks();
// Navigator.pop(context);
// });
//
//
// Map receipt = Provider.of<Receipt>(context, listen: true).receipt;
//

// class Stock with ChangeNotifier {
//   List _stocks = [];
//
//   List get stocks => _stocks;
//
//   void addStock(Map<String, dynamic> stockDetails) {
//     stockDetails['id'] = _stocks.last['id'] + 1;
//     if (stockDetails['reshipping_days'] == '')
//       stockDetails.remove('reshipping_days');
//     http
//         .post(
//             Uri.parse('https://bias-o42x8.ondigitalocean.app/apis/add_stock/'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8'
//             },
//             body: jsonEncode(stockDetails))
//         .then((value) {
//       if (value.statusCode == 200) {
//         _stocks.add(stockDetails);
//         notifyListeners();
//       }
//     });
//   }
//
//   void getStocks() {
//     http.get(
//       Uri.parse('https://bias-o42x8.ondigitalocean.app/apis/get_stocks/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8'
//       },
//     ).then((value) {
//       if (value.statusCode == 200) {
//         _stocks = jsonDecode(value.body);
//         notifyListeners();
//       }
//     });
//   }
//
//   void updateStock(
//       Map<String, dynamic> stockDetails, bool allDetails, int fakeId) {
//     http
//         .post(
//             Uri.parse(
//                 'https://bias-o42x8.ondigitalocean.app/apis/update_stock/'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8'
//             },
//             body: jsonEncode(stockDetails))
//         .then((value) {
//       if (value.statusCode == 200) {
//         if (allDetails) {
//           _stocks[fakeId] = stockDetails;
//         } else {
//           _stocks[fakeId]['available_quantity'] =
//               stockDetails['available_quantity'];
//         }
//
//         notifyListeners();
//       }
//     });
//   }
//
//   void deleteStock(int id, int fakeId) {
//     http.get(
//       Uri.parse('https://bias-o42x8.ondigitalocean.app/apis/delete_stock/$id'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8'
//       },
//     ).then((value) {
//       _stocks.removeAt(fakeId);
//       notifyListeners();
//     });
//   }
// }
