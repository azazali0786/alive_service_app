import 'package:alive_service_app/features/workers/screens/worker_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class WorkList extends StatelessWidget {
  
  const WorkList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 233, 240),
      
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          CarouselSlider(
            options: CarouselOptions(
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              height: 180.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 2,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: imgList
                .map((item) => Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7.0)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(item,
                                  fit: BoxFit.cover, width: 1000.0),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    'No. ${imgList.indexOf(item)} image',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ))
                .toList(),
          ),
          const Works()
        ]),
      ),
    );
  }
}

class Works extends StatelessWidget {
  const Works({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 150,
              maxCrossAxisExtent: 125,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8),
          itemCount: imgList.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, WorkerList.routeName,
                    arguments: workNameList[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(imgList[index]),
                        fit: BoxFit.cover)),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      workNameList[index],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            );
          }),
    );
  }
}

final List<String> workNameList = [
  'Plumber',
  'Electrician',
  'Fridge Mistry',
  'AC Mistry',
  'Carpentor',
  'Parler Girl'
];

final List<String> imgList = [
  'https://img.freepik.com/free-vector/colorful-plumbing-round-composition_1284-40766.jpg?size=626&ext=jpg&ga=GA1.1.869417839.1647071011&semt=sph',
  'https://img.freepik.com/free-vector/colorful-electricity-elements-concept_1284-37811.jpg?size=626&ext=jpg&ga=GA1.1.869417839.1647071011&semt=sph',
  'https://img.freepik.com/free-vector/gluttony-flat-concept-with-man-hugging-fridge-with-junk-food-floor_1284-64200.jpg?size=626&ext=jpg&ga=GA1.1.869417839.1647071011&semt=ais',
  'https://img.freepik.com/free-vector/isometric-air-conditioning-concept-with-worker-men-installing-cooking-system-vector-illustration_1284-80987.jpg?size=626&ext=jpg&ga=GA1.1.869417839.1647071011&semt=ais',
  'https://img.freepik.com/free-vector/carpentry-round-concept_1284-38167.jpg?size=626&ext=jpg&ga=GA1.1.869417839.1647071011&semt=sph',
  'https://img.freepik.com/free-photo/beautician-with-brush-applies-white-moisturizing-mask-face-young-girl-client-spa-beauty-salon_343596-4247.jpg?w=996&t=st=1703509748~exp=1703510348~hmac=d4f4c7d89511cf45044777e267b38263044128be8ab3bbeaa0847ed94f96f3ec'
];
