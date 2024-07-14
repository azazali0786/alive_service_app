import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
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
      stream: ref.read(workerControllerProvidere).getQuery(),
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
              return Padding(
                padding: const EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, WorkerProfileScreen.routeName,
                        arguments: {'workType': [worker['workType'].toString()], 'workerId': [worker['workerId'].toString()],'currentUser': ['false']});
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
                              worker['shopName'],
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              worker['workType'],
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
