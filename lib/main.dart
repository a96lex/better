import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';
import 'package:better/screens/about.dart';
import 'package:better/screens/history.dart';
import 'package:better/screens/home.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mejor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;
  late PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // body: _widgetOptions.elementAt(_pageIndex),
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