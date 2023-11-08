import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:alive_service_app/features/workers/screens/work_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallhistoryList extends ConsumerStatefulWidget {
  static const routeName = "/History-page";

  const CallhistoryList({super.key});
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends ConsumerState<CallhistoryList> {
  ScrollController scrollController = ScrollController();
  Stream<QuerySnapshot>? query;
  // Map<String, dynamic> workerData = {};
  @override
  void initState(){
    query = ref.read(workerControllerProvidere).workerRepository.getQuery();
    super.initState();
  }

  // void getworkerData(String workType, String workerId) async {
  //   workerData = await ref
  //       .read(workerControllerProvidere)
  //       .workerRepository
  //       .getWorkerData(workType, workerId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }
        return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final worker =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              // getworkerData(worker['workType'],worker['workerId']);
              return Padding(
                padding: const EdgeInsets.all(15),
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
                              "workerData",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                             Text(
                              "workerDat",
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.arrow_outward),
                                SizedBox(
                                  child: Text(
                                    ' ${worker['timeIn']}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.28,
                                  child: Text(
                                    worker['date'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
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
            });
      },
    );
  }
}
