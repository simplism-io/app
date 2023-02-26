// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:base/constants/drawers/private_menu_end_drawer.dart';
import 'package:base/constants/icons/chevron_down_icon.dart';
import 'package:base/constants/loaders/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/icons/chevron_right_icon.dart';
import '../../../services/localization_service.dart';
import '../../../services/mailbox_service.dart';
import '../../../services/message_service.dart';
import '../../../constants/links/logo_header_link.dart';
import '../../../services/util_service.dart';
import '../view/create_view_screen.dart';
import 'message_detail_screen.dart';
import 'messages_by_customer_screen.dart';

final supabase = Supabase.instance.client;

class MessagesScreen extends StatefulWidget {
  final dynamic agent;
  const MessagesScreen({Key? key, required this.agent}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool loaded = false;
  bool defaultViewCollapsed = true;
  bool customViewCollapsed = true;
  String? viewEncoded;
  final Map view = {};
  List? localMessages = [];
  bool showSideBar = true;
  bool showCustomerBar = false;
  late bool previousStateShowSideBar;
  late Map customerInFocus;
  Uint8List? customerAvatarBytes;

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

  toggleShowSideBar() {
    setState(() {
      showCustomerBar = false;
      showSideBar = !showSideBar;
    });
  }

  toggleCustomerBar(customer) {
    setState(() {
      if (showSideBar == true) {
        previousStateShowSideBar = true;
        showSideBar = false;
      }
      if (customer != null && showCustomerBar == false) {
        showCustomerBar = !showCustomerBar;
      }
      if (customer == null && showCustomerBar == true) {
        showCustomerBar = !showCustomerBar;
        showSideBar = previousStateShowSideBar;
      }
      if (showCustomerBar == true) {
        customerAvatarBytes = base64Decode(customer['avatar']);
        customerInFocus = customer;
      }
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
                    padding: EdgeInsets.fromLTRB(
                        ResponsiveValue(context,
                            defaultValue: 10.0,
                            valueWhen: [
                              const Condition.largerThan(
                                  name: MOBILE, value: 20.0),
                            ]).value!,
                        0,
                        0,
                        0),
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
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ResponsiveValue(context, defaultValue: 0.0, valueWhen: [
                    const Condition.largerThan(name: MOBILE, value: 10.0),
                  ]).value!,
                  0,
                  0,
                  0),
              child: const LogoHeaderLink(),
            )
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  0,
                  ResponsiveValue(context, defaultValue: 10.0, valueWhen: [
                    const Condition.largerThan(name: MOBILE, value: 15.0),
                  ]).value!,
                  0),
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
      body: SingleChildScrollView(
        child: ResponsiveRowColumn(
          layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          rowPadding: const EdgeInsets.all(10.0),
          columnPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          children: [
            showSideBar == false && showCustomerBar == false
                ? ResponsiveRowColumnItem(
                    child: ResponsiveVisibility(
                    hiddenWhen: const [Condition.smallerThan(name: TABLET)],
                    child: SizedBox(
                      child: Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                            ),
                            onPressed: () {
                              toggleShowSideBar();
                              //Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                    ),
                  ))
                : ResponsiveRowColumnItem(child: Container()),
            showSideBar == true
                ? ResponsiveRowColumnItem(
                    child: ResponsiveVisibility(
                    hiddenWhen: const [Condition.smallerThan(name: TABLET)],
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                      LocalizationService.of(context)
                                              ?.translate(
                                                  'views_header_label') ??
                                          '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                const Spacer(),
                                SizedBox(
                                  child: Builder(
                                    builder: (context) {
                                      return IconButton(
                                        icon: const Icon(
                                          Icons.chevron_left,
                                        ),
                                        onPressed: () {
                                          toggleShowSideBar();
                                          //Scaffold.of(context).openDrawer();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Consumer<MessageService>(
                                builder: (context, ms, child) => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
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
                                                    (ms.totalMessageCount) +
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
                                      ),
                                      defaultViewCollapsed == true
                                          ? const ChevronRightIcon(size: 12)
                                          : const ChevronDownIcon(size: 12)
                                    ],
                                  )),
                            ),
                            defaultViewCollapsed != true
                                ? LimitedBox(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.2,
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
                                                  view['key'] =
                                                      'emails.mailbox_id';
                                                  view['value'] =
                                                      mailboxes[index]['id'];
                                                  viewEncoded =
                                                      json.encode(view);
                                                  return Consumer<
                                                          MessageService>(
                                                      builder:
                                                          (context, ms,
                                                                  child) =>
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        20,
                                                                        5,
                                                                        10,
                                                                        5),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () => {
                                                                    ms.saveViewToPrefs(
                                                                        viewEncoded)
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        mailboxes[index]
                                                                            [
                                                                            'email'],
                                                                        style: TextStyle(
                                                                            color: ms.activeView == mailboxes[index]['id']
                                                                                ? Theme.of(context).colorScheme.primary
                                                                                : null),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          '(' +
                                                                              (mailboxes[index]['emails'].length)
                                                                                  .toString() +
                                                                              ')',
                                                                          style:
                                                                              TextStyle(color: ms.activeView == mailboxes[index]['id'] ? Theme.of(context).colorScheme.primary : null))
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
                                child: Row(
                                  children: [
                                    Text(
                                        LocalizationService.of(context)?.translate(
                                                'custom_views_header_label') ??
                                            '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                customViewCollapsed != true
                                                    ? FontWeight.bold
                                                    : null)),
                                    customViewCollapsed == true
                                        ? const ChevronRightIcon(size: 12)
                                        : const ChevronDownIcon(size: 12)
                                  ],
                                ),
                              ),
                            ),
                            customViewCollapsed != true
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5, 10, 10),
                                    child: SizedBox(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              alignment: Alignment.centerLeft),
                                          onPressed: () => {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CreateViewScreen())),
                                              },
                                          child: Text('Add custom view')),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ))
                : ResponsiveRowColumnItem(child: Container()),
            showCustomerBar == true
                ? ResponsiveRowColumnItem(
                    child: SizedBox(
                    height: 250,
                    width: 200,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.xmark,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    size: 12,
                                  ),
                                  onPressed: () {
                                    toggleCustomerBar(null);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(customerAvatarBytes!)),
                            ),
                            const SizedBox(height: 20.0),
                            Text(customerInFocus['name']),
                            const SizedBox(height: 20.0),
                            TextButton(
                              onPressed: () => {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MessagesByCustomerScreen(
                                                customer: customerInFocus,
                                                agent: widget.agent))),
                              },
                              child: Text('See all messages'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
                : ResponsiveRowColumnItem(child: Container()),
            ResponsiveRowColumnItem(
                rowFlex: ResponsiveValue(context, defaultValue: 3, valueWhen: [
                  const Condition.largerThan(name: TABLET, value: 4),
                  const Condition.smallerThan(name: TABLET, value: 4)
                ]).value!,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Consumer<MessageService>(
                      builder: (context, ms, child) => ms.messages.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: ms.messages.length,
                              itemBuilder: (context, index) {
                                ms.messages[index]['customers'];
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
                                                                  message:
                                                                      ms.messages[
                                                                          index],
                                                                  agent: widget
                                                                      .agent)),
                                                    )
                                                  },
                                              child: Card(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  elevation: 0,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 10, 15, 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ResponsiveVisibility(
                                                            hiddenWhen: const [
                                                              Condition
                                                                  .largerThan(
                                                                      name:
                                                                          MOBILE)
                                                            ],
                                                            child: Row(
                                                              children: [
                                                                TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    minimumSize:
                                                                        const Size(
                                                                            40,
                                                                            20),
                                                                    tapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .shrinkWrap,
                                                                  ),
                                                                  onPressed:
                                                                      () => {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                MessagesByCustomerScreen(customer: ms.messages[index]['customers'], agent: widget.agent))),
                                                                  },
                                                                  child: Text(
                                                                      ms.messages[index]
                                                                              [
                                                                              'customers']
                                                                          [
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10)),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  Jiffy(ms.messages[
                                                                              index]
                                                                          [
                                                                          'created'])
                                                                      .fromNow(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          3,
                                                                          0,
                                                                          3,
                                                                          0),
                                                                  child: Text(
                                                                      'via',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          1,
                                                                          0,
                                                                          0),
                                                                  child: UtilService().getIcon(
                                                                      ms.messages[index]
                                                                              [
                                                                              'channels']
                                                                          [
                                                                          'channel']),
                                                                ),
                                                              ],
                                                            )),
                                                        Row(
                                                          children: [
                                                            ResponsiveVisibility(
                                                                hiddenWhen: const [
                                                                  Condition
                                                                      .smallerThan(
                                                                          name:
                                                                              TABLET)
                                                                ],
                                                                child: SizedBox(
                                                                    width: ResponsiveValue(
                                                                            context,
                                                                            defaultValue:
                                                                                110.0,
                                                                            valueWhen: [
                                                                          const Condition.largerThan(
                                                                              name: TABLET,
                                                                              value: 150.0),
                                                                        ])
                                                                        .value!,
                                                                    child:
                                                                        TextButton(
                                                                            style: TextButton.styleFrom(
                                                                                padding: EdgeInsets
                                                                                    .zero,
                                                                                minimumSize: const Size(50,
                                                                                    30),
                                                                                tapTargetSize: MaterialTapTargetSize
                                                                                    .shrinkWrap,
                                                                                alignment: Alignment
                                                                                    .centerLeft),
                                                                            onPressed: () =>
                                                                                {
                                                                                  toggleCustomerBar(ms.messages[index]['customers'])
                                                                                },
                                                                            child:
                                                                                Text(
                                                                              UtilService().truncateString(
                                                                                  ms.messages[index]['customers']['name'],
                                                                                  ResponsiveValue(context, defaultValue: 12, valueWhen: [
                                                                                    const Condition.largerThan(name: TABLET, value: 18),
                                                                                    const Condition.smallerThan(name: TABLET, value: 12)
                                                                                  ]).value!),
                                                                            )))),
                                                            Text(
                                                              ms.messages[index]
                                                                              [
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
                                                                              defaultValue: showSideBar == true || showCustomerBar == true ? 40 : 60,
                                                                              valueWhen: [
                                                                                Condition.largerThan(name: TABLET, value: showSideBar == true ? 60 : 70),
                                                                                const Condition.smallerThan(name: TABLET, value: 35)
                                                                              ]).value!)
                                                                  : UtilService().truncateString(
                                                                      ms.messages[index]["subject"],
                                                                      ResponsiveValue(context, defaultValue: showSideBar == true || showCustomerBar == true ? 40 : 60, valueWhen: [
                                                                        Condition.largerThan(
                                                                            name:
                                                                                TABLET,
                                                                            value: showSideBar == true || showCustomerBar == true
                                                                                ? 60
                                                                                : 70),
                                                                        const Condition.smallerThan(
                                                                            name:
                                                                                TABLET,
                                                                            value:
                                                                                35)
                                                                      ]).value!),
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const Spacer(),
                                                            ResponsiveVisibility(
                                                                hiddenWhen: const [
                                                                  Condition
                                                                      .smallerThan(
                                                                          name:
                                                                              TABLET)
                                                                ],
                                                                child: Text(
                                                                  Jiffy(ms.messages[
                                                                              index]
                                                                          [
                                                                          'created'])
                                                                      .fromNow(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                            const ResponsiveVisibility(
                                                                hiddenWhen: [
                                                                  Condition
                                                                      .smallerThan(
                                                                          name:
                                                                              TABLET)
                                                                ],
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          3,
                                                                          0,
                                                                          3,
                                                                          0),
                                                                  child: Text(
                                                                      'via',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                )),
                                                            ResponsiveVisibility(
                                                                hiddenWhen: const [
                                                                  Condition
                                                                      .smallerThan(
                                                                          name:
                                                                              TABLET)
                                                                ],
                                                                child: Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            1,
                                                                            0,
                                                                            0),
                                                                    child: UtilService().getIcon(ms.messages[index]
                                                                            [
                                                                            'channels']
                                                                        [
                                                                        'channel']))),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                              : const Loader(size: 50.0)),
                ))
          ],
        ),
      ),
      drawer: drawer(),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}
