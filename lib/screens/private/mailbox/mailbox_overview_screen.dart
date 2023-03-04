import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../constants/icon_buttons/go_back_text_button.dart';
import '../../../constants/loaders/loader.dart';
import '../../../services/localization_service.dart';
import '../../../services/mailbox_service.dart';
import 'create_mailbox_screen.dart';
import 'update_mailbox_screen.dart';

class MailboxOverviewScreen extends StatelessWidget {
  const MailboxOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    header() {
      return SizedBox(
        width: ResponsiveValue(context, defaultValue: 450.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 450.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const GoBackTextButton(toRoot: true),
              const SizedBox(height: 20),
              Text(
                  LocalizationService.of(context)
                          ?.translate('mailbox_overview_header_label') ??
                      '',
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.onBackground)),
            ]),
          ),
        ),
      );
    }

    createMailboxLink() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS)
            ? CupertinoButton(
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => const CreateMailboxScreen()),
                  );
                },
                color: Theme.of(context).colorScheme.primary,
                child: Text(LocalizationService.of(context)
                        ?.translate('create_mailbox_link_label') ??
                    ''))
            : ElevatedButton(
                onPressed: () => {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => const CreateMailboxScreen()),
                      )
                    },
                child: Text(LocalizationService.of(context)
                        ?.translate('create_mailbox_link_label') ??
                    '')),
      );
    }

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
        body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  height: 800,
                  width: ResponsiveValue(context,
                      defaultValue: 500.0,
                      valueWhen: const [
                        Condition.largerThan(name: MOBILE, value: 500.0),
                        Condition.smallerThan(
                            name: TABLET, value: double.infinity)
                      ]).value,
                  child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: FutureBuilder(
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data.length > 0) {
                              final mailboxes = snapshot.data;
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      header(),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: mailboxes.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Card(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              elevation: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 10, 10, 10),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                      child: Icon(
                                                          (defaultTargetPlatform ==
                                                                      TargetPlatform
                                                                          .iOS ||
                                                                  defaultTargetPlatform ==
                                                                      TargetPlatform
                                                                          .macOS)
                                                              ? CupertinoIcons
                                                                  .circle_fill
                                                              : FontAwesomeIcons
                                                                  .circle,
                                                          size: 10,
                                                          color: mailboxes[
                                                                          index]
                                                                      [
                                                                      'active'] ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.red),
                                                    ),
                                                    Text(mailboxes[index]
                                                        ['email']),
                                                    const Spacer(),
                                                    IconButton(
                                                      iconSize: 10,
                                                      icon: const Icon(
                                                        FontAwesomeIcons.pen,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpdateMailboxScreen(
                                                                      mailbox:
                                                                          mailboxes[
                                                                              index])),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 20, 20, 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                createMailboxLink(),
                                              ],
                                            ),
                                          ))
                                    ]),
                              );
                            } else {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    header(),
                                    Card(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        elevation: 0,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 20, 20, 10),
                                              child: Row(
                                                children: [
                                                  Text(LocalizationService.of(
                                                              context)
                                                          ?.translate(
                                                              'no_data_message_mailboxes') ??
                                                      ''),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 10, 20, 20),
                                                  child: createMailboxLink(),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ]);
                            }
                          } else {
                            return const Loader(size: 50.0);
                          }
                        },
                        future: MailBoxService().loadMailBoxes(),
                      )))),
        ));
  }
}
