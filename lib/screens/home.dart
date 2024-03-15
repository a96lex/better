import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Event? lastEvent;

  @override
  void initState() {
    super.initState();
    _readEvent();
  }

  void _readEvent() async {
    lastEvent = await DatabaseHelper.instance.readLastEvent();
    print("got last ");
    print(lastEvent);
    print(lastEvent?.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Welcome to the Home Screen!',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
