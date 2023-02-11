import 'dart:async';

import 'package:base/constants/drawers/private_menu_end_drawer.dart';
import 'package:base/constants/loaders/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/icons/alert_icon.dart';
import '../../constants/icons/email_icon.dart';
import '../../services/localization_service.dart';
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
        return const EmailIcon();
      case 'alert':
        return const AlertIcon();
    }
  }

  drawer() {
    return const Drawer(child: Text('Text'));
  }

  bool loaded = false;

  countdown() {
    Timer(Duration(seconds: 10), () {
      setState(() {
        loaded = true;
      });
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
              child: SizedBox(
                width: 175,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Card(
                            color: Theme.of(context).colorScheme.surface,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: const Text('Views'),
                            )),
                        Column(
                          children: [
                            const SizedBox(height: 4),
                            SizedBox(
                              child: Builder(
                                builder: (context) {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                    ),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: SizedBox(
                        child: Text('All mailboxes'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: SizedBox(
                        child: Text('Other Mailbox'),
                      ),
                    )
                  ],
                ),
              ),
            )),
            ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Consumer<MessageService>(
                    builder: (context, ms, child) => ms.messages.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: ms.messages.length,
                            itemBuilder: (context, index) {
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
                            : const Loader()))
          ],
        ),
      ),
      drawer: drawer(),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}
