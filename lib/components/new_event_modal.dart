import 'package:better/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:better/components/date_time.dart';
import 'package:intl/intl.dart';
import 'package:better/database/database_helper.dart';
import 'package:better/models/event.dart';

class NewEntryModal extends StatefulWidget {
  final String text;

  const NewEntryModal({
    super.key,
    required this.text,
  });

  @override
  NewEntryModalState createState() => NewEntryModalState();
}

class NewEntryModalState extends State<NewEntryModal> {
  String selectedDateTimeDisplayText = "";
  DateTime selectedDateTime = DateTime.now();
  bool _isDialogOpen = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      selectedDateTimeDisplayText = _getDefaultDateTime(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () => _dialogBuilder(context),
      text: widget.text,
    );
  }

  String _getDefaultDateTime(BuildContext context) {
    // Calculate the default date and time string
    String formattedDate =
        DateFormat.yMd(Localizations.localeOf(context).languageCode)
            .format(DateTime.now());
    String formattedTime = DateFormat('H:mm').format(DateTime.now());
    String selectedDateTimeDisplayText = '$formattedDate $formattedTime';
    return selectedDateTimeDisplayText;
  }

  Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime? maybeSelectedDateTime = await showDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (maybeSelectedDateTime != null && context.mounted) {
      // Handle the selected date and time
      String formattedDate =
          DateFormat.yMd(Localizations.localeOf(context).languageCode)
              .format(maybeSelectedDateTime);
      String formattedTime = DateFormat('H:mm').format(maybeSelectedDateTime);
      setState(() {
        selectedDateTimeDisplayText = "$formattedDate $formattedTime";
        selectedDateTime = maybeSelectedDateTime;
        // force rebuild of _dialogBuilder. This is a workaround. I have no idea
        // why the button text is not updated if I remove this line.
        _dialogBuilder(context);
      });
    }
  }

  void _addEvent() async {
    var newEvent = Event(
      date: selectedDateTime,
      text: _textController.text,
    );
    await DatabaseHelper.instance.createEvent(newEvent);
  }

  Future<void> _dialogBuilder(BuildContext context) {
    // Prevent multiple dialogs from being opened.
    if (_isDialogOpen) {
      return Future.value();
    }

    _isDialogOpen = true;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.newEntryModalHeader),
          content: SingleChildScrollView(
              child: Column(children: [
            Text(
              AppLocalizations.of(context)!.newEntryModalText,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () => _showDateTimePicker(context),
              text: selectedDateTimeDisplayText,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _textController,
                maxLines: 4,
                maxLength: 1000,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!
                      .newEntryModalDescriptionPrompt,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                _addEvent();
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {
                  selectedDateTimeDisplayText = _getDefaultDateTime(context);
                  _textController.clear();
                });
              },
              text: AppLocalizations.of(context)!.newEntryModalButton,
            )
          ])),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(AppLocalizations.of(context)!.newEntryModalClose),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((value) {
      _isDialogOpen = false;
    });
  }
}
