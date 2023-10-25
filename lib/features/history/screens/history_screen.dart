import 'package:alive_service_app/features/works/screens/work_list.dart';
import 'package:flutter/material.dart';

// import 'package:netflix_clone/json/search_json.dart';
// import 'package:netflix_clone/pages/video_detail_page.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "/History-page";

  const HistoryPage({super.key});
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(Icons.history),
          ),
        ],
        title: const Text("Calls History"),
      ),

      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          double start = 0;
          scrollController.jumpTo(start);
        },
        child: const Icon(Icons.arrow_upward),
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
            
            const SizedBox(
              height: 12,
            ),
            Column(
                children: List.generate(imgList.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        height: 105,
                        width: 135,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage(imgList[index]),
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
                              'Shope Name$index ',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                                children: [
                                  IconButton(
                                      onPressed: (){},
                                      icon: const Icon(
                                        Icons.arrow_outward,
                                        color: Colors.blue,
                                      )),
                                  const SizedBox(
                                    child: Text(
                                      ' 12:48 am',
                                      style:
                                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
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
                          onPressed: () {}, icon: const Icon(Icons.phone)),
                    ],
                  ),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }
}
