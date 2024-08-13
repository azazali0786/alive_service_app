import 'package:alive_service_app/common/utils/colors.dart';
import 'package:alive_service_app/common/widgets/data_json.dart';
import 'package:alive_service_app/features/workers/screens/worker_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: size.height*0.02),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Alive Service,", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            IconButton(onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            }, icon: const Icon(Icons.search)),
          ],
        ),
        SizedBox(
          height: size.height*0.001,
        ),
        const Text(
          "Find a worker for your work",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: size.height * 0.2, 
            aspectRatio: 2.0, 
            viewportFraction: 0.8, 
            initialPage: 0,
            enableInfiniteScroll: true, 
            autoPlay: true, 
            autoPlayInterval: const Duration(seconds: 3), 
            autoPlayAnimationDuration: const Duration(milliseconds: 800), 
            enlargeCenterPage: true, 
            enlargeStrategy: CenterPageEnlargeStrategy.height, 
            autoPlayCurve: Curves.fastOutSlowIn, 
            scrollPhysics: const BouncingScrollPhysics(), 
          ),
          items: adsData.map((item) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      item['img'],
                      fit: BoxFit.cover,
                    ),
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          item['title'] ?? 'No Title', // Display the title from adsData
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: size.height*0.03,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Categories",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "See All",
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: primary),
            )
          ],
        ),
        SizedBox(
          height: size.height*0.02,
        ),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(dataOne.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, WorkerList.routeName,
                    arguments: dataOne[index]['title']);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height*0.02),
            child: Stack(
              children: <Widget>[
                Container(
                      width: size.width * 0.28,
                      height: size.height * 0.18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(dataOne[index]['img']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: size.height * 0.045),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.only(top: size.height*0.01, right: size.width*0.01, left: size.width*0.02),
                  child: Text(
                    dataOne[index]['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(dataTwo.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, WorkerList.routeName,
                    arguments: dataTwo[index]['title']);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height*0.02),
            child: Stack(
              children: <Widget>[
                Container(
                      width: size.width * 0.28,
                      height: size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(dataTwo[index]['img']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: size.height * 0.045),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.only(top: size.height*0.01, right: size.width*0.01, left: size.width*0.02),
                  child: Text(
                    dataTwo[index]['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(dataThree.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, WorkerList.routeName,
                    arguments: dataThree[index]['title']);
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height*0.02),
            child: Stack(
              children: <Widget>[
                Container(
                      width: size.width * 0.28,
                      height: size.height * 0.18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(dataThree[index]['img']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: size.height * 0.045),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(100, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.only(top: size.height*0.01, right: size.width*0.02, left: size.width*0.02),
                  child: Text(
                    dataThree[index]['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  ],
)

      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildResults(BuildContext context) {
    // Do nothing here to prevent navigating when "Enter" is pressed on the keyboard.
    return Container(); // Empty container as navigation is handled in the ListTile onTap.
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = workNameList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Container(
            color: white,
            child: ListTile(
              title: Text(suggestion),
              onTap: () {
                query = suggestion;
                _navigateToWorkerList(context, query);
              },
            ),
          );
        });
  }

  void _navigateToWorkerList(BuildContext context, String query) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushNamed(context, WorkerList.routeName, arguments: query);
  }

  @override
  TextInputAction get textInputAction => TextInputAction.done; // Set the keyboard action
}
