import 'package:alive_service_app/common/utils/colors.dart';
import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/details/controller/user_details_controller.dart';
import 'package:alive_service_app/features/details/screens/user_detail_page.dart';
import 'package:alive_service_app/features/drawer/controller/drawer_controller.dart';
import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:alive_service_app/features/workers/screens/full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
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
  var number = '';

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
              color: Color.fromARGB(255, 109, 160, 255),
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
          "${firstPlacemark.subLocality}, ${firstPlacemark.locality}, ${firstPlacemark.postalCode}, ${firstPlacemark.administrativeArea}";
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
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
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
          widget.currentUser == 'true' &&
                  widget.workerInf['workType']!.length != 1
              ? FutureBuilder<void>(
                  future: _fetchUserWorkData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    } else {
                      return userIdWorkType['workTypes']!.length > 1
                          ? PopupMenuButton(
                              color: const Color.fromARGB(255, 242, 247, 255),
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
                                return userIdWorkType['workTypes']!
                                    .map((String item) {
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
                )
              : const SizedBox()
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
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreenImage(
                                    imageUrl: worker['mainImage'])));
                      },
                      child: Container(
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 109, 160, 255)
                                  .withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: NetworkImage(worker['mainImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: worker['shopeName'],
                                      style: TextStyle(
                                        color: black.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  (${worker['workType']})',
                                      style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.currentUser == 'false'
                                  ? GestureDetector(
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            'https://wa.me/${worker['phoneNumber']}'));
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSyTGYZZm3l6Wyx0tdsjFt5DwdFGav-3Bt6A&s"),
                                                fit: BoxFit.cover)),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          Row(
                            children: [
                              SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
                                  rating: worker['overallRating'],
                                  size: 20.0,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half_outlined,
                                  color:
                                      const Color.fromARGB(255, 109, 160, 255),
                                  borderColor:
                                      const Color.fromARGB(255, 109, 160, 255),
                                  spacing: 0.0),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              Text(
                                worker['overallRating'].toStringAsFixed(1),
                                style: TextStyle(
                                  color: black.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: black.withOpacity(0.6),
                                size: 20.0,
                              ),
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
                                return RichText(
                                  text: TextSpan(
                                    text: snapshot.data,
                                    style: TextStyle(
                                      color: black.withOpacity(0.5),
                                      fontSize: 15.0,
                                      height: 1.4,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: size.width * 0.02),
                          Text(
                            'Timing',
                            style: TextStyle(
                              color: black.withOpacity(0.9),
                              fontSize: 18.0,
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${worker['timeIn']} to ${worker['timeOut']}',
                            style: TextStyle(
                              color: black.withOpacity(0.5),
                              fontSize: 15.0,
                              height: 1.4,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: size.width * 0.05),
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
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullScreenImage(
                                                            imageUrl: worker[
                                                                    'moreImage']
                                                                [index])));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                                width: 100,
                                                color: grey,
                                                child: Image.network(
                                                  worker['moreImage'][index],
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        );
                                      }),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${worker['discription']}',
                              style: TextStyle(
                                color: black.withOpacity(0.5),
                                fontSize: 15.0,
                                height: 1.4,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          widget.currentUser == 'false'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          _showRatingDialog(context, worker),
                                      child: const Column(
                                        children: [
                                          Text(
                                            '  Give rating',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Icon(Icons.star),
                                        ],
                                      ),
                                    ),
                                    FloatingActionButton(
                                      backgroundColor: const Color.fromARGB(
                                          255, 109, 160, 255),
                                      onPressed: () {
                                        getCall(worker,
                                            widget.workerInf['workerId']![0]);
                                      },
                                      child: const Icon(
                                        Icons.call,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
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
