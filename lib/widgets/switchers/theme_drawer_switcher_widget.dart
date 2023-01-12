import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/localization_service.dart';
import '../../services/theme_service.dart';

class ThemeDrawerSwitcherWidget extends StatelessWidget {
  const ThemeDrawerSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
      child: Consumer<ThemeService>(
        builder: (context, theme, child) => SwitchListTile(
          activeColor: Theme.of(context).colorScheme.primary,
          title: Text(
            LocalizationService.of(context)
                    ?.translate('dark_mode_switcher_label') ??
                '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onChanged: (value) {
            theme.toggleTheme();
          },
          value: theme.darkTheme,
        ),
      ),
    );
  }
}
