import 'package:base/constants/icon_buttons/go_back_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../constants/icon_buttons/go_back_icon_button.dart';
import '../../constants/links/logo_header_link.dart';
import '../../constants/loaders/loader.dart';
import '../../services/localization_service.dart';
import '../../services/message_service.dart';
import 'message_detail_screen.dart';

class MessagesByCustomerScreen extends StatelessWidget {
  final Map customer;
  final Map agent;
  const MessagesByCustomerScreen(
      {super.key, required this.customer, required this.agent});

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
                    const Condition.largerThan(name: MOBILE, value: 10.0),
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GoBackTextButton(toRoot: false),
                ),
                const Spacer(),
                SizedBox(
                    child: Text('Messages by ${customer['name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerRight),
                      onPressed: () => {},
                      child: Text('See profile')),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Divider(color: Theme.of(context).colorScheme.surface),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: FutureBuilder(
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final messages = snapshot.data;
                        return SizedBox(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: messages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: messages[index]
                                                        ['incoming'] ==
                                                    true
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.end,
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.fromLTRB(
                                              //       5, 0, 5, 0),
                                              //   child: SizedBox(
                                              //     child: messages[index]['incoming'] ==
                                              //             true
                                              //         ? getIcon(
                                              //             widget.message['channels']
                                              //                 ['channel'])
                                              //         : '',
                                              //   ),
                                              // ),
                                              SizedBox(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 0, 8, 0),
                                                child: Text(
                                                    Jiffy(messages[index]
                                                            ['created'])
                                                        .fromNow(),
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () => {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageDetailScreen(
                                                            message:
                                                                messages[index],
                                                            agent: agent)),
                                                (Route<dynamic> route) => false,
                                              )
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                              child: Card(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                elevation: 0,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        messages[index]
                                                            ['subject'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 0, 10, 0),
                                                      child: Divider(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 7, 0, 0),
                                                      child: Text(
                                                          messages[index][
                                                                      'customers']
                                                                  ['name'] +
                                                              ':',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    messages[index]['channels']
                                                                ['channel'] ==
                                                            'email'
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    5,
                                                                    10,
                                                                    10),
                                                            child: HtmlWidget(
                                                              messages[index][
                                                                          'emails'][0]
                                                                      [
                                                                      'body_html'] ??
                                                                  '',
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    5,
                                                                    10,
                                                                    10),
                                                            child: Text(
                                                              messages[index]['channels']
                                                                          [
                                                                          'channel'] ==
                                                                      'alert'
                                                                  ? LocalizationService.of(
                                                                              context)
                                                                          ?.translate(messages[index]
                                                                              [
                                                                              'body']) ??
                                                                      ''
                                                                  : messages[index]
                                                                          [
                                                                          'body'] ??
                                                                      '',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                }),
                          ),
                        );
                      }
                    }
                    return const Center(
                      child: Loader(size: 50.0),
                    );
                  },
                  future: MessageService().getMessageHistory(customer['id']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
