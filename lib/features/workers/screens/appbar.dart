import 'package:alive_service_app/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final ZoomDrawerController zoomDrawerController;

  const Appbar({Key? key, required this.zoomDrawerController})
      : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();

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
              icon: SvgPicture.asset("assets/images/burger_icon.svg"),
              onPressed: () {
                widget.zoomDrawerController.toggle?.call();
              }),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                        "assets/play_store_512.png"),
                    fit: BoxFit.cover)),
          )
        ],
      ),
    );
  }
}
