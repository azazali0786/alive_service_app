import 'package:alive_service_app/features/callHistory/controller/callHistoryController.dart';
import 'package:alive_service_app/features/workers/screens/work_list.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerStatefulWidget {
  static const routeName = "/History-page";

  const HistoryPage({super.key});
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends ConsumerState<HistoryPage> {
  ScrollController scrollController = ScrollController();
  CallLog callLog = CallLog();
  Future<Iterable<CallLogEntry>>? logs;

  @override
  void initState() {
    super.initState();
    logs = ref
        .read(callHistoryControllerProvider)
        .callHistoryRepository
        .getCallLogs();
  }

  void call(String number) {
    ref.read(callHistoryControllerProvider).callHistoryRepository.call(number);
  }

  Widget callType(CallType callType) {
    Widget wid = ref
        .read(callHistoryControllerProvider)
        .callHistoryRepository
        .getAvator(callType);
    return wid;
  }

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
    return FutureBuilder(
        future: logs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Iterable<CallLogEntry> entries = snapshot.data!;
            return ListView.builder(
                controller: scrollController,
                itemCount: entries.length,
                itemBuilder: (context, index) {
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
                                  entries.elementAt(index).name.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_outward),
                                    const SizedBox(
                                      child: Text(
                                        ' 12:48 am',
                                        style: TextStyle(
                                            fontSize: 16,
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
                                call(entries.elementAt(index).number.toString());
                              },
                              icon: const Icon(Icons.phone)),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
