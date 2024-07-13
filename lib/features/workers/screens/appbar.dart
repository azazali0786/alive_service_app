import 'package:alive_service_app/features/workers/screens/work_list.dart';
import 'package:alive_service_app/features/workers/screens/worker_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final ZoomDrawerController zoomDrawerController;

  const Appbar({Key? key, required this.zoomDrawerController}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Alive_Service"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ],
      backgroundColor: const Color.fromARGB(255, 130, 147, 163),
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              widget.zoomDrawerController.toggle?.call();
            },
            icon: const Icon(Icons.menu),
          );
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = workNameList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              Navigator.pushNamed(context, WorkerList.routeName, arguments: query);
            },
          );
        });
  }
}
