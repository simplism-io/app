import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as pv;

import '../../../services/localization_service.dart';
import '../../../services/message_service.dart';
import '../../buttons/sign_out_drawer_button_widget.dart';
import '../../drop_downs/language_drawer_dropdown_widget.dart';
import '../../headers/private_end_drawer_header_widget.dart';
import '../../icons/email_icon_widget.dart';
import '../../icons/private_drawer_icon_widget.dart';
import '../../icons/private_end_drawer_icon_widget.dart';
import '../../links/logo_header_link_widget.dart';
import '../../links/profile_drawer_link_widget.dart';
import '../../loaders/loader_spinner_widget.dart';
import '../../switchers/biometrics_drawer_switcher_widget.dart';
import '../../switchers/theme_drawer_switcher_widget.dart';

final supabase = Supabase.instance.client;

class HomeScreenWidget extends StatefulWidget {
  final dynamic agent;
  const HomeScreenWidget({Key? key, required this.agent}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  Map<int, dynamic> showBody = {};
  final formKey = GlobalKey<FormState>();
  String? body;
  bool loader = false;

  @override
  initState() {
    presetBodyToggles();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    await supabase.removeAllChannels();
    super.dispose();
  }

  presetBodyToggles() {
    for (int index = 0; index <= 250; index++) {
      showBody[index] = false;
    }
  }

  toggleBody(index) {
    setState(() {
      showBody[index] = !showBody[index];
    });
    return showBody[index];
  }

  Uint8List? avatarBytes;

  drawer() {
    return const Drawer(child: Text('Text'));
  }

  endDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PrivateEndDrawerHeaderWidget(),
          const SizedBox(height: 20.0),
          ProfileDrawerLinkWidget(agent: widget.agent),
          const SizedBox(height: 5.0),
          const LanguageDrawerDropdownWidget(),
          const ThemeDrawerSwitcherWidget(),
          const BiometricsDrawerSwitcherWidget(),
          const SizedBox(height: 50),
          const SignOutDrawerButtonWidget()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> messages =
        pv.Provider.of<MessageService>(context, listen: true).messages;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            PrivateDrawerIconWidget(),
            LogoHeaderLinkWidget()
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [PrivateEndDrawerWidget()],
      ),
      body: ResponsiveRowColumn(
        layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowMainAxisAlignment: MainAxisAlignment.start,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        rowPadding: const EdgeInsets.all(20),
        columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        children: [
          ResponsiveRowColumnItem(
              child: ResponsiveVisibility(
            hiddenWhen: const [Condition.smallerThan(name: TABLET)],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Row(
                    children: [
                      const SizedBox(height: 5),
                      const Text('All Messages'),
                      Column(
                        children: [
                          const SizedBox(height: 4),
                          SizedBox(
                            child: Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.chevron_right,
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
                )
              ],
            ),
          )),
          ResponsiveRowColumnItem(
              rowFlex: 2,
              child: messages.isEmpty
                  ? const LoaderSpinnerWidget()
                  : SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => toggleBody(index),
                                    child: messages[index]['incoming'] == true
                                        ? Card(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 10, 10, 10),
                                              child: Row(
                                                children: [
                                                  messages[index]['channels']
                                                              ['channel'] ==
                                                          'Email'
                                                      ? const EmailIconWidget()
                                                      : Container(),
                                                  Text(
                                                    messages[index]
                                                            ["subject"] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        : Container(),
                                  ),
                                  showBody[index] == true
                                      ? Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 10, 10, 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      messages[index]["body"] ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5)
                                              ],
                                            ),
                                          ))
                                      : Container(),
                                  showBody[index] == true
                                      ? Column(
                                          children: [
                                            Card(
                                              elevation: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              child: SizedBox(
                                                width: ResponsiveValue(context,
                                                    defaultValue:
                                                        double.infinity,
                                                    valueWhen: const [
                                                      Condition.largerThan(
                                                          name: MOBILE,
                                                          value:
                                                              double.infinity),
                                                      Condition.smallerThan(
                                                          name: TABLET,
                                                          value: 300.0)
                                                    ]).value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15.0, 0.0, 15, 0.0),
                                                  child: Form(
                                                    key: formKey,
                                                    child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: null,
                                                        minLines: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          border:
                                                              InputBorder.none,
                                                          hintText: LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'reply_message_hinttext') ??
                                                              '',
                                                        ),
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        autofocus: true,
                                                        validator:
                                                            (String? value) {
                                                          return (value !=
                                                                      null &&
                                                                  value.length <
                                                                      2)
                                                              ? LocalizationService.of(
                                                                          context)
                                                                      ?.translate(
                                                                          'invalid_reply_message') ??
                                                                  ''
                                                              : null;
                                                        },
                                                        onChanged: (val) {
                                                          setState(() =>
                                                              {body = val});
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5.0, 5.0, 5.0, 5.0),
                                                  child: SizedBox(
                                                    width: 150.0,
                                                    child: (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoButton(
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() =>
                                                                    loader =
                                                                        true);
                                                                final result = await MessageService().sendMessageProcedure(
                                                                    messages[
                                                                            index]
                                                                        ['id'],
                                                                    messages[
                                                                            index]
                                                                        [
                                                                        'channel_id'],
                                                                    messages[
                                                                            index]
                                                                        [
                                                                        'subject'],
                                                                    body);
                                                                if (result ==
                                                                    true) {
                                                                  if (!mounted) {
                                                                    return;
                                                                  }
                                                                  final successSnackBar =
                                                                      SnackBar(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    content: Text(
                                                                        LocalizationService.of(context)?.translate('reply_message_snackbar_label') ??
                                                                            '',
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onPrimary,
                                                                        )),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          successSnackBar);
                                                                  setState(() {
                                                                    loader =
                                                                        false;
                                                                    toggleBody(
                                                                        index);
                                                                  });
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  loader =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                loader == true
                                                                    ? LocalizationService.of(context)?.translate(
                                                                            'loader_button_label') ??
                                                                        ''
                                                                    : LocalizationService.of(context)
                                                                            ?.translate('reply_message_button_label') ??
                                                                        '',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                        : ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() =>
                                                                    loader =
                                                                        true);
                                                                final result = await MessageService().sendMessageProcedure(
                                                                    messages[
                                                                            index]
                                                                        ['id'],
                                                                    messages[
                                                                            index]
                                                                        [
                                                                        'channel_id'],
                                                                    messages[
                                                                            index]
                                                                        [
                                                                        'subject'],
                                                                    body);
                                                                if (result ==
                                                                    true) {
                                                                  if (!mounted) {
                                                                    return;
                                                                  }
                                                                  final successSnackBar =
                                                                      SnackBar(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    content: Text(
                                                                        LocalizationService.of(context)?.translate('reply_message_snackbar_label') ??
                                                                            '',
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onPrimary,
                                                                        )),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          successSnackBar);
                                                                  setState(() {
                                                                    loader =
                                                                        false;
                                                                    toggleBody(
                                                                        index);
                                                                  });
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  loader =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Text(
                                                                loader == true
                                                                    ? LocalizationService.of(context)?.translate(
                                                                            'loader_button_label') ??
                                                                        ''
                                                                    : LocalizationService.of(context)
                                                                            ?.translate('reply_message_button_label') ??
                                                                        '',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              );
                            }),
                      ),
                    ))
        ],
      ),
      drawer: drawer(),
      endDrawer: endDrawer(),
    );
  }
}
