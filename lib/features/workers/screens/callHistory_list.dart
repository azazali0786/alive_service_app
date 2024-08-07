import 'package:alive_service_app/common/utils/colors.dart';
import 'package:alive_service_app/features/workers/controller/workerController.dart';
import 'package:alive_service_app/features/workers/screens/worker_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: white,
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
        return const Center(child: Text('Loading...'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No data available'));
      }

      return ListView.builder(
          controller: scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final worker = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final Timestamp timestamp = worker['timestamp'];
            final DateTime dateTime = timestamp.toDate();
            final String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
            final String formattedTime = DateFormat('h:mm a').format(dateTime);
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
                            style: TextStyle(
                                        color: black.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                          ),
                          Text(
                            worker['workType'],
                            style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 15.0,
                                      ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_outward,size: 15,color: black.withOpacity(0.5),),
                              SizedBox(
                                child: Text(
                                  ' $formattedTime',
                                  style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 15.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.28,
                                child: Text(
                                  formattedDate,
                                 style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 15.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    },
  );
}

}
