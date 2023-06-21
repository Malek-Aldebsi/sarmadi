import 'dart:convert';
import 'package:crypto/crypto.dart';

String encrypt(String text) {
  List<int> bytes = utf8.encode(text);
  Digest codedSha256 = sha256.convert(bytes);
  return codedSha256.toString();
}
