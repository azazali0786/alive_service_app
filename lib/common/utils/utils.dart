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
   if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
  }
  return image;
}

Future<List<XFile>> pickMUltiImageFromGallery(BuildContext context,int imageCount) async {
  List<XFile> imageFileList = [];
  try {
    final pickedImage = await ImagePicker().pickMultiImage();
      if (pickedImage.length <= imageCount) {
        imageFileList.addAll(pickedImage);
      } else {
        if(context.mounted){
           showSnackBar(context: context, content: 'You can pick up to 5 images only.');
        }
      }
  } catch (e) {
    if(context.mounted){
      showSnackBar(context: context, content: e.toString());
    }
  }
  return imageFileList;
}
