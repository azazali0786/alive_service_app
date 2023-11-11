import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  ScrollController scrollController = ScrollController();
  void getCall(Map<String, dynamic> worker, String workerId) {
    var date = DateFormat.yMMMMd('en_US').format(DateTime.now());
    var timeIn = DateFormat.jm().format(DateTime.now());
    ref
        .read(workerControllerProvidere)
        .workerRepository
        .call(worker['phoneNumber']);
    ref.read(workerControllerProvidere).workerRepository.setCallHistory(
        context: context,
        workerId: workerId,
        shopeName: worker['shopeName'],
        workType: worker['workType'],
        timeIn: timeIn,
        date: date);
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
                  Text(
                    "Radious",
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(
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
              const PopupMenuItem(value: "20", child: Text('20')),
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
    double rating = 3.0;
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
                  color: Colors.grey.withOpacity(0.25)),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Location",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    suffixIcon: const Icon(Icons.location_on)),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userDetails')
                  .doc(widget.workType)
                  .collection('Users')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No data available');
                }

                return Column(
                    children:
                        List.generate(snapshot.data!.docs.length, (index) {
                  final worker =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, WorkerProfileScreen.routeName,
                            arguments: worker);
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
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: size.width * 0.025,
                          ),
                          SizedBox(
                            width: size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  worker['shopeName'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${widget.workType} ',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                SmoothStarRating(
                                    allowHalfRating: true,
                                    onRatingChanged: (v) {
                                      rating = v;
                                      setState(() {});
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
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.28,
                                      child: Text(
                                        'Location$index',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const Icon(Icons.location_on)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                getCall(worker, snapshot.data!.docs[index].id);
                              },
                              icon: const Icon(Icons.phone)),
                        ],
                      ),
                    ),
                  );
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
