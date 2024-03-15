import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';
import 'package:better/screens/about.dart';
import 'package:better/screens/history.dart';
import 'package:better/screens/home.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Mejor'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;
  late PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    const HistoryScreen(),
    const AboutScreen()
  ];

  void _addEvent() async {
    var newEvent = Event(date: DateTime.now());
    await DatabaseHelper.instance.createEvent(newEvent);
    print("Added one event.");
  }

  void _readEvents() async {
    var event = await DatabaseHelper.instance.readAllevents();
    print("i read one");
    for (var e in event) {
      print(e.toMap());
    }
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontFamily: "Playfair Display",
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 80),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 40,
        selectedFontSize: 12.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'About',
          ),
        ],
        currentIndex: _pageIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

        // floatingActionButton:
        //     Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        //   FloatingActionButton(
        //     onPressed: _addEvent,
        //     tooltip: 'Add event',
        //     child: const Icon(Icons.add),
        //   ), // This trailing comma makes auto-formatting nicer for build methods.
        //   // add some space
        //   const SizedBox(
        //     height: 10,
        //   ),
        //   FloatingActionButton(
        //     onPressed: _readEvents,
        //     tooltip: 'Read events',
        //     child: const Icon(Icons.chrome_reader_mode),
        //   ), // This trailing comma makes auto-formatting nicer for build methods.
        // ]));