import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/internationalization_service.dart';
import '../../services/localization_service.dart';

class LanguageDrawerDropdown extends StatelessWidget {
  const LanguageDrawerDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternationalizationService>(
      builder: (context, internationalization, child) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
          child: ListTile(
              title: Text(
                  LocalizationService.of(context)!
                      .translate('language_dropdown_label')!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: DropdownButton<String>(
                underline:
                    Container(color: Theme.of(context).colorScheme.background),
                value: internationalization.selectedItem,
                onChanged: (String? newValue) {
                  internationalization.changeLanguage(Locale(newValue!));
                },
                items: internationalization.languages
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ))),
    );
  }
}
