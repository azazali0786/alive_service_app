import 'dart:io';
import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/details/controller/user_details_controller.dart';
import 'package:alive_service_app/features/details/screens/location_page.dart';
import 'package:alive_service_app/features/details/screens/timing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserDetailPage extends ConsumerStatefulWidget {
  final String currentUser;
  final Map<String, dynamic> worker;
  static const routeName = "/User-detail-page";
  const UserDetailPage(
      {super.key, required this.worker, required this.currentUser});

  @override
  ConsumerState<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserDetailPage> {
  final TextEditingController shopeNameController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  String postalCode = '';
  File? mainImage;
  List<XFile> imageFileList = [];
  Position? position;
  String? workType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Time> timeList =
      List<Time>.filled(2, Time(hour: 0, minute: 0, timeFormat: ''));
  @override
  void initState() {
    if (widget.currentUser == 'true') {
      setValue();
    }
    super.initState();
  }

  void setValue() {
    workType = widget.worker['workType'];
    shopeNameController.text = widget.worker['shopeName'];
    discriptionController.text = widget.worker['discription'];
    DateTime timeIn = DateFormat("h:mm a").parse(widget.worker['timeIn']);
    DateTime timeOut = DateFormat("h:mm a").parse(widget.worker['timeIn']);
    timeList[0] = Time(
        hour: timeIn.hour,
        minute: timeIn.minute,
        timeFormat: DateFormat("a").format(timeIn));
    timeList[1] = Time(
        hour: timeIn.hour,
        minute: timeIn.minute,
        timeFormat: DateFormat("a").format(timeOut));
    futureValueSet();
  }

  void futureValueSet() async {
    mainImage = await ref
        .read(userDetailsControllerProvider)
        .urlToFile(widget.worker['mainImage']);
    for (var image in widget.worker['moreImage']) {
      File fileImage =
          await ref.read(userDetailsControllerProvider).urlToFile(image);
      imageFileList.add(XFile(fileImage.path));
    }
    setState(() {});
  }

  void deleteUserData(String work) {
    ref.read(userDetailsControllerProvider).deleteUserData(work);
  }

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
      Navigator.pop(context);
    } else if (_formKey.currentState!.validate() && mainImage == null) {
      return showSnackBar(context: context, content: 'Please pick image');
    }
  }

  List workList = ['Plumber', 'Electrician', 'Fridge Mistry', 'AC Mistry'];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.currentUser == 'true'
          ? AppBar(
              title: const Text('Edit yourId'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Alert"),
                                content: const Text(
                                    "Do you really want to delete this Id."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No')),
                                  TextButton(
                                      onPressed: () {
                                        deleteUserData(workType.toString());
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes')),
                                ],
                              );
                            });
                      },
                      child: const Text(
                        'DeleteId',
                        style: TextStyle(color: Colors.purple),
                      )),
                )
              ],
            )
          : AppBar(
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
                        const CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/6681/6681204.png'),
                          backgroundColor: Colors.white,
                        ),
                        Positioned(
                          bottom: size.height * 0.01,
                          left: size.width * 0.25,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Color.fromARGB(255, 28, 104, 184),
                            ),
                            onPressed: () => selectImage(),
                          ),
                        ),
                      ])
                    : InkWell(
                        onTap: selectImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: FileImage(mainImage!),
                          backgroundColor: Colors.white,
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
                widget.currentUser == 'false'
                    ? DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.miscellaneous_services_outlined),
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
                      )
                    : const SizedBox(),
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
                  postalCode: postalCode,
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
  // void getPerm() async {
  //     final permissionStatus = await Permission.storage.status;
  //     if (permissionStatus.isDenied) {
  //       // Here just ask for the permission for the first time
  //       await Permission.storage.request();

  //       // I noticed that sometimes popup won't show after user press deny
  //       // so I do the check once again but now go straight to appSettings
  //       if (permissionStatus.isDenied) {
  //         await openAppSettings();
  //       }
  //     } else if (permissionStatus.isPermanentlyDenied) {
  //       // Here open app settings for user to manually enable permission in case
  //       // where permission was permanently denied
  //       await openAppSettings();
  //     } else {
  //       // Do stuff that require permission here
  //     }
  //   }
}
