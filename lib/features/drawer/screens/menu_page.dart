import 'package:alive_service_app/features/details/screens/user_detail_page.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  final Map<String, List<String>> userIdWorkType;
  final String currentPage;
  final ValueChanged<String> onSelectedPage;
  const MenuPage({
    super.key,
    required this.userIdWorkType,
    required this.currentPage, //stateless honi chahiye
    required this.onSelectedPage,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    print('object');
    String currentPage = widget.currentPage;
    final name = widget.userIdWorkType['userData']?[1] ?? "NoUser";
    final email = widget.userIdWorkType['userData']?[2] ?? "Please Loging";
    final urlImage = widget.userIdWorkType['userData']?[0] ??
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 50, 205, 195),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () {
                if (widget.userIdWorkType['userId'] != null) { 
                  Navigator.pushNamed(context, WorkerProfileScreen.routeName,
                      arguments: {
                        'workType': widget.userIdWorkType['workTypes']!,
                        'workerId': [widget.userIdWorkType['userId']![0]],
                        'currentUser': ['true']
                      });
                }
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Map<String, dynamic> worker={};
                      Navigator.pushNamed(context, UserDetailPage.routeName,arguments: worker);
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Add your Work'),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'People',
                    icon: Icons.people,
                    onClicked: () {
                      widget.onSelectedPage('People');
                      currentPage = 'People';
                    },
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                      text: 'Favourites',
                      icon: Icons.favorite_border,
                      onClicked: () {
                        widget.onSelectedPage('Favourites');
                        currentPage = 'Favourites';
                      }),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Workflow',
                    icon: Icons.workspaces_outline,
                    onClicked: () => {},
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'About',
                    icon: Icons.warning_amber_rounded,
                    onClicked: () => {},
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Plugins',
                    icon: Icons.account_tree_outlined,
                    onClicked: () => {},
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Notifications',
                    icon: Icons.notifications_outlined,
                    onClicked: () => {},
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
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
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
              backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              child: Icon(Icons.note_alt_outlined, color: Colors.white),
            )
          ],
        ),
      ),
    );
