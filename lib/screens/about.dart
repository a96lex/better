import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(60, 10, 60, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.aboutHeader,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              AppLocalizations.of(context)!.aboutShare,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              AppLocalizations.of(context)!.aboutKofi,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              AppLocalizations.of(context)!.aboutGithub,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              AppLocalizations.of(context)!.aboutGoogle,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              AppLocalizations.of(context)!.aboutFooter,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ));
  }
}
