import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../constants/loaders/loader_spinner_widget.dart';
import '../../../services/localization_service.dart';
import '../../../services/mailbox_service.dart';
import 'create_mailbox_screen.dart';
import 'update_mailbox_screen.dart';

class MailboxOverviewScreen extends StatelessWidget {
  const MailboxOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    header() {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    ?.translate('mailbox_overview_header_label') ??
                '',
            style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onBackground)),
        const SizedBox(height: 40.0)
      ]);
    }

    createMailboxLink() {
      return (defaultTargetPlatform == TargetPlatform.iOS ||
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
                  ''));
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
          child: IntrinsicHeight(
            child: Center(
                child: SizedBox(
                    width: ResponsiveValue(context,
                        defaultValue: 450.0,
                        valueWhen: const [
                          Condition.largerThan(name: MOBILE, value: 450.0),
                          Condition.smallerThan(
                              name: TABLET, value: double.infinity)
                        ]).value,
                    child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: FutureBuilder(
                              builder: (ctx, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.data.length > 0) {
                                    final mailboxes = snapshot.data;
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: mailboxes.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Row(
                                                  children: [
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
                                                                  const UpdateMailboxScreen()),
                                                        );
                                                      },
                                                    ),
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets
                                                    //               .fromLTRB(
                                                    //           15.0,
                                                    //           5.0,
                                                    //           15.0,
                                                    //           0),
                                                    //   child: Consumer<
                                                    //       MailBoxService>(
                                                    //     builder: (context,
                                                    //             mail,
                                                    //             child) =>
                                                    //         SwitchListTile(
                                                    //       activeColor: Theme
                                                    //               .of(context)
                                                    //           .colorScheme
                                                    //           .primary,
                                                    //       title: Text(
                                                    //         LocalizationService.of(
                                                    //                     context)
                                                    //                 ?.translate(
                                                    //                     'dark_mode_switcher_label') ??
                                                    //             '',
                                                    //         style: const TextStyle(
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .bold),
                                                    //       ),
                                                    //       onChanged:
                                                    //           (value) {
                                                    //         mail.toggleEmail(
                                                    //             mailboxes[
                                                    //                     index]
                                                    //                 [
                                                    //                 'email']);
                                                    //       },
                                                    //       value: mail.email,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                );
                                              }),
                                          const SizedBox(height: 40),
                                          createMailboxLink()
                                        ]);
                                  } else {
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          header(),
                                          Text(LocalizationService.of(context)
                                                  ?.translate(
                                                      'no_data_message_mailboxes') ??
                                              ''),
                                          const SizedBox(height: 40),
                                          createMailboxLink()
                                        ]);
                                  }
                                } else {
                                  return const LoaderSpinnerWidget();
                                }
                              },
                              future: MailBoxService().loadMailboxes(),
                            ))))),
          ),
        ));
  }
}
