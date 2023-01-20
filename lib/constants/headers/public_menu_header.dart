import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class PublicMenuHeader extends StatelessWidget {
  const PublicMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Text(
          LocalizationService.of(context)
                  ?.translate('public_menu_header_label') ??
              '',
          style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
    );
  }
}
