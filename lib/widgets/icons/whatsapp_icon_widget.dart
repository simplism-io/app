import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailIconWidget extends StatelessWidget {
  const EmailIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Icon(FontAwesomeIcons.whatsapp,
            color: Theme.of(context).colorScheme.onBackground));
  }
}
