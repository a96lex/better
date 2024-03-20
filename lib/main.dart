import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/screens/about.dart';
import 'package:better/screens/history.dart';
import 'package:better/screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.albertSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // TODO: remove
      locale: const Locale("es"),
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
    const HomeScreen(),
    const HistoryScreen(),
    const AboutScreen()
  ];

  void _deleteEvents() async {
    await DatabaseHelper.instance.deleteAllEvents();
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
          toolbarHeight: 120,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.title,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontFamily: "Playfair Display",
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 80),
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          itemCount: _widgetOptions.length,
          itemBuilder: (context, index) =>
              SingleChildScrollView(child: _widgetOptions[index]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 40,
          selectedFontSize: 0,
          iconSize: 30,
          currentIndex: _pageIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline_rounded),
              label: "",
            ),
          ],
        ),
        // for debug purposes only.
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _deleteEvents,
              tooltip: 'Delete events',
              foregroundColor: Colors.red,
              backgroundColor: Colors.red.shade100,
              child: const Icon(Icons.delete_forever_rounded),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ],
        ));
  }
}
