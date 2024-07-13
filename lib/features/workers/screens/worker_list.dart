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
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  void getCall(Map<String, dynamic> worker, String workerId) {
    var date = DateFormat.yMd().format(DateTime.now());
    var timeIn = DateFormat.jm().format(DateTime.now());
    ref
        .read(workerControllerProvidere)
        .workerRepository
        .call(worker['phoneNumber']);
    ref.read(workerControllerProvidere).workerRepository.setCallHistory(
          context: context,
          mainImage: worker['mainImage'],
          workerId: workerId,
          shopeName: worker['shopeName'],
          workType: worker['workType'],
          timeIn: timeIn,
          date: date,
        );
  }

  void getPosition() async {
    position = await ref.read(userDetailsControllerProvider).getCurrentLocation();
    setState(() {});
  }

  Future<String> getLocation(String lati, String logi) async {
    List<Placemark> placemarks = await ref
        .read(userDetailsControllerProvider)
        .getAddressFromLatLong(lati, logi);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;

      String address = "${firstPlacemark.subLocality}, ${firstPlacemark.locality}";

      return address;
    } else {
      return "No address found";
    }
  }

  String radius = '5';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  const Text(
                    "Radius",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "${radius}km",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: "5", child: Text('5')),
              const PopupMenuItem(value: "10", child: Text('10')),
              const PopupMenuItem(value: "15", child: Text('15')),
              const PopupMenuItem(value: "30", child: Text('30')),
            ],
            onSelected: (newValue) {
              setState(() {
                radius = newValue;
              });
            },
          ),
        ],
        title: const Text("Current Location"),
      ),
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          double start = 0;
          scrollController.jumpTo(start);
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    // double rating = 3.0;
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
                Switch(value: false, onChanged: (onchange) {})
              ],
            ),
            Container(
              width: size.width,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Location",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  suffixIcon: const Icon(Icons.location_on),
                ),
              ),
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
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return Column(
                  children: List.generate(snapshot.data!.length, (index) {
                    final worker = snapshot.data![index].data() as Map<String, dynamic>;
                    var geopoint = worker['position']['geopoint'];

                    return FutureBuilder<String>(
                      future: getLocation(
                        geopoint.latitude.toString(),
                        geopoint.longitude.toString(),
                      ),
                      builder: (context, AsyncSnapshot<String> addressSnapshot) {
                        if (addressSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (addressSnapshot.hasError) {
                          return Text('Error: ${addressSnapshot.error}');
                        } else if (!addressSnapshot.hasData) {
                          return const Text('Address not found');
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
                                        image: NetworkImage(worker['mainImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                  SizedBox(
                                    width: size.width * 0.35,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          worker['shopeName'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${widget.workType} ',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SmoothStarRating(
                                          allowHalfRating: true,
                                          onRatingChanged: null,  // Set to null to disable rating changes
                                          starCount: 5,
                                          rating: worker['overallRating'] ?? 0.0,
                                          size: 20.0,
                                          filledIconData: Icons.star,
                                          halfFilledIconData: Icons.star_half_outlined,
                                          color: Colors.green,
                                          borderColor: Colors.green,
                                          spacing: 0.0,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.28,
                                              child: Text(
                                                addressSnapshot.data!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.location_on),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      getCall(worker, snapshot.data![index].id);
                                    },
                                    icon: const Icon(Icons.call),
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
