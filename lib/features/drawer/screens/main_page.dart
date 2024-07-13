import 'package:alive_service_app/features/auth/screens/login_page.dart';
import 'package:alive_service_app/features/auth/screens/otp_page.dart';
import 'package:alive_service_app/features/drawer/controller/drawer_controller.dart';
import 'package:alive_service_app/features/drawer/screens/menu_page.dart';
import 'package:alive_service_app/features/workers/screens/appBar.dart';
import 'package:alive_service_app/user_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  Map<String, List<String>> userIdWorkType = {};

  @override
  void initState() {
    userWorkData();
    super.initState();
  }

  void userWorkData() async {
    userIdWorkType = await ref.read(drawerControllerProvider).userWorkData();
    setState(() {});
  }

  Future<bool?> showWarning(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: const Text("Do you want to exit this App?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  String currentPage = 'People';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: ZoomDrawer(
        controller: zoomDrawerController,
        menuScreen: MenuPage(
          userIdWorkType: userIdWorkType,
          currentPage: currentPage,
          onSelectedPage: (pageName) {
            setState(() {
              currentPage = pageName;
            });
          },
        ),
        mainScreen: Scaffold(
          appBar: Appbar(zoomDrawerController: zoomDrawerController),
          body: getPage(),
        ),
        angle: 0,
        duration: const Duration(milliseconds: 250),
        showShadow: true,
        drawerShadowsBackgroundColor: const Color.fromARGB(255, 60, 145, 215),
        menuBackgroundColor: const Color.fromARGB(255, 179, 154, 153),
        style: DrawerStyle.style2,
        moveMenuScreen: false,
        menuScreenWidth: 450,
        slideWidth: 150,
      ),
    );
  }

  Widget getPage() {
    switch (currentPage) {
      case 'People':
        return UserInformationPage(zoomDrawerController: zoomDrawerController);
      case 'Favourites':
        return const LoginPage();
      default:
        return const OtpPage(verificationId: 'verificationId');
    }
  }
}
