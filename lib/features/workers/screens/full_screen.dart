import 'package:alive_service_app/common/utils/colors.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: InteractiveViewer(
        child: Center(
          child: Image.network(imageUrl,fit: BoxFit.scaleDown,),
        ),
      ),
    );
  }
}
