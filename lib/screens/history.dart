import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<Event> eventList = [];

  @override
  void initState() {
    super.initState(); // _readEvent();

    _getAllEvents();

    DatabaseHelper.instance.onUpdate.listen((event) async {
      _getAllEvents();
    });
  }

  void _getAllEvents() async {
    var fetchedEventList = await DatabaseHelper.instance.readAllevents();
    setState(() {
      eventList = fetchedEventList;
      print("setstate called, length: ${eventList.length}");
      print("setstate called, list: $eventList");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventList.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 6.0,
                    height: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 60,
                    ),
                    child: Text(DateFormat.yMMMMEEEEd(
                                Localizations.localeOf(context).languageCode)
                            .add_Hm()
                            .format(eventList[index].date)
                        // Additional Text properties
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 100),
                    child: Text(
                      '${eventList[index].text}',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
