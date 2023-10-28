import 'package:alive_service_app/common/widgets/error.dart';
import 'package:alive_service_app/features/auth/screens/login_page.dart';
import 'package:alive_service_app/features/auth/screens/otp_page.dart';
import 'package:alive_service_app/features/details/screens/user_detail_page.dart';
import 'package:alive_service_app/features/workers/screens/worker_list.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
import 'package:alive_service_app/user_information_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (context) => const LoginPage());

    case WorkerList.routeName:
      final workType = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => WorkerList(
                workType: workType,
              ));

    case WorkerProfileScreen.routeName:
      final worker = settings.arguments as Map<String,dynamic>;
      return MaterialPageRoute(
          builder: (context) => WorkerProfileScreen(
                worker: worker,
              ));          

    case UserDetailPage.routeName:
      return MaterialPageRoute(builder: (context) => const UserDetailPage());

    case UserInformationPage.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationPage());

    case OtpPage.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OtpPage(
                verificationId: verificationId,
              ));

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
