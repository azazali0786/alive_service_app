import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<List<XFile>> pickMUltiImageFromGallery(BuildContext context) async {
  List<XFile> imageFileList = [];
  try {
    final pickedImage = await ImagePicker().pickMultiImage();
    imageFileList.addAll(pickedImage);
    // }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return imageFileList;
}
