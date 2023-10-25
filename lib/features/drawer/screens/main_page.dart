import 'package:alive_service_app/features/auth/screens/otp_page.dart';
import 'package:alive_service_app/features/drawer/screens/menu_page.dart';
import 'package:alive_service_app/user_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String currentPage = 'People';

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: MenuPage(
          currentPage: currentPage,
          onSelectedPage: (pageName) {
            setState(() {
              currentPage = pageName;
            });
          }),
      mainScreen: getPage(),
      angle: 0,
      duration: const Duration(milliseconds: 250),
      showShadow: true,
      drawerShadowsBackgroundColor: const Color.fromARGB(255, 60, 145, 215),
      menuBackgroundColor: const Color.fromARGB(255, 179, 154, 153),
      style: DrawerStyle.style2,
      moveMenuScreen: false,
      menuScreenWidth: 450,
      slideWidth: 150,
    );
  }

  Widget getPage() {
    switch (currentPage) {
      case 'People':
        return const UserInformationPage();
      case 'Favourites':
        return const OtpPage(verificationId: 'verificationId');
      default:
        return const OtpPage(verificationId: 'verificationId');
    }
  }
}
