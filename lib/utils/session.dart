import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future setSession(String key, String value) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(key, value);
}

Future getSession(String key) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(key);
}

Future delSession(String key) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.remove(key);
}

Future checkSession(String key) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.containsKey(key);
}

// await setSession('key', 'value');
// await getSession('key');
// await delSession('key');
// await checkSession('key');
