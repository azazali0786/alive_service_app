import 'dart:io';
import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/details/controller/user_details_controller.dart';
import 'package:alive_service_app/features/details/screens/location_page.dart';
import 'package:alive_service_app/features/details/screens/timing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserDetailPage extends ConsumerStatefulWidget {
  static const routeName = "/User-detail-page";
  const UserDetailPage({super.key});

  @override
  ConsumerState<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserDetailPage> {
  final TextEditingController shopeNameController = TextEditingController();
  final TextEditingController discriptionController = TextEditingController();
  File? mainImage;
  List<XFile> imageFileList = [];
  Position? position;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getPerm();
    super.initState();
  }


  List<Time> timeList =
      List<Time>.filled(2, Time(hour: 0, minute: 0, timeFormat: ''));

  void selectImage() async {
    mainImage = await pickImageFromGallery(context);
    setState(() {});
  }

  void selectmoreImage() async {
    imageFileList.addAll(await pickMUltiImageFromGallery(context));
    setState(() {});
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && timeList[0].timeFormat == '') {
      timingBottomSheet(context);
    } else if (_formKey.currentState!.validate() && mainImage != null) {
      ref.read(userDetailsControllerProvider).saveUserDetailData(
          context,
          mainImage!,
          imageFileList,
          shopeNameController.text,
          workType!,
          timeList,
          position!,
          discriptionController.text);
      showSnackBar(context: context, content: 'Form submitted successfully');
    } else if (_formKey.currentState!.validate() && mainImage == null) {
      return showSnackBar(context: context, content: 'Please pick image');
    }
  }

  String? workType;
  List workList = ['Plumber', 'Electrician', 'Fridge Mistry', 'AC Mistry'];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register yourself'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                mainImage == null
                    ? Stack(children: [
                        Container(
                          height: size.height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                                image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2017/03/25/17/55/colorful-2174045_1280.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Positioned(
                          bottom: size.height * 0.1,
                          left: size.width * 0.41,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 40,
                            ),
                            onPressed: () => selectImage(),
                          ),
                        )
                      ])
                    : InkWell(
                        onTap: selectImage,
                        child: Container(
                          height: size.height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: FileImage(mainImage!), fit: BoxFit.fill),
                          ),
                        ),
                      ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  children: [
                    const SizedBox(
                      child: Text(
                        '  Add more images',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                        onPressed: selectmoreImage,
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.blue,
                        ))
                  ],
                ),
                imageFileList.isNotEmpty
                    ? SizedBox(
                        height: 130,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFileList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 12,
                                ),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(children: [
                                  Container(
                                    width: 100,
                                    color: Colors.red,
                                    child: Image.file(
                                        File(imageFileList[index].path),
                                        fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          splashColor: Colors.transparent,
                                          onPressed: () {
                                            imageFileList.removeAt(index);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.black,
                                          ))),
                                ]),
                              );
                            }),
                      )
                    : const SizedBox(
                        height: 12,
                      ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: shopeNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your shopeName",
                        labelText: 'ShopeName',
                        prefixIcon: Icon(Icons.home),
                      ),
                      maxLength: 15,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return 'Enter correct shopName';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.miscellaneous_services_outlined),
                      labelText: 'Add your work'),
                  hint: const Text('   Select Work   '),
                  iconSize: 36,
                  value: workType,
                  onChanged: (newValue) {
                    setState(() {
                      workType = newValue.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select workType';
                    } else {
                      return null;
                    }
                  },
                  items: workList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text('   $value  '),
                    );
                  }).toList(),
                ),
                // SizedBox(height: size.height*,),
                Row(
                  children: [
                    const SizedBox(
                      child: Text(
                        '  Select time schedule',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          timingBottomSheet(context);
                        },
                        icon: const Icon(
                          Icons.schedule_send,
                          color: Colors.blue,
                        ))
                  ],
                ),
                timeList[0].timeFormat != ''
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "  ${timeList[0].hour.toString().padLeft(2, '0')}:${timeList[0].minute.toString().padLeft(2, '0')} ${timeList[0].timeFormat}"),
                          const Text('To',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(
                              "${timeList[1].hour.toString().padLeft(2, '0')}:${timeList[1].minute.toString().padLeft(2, '0')} ${timeList[1].timeFormat} "),
                        ],
                      )
                    : const SizedBox(),

                SizedBox(
                  height: size.height * 0.03,
                ),
                LocationPage(
                  formKey: _formKey,
                  sendPostion: (value) {
                    position = value;
                    setState(() {});
                  },
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: discriptionController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Discription",
                        labelText: 'Enter for discription',
                      ),
                      maxLength: 120,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please write discription';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: _submitForm, child: const Text('Submit')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> timingBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return TimingPage(
            onSelectedTime: (value) {
              timeList = value;
              setState(() {});
            },
          );
        });
  }

  void getPerm() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      // Here just ask for the permission for the first time
      await Permission.storage.request();

      // I noticed that sometimes popup won't show after user press deny
      // so I do the check once again but now go straight to appSettings
      if (permissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // Here open app settings for user to manually enable permission in case
      // where permission was permanently denied
      await openAppSettings();
    } else {
      // Do stuff that require permission here
    }
  }
}
