import 'package:flutter/material.dart';

import '../../services/localization_service.dart';
import '../icons/chevron_right_icon.dart';
import '../../screens/public/contact_screen.dart';

class ContactDrawerLink extends StatelessWidget {
  final bool highlight;
  const ContactDrawerLink({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: ListTile(
        onTap: () => {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ContactScreen(),
          )),
        },
        title: Text(
            LocalizationService.of(context)?.translate('contact_link_label') ??
                '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlight == true
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            )),
        trailing: const ChevronRightIcon(size: 15),
      ),
    );
  }
}
