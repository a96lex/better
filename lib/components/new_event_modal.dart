import 'package:better/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewEntryModal extends StatelessWidget {
  final String text;

  const NewEntryModal({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(onPressed: () => _dialogBuilder(context), text: text);
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.newEntryModalHeader),
          content: Text(
            AppLocalizations.of(context)!.newEntryModalText,
            style: const TextStyle(fontSize: 16),
          ),
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
    );
  }
}
