import 'package:alive_service_app/features/details/screens/user_detail_page.dart';
import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    workType = widget.workerInf['workType']![0];
    super.initState();
  }

  void _showRatingDialog(BuildContext context, worker) {
    double rating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate ${worker['rating']}'),
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

   void _submitRating( worker, double rating) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference workerRef = FirebaseFirestore.instance
        .collection('userDetails')
        .doc(worker['workType'])
        .collection('Users')
        .doc(widget.workerInf['workerId']![0]);

    DocumentReference userRatingRef = workerRef
        .collection('ratings')
        .doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot workerSnapshot = await transaction.get(workerRef);
      DocumentSnapshot userRatingSnapshot = await transaction.get(userRatingRef);

      if (!workerSnapshot.exists) {
        throw Exception("Worker does not exist!");
      }

      double currentOverallRating = (workerSnapshot['overallRating'] as num).toDouble();
      int currentRatingCount = workerSnapshot['ratingCount'] as int;

      double previousUserRating = 0.0;
      if (userRatingSnapshot.exists) {
        previousUserRating = (userRatingSnapshot['rating'] as num).toDouble();
      }

      double newOverallRating;
      if (userRatingSnapshot.exists) {
        newOverallRating = (currentOverallRating * currentRatingCount - previousUserRating + rating) / currentRatingCount;
      } else {
        newOverallRating = (currentOverallRating * currentRatingCount + rating) / (currentRatingCount + 1);
        currentRatingCount += 1;
      }

      transaction.update(workerRef, {
        'overallRating': newOverallRating,
        'ratingCount': currentRatingCount,
      });

      transaction.set(userRatingRef, {
        'rating': rating,
      });
    });

    setState(() {});
  }

   
//   void _submitRating(worker, double rating) async {
//   // Ensure the worker reference path is correct
//   DocumentReference workerRef = FirebaseFirestore.instance
//       .collection('userDetails')
//       .doc(worker['workType']) // Assuming worker has a field 'workType'
//       .collection('Users')
//       .doc(widget.workerInf['workerId']![0]); // Using worker.id directly

//   try {
//     // Run the transaction
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentSnapshot snapshot = await transaction.get(workerRef);
//       if (!snapshot.exists) {
//         throw Exception("Worker does not exist!");
//       }

//       double currentRating = (snapshot['rating'] as num).toDouble();
//       int currentRatingCount = snapshot['ratingCount'] as int;

//       double newRating = (currentRating * currentRatingCount + rating) /
//           (currentRatingCount + 1);
//       int newRatingCount = currentRatingCount + 1;

//       transaction.update(workerRef, {
//         'rating': newRating,
//         'ratingCount': newRatingCount,
//       });

//     });

//     setState(() {}); // Refresh the UI
//   } catch (e) {
//     print("Failed to update rating: $e");
//   }
// }
 

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
          widget.workerInf['workType']!.length != 1
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
                    return widget.workerInf['workType']!.map((String item) {
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
              : const SizedBox(),
        ],
      ),
      body: FutureBuilder(
        future: ref
            .read(workerControllerProvidere)
            .workerRepository
            .getWorkerData(workType, widget.workerInf['workerId']![0]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the user data
            Map<String, dynamic> worker = snapshot.data as Map<String, dynamic>;
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
                      Positioned(
                          right: size.width * 0.5,
                          top: 12,
                          child: Text(
                            worker['shopeName'],
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
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
                                  '${worker['workType']}  ',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SmoothStarRating(
                                    allowHalfRating: true,
                                    onRatingChanged: (v) {
                                      setState(() {
                                        rating = v;
                                      });
                                    },
                                    starCount: 5,
                                    rating: rating,
                                    size: 20.0,
                                    filledIconData: Icons.star,
                                    halfFilledIconData:
                                        Icons.star_half_outlined,
                                    color: Colors.green,
                                    borderColor: Colors.green,
                                    spacing: 0.0),
                              ],
                            ),
                            const Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                    '    Rafiqabad caloni dasna ,Ghaziabad')),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.12,
                        ),
                        widget.currentUser == 'false'
                            ? IconButton(
                                onPressed: () {}, icon: const Icon(Icons.call))
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
                                      Container(
                                          width: 100,
                                          color: Colors.red,
                                          child: Image.network(
                                            worker['moreImage'][index],
                                            fit: BoxFit.cover,
                                          )),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
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
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '  Discription',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '  Give rating',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              _showRatingDialog(context, worker);
                            },
                            icon: const Icon(Icons.star)),
                        widget.currentUser == 'false'
                            ? IconButton(
                                onPressed: () {
                                  launchUrl(Uri.parse(
                                      'https://wa.me/${worker['phoneNumber']}'));
                                },
                                icon: const Icon(
                                  Icons.whatshot,
                                  color: Colors.green,
                                ))
                            : const SizedBox()
                      ],
                    ),
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
