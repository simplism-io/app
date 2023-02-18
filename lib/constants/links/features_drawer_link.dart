import 'package:flutter/material.dart';

import '../../services/localization_service.dart';
import '../icons/chevron_right_icon.dart';
import '../../screens/public/features._screen.dart';

class FeaturesDrawerLink extends StatelessWidget {
  final bool highlight;
  const FeaturesDrawerLink({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: ListTile(
        onTap: () => {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const FeaturesScreen(),
          )),
        },
        title: Text(
            LocalizationService.of(context)?.translate('features_link_label') ??
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
