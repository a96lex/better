import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_widget/home_widget.dart';

class TimeBadge extends StatefulWidget {
  final int timeStamp;

  const TimeBadge({
    super.key,
    required this.timeStamp,
  });

  @override
  TimeBadgeState createState() => TimeBadgeState();
}

class TimeBadgeState extends State<TimeBadge> {
  List<List<String>> timeNomenclatures = [];
  int maxUnitValue = 0;
  String maxUnitLabel = "";
  String displayText = "";
  bool showBadge = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initNomenclatures(context);

    setState(() {
      displayText = convertToBadgeText(context, widget.timeStamp);
    });

    // call the convertToBadgeText every second from now on
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        displayText = convertToBadgeText(context, widget.timeStamp);
      });
    });
  }

  void initNomenclatures(BuildContext context) {
    timeNomenclatures = [
      [
        AppLocalizations.of(context)!.yearLongSingular,
        AppLocalizations.of(context)!.yearLongPlural,
        AppLocalizations.of(context)!.yearShort,
      ],
      [
        AppLocalizations.of(context)!.monthLongSingular,
        AppLocalizations.of(context)!.monthLongPlural,
        AppLocalizations.of(context)!.monthShort
      ],
      [
        AppLocalizations.of(context)!.dayLongSingular,
        AppLocalizations.of(context)!.dayLongPlural,
        AppLocalizations.of(context)!.dayShort
      ],
      [
        AppLocalizations.of(context)!.hourLongSingular,
        AppLocalizations.of(context)!.hourLongPlural,
        AppLocalizations.of(context)!.hourShort
      ],
      [
        AppLocalizations.of(context)!.minuteLongSingular,
        AppLocalizations.of(context)!.minuteLongPlural,
        AppLocalizations.of(context)!.minuteShort
      ],
      [
        AppLocalizations.of(context)!.secondLongSingular,
        AppLocalizations.of(context)!.secondLongPlural,
        AppLocalizations.of(context)!.secondShort
      ]
    ];
  }

  String convertToBadgeText(BuildContext context, int timeStamp) {
    var seconds = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp))
        .inSeconds;

    // only show badge after 1 day
    showBadge = seconds >= 86400;

    //TODO: handle weeks and gap years
    int years = seconds ~/ 31536000;
    seconds %= 31536000;
    int months = seconds ~/ 2592000;
    seconds %= 2592000;
    int days = seconds ~/ 86400;
    seconds %= 86400;
    int hours = seconds ~/ 3600;
    seconds %= 3600;
    int minutes = seconds ~/ 60;
    seconds %= 60;

    String result = '';
    int unitsUsed = 0;
    bool highestFound = false;

    List<int> units = [years, months, days, hours, minutes, seconds];

    for (int i = 0; i < units.length; i++) {
      var time = units[i];
      if (time > 0) {
        if (result.isNotEmpty) {
          if (unitsUsed == 2 || i == units.length - 1) {
            result += ' ${AppLocalizations.of(context)!.and} ';
          } else {
            result += ', ';
          }
        }

        result += '$time ';
        if (time == 1) {
          result += timeNomenclatures[i][0];
        } else {
          result += timeNomenclatures[i][1];
        }
        unitsUsed++;
        if (!highestFound) {
          highestFound = true;
          maxUnitValue = time;
          maxUnitLabel = timeNomenclatures[i][2];
        }
      }
      if (unitsUsed == 3) {
        break;
      }
    }

    // send result to widget
    HomeWidget.saveWidgetData("letter", maxUnitLabel);
    HomeWidget.saveWidgetData("number", maxUnitValue);
    HomeWidget.saveWidgetData("text", result);
    HomeWidget.updateWidget(
      androidName: "BadgeWidget",
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBadge)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(maxUnitValue.toString(),
                      style: const TextStyle(fontSize: 24)),
                  Text(maxUnitLabel),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Text(displayText)
        ]);
  }
}
