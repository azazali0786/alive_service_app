// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alive_service_app/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class Time {
  int hour;
  int minute;
  String timeFormat;
  Time({
    required this.hour,
    required this.minute,
    required this.timeFormat,
  });
}

class TimingPage extends StatefulWidget {
 final ValueChanged<List<Time>> onSelectedTime;
  const TimingPage({
    Key? key,
    required this.onSelectedTime,
  }) : super(key: key);

  @override
  State<TimingPage> createState() => _TimingPageState();
}

class _TimingPageState extends State<TimingPage> {
  var timeListIndex = 0;
  List<Time> timeList =
      List<Time>.filled(2, Time(hour: 0, minute: 0, timeFormat: ''));
  var hour = 0;
  var minute = 0;
  var timeFormat = "AM";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
              "Pick Your Time!  ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} $timeFormat",
              style: TextStyle(
                                        color: black.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),),
          const SizedBox(
            height: 20,
          ),
          timeListIndex != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '  ${timeList[0].hour.toString().padLeft(2, '0')}:${timeList[0].minute.toString().padLeft(2, '0')} ${timeList[0].timeFormat}',
                       style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 18.0,
                                      ),),
                    Text('To',
                        style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 18.0,
                                      ),),
                    Text(
                        "${timeList[1].hour.toString().padLeft(2, '0')}:${timeList[1].minute.toString().padLeft(2, '0')} ${timeList[1].timeFormat} ",
                        style: TextStyle(
                                        color: black.withOpacity(0.5),
                                        fontSize: 18.0,
                                      ),),
                  ],
                )
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberPicker(
                  minValue: 0,
                  maxValue: 12,
                  value: hour,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    setState(() {
                      hour = value;
                    });
                  },
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                  selectedTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 30),
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Colors.white,
                        ),
                        bottom: BorderSide(color: Colors.white)),
                  ),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: minute,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    setState(() {
                      minute = value;
                    });
                  },
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                  selectedTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 30),
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Colors.white,
                        ),
                        bottom: BorderSide(color: Colors.white)),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          timeFormat = "AM";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: timeFormat == "AM"
                                ? Colors.grey.shade800
                                : Colors.grey.shade700,
                            border: Border.all(
                              color: timeFormat == "AM"
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                            )),
                        child: const Text(
                          "AM",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          timeFormat = "PM";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: timeFormat == "PM"
                              ? Colors.grey.shade800
                              : Colors.grey.shade700,
                          border: Border.all(
                            color: timeFormat == "PM"
                                ? Colors.grey
                                : Colors.grey.shade700,
                          ),
                        ),
                        child: const Text(
                          "PM",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        timeList[timeListIndex] = Time(
                            hour: hour, minute: minute, timeFormat: timeFormat);
                        timeListIndex++;
                        if (timeListIndex == 2) {
                          widget.onSelectedTime(timeList);
                          Navigator.pop(context);
                        }
                        setState(() {});
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 75, 81, 94)),
                        shape:
                            WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      child: const Text("Enter"),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
