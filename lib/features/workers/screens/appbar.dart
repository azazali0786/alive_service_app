import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Alive_Service"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ),
      ],
      backgroundColor: const Color.fromARGB(255, 130, 147, 163),
      leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: const Icon(Icons.menu)),
    );
  }
}
