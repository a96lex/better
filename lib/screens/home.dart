import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:better/components/custom_button.dart';

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
        _readEvent();

        return Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (lastEvent == null) ...[
                  Text(
                    AppLocalizations.of(context)!.homeNoEntries,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    onPressed: () {},
                    text: AppLocalizations.of(context)!.homeFirstEntryButton,
                  )
                ] else
                  Padding(
                      padding: const EdgeInsets.all(60),
                      child: Column(children: [
                        Text(
                          "Last event: ${lastEvent?['id']}, ${lastEvent?['date']}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ]))
              ],
            ));
      },
    );
  }
}
