import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../services/localization_service.dart';
import '../mailbox/mailbox_overview_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Navigator.pop(context);
                },
              );
            }),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 450.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 450.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: () => {
                                  Navigator.pop(context),
                                },
                            child: Text(LocalizationService.of(context)
                                    ?.translate('go_back_link_label') ??
                                '')),
                        const SizedBox(height: 20),
                        Text(
                            LocalizationService.of(context)
                                    ?.translate('admin_header_label') ??
                                '',
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                        const SizedBox(height: 40.0),
                        (defaultTargetPlatform == TargetPlatform.iOS ||
                                defaultTargetPlatform == TargetPlatform.macOS)
                            ? CupertinoButton(
                                onPressed: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MailboxOverviewScreen()),
                                  );
                                },
                                color: Theme.of(context).colorScheme.primary,
                                child: Text(LocalizationService.of(context)
                                        ?.translate(
                                            'manage_email_link_label') ??
                                    ''))
                            : ElevatedButton(
                                onPressed: () => {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MailboxOverviewScreen()),
                                      )
                                    },
                                child: Text(LocalizationService.of(context)
                                        ?.translate(
                                            'manage_email_link_label') ??
                                    '')),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
