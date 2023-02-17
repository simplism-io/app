import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../services/localization_service.dart';
import '../../constants/loaders/loader.dart';
import '../root.dart';
import 'update_password_screen.dart';
import 'update_agent_screen.dart';

final supabase = Supabase.instance.client;

// ignore: must_be_immutable
class AgentScreen extends StatelessWidget {
  final dynamic agent;
  AgentScreen({
    super.key,
    required this.agent,
  });

  final bool loading = false;
  XFile? avatarFile;
  Uint8List? avatarBytes;

  @override
  Widget build(BuildContext context) {
    avatarBytes = base64Decode(agent!['avatar']);

    return loading
        ? const Loader(size: 50.0)
        : Scaffold(
            appBar: AppBar(
                leading: ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [Condition.smallerThan(name: TABLET)],
                  child: Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const App()),
                                (route) => false);
                      },
                    );
                  }),
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: SizedBox(
                    width: ResponsiveValue(context,
                        defaultValue: 450.0,
                        valueWhen: const [
                          Condition.largerThan(name: MOBILE, value: 450.0),
                          Condition.smallerThan(
                              name: MOBILE, value: double.infinity)
                        ]).value,
                    child: Column(
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Column(
                                  children: <Widget>[
                                    Text(
                                        LocalizationService.of(context)
                                                ?.translate(
                                                    'profile_header_label') ??
                                            '',
                                        style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 40.0),
                                    SizedBox(
                                        height: ResponsiveValue(context,
                                            defaultValue: 200.0,
                                            valueWhen: const [
                                              Condition.smallerThan(
                                                  name: TABLET, value: 175.0)
                                            ]).value,
                                        width: ResponsiveValue(context,
                                            defaultValue: 200.0,
                                            valueWhen: const [
                                              Condition.smallerThan(
                                                  name: TABLET, value: 175.0)
                                            ]).value,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.memory(avatarBytes!))),
                                    const SizedBox(height: 50.0),
                                    Text(
                                      agent['name'],
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(supabase.auth.currentUser?.email! ??
                                        ''),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                    width: ResponsiveValue(context,
                                        defaultValue: 360.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                              name: MOBILE, value: 360.0),
                                          Condition.smallerThan(
                                              name: TABLET,
                                              value: double.infinity)
                                        ]).value,
                                    child: (defaultTargetPlatform ==
                                                TargetPlatform.iOS ||
                                            defaultTargetPlatform ==
                                                TargetPlatform.macOS)
                                        ? CupertinoButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateAgentScreen(
                                                        agent: agent,
                                                        avatarBytes:
                                                            avatarBytes),
                                              ));
                                            },
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Text(
                                              LocalizationService.of(context)
                                                      ?.translate(
                                                          'update_profile_button_label') ??
                                                  '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : ElevatedButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(LocalizationService
                                                          .of(context)
                                                      ?.translate(
                                                          'update_profile_button_label') ??
                                                  ''),
                                            ),
                                            onPressed: () => {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateAgentScreen(
                                                            agent: agent,
                                                            avatarBytes:
                                                                avatarBytes),
                                                  ))
                                                })),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: ResponsiveValue(context,
                                        defaultValue: 360.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                              name: MOBILE, value: 360.0),
                                          Condition.smallerThan(
                                              name: TABLET,
                                              value: double.infinity)
                                        ]).value,
                                    child: (defaultTargetPlatform ==
                                                TargetPlatform.iOS ||
                                            defaultTargetPlatform ==
                                                TargetPlatform.macOS)
                                        ? CupertinoButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePasswordScreen(
                                                        agent: agent),
                                              ));
                                            },
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Text(
                                              LocalizationService.of(context)
                                                      ?.translate(
                                                          'update_password_button_label') ??
                                                  '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : ElevatedButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(LocalizationService
                                                          .of(context)
                                                      ?.translate(
                                                          'update_password_button_label') ??
                                                  ''),
                                            ),
                                            onPressed: () => {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePasswordScreen(
                                                            agent: agent),
                                                  ))
                                                })),
                                const SizedBox(height: 30),
                                Center(
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 30),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          alignment: Alignment.centerLeft),
                                      onPressed: () => {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Root()),
                                                    (route) => false)
                                          },
                                      child: Text(
                                          LocalizationService.of(context)
                                                  ?.translate(
                                                      'go_back_link_label') ??
                                              '')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
