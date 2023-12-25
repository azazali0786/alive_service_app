import 'package:alive_service_app/features/auth/screens/login_page.dart';
import 'package:alive_service_app/features/workers/screens/callHistory_list.dart';
import 'package:alive_service_app/features/workers/screens/work_list.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class UserInformationPage extends StatefulWidget {
  static const routeName = "/user-information-screen";
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children:const <Widget>[
             WorkList(),
             CallhistoryList(),
             LoginPage()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: const Text('     Home'), icon: const Icon(Icons.home)),
          BottomNavyBarItem(
              title: const Text('     History'),
              icon: const Icon(Icons.history)),
          BottomNavyBarItem(
              title: const Text('     Login'),
              icon: const Icon(Icons.login)),
          
        ],
      ),
    );
  }
}
