import 'package:better/components/new_event_modal.dart';
import 'package:flutter/material.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? lastEvent;

  @override
  void initState() {
    super.initState(); // _readEvent();

    _checkLast();

    DatabaseHelper.instance.onUpdate.listen((event) async {
      _checkLast();
    });
  }

  void _checkLast() async {
    Event? maybeLastEvent = await DatabaseHelper.instance.readLastEvent();

    // Workaround
    // for some reason, the combination of StreamController stream and setState
    // is triggering many database reads. If setState is not used, on the
    // initial component build, the lastEvent will be null.
    if (mounted) {
      setState(() {
        lastEvent = maybeLastEvent?.toMap();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(60, 10, 60, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lastEvent == null) ...[
              Text(
                AppLocalizations.of(context)!.homeNoEntries,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 60),
              NewEntryModal(
                text: AppLocalizations.of(context)!.homeFirstEntryButton,
              )
            ] else ...[
              Text(
                AppLocalizations.of(context)!.homeHeader,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "\nLast event: ${lastEvent?['id']}, ${lastEvent?['date']}\n",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                AppLocalizations.of(context)!.homeFooter,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 60),
              NewEntryModal(
                text: AppLocalizations.of(context)!.homeNewEntryButton,
              )
            ]
          ],
        ));
  }
}
