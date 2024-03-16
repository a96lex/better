import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? lastEvent;

  bool _initialStateSet = false;

  @override
  void initState() {
    super.initState();
    // _readEvent();
  }

  void _readEvent() async {
    Event? maybeLastEvent = await DatabaseHelper.instance.readLastEvent();

    // Workaround
    // for some reason, the combination of StreamController stream and setState
    // is triggering many database reads. If setState is not used, on the
    // initial component build, the lastEvent will be null.
    if (maybeLastEvent != null && mounted) {
      if (!_initialStateSet) {
        setState(() {
          lastEvent = maybeLastEvent.toMap();
          _initialStateSet = true;
        });
      } else {
        lastEvent = maybeLastEvent.toMap();
      }
    } else {
      lastEvent = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: DatabaseHelper.instance.onUpdate,
      builder: (context, snapshot) {
        // Call _readEvent() here to update the data from the database
        _readEvent();

        // Your UI code here
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (lastEvent == null)
                const Text("No last event")
              else
                Text(
                  "Last event: ${lastEvent?['id']}, ${lastEvent?['date']}",
                  style: const TextStyle(fontSize: 20),
                ),
            ],
          ),
        );
      },
    );
  }
}
