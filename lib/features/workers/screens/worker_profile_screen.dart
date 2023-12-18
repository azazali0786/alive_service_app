import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class WorkerProfileScreen extends ConsumerStatefulWidget {
  final String profileType;
  final Map<String, dynamic> workerInf;
  static const routeName = "/Worker-Profile-Screen";
  const WorkerProfileScreen(
      {super.key, required this.workerInf, required this.profileType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends ConsumerState<WorkerProfileScreen> {
  String workType = "Electrician";


  @override
  Widget build(BuildContext context) {
    double rating = 3.5;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileType),
        actions: [
          PopupMenuButton(
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
                  ), // Replace with your desired icon
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: "Electrician", child: Text("Electrician")),
              const PopupMenuItem(value: "Plumber", child: Text("Plumber")),
              const PopupMenuItem(
                  value: "Fridge Mistry", child: Text("Fridge Mistry")),
            ],
            onSelected: (newValue) {
              setState(() {
                workType = newValue;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(workerControllerProvidere).workerRepository.
        getWorkerData(widget.workerInf['workType'], widget.workerInf['workerId']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the user data
            Map<String, dynamic> worker = snapshot.data as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(children: [
                      Container(
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: NetworkImage(worker['mainImage']),
                              fit: BoxFit.fill),
                        ),
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
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.call))
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
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SmoothStarRating(
                          allowHalfRating: true,
                          onRatingChanged: (v) {
                            rating = v;
                            setState(() {});
                          },
                          starCount: 5,
                          rating: rating,
                          size: 40.0,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half_outlined,
                          color: Colors.green,
                          borderColor: Colors.green,
                          spacing: 0.0),
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



