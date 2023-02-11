import 'dart:convert';

import 'package:base/constants/loaders/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:html/parser.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../constants/drawers/private_menu_end_drawer.dart';
import '../../constants/icon_buttons/go_back_icon_button.dart';
import '../../constants/icon_buttons/go_back_text_button.dart';
import '../../constants/icons/alert_icon.dart';
import '../../constants/icons/email_icon.dart';
import '../../constants/links/logo_header_link.dart';
import '../../services/localization_service.dart';
import '../../services/message_service.dart';
import '../../services/util_service.dart';

class MessageDetailScreen extends StatefulWidget {
  final dynamic message;
  final dynamic agent;

  const MessageDetailScreen(
      {super.key, required this.message, required this.agent});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  bool seeAllMessages = false;
  int maxNumberOfMessages = 2;

  getIcon(channel) {
    switch (channel) {
      case 'email':
        return const EmailIcon();
      case 'alert':
        return const AlertIcon();
    }
  }

  toggleSeeAllMessages() {
    seeAllMessages = !seeAllMessages;
    if (seeAllMessages == true) {
      maxNumberOfMessages = 1000;
    } else {
      maxNumberOfMessages = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            GoBackIconButton(toRoot: true),
            LogoHeaderLink()
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
        child: Column(
          children: [
            ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.largerThan(name: MOBILE)],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                        child: GoBackTextButton(toRoot: true),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
              child: Row(
                children: [
                  Text(
                    widget.message['channels']['channel'] == 'alert'
                        ? UtilService().truncateString(
                            LocalizationService.of(context)
                                    ?.translate(widget.message["subject"]) ??
                                '',
                            20)
                        : UtilService()
                            .truncateString(widget.message["subject"], 15),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('Agent avatar')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Divider(color: Theme.of(context).colorScheme.surface),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                child: FutureBuilder(
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final messages = snapshot.data;
                        return Column(
                          children: [
                            maxNumberOfMessages == 2
                                ? TextButton(
                                    onPressed: () => {
                                          setState(() {
                                            toggleSeeAllMessages();
                                          })
                                        },
                                    child: Text('See all'))
                                : Container(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: messages.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: index < maxNumberOfMessages
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 0, 0),
                                                          child: Text(
                                                              messages[index][
                                                                          'incoming'] ==
                                                                      true
                                                                  ? messages[index]
                                                                          ['customers']
                                                                      ['name']
                                                                  : messages[index]['messages_agents']
                                                                              .length >
                                                                          0
                                                                      ? messages[index]['messages_agents'][0]
                                                                              ['agents']
                                                                          [
                                                                          'name']
                                                                      : 'Agent name',
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),

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
                                                      const Spacer(),
                                                      SizedBox(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Text(
                                                            messages[index]
                                                                ['created'],
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 0, 5),
                                                      child: Card(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        child: widget.message[
                                                                        'channels']
                                                                    [
                                                                    'channel'] ==
                                                                'email'
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        10,
                                                                        10),
                                                                child:
                                                                    HtmlWidget(
                                                                  messages[index]['emails']
                                                                              [
                                                                              0]
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
                                                                        10,
                                                                        10,
                                                                        10),
                                                                child: Text(
                                                                  messages[index]['channels']
                                                                              [
                                                                              'channel'] ==
                                                                          'alert'
                                                                      ? LocalizationService.of(context)?.translate(widget.message[
                                                                              'body']) ??
                                                                          ''
                                                                      : messages[index]
                                                                              [
                                                                              'body'] ??
                                                                          '',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const Center(
                      child: Loader(),
                    );
                  },
                  future: MessageService()
                      .getMessageHistory(widget.message['customer_id']),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          ReplyForm(message: widget.message, agent: widget.agent),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}

class ReplyForm extends StatefulWidget {
  final dynamic message;
  final dynamic agent;
  const ReplyForm({super.key, required this.message, required this.agent});

  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {
  final formKey = GlobalKey<FormState>();
  String? bodyHtml;
  String? bodyText;
  bool loader = false;
  final QuillEditorController controller = QuillEditorController();
  Map<int, Map> attachments = {};
  bool showFab = true;

  String? formatHtmlString(String string) {
    var htmlString = parse(string);
    if (htmlString.documentElement != null) {
      String textString = htmlString.documentElement!.text;
      return textString;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future reply(message) async {
      bodyHtml = await controller.getText();
      bodyText = formatHtmlString(bodyHtml!)!.trim();
      controller.enableEditor(false);

      final result = await MessageService().sendMessageProcedure(
          message['id'],
          message['channel_id'],
          message['channels']['channel'],
          message['customer_id'],
          message['subject'],
          bodyHtml,
          bodyText,
          attachments,
          widget.agent['id']);
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
        });
        controller.clear();
        Navigator.pop(context);
      } else {
        if (!mounted) {
          return;
        }
        final errorSnackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('general_error_message') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        controller.enableEditor(true);
        setState(() {
          loader = false;
        });
      }
    }

    final customButtons = [
      InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['txt', 'pdf', 'doc', 'docx']);

            print(result);

            if (result != null) {
              String? base64Attachment =
                  base64Encode(result.files.single.bytes!);
              Map<String, String> attachment = {};
              attachment["name"] = result.names[0]!;
              attachment["base64"] = base64Attachment;
              setState(() {
                attachments[attachments.length] = attachment;
              });
            }
          },
          child: const Icon(
            FontAwesomeIcons.paperclip,
            size: 18,
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: InkWell(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'jpeg', 'svg', 'mp4']);

              print(result);

              if (result != null) {
                String? base64Attachment =
                    base64Encode(result.files.single.bytes!);
                Map<String, String> attachment = {};
                attachment["name"] = result.names[0]!;
                attachment["base64"] = base64Attachment;
                setState(() {
                  attachments[attachments.length] = attachment;
                });
              }
            },
            child: const Icon(
              FontAwesomeIcons.image,
              size: 18,
            )),
      ),
    ];

    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });

    final customToolBarList = [
      ToolBarStyle.bold,
      ToolBarStyle.italic,
      ToolBarStyle.underline,
      ToolBarStyle.listBullet,
      ToolBarStyle.listOrdered,
    ];

    return showFab
        ? FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              var bottomSheetController = showBottomSheet(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 5,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.94),
                  context: context,
                  builder: (context) => SizedBox(
                        height: 270,
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
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Card(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: SizedBox(
                                      height:
                                          attachments.isNotEmpty ? 220 : 168,
                                      width: double.infinity,
                                      child: Form(
                                        key: formKey,
                                        child: Card(
                                          elevation: 0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              QuillHtmlEditor(
                                                defaultFontSize: 15,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                defaultFontColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                hintText: LocalizationService
                                                            .of(context)
                                                        ?.translate(
                                                            'reply_message_hinttext') ??
                                                    '',
                                                controller: controller,
                                                height: 150,
                                                onTextChanged: (text) => debugPrint(
                                                    'widget text change $text'),
                                                isEnabled: true,
                                              ),
                                              attachments.isNotEmpty
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          25, 10, 25, 0),
                                                      child: SizedBox(
                                                        height: 40,
                                                        width: 1000,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis
                                                                        .horizontal,
                                                                itemCount:
                                                                    attachments
                                                                        .length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Chip(
                                                                      elevation:
                                                                          0,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      backgroundColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .background,
                                                                      deleteIcon:
                                                                          const Icon(
                                                                        Icons
                                                                            .close,
                                                                      ),
                                                                      onDeleted:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          attachments
                                                                              .remove(index);
                                                                        });
                                                                      },
                                                                      label:
                                                                          Text(
                                                                        attachments[index]![
                                                                            'name'],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10),
                                                                      ), //Text
                                                                    ),
                                                                    //CircleAvatar
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Card(
                                        child: ToolBar(
                                            padding: const EdgeInsets.all(7),
                                            activeIconColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            controller: controller,
                                            customButtons: customButtons,
                                            toolBarConfig: customToolBarList),
                                      ),
                                      const Spacer(),
                                      ResponsiveVisibility(
                                          visible: false,
                                          visibleWhen: const [
                                            Condition.largerThan(name: MOBILE)
                                          ],
                                          child: SizedBox(
                                              width: 200,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5.0, 5.0, 5.0, 5.0),
                                                child: (defaultTargetPlatform ==
                                                            TargetPlatform
                                                                .iOS ||
                                                        defaultTargetPlatform ==
                                                            TargetPlatform
                                                                .macOS)
                                                    ? CupertinoButton(
                                                        onPressed: () async {
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            setState(() =>
                                                                loader = true);
                                                            reply(
                                                                widget.message);
                                                          }
                                                        },
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            loader == true
                                                                ? LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'loader_button_label') ??
                                                                    ''
                                                                : LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'reply_message_button_label') ??
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
                                                        onPressed: () async {
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            setState(() {
                                                              loader = true;
                                                            });
                                                            reply(
                                                                widget.message);
                                                          } else {
                                                            setState(() {
                                                              loader = false;
                                                            });
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                            loader == true
                                                                ? LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'loader_button_label') ??
                                                                    ''
                                                                : LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'reply_message_button_label') ??
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
                                              ))),
                                      ResponsiveVisibility(
                                          visible: false,
                                          visibleWhen: const [
                                            Condition.smallerThan(name: TABLET)
                                          ],
                                          child: InkWell(
                                              onTap: () async {
                                                reply(widget.message);
                                              },
                                              child: const Icon(
                                                FontAwesomeIcons
                                                    .circleChevronRight,
                                                size: 18,
                                              )))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
              showFoatingActionButton(false);
              bottomSheetController.closed.then((value) {
                showFoatingActionButton(true);
              });
            },
            child: Icon(
              (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS)
                  ? CupertinoIcons.reply
                  : FontAwesomeIcons.reply,
              size: 15,
            ),
          )
        : Container();
  }

  void showFoatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}
