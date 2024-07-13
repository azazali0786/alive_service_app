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
      final workerInf = settings.arguments as Map<String, List<String>>;
      return MaterialPageRoute(
          builder: (context) => WorkerProfileScreen(
                currentUser: workerInf['currentUser']![0],
                workerInf: workerInf,
              ));        

    case UserDetailPage.routeName:
    final workerData = settings.arguments as Map<String, dynamic>;
    String currentUser = 'false';
    if(workerData.isNotEmpty){
      currentUser= 'true';
    }
      return MaterialPageRoute(builder: (context) => UserDetailPage(
        currentUser: currentUser,
        worker: workerData,
      ));

    // case UserInformationPage.routeName:
    //   return MaterialPageRoute(
    //       builder: (context) => const UserInformationPage(zoomDrawerController: ,));

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
