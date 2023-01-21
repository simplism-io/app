import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as pv;

import '../../constants/icons/chevron_right_icon.dart';
import '../../constants/icons/email_icon.dart';
import '../../services/agent_service.dart';
import '../../services/biometric_service.dart';
import '../../services/internationalization_service.dart';
import '../../services/localization_service.dart';
import '../../services/message_service.dart';
import '../../constants/icons/private_drawer_icon.dart';
import '../../constants/icons/private_end_drawer_icon_widget.dart';
import '../../constants/links/logo_header_link.dart';
import '../../services/theme_service.dart';
import 'admin_screen.dart';
import 'agent_screen.dart';

final supabase = Supabase.instance.client;

class InboxScreen extends StatefulWidget {
  final dynamic agent;
  const InboxScreen({Key? key, required this.agent}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
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
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Text(
                LocalizationService.of(context)
                        ?.translate('settings_header_label') ??
                    '',
                style: const TextStyle(
                    fontSize: 25.0, fontWeight: FontWeight.bold)),
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
                    trailing: const ChevronRightIcon(),
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
                trailing: const ChevronRightIcon(),
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
              onTap: () async => {
                // SnackBarService()
                //     .successSnackBar('sign_out_snackbar_label', context),
                await AgentService().signOut()
              },
              title: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_out_button_label') ??
                      '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground)),
              trailing: const ChevronRightIcon(),
            ),
          )
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
          children: const <Widget>[PrivateDrawerIcon(), LogoHeaderLink()],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [PrivateEndDrawer()],
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
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            children: [
                              Text(LocalizationService.of(context)
                                      ?.translate('no_data_message_messages') ??
                                  ''),
                            ],
                          ),
                        ),
                      ),
                    )
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
                                                      ? const EmailIcon()
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
