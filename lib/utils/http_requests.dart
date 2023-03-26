import 'package:http/http.dart' as http;
import 'dart:convert';

// String baseURL = 'http://127.0.0.1:8000';
String baseURL = 'https://jellyfish-app-6vyai.ondigitalocean.app';

Future get(String endPoint) async {
  return await http.get(
    Uri.parse('$baseURL/$endPoint'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
  );
}

Future post(String endPoint, Map body) async {
  return await http.post(Uri.parse('$baseURL/$endPoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(body));
}

dynamic decode(requestBody) {
  if (requestBody.statusCode == 200) {
    var data = utf8.decode(requestBody.bodyBytes);
    return jsonDecode(data);
  }
  return 404;
}
