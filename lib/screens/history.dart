import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (eventList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(60, 10, 60, 0),
        child: Text(AppLocalizations.of(context)!.historyNoEvents,
            style: const TextStyle(fontSize: 16)),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.fromLTRB(60, 10, 60, 0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                int reversedIndex = eventList.length - 1 - index;
                return Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        )),
                    Text(
                      DateFormat.yMMMEd(
                              Localizations.localeOf(context).languageCode)
                          .add_Hm()
                          .format(eventList[reversedIndex].date),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 42, 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '${eventList[reversedIndex].text}',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ]);
              }));
    }
  }
}
