import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../constants/icons/alert_icon.dart';
import '../../constants/icons/chevron_right_icon.dart';
import '../../constants/icons/email_icon.dart';
import '../../services/agent_service.dart';
import '../../services/biometric_service.dart';
import '../../services/internationalization_service.dart';
import '../../services/localization_service.dart';
import '../../services/message_service.dart';
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
  Map<String, dynamic> showBody = {};
  Map<String, dynamic> formKey = {};
  bool showSettings = true;
  String? body_html;
  String? body_text;
  bool loader = false;
  Uint8List? attachmentBytes;
  final HtmlEditorController controller = HtmlEditorController();

  @override
  initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    await supabase.removeAllChannels();
    super.dispose();
  }

  toggleBody(id, value) {
    setState(() {
      if (showBody[id] == null) {
        showBody[id] = value;
      } else {
        if (showBody[id] != value) {
          showBody[id] = value;
        } else {
          showBody[id] = !value;
        }
      }
    });
    return showBody[id];
  }

  getIcon(channel) {
    switch (channel) {
      case 'email':
        return const EmailIcon();
      case 'alert':
        return const AlertIcon();
    }
  }

  getFormKey(id) {
    formKey[id] = GlobalKey<FormState>();
    return formKey[id];
  }

  String truncateString(String data, int length) {
    return (data.length >= length) ? '${data.substring(0, length)}...' : data;
  }

  String formatHtmlString(String string) {
    return string
        .replaceAll("\n\n", "<p>") // Paragraphs
        .replaceAll("\n", "<br>") // Line Breaks
        .replaceAll("\"", "&quot;") // Quote Marks
        .replaceAll("'", "&apos;") // Apostrophe
        .replaceAll(">", "&lt;") // Less-than Comparator (Strip Tags)
        .replaceAll("<", "&gt;") // Greater-than Comparator (Strip Tags)
        .trim(); // Whitespace
  }

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
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
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
            onTap: () async => {await AgentService().signOut()},
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
    ));
  }

  replyFormField() {
    return HtmlEditor(
      controller: controller,
      htmlEditorOptions: HtmlEditorOptions(
        adjustHeightForKeyboard: true,
        shouldEnsureVisible: true,
        hint: LocalizationService.of(context)
                ?.translate('reply_message_hinttext') ??
            '',
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        defaultToolbarButtons: [
          StyleButtons(),
          FontButtons(),
          InsertButtons(otherFile: true),
        ],
        toolbarPosition: ToolbarPosition.belowEditor,
        toolbarType: ToolbarType.nativeGrid,
        onOtherFileLinkInsert: (String url) {
          print(url);
          //return true;
        },
        onOtherFileUpload: (PlatformFile file) async {
          dynamic avatarAsBytes = await file.bytes;
          String? base64Avatar = base64Encode(avatarAsBytes);

          print(base64Avatar);
        },
        mediaLinkInsertInterceptor: (String url, InsertFileType type) {
          print(url);
          return true;
        },
        mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
          print(file.name); //filename
          print(file.size); //size in bytes
          print(file.extension); //file extension (eg jpeg or mp4)
          return true;
        },
      ),
      otherOptions: OtherOptions(height: 200),
      callbacks: Callbacks(
        onBeforeCommand: (String? currentHtml) {
          print('html before change is $currentHtml');
        },
        onChangeContent: (String? changed) {
          print('content changed to $changed');
        },
        onChangeCodeview: (String? changed) {
          print('code changed to $changed');
        },
        onChangeSelection: (EditorSettings settings) {
          print('parent element is ${settings.parentElement}');
          print('font name is ${settings.fontName}');
        },
        onImageLinkInsert: (String? url) {
          print(url ?? "unknown url");
        },
        onImageUpload: (FileUpload file) async {
          print(file.name);
          // print(file.size);
          // print(file.type);
          print(file.base64);

          setState(() {
            //List attachment
          });
        },
        onImageUploadError:
            (FileUpload? file, String? base64Str, UploadError error) {
          print(describeEnum(error));
          print(base64Str ?? '');
          if (file != null) {
            print(file.name);
            print(file.size);
            print(file.type);
          }
        },
      ),
    );
    //  TextFormField(
    //     keyboardType:
    //         TextInputType
    //             .multiline,
    //     maxLines: null,
    //     minLines: 3,
    //     decoration:
    //         InputDecoration(
    //       focusedBorder:
    //           InputBorder
    //               .none,
    //       border:
    //           InputBorder
    //               .none,
    //       hintText: LocalizationService.of(
    //                   context)
    //               ?.translate(
    //                   'reply_message_hinttext') ??
    //           '',
    //     ),
    //     textCapitalization:
    //         TextCapitalization
    //             .words,
    //     textAlign:
    //         TextAlign.left,
    //     style:
    //         const TextStyle(
    //             fontSize:
    //                 14),
    //     autofocus: true,
    //     validator: (String?
    //         value) {
    //       return (value !=
    //                   null &&
    //               value.length <
    //                   2)
    //           ? LocalizationService.of(
    //                       context)
    //                   ?.translate(
    //                       'invalid_reply_message') ??
    //               ''
    //           : null;
    //     },
    //     onChanged: (val) {
    //       setState(() =>
    //           {body = val});
    //     }),
  }

  @override
  Widget build(BuildContext context) {
    reply(message, index) async {
      setState(() async {
        loader = true;
        body_html = await controller.getText();
        body_text = formatHtmlString(body_html!);
      });
      final result = await MessageService().sendMessageProcedure(message['id'],
          message['channel_id'], message['subject'], body_html, body_text);
      if (result == true) {
        if (!mounted) {
          return;
        }
        final successSnackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('reply_message_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        setState(() {
          loader = false;
          toggleBody(message['id'], false);
        });
      }
    }

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
                        (defaultTargetPlatform == TargetPlatform.iOS ||
                                defaultTargetPlatform == TargetPlatform.macOS)
                            ? CupertinoIcons.collections
                            : FontAwesomeIcons.folderTree,
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
      body: ResponsiveRowColumn(
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
                            child: const Text('All Messages'),
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
                      child: Text('Other Mailbox'),
                    ),
                  )
                ],
              ),
            ),
          )),
          ResponsiveRowColumnItem(
              rowFlex: 2,
              child: SingleChildScrollView(
                child: Consumer<MessageService>(
                  builder: (context, ms, child) => ms.messages.isEmpty
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
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: ms.messages.length,
                          itemBuilder: (context, index) {
                            return Padding(
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
                                      onTap: () => toggleBody(
                                          ms.messages[index]['id'], true),
                                      child: ms.messages[index]['incoming'] ==
                                              true
                                          ? Card(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              elevation: showBody[
                                                          ms.messages[index]
                                                              ['id']] ==
                                                      true
                                                  ? 3
                                                  : 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 5, 10),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                        width: 40,
                                                        child: Text('avtr')),
                                                    Text(
                                                      ms.messages[index]
                                                                      ['channels']
                                                                  ['channel'] ==
                                                              'alert'
                                                          ? truncateString(
                                                              LocalizationService.of(
                                                                          context)
                                                                      ?.translate(
                                                                          ms.messages[index]
                                                                              [
                                                                              "subject"]) ??
                                                                  '',
                                                              ResponsiveValue(
                                                                  context,
                                                                  defaultValue:
                                                                      20,
                                                                  valueWhen: [
                                                                    const Condition
                                                                            .largerThan(
                                                                        name:
                                                                            TABLET,
                                                                        value:
                                                                            50),
                                                                    const Condition
                                                                            .largerThan(
                                                                        name:
                                                                            MOBILE,
                                                                        value:
                                                                            30)
                                                                  ]).value!)
                                                          : truncateString(
                                                              ms.messages[index]
                                                                  ["subject"],
                                                              15),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Spacer(),
                                                    getIcon(ms.messages[index]
                                                            ['channels']
                                                        ['channel']),
                                                  ],
                                                ),
                                              ))
                                          : Container(),
                                    ),
                                    showBody[ms.messages[index]['id']] == true
                                        ? Card(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 10, 10, 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      ms.messages[index][
                                                                      'channels']
                                                                  ['channel'] ==
                                                              'email'
                                                          ? Expanded(
                                                              child: Html(
                                                                data: ms.messages[index]
                                                                            [
                                                                            'emails']
                                                                        [
                                                                        "body_html"] ??
                                                                    '',
                                                              ),
                                                            )
                                                          : Text(
                                                              ms.messages[index]
                                                                              [
                                                                              'channels']
                                                                          [
                                                                          'channel'] ==
                                                                      'alert'
                                                                  ? LocalizationService.of(
                                                                              context)
                                                                          ?.translate(ms.messages[index]
                                                                              [
                                                                              'body']) ??
                                                                      ''
                                                                  : ms.messages[
                                                                              index]
                                                                          [
                                                                          'body'] ??
                                                                      '',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5)
                                                ],
                                              ),
                                            ))
                                        : Container(),
                                    showBody[ms.messages[index]['id']] == true
                                        ? Column(
                                            children: [
                                              Card(
                                                elevation: 0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                child: SizedBox(
                                                  width: ResponsiveValue(
                                                      context,
                                                      defaultValue:
                                                          double.infinity,
                                                      valueWhen: const [
                                                        Condition.largerThan(
                                                            name: MOBILE,
                                                            value: double
                                                                .infinity),
                                                        Condition.smallerThan(
                                                            name: TABLET,
                                                            value:
                                                                double.infinity)
                                                      ]).value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15.0, 0.0, 15, 0.0),
                                                    child: Form(
                                                        key: getFormKey(
                                                            ms.messages[index]
                                                                ['id']),
                                                        child:
                                                            replyFormField()),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        5.0, 5.0, 5.0, 5.0),
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints
                                                                  .tightFor(
                                                              height: 50),
                                                      child: (defaultTargetPlatform ==
                                                                  TargetPlatform
                                                                      .iOS ||
                                                              defaultTargetPlatform ==
                                                                  TargetPlatform
                                                                      .macOS)
                                                          ? CupertinoButton(
                                                              onPressed:
                                                                  () async {
                                                                if (getFormKey(ms
                                                                            .messages[
                                                                        index]['id'])
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setState(() =>
                                                                      loader =
                                                                          true);
                                                                  reply(
                                                                      ms.messages[
                                                                          index],
                                                                      index);
                                                                }
                                                              },
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
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
                                                                if (getFormKey(ms
                                                                            .messages[
                                                                        index]['id'])
                                                                    .currentState!
                                                                    .validate()) {
                                                                  reply(
                                                                      ms.messages[
                                                                          index],
                                                                      index);
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
                                        : Container(),
                                    showBody[ms.messages[index]['id']] == true
                                        ? const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 10, 5, 10),
                                            child: Divider(),
                                          )
                                        : Container()
                                  ],
                                )); //getMessages();
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
