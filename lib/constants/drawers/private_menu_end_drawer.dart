import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../screens/private/admin/admin_screen.dart';
import '../../screens/private/agent/agent_screen.dart';
import '../../services/agent_service.dart';
import '../../services/biometric_service.dart';
import '../../services/internationalization_service.dart';
import '../../services/localization_service.dart';
import '../../services/theme_service.dart';
import '../icons/chevron_right_icon.dart';

final supabase = Supabase.instance.client;

class PrivateMenuEndDrawer extends StatefulWidget {
  final dynamic agent;
  const PrivateMenuEndDrawer({super.key, required this.agent});

  @override
  State<PrivateMenuEndDrawer> createState() => _PrivateMenuEndDrawerState();
}

class _PrivateMenuEndDrawerState extends State<PrivateMenuEndDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Text(
              LocalizationService.of(context)
                      ?.translate('settings_header_label') ??
                  '',
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20.0),
        supabase.auth.currentSession!.user.userMetadata!['is_admin'] == true
            ? Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: ListTile(
                  onTap: () => {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => const AdminScreen()),
                    )
                  },
                  title: Text(
                      LocalizationService.of(context)
                              ?.translate('admin_drawer_link_label') ??
                          '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const ChevronRightIcon(size: 15),
                ))
            : Container(),
        const SizedBox(height: 5.0),
        Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: ListTile(
              onTap: () => {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                      builder: (context) => AgentScreen(agent: widget.agent)),
                )
              },
              title: Text(
                  LocalizationService.of(context)
                          ?.translate('profile_link_label') ??
                      '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const ChevronRightIcon(size: 15),
            )),
        const SizedBox(height: 5.0),
        Consumer<InternationalizationService>(
          builder: (context, internationalization, child) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
              child: ListTile(
                  title: Text(
                      LocalizationService.of(context)!
                          .translate('language_dropdown_label')!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: DropdownButton<String>(
                    underline: Container(
                        color: Theme.of(context).colorScheme.background),
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
        ),
        Padding(
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
        ),
        defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android
            ? Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
                child: Consumer<BiometricService>(
                  builder: (context, localAuthentication, child) =>
                      SwitchListTile(
                    activeColor: Theme.of(context).colorScheme.primary,
                    title: Text(
                      LocalizationService.of(context)
                              ?.translate('biometrics_switcher_label') ??
                          '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      localAuthentication.toggleBiometrics();
                    },
                    value: localAuthentication.biometrics,
                  ),
                ),
              )
            : Container(),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
          child: ListTile(
            onTap: () async => {await AgentService().signOut()},
            title: Text(
                LocalizationService.of(context)
                        ?.translate('sign_out_button_label') ??
                    '',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground)),
            trailing: const ChevronRightIcon(size: 15),
          ),
        )
      ],
    ));
  }
}
