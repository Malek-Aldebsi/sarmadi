import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

import '../components/otp_dialog.dart';
import '../components/snack_bar.dart';
import '../providers/user_info_provider.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  User get user => _auth.currentUser!;
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  FirebaseAuthMethods(this._auth);

  Future<bool> signUpWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        showSnackBar(context, e.message!);
      }
    }
    await _auth.currentUser!.sendEmailVerification();

    bool verificationStatus = await showOTPDialog(
        context: context,
        title: const Text("تأكيد الايميل"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                'لقد تم ارسال رابط للتحقق من صحة البريد الالكتروني\nقم بفتحه ثم انقر على تم')
          ],
        ),
        action: TextButton(
          child: const Text("تم"),
          onPressed: () async {
            User user = context.read<FirebaseAuthMethods>().user;
            await user.reload();
            bool isEmailVerified = user.emailVerified;
            if (isEmailVerified) {
              Navigator.of(context).pop(true);
            }
          },
        ));

    return verificationStatus;
  }

  Future<bool> signUpWithPhone(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();

    ConfirmationResult result = await _auth.signInWithPhoneNumber(phoneNumber);

    bool verificationStatus = await showOTPDialog(
        context: context,
        title: const Text("تأكيد الهاتف"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: codeController,
            ),
          ],
        ),
        action: TextButton(
          child: const Text("تم"),
          onPressed: () async {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: result.verificationId,
              smsCode: codeController.text.trim(),
            );

            await _auth.signInWithCredential(credential);
            Navigator.of(context).pop(true);
          },
        ));

    return verificationStatus;
  }

  Future<bool> signUpWithGoogle(
      BuildContext context, UserInfoProvider userInfoProvider) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        userInfoProvider.userEmail.text =
            userCredential.additionalUserInfo?.profile?['email'];
        userInfoProvider.userPassword.text =
            userCredential.additionalUserInfo?.profile?['id'];
        userInfoProvider.firstName.text =
            userCredential.additionalUserInfo?.profile?['given_name'];
        userInfoProvider.lastName.text =
            userCredential.additionalUserInfo?.profile?['family_name'];

        return true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
    return false;
  }

  Future<bool> signUpWithFacebook(
      BuildContext context, UserInfoProvider userInfoProvider) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      userInfoProvider.userEmail.text =
          userCredential.additionalUserInfo?.profile?['email'] ?? '';
      userInfoProvider.userPhone.text =
          userCredential.additionalUserInfo?.profile?['phone'] ?? '';
      userInfoProvider.userPassword.text =
          userCredential.additionalUserInfo?.profile?['id'];
      userInfoProvider.firstName.text =
          userCredential.additionalUserInfo?.profile?['first_name'];
      userInfoProvider.lastName.text =
          userCredential.additionalUserInfo?.profile?['last_name'];
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
    return false;
  }
}
