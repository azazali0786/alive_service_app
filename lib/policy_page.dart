import 'package:alive_service_app/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyPage extends StatelessWidget {
  final String filePath;

  const PolicyPage({super.key, required this.filePath});

  Future<String> loadMarkdownFile(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      return 'Error loading content';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: FutureBuilder<String>(
        future: loadMarkdownFile(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading content'));
          } else {
            return Markdown(data: snapshot.data ?? '');
          }
        },
      ),
    );
  }
}
