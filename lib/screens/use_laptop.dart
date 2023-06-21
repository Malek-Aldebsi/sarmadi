import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class UseLapTop extends StatefulWidget {
  const UseLapTop({Key? key}) : super(key: key);

  @override
  State<UseLapTop> createState() => _UseLapTopState();
}

class _UseLapTopState extends State<UseLapTop> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: kDarkGray,
        body: Center(
            child: Text('لتجربة أفضل قم باستخدام جهاز الحاسوب\nبدلاً من الهاتف',
                textAlign: TextAlign.center,
                style: textStyle(0, width, height, kWhite))));
  }
}
