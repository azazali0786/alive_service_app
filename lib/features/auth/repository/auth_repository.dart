import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/auth/screens/login_page.dart';
import 'package:alive_service_app/features/auth/screens/otp_page.dart';
import 'package:alive_service_app/features/drawer/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      auth: FirebaseAuth.instance,
    ));

class AuthRepository {
  final FirebaseAuth auth;
  AuthRepository({
    required this.auth,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OtpPage.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainPage.routeName, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message!);
      }
    }
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
