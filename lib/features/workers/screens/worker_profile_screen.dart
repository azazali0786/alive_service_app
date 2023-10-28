import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class WorkerProfileScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> worker;
  static const routeName = "/Worker-Profile-Screen";
  const WorkerProfileScreen({super.key, required this.worker});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends ConsumerState<WorkerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double rating = 3.5;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('workerProfile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage(
                          widget.worker['mainImage']),
                      fit: BoxFit.fill),
                ),
              ),
              Positioned(
                  right: size.width * 0.5,
                  bottom: 12,
                  child: Text(
                    widget.worker['shopeName'],
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  )),
            ]),
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                         Text(
                          '${widget.worker['shopeName']}  ',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
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
                            halfFilledIconData: Icons.star_half_outlined,
                            color: Colors.green,
                            borderColor: Colors.green,
                            spacing: 0.0),
                      ],
                    ),
                    const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('   Rafiqabad caloni dasna ,Ghaziabad')),
                  ],
                ),
                SizedBox(
                  width: size.width * 0.12,
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.call))
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '  TimeIn',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  'TimeOut  ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                  '  ${widget.worker['timeIn']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${widget.worker['timeOut']}  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                       Text(
                        '  ${widget.worker['discription']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: size.height * 0.06,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '  Give rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
