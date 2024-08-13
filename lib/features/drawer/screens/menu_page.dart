// ignore_for_file: unused_local_variable

import 'package:alive_service_app/common/utils/colors.dart';
import 'package:alive_service_app/features/auth/controller/auth_controller.dart';
import 'package:alive_service_app/features/details/screens/user_detail_page.dart';
import 'package:alive_service_app/features/drawer/controller/drawer_controller.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuPage extends ConsumerStatefulWidget {
  final String currentPage;
  final ValueChanged<String> onSelectedPage;
  const MenuPage({
    super.key,
    required this.currentPage,
    required this.onSelectedPage,
  });

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  Map<String, List<String>> userIdWorkType = {};

  @override
  void initState() {
    super.initState();
    _fetchUserWorkData();
  }

  Future<void> _fetchUserWorkData() async {
    userIdWorkType = await ref.read(drawerControllerProvider).userWorkData();
    setState(() {});
  }

  void signOut() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("Do you really want to Logout."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    ref
                        .read(authControllerProvider)
                        .authRepository
                        .signOut(context);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String currentPage = widget.currentPage;
    final name = userIdWorkType['userData']?[1] ?? "NoUser";
    final email = userIdWorkType['userData']?[2] ?? "Please Loging";
    final urlImage = userIdWorkType['userData']?[0] ?? 'noImage';

    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 184, 153, 255),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () async {
                if (userIdWorkType['userId'] != null) {
                  await Navigator.pushNamed(
                    context,
                    WorkerProfileScreen.routeName,
                    arguments: {
                      'workType': userIdWorkType['workTypes']!,
                      'workerId': [userIdWorkType['userId']![0]],
                      'currentUser': ['true']
                    },
                  );
                  // Refresh the user work data after navigating back
                } else {
                  Map<String, dynamic> worker = {};
                  await Navigator.pushNamed(
                    context,
                    UserDetailPage.routeName,
                    arguments: worker,
                  );
                }
                _fetchUserWorkData();
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Map<String, dynamic> worker = {};
                      await Navigator.pushNamed(
                        context,
                        UserDetailPage.routeName,
                        arguments: worker,
                      );
                      // Refresh the user work data after navigating back
                      _fetchUserWorkData();
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Add your Work'),
                  ),
                  SizedBox(height: size.height * 0.05),
                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home,
                    onClicked: () {
                      widget.onSelectedPage('Home');
                      currentPage = 'Home';
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  buildMenuItem(
                    text: 'History',
                    icon: Icons.location_history,
                    onClicked: () {
                      widget.onSelectedPage('History');
                      currentPage = 'History';
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  buildMenuItem(
                    text: 'About',
                    icon: Icons.warning_rounded,
                    onClicked: () {
                      widget.onSelectedPage('About');
                      currentPage = 'About';
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout_outlined,
                    onClicked: () {
                      signOut();
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Divider(color: Colors.white70),
                  SizedBox(height: size.height * 0.07),
                  buildMenuItem(
                    text: 'Privacy Policy',
                    icon: Icons.policy,
                    onClicked: () {
                      widget.onSelectedPage('Privacy Policy');
                      currentPage = 'Privacy Policy';
                    },
                  ),
                  buildMenuItem(
                    text: 'Term and Conditions',
                    icon: Icons.description_sharp,
                    onClicked: () {
                      widget.onSelectedPage('Term and Conditions');
                      currentPage = 'Term and Conditions';
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;
    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        selectedTileColor: Colors.black26,
        selected: widget.currentPage == text,
        leading: Icon(icon, color: color),
        title: Text(text, style: const TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: onClicked,
      ),
    );
  }
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required String email,
  required VoidCallback onClicked,
}) =>
    InkWell(
      onTap: onClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundImage: urlImage == 'noImage'
                    ? const AssetImage('assets/user.jpg')
                    : NetworkImage(urlImage) as ImageProvider,
             ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 24,
              backgroundColor: white,
              backgroundImage: AssetImage('assets/icon.png'),
            )
          ],
        ),
      ),
    );
