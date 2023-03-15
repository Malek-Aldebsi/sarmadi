import 'package:flutter/material.dart';
import 'package:sarmadi/const.dart';

popUp(context, width, title, child) {
  showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: kGray,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kBlack),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 24.0, color: kOffPurple),
            ),
            content: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: child,
                ),
              ),
            ),
          ),
        );
      });
}
