// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:base/constants/drawers/private_menu_end_drawer.dart';
import 'package:base/constants/icons/checkmark_icon.dart';
import 'package:base/constants/icons/chevron_down_icon.dart';
import 'package:base/constants/loaders/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/icons/alert_icon.dart';
import '../../constants/icons/chevron_right_icon.dart';
import '../../constants/icons/email_icon.dart';
import '../../services/localization_service.dart';
import '../../services/mailbox_service.dart';
import '../../services/message_service.dart';
import '../../constants/links/logo_header_link.dart';
import '../../services/util_service.dart';
import 'message_detail_screen.dart';

final supabase = Supabase.instance.client;

class MessagesScreen extends StatefulWidget {
  final dynamic agent;
  const MessagesScreen({Key? key, required this.agent}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool loaded = false;
  bool defaultViewCollapsed = false;
  bool customViewCollapsed = false;
  String? viewEncoded;
  final Map view = {};
  List? localMessages = [];

  @override
  initState() {
    countdown();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    await supabase.removeAllChannels();
    super.dispose();
  }

  getIcon(channel) {
    switch (channel) {
      case 'email':
        return const EmailIcon(size: 15);
      case 'alert':
        return const AlertIcon();
    }
  }

  drawer() {
    return const Drawer(child: Text('Text'));
  }

  countdown() {
    Timer(const Duration(seconds: 10), () {
      setState(() {
        loaded = true;
      });
    });
  }

  toggleCollapsedDefaultViews() {
    setState(() {
      defaultViewCollapsed = !defaultViewCollapsed;
    });
  }

  toggleCollapsedCustomViews() {
    setState(() {
      customViewCollapsed = !customViewCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.smallerThan(name: TABLET)],
                child: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.collections,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  );
                })),
            const LogoHeaderLink()
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: IconButton(
                icon: Icon(
                    (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.macOS)
                        ? CupertinoIcons.bars
                        : FontAwesomeIcons.bars,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            );
          })
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ResponsiveRowColumn(
          layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          rowPadding: const EdgeInsets.all(20.0),
          columnPadding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          children: [
            ResponsiveRowColumnItem(
                child: ResponsiveVisibility(
              hiddenWhen: const [Condition.smallerThan(name: TABLET)],
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            LocalizationService.of(context)
                                    ?.translate('views_header_label') ??
                                '',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      // Column(
                      //   children: [
                      //     const SizedBox(height: 4),
                      //     SizedBox(
                      //       child: Builder(
                      //         builder: (context) {
                      //           return IconButton(
                      //             icon: const Icon(
                      //               Icons.chevron_left,
                      //             ),
                      //             onPressed: () {
                      //               Scaffold.of(context).openDrawer();
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Consumer<MessageService>(
                          builder: (context, ms, child) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: GestureDetector(
                                  onTap: () => {ms.removeViewFromPrefs()},
                                  child: Row(
                                    children: [
                                      Text(
                                          LocalizationService.of(context)
                                                  ?.translate(
                                                      'all_messages_button_label') ??
                                              '',
                                          style: TextStyle(
                                              color: ms.activeView == null
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : null)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '(' +
                                              (ms.totalMessageCount)
                                                   +
                                              ')',
                                          style: TextStyle(
                                              color: ms.activeView == null
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : null))
                                    ],
                                  ),
                                ),
                              )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: GestureDetector(
                            onTap: () => {toggleCollapsedDefaultViews()},
                            child: Row(
                              children: [
                                Text(
                                  LocalizationService.of(context)?.translate(
                                          'default_email_views_header_label') ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                defaultViewCollapsed == false
                                    ? const ChevronRightIcon(size: 12)
                                    : const ChevronDownIcon(size: 12)
                              ],
                            )),
                      ),
                      defaultViewCollapsed == true
                          ? LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.2,
                              child: FutureBuilder(
                                builder: (ctx, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data.length > 0) {
                                      final mailboxes = snapshot.data!;
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: mailboxes.length,
                                          itemBuilder: (context, index) {
                                            view['key'] = 'emails.mailbox_id';
                                            view['value'] =
                                                mailboxes[index]['id'];
                                            viewEncoded = json.encode(view);

                                            return Consumer<MessageService>(
                                                builder:
                                                    (context, ms, child) =>
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 5, 10, 5),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () => {
                                                              ms.saveViewToPrefs(
                                                                  viewEncoded)
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  mailboxes[
                                                                          index]
                                                                      ['email'],
                                                                  style: TextStyle(
                                                                      color: ms.activeView ==
                                                                              mailboxes[index][
                                                                                  'id']
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .primary
                                                                          : null),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                    '(' +
                                                                        (mailboxes[index]['emails'].length)
                                                                            .toString() +
                                                                        ')',
                                                                    style: TextStyle(
                                                                        color: ms.activeView ==
                                                                                mailboxes[index]['id']
                                                                            ? Theme.of(context).colorScheme.primary
                                                                            : null))
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                          });
                                    } else {
                                      return Container();
                                    }
                                  }
                                  return const Loader(size: 25.0);
                                },
                                future: MailBoxService().loadMailBoxes(),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: GestureDetector(
                          onTap: () => {toggleCollapsedCustomViews()},
                          child: Text(
                              LocalizationService.of(context)?.translate(
                                      'custom_views_header_label') ??
                                  '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: customViewCollapsed == true
                                      ? FontWeight.bold
                                      : null)),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      customViewCollapsed == true
                          ? Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: SizedBox(
                                child: Text('Custom Views'),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            )),
            ResponsiveRowColumnItem(
                rowFlex: 4,
                child: Consumer<MessageService>(
                    builder: (context, ms, child) => ms.messages.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: ms.messages.length,
                            itemBuilder: (context, index) {
                              localMessages = ms.messages;
                              return SizedBox(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0,
                                        0.0,
                                        ResponsiveValue(context,
                                            defaultValue: 0.0,
                                            valueWhen: [
                                              const Condition.largerThan(
                                                  name: MOBILE, value: 10.0)
                                            ]).value!,
                                        0.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MessageDetailScreen(
                                                          message: ms
                                                              .messages[index],
                                                          agent: widget.agent)),
                                            )
                                          },
                                          child: ms.messages[index]
                                                      ['incoming'] ==
                                                  true
                                              ? Card(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  elevation: 0,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 10, 15, 10),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 40,
                                                            child:
                                                                Text('avtr')),
                                                        Text(
                                                          ms.messages[index][
                                                                          'channels']
                                                                      [
                                                                      'channel'] ==
                                                                  'alert'
                                                              ? UtilService()
                                                                  .truncateString(
                                                                      LocalizationService.of(context)?.translate(ms.messages[index]["subject"]) ??
                                                                          '',
                                                                      ResponsiveValue(
                                                                              context,
                                                                              defaultValue:
                                                                                  20,
                                                                              valueWhen: [
                                                                            const Condition.largerThan(
                                                                                name: TABLET,
                                                                                value: 50),
                                                                            const Condition.largerThan(
                                                                                name: MOBILE,
                                                                                value: 30)
                                                                          ])
                                                                          .value!)
                                                              : UtilService()
                                                                  .truncateString(
                                                                      ms.messages[
                                                                              index]
                                                                          ["subject"],
                                                                      15),
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const Spacer(),
                                                        getIcon(
                                                            ms.messages[index]
                                                                    ['channels']
                                                                ['channel']),
                                                      ],
                                                    ),
                                                  ))
                                              : Container(),
                                        ),
                                      ],
                                    )),
                              ); //getMessages();
                            })
                        : loaded == true
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0.0,
                                    0.0,
                                    ResponsiveValue(context,
                                        defaultValue: 0.0,
                                        valueWhen: [
                                          const Condition.largerThan(
                                              name: MOBILE, value: 10.0)
                                        ]).value!,
                                    0.0),
                                child: Card(
                                  color: Theme.of(context).colorScheme.surface,
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 10.0, 15.0, 10.0),
                                    child: Row(
                                      children: [
                                        Text(LocalizationService.of(context)
                                                ?.translate(
                                                    'no_data_message_messages') ??
                                            ''),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const Loader(size: 50.0)))
          ],
        ),
      ),
      drawer: drawer(),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}
