import 'package:alive_service_app/features/workers/screens/work_list.dart';
import 'package:alive_service_app/features/workers/screens/worker_list.dart';
import 'package:flutter/material.dart';

class Location_search extends StatefulWidget {
  const Location_search({super.key});

  @override
  State<Location_search> createState() => _Location_searchState();
}

class _Location_searchState extends State<Location_search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
          showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
        }, icon: const Icon(Icons.search))
      ]),
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
              Navigator.pushNamed(context, WorkerList.routeName,arguments: query);
            },
          );
        });
  }
}