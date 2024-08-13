import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../../common/utils/colors.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final ZoomDrawerController zoomDrawerController;

  const Appbar({Key? key, required this.zoomDrawerController})
      : super(key: key);

  @override 
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return
    AppBar(
      elevation: 0,
      backgroundColor: white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: SvgPicture.asset("assets/burger_icon.svg"),
              onPressed: () {
                widget.zoomDrawerController.toggle?.call();
              }),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                        "assets/icon.png"),
                    fit: BoxFit.cover)),
          )
        ],
      ),
    );
  }
}
