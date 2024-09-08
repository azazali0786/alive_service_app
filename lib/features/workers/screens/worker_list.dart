import 'package:alive_service_app/common/utils/colors.dart';
import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/details/controller/user_details_controller.dart';
import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class WorkerList extends ConsumerStatefulWidget {
  final String workType;
  static const routeName = "/Worker-list";

  const WorkerList({
    Key? key,
    required this.workType,
  }) : super(key: key);

  @override
  WorkerListState createState() => WorkerListState();
}

class WorkerListState extends ConsumerState<WorkerList> {
  Position? position;
  bool sortByRating = false;
  String? currUserId;

  @override
  void initState() {
    getCurrUserId();
    getPosition();
    super.initState();
  }

  ScrollController scrollController = ScrollController();

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

  void getPosition() async {
    position =
        await ref.read(userDetailsControllerProvider).getCurrentLocation();
    setState(() {});
  }

  void getCurrUserId() {
    currUserId = ref.read(workerControllerProvidere).getCurrUserId();
  }

  Future<String> getLocation(String lati, String logi) async {
    List<Placemark> placemarks = await ref
        .read(userDetailsControllerProvider)
        .getAddressFromLatLong(lati, logi);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;

      String address =
          "${firstPlacemark.subLocality}, ${firstPlacemark.locality}";
      return address;
    } else {
      return "No address found";
    }
  }

  String radius = '10';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        actions: [
          PopupMenuButton(
            color: const Color.fromARGB(255, 249, 251, 255),
            child: Padding(
              padding: const EdgeInsets.only(right: 22),
              child: Row(
                children: [
                  Text(
                    "Radius",
                    style: TextStyle(
                      color: black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Text(
                    "${radius}km",
                    style: TextStyle(
                      color: black.withOpacity(0.7),
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: "10", child: Text('10')),
              const PopupMenuItem(value: "100", child: Text('100')),
              const PopupMenuItem(value: "500", child: Text('500')),
              const PopupMenuItem(value: "1000", child: Text('1000')),
              const PopupMenuItem(value: "2000", child: Text('2000')),
            ],
            onSelected: (newValue) {
              setState(() {
                radius = newValue;
              });
            },
          ),
        ],
        title: const Text(
          "workers",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 109, 160, 255),
        onPressed: () {
          double start = 0;
          scrollController.jumpTo(start);
        },
        child: const Icon(
          Icons.arrow_upward,
          color: white,
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 18, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rating..",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: sortByRating,
                    onChanged: (onchange) {
                      setState(() {
                        sortByRating = onchange;
                      });
                    },
                    activeColor: Colors.blue, // Customize active color
                    inactiveThumbColor:
                        Colors.grey, // Customize inactive thumb color
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: GeoFlutterFire()
                  .collection(
                    collectionRef: FirebaseFirestore.instance
                        .collection('userDetails')
                        .doc(widget.workType)
                        .collection('Users'),
                  )
                  .within(
                    center: position != null
                        ? GeoFlutterFire().point(
                            latitude: position!.latitude,
                            longitude: position!.longitude,
                          )
                        : GeoFirePoint(0, 0),
                    radius: double.parse(radius),
                    field: 'position',
                    strictMode: true,
                  ),
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Sort the data if sortByRating is true
                if (sortByRating) {
                  snapshot.data!.sort((a, b) {
                    var ratingA = a['overallRating'] ?? 0.0;
                    var ratingB = b['overallRating'] ?? 0.0;
                    return ratingB.compareTo(ratingA);
                  });
                }

                return Column(
                  children: List.generate(snapshot.data!.length, (index) {
                    final worker =
                        snapshot.data![index].data() as Map<String, dynamic>;
                    var geopoint = worker['position']['geopoint'];

                    return FutureBuilder<String>(
                      future: getLocation(
                        geopoint.latitude.toString(),
                        geopoint.longitude.toString(),
                      ),
                      builder:
                          (context, AsyncSnapshot<String> addressSnapshot) {
                        if (addressSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (addressSnapshot.hasError) {
                          return Text('Error: ${addressSnapshot.error}');
                        } else if (!addressSnapshot.hasData) {
                          return const Text('Address not found');
                        } else if (snapshot.data![index].id == currUserId) {
                          return const SizedBox();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  WorkerProfileScreen.routeName,
                                  arguments: {
                                    'workType': [widget.workType],
                                    'workerId': [snapshot.data![index].id],
                                    'currentUser': ['false'],
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 105,
                                    width: 135,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(worker['mainImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                  SizedBox(
                                    width: size.width * 0.47,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          worker['shopeName'],
                                          style: TextStyle(
                                            color: black.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(
                                          '${widget.workType} ',
                                          style: TextStyle(
                                            color: black.withOpacity(0.5),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SmoothStarRating(
                                              allowHalfRating: false,
                                              // onRatingChanged:
                                              //     null,
                                              starCount: 5,
                                              rating: worker['overallRating'] ??
                                                  0.0,
                                              size: 20.0,
                                              filledIconData: Icons.star,
                                              halfFilledIconData:
                                                  Icons.star_half_outlined,
                                              color: const Color.fromARGB(
                                                  255, 109, 160, 255),
                                              borderColor: const Color.fromARGB(
                                                  255, 109, 160, 255),
                                              spacing: 0.0,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  getCall(worker,
                                                      snapshot.data![index].id);
                                                },
                                                child: const Icon(Icons.phone))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  text: addressSnapshot.data,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 15.0,
                                                    height: 1.4,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.location_on,
                                              color: Color.fromARGB(
                                                  255, 109, 160, 255),
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
