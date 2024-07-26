import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/details/controller/user_details_controller.dart';
import 'package:alive_service_app/features/details/screens/user_detail_page.dart';
import 'package:alive_service_app/features/drawer/controller/drawer_controller.dart';
import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerProfileScreen extends ConsumerStatefulWidget {
  final String currentUser;
  final Map<String, List<String>> workerInf;
  static const routeName = "/Worker-Profile-Screen";
  const WorkerProfileScreen(
      {super.key, required this.workerInf, required this.currentUser});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends ConsumerState<WorkerProfileScreen> {
  Map<String, dynamic> workerData = {};
  String workType = '';
  double rating = 0;
  Map<String, List<String>> userIdWorkType = {};
  late Future<void> _fetchUserWorkData;

  @override
  void initState() {
    workType = widget.workerInf['workType']![0];
    _fetchUserWorkData = _fetchUserWorkDataAsync();
    super.initState();
  }

  Future<void> _fetchUserWorkDataAsync() async {
    userIdWorkType = await ref.read(drawerControllerProvider).userWorkData();
  }

  void _showRatingDialog(BuildContext context, worker) {
    double rating = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rating'),
          content: RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              rating = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _submitRating(worker, rating);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<String> getLocation(String lati, String logi) async {
    List<Placemark> placemarks = await ref
        .read(userDetailsControllerProvider)
        .getAddressFromLatLong(lati, logi);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;
      String address =
          "${firstPlacemark.subLocality}, ${firstPlacemark.locality}, ${firstPlacemark.street}, ${firstPlacemark.administrativeArea}";

      return address;
    } else {
      return "No address found";
    }
  }

  void _submitRating(Map<String, dynamic> worker, double rating) {
    ref
        .read(workerControllerProvidere)
        .workerRepository
        .submitRating(worker, rating, widget.workerInf['workerId']![0]);
  }

  void getCall(Map<String, dynamic> worker, String workerId) {
    ref
        .read(workerControllerProvidere)
        .workerRepository
        .call(worker['phoneNumber']);
    ref.read(workerControllerProvidere).setCallHistory((error) {
      if (mounted) {
        showSnackBar(context: context, content: error);
      }
    }, worker['mainImage'], workerId, worker['shopeName'], worker['workType']);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Profile'),
            widget.currentUser == 'true'
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, UserDetailPage.routeName,
                          arguments: workerData);
                    },
                  )
                : const SizedBox()
          ],
        ),
         actions: [
         widget.currentUser=='true'&& widget.workerInf['workType']!.length != 1? FutureBuilder<void>(
            future: _fetchUserWorkData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                return userIdWorkType['workTypes']!.length > 1
                    ? PopupMenuButton(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            children: [
                              Text(
                                workType,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (BuildContext context) {
                          return userIdWorkType['workTypes']!.map((String item) {
                            return PopupMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList();
                        },
                        onSelected: (newValue) {
                          setState(() {
                            workType = newValue;
                          });
                        },
                      )
                    : const SizedBox();
              }
            },
          ):const SizedBox()
        ],
      ),
      body: FutureBuilder(
        future: ref
            .read(workerControllerProvidere)
            .workerRepository
            .getWorkerData(workType, widget.workerInf['workerId']![0]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('This user is not present now'));
          } else {
            Map<String, dynamic> worker = snapshot.data as Map<String, dynamic>;
            var geopoint = worker['position']['geopoint'];
            var addressFuture = getLocation(
                geopoint.latitude.toString(), geopoint.longitude.toString());
            workerData = worker;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(worker['mainImage']),
                      ),
                      Text(
                        worker['shopeName'],
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ]),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${worker['workType']} ',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SmoothStarRating(
                                    allowHalfRating: false,
                                    starCount: 5,
                                    rating: worker['overallRating'],
                                    size: 20.0,
                                    filledIconData: Icons.star,
                                    halfFilledIconData:
                                        Icons.star_half_outlined,
                                    color: Colors.green,
                                    borderColor: Colors.green,
                                    spacing: 0.0),
                              ],
                            ),
                            FutureBuilder<String>(
                              future: addressFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading address...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox(
                                    width: size.width * 0.65,
                                    child: Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.12,
                        ),
                        widget.currentUser == 'false'
                            ? IconButton(
                                onPressed: () {
                                  getCall(
                                      worker, widget.workerInf['workerId']![0]);
                                },
                                icon: const Icon(Icons.call))
                            : const SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    worker['moreImage'].isNotEmpty
                        ? SizedBox(
                            height: 130,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: worker['moreImage'].length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      width: 12,
                                    ),
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(children: [
                                      InstaImageViewer(
                                        child: Container(
                                            width: 100,
                                            color: Colors.red,
                                            child: Image.network(
                                              worker['moreImage'][index],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                              splashColor: Colors.transparent,
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.fullscreen,
                                                color: Colors.black,
                                              ))),
                                    ]),
                                  );
                                }),
                          )
                        : const SizedBox(
                            height: 12,
                          ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '  TimeIn',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'TimeOut  ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '  ${worker['timeIn']}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${worker['timeOut']}  ',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                        height: 110,
                        width: size.width * 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '  Discription',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              Text(
                                '  ${worker['discription']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    widget.currentUser == 'false'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '  Give rating',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _showRatingDialog(context, worker);
                                      },
                                      icon: const Icon(Icons.star)),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(
                                        'https://wa.me/${worker['phoneNumber']}'));
                                  },
                                  icon: const Icon(
                                    Icons.whatshot,
                                    color: Colors.green,
                                  ))
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
