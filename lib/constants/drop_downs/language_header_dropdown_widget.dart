import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:circle_flags/circle_flags.dart';

import '../../services/internationalization_service.dart';

class LanguageHeaderDropdown extends StatelessWidget {
  const LanguageHeaderDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<InternationalizationService>(
      builder: (context, internationalization, child) => Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
          child: DropdownButton<String>(
            underline: Container(color: Colors.transparent),
            value: internationalization.selectedItem,
            onChanged: (String? newValue) {
              internationalization.changeLanguage(Locale(newValue!));
            },
            items: internationalization.languages
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      CircleFlag(
                        value == 'en' ? 'gb' : value,
                        size: 25,
                      ),
                      const SizedBox(width: 5),
                      Text(value.toUpperCase())
                    ],
                  ));
            }).toList(),
          )),
    );
  }
}
