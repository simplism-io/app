import 'dart:convert';

import 'package:base/constants/loaders/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
  final formKey = GlobalKey<FormState>();
  String? bodyHtml;
  String? bodyText;
  bool loader = false;

  final QuillEditorController controller = QuillEditorController();

  Map<int, Map> attachments = {};

  String? formatHtmlString(String string) {
    var htmlString = parse(string);
    if (htmlString.documentElement != null) {
      String textString = htmlString.documentElement!.text;
      return textString;
    }
    return null;
  }

  getIcon(channel) {
    switch (channel) {
      case 'email':
        return const EmailIcon();
      case 'alert':
        return const AlertIcon();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.message['emails'][0]['body_html']);

    Future reply(message) async {
      bodyHtml = await controller.getText();
      bodyText = formatHtmlString(bodyHtml!)!.trim();
      controller.enableEditor(false);

      final result = await MessageService().sendMessageProcedure(
          message['id'],
          message['channel_id'],
          message['channels']['channel'],
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GoBackIconButton(inheritedContext: context),
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
      body: SingleChildScrollView(
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
                        child: GoBackTextButton(),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
                child: Row(
                  children: [
                    const SizedBox(width: 40, child: Text('avtr')),
                    SizedBox(
                        width: 40,
                        child: Text(widget.message['messages_customers'][0]
                            ['customers']['name'])),
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
                    getIcon(widget.message['channels']['channel']),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: LimitedBox(
                maxHeight: 200,
                maxWidth: double.infinity,
                child: FutureBuilder(
                  builder: (ctx, snapshot) {
                    // Checking if future is resolved or not
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: TextStyle(fontSize: 18),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        final messages = snapshot.data;

                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              var messagesCustomers =
                                  messages[index]['messages_customers'];
                              print(messagesCustomers.length);
                              return Row(
                                crossAxisAlignment: messages[index]
                                            ['messages_customers'] !=
                                        null
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(messages[index]['body']),
                                  )),
                                ],
                              );
                            });
                      }
                    }
                    return const Center(
                      child: Loader(),
                    );
                  },
                  future:
                      MessageService().getMessageHistory(widget.agent['id']),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 0,
                child: widget.message['channels']['channel'] == 'email'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: HtmlWidget(
                          widget.message['emails'][0]['body_html'] ?? '',
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          widget.message['channels']['channel'] == 'alert'
                              ? LocalizationService.of(context)
                                      ?.translate(widget.message['body']) ??
                                  ''
                              : widget.message['body'] ?? '',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: SizedBox(
                  height: attachments.isNotEmpty ? 270 : 208,
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          QuillHtmlEditor(
                            defaultFontSize: 15,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            defaultFontColor:
                                Theme.of(context).colorScheme.onSurface,
                            hintText: LocalizationService.of(context)
                                    ?.translate('reply_message_hinttext') ??
                                '',
                            controller: controller,
                            height: 200,
                            onTextChanged: (text) =>
                                debugPrint('widget text change $text'),
                            isEnabled: true,
                          ),
                          attachments.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 10, 25, 0),
                                  child: SizedBox(
                                    height: 40,
                                    width: 1000,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: attachments.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 5, 0),
                                                child: Chip(
                                                  elevation: 0,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                  deleteIcon: const Icon(
                                                    Icons.close,
                                                  ),
                                                  onDeleted: () {
                                                    setState(() {
                                                      attachments.remove(index);
                                                    });
                                                  },
                                                  label: Text(
                                                    attachments[index]!['name'],
                                                    style: const TextStyle(
                                                        fontSize: 10),
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
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: ToolBar(
                          padding: const EdgeInsets.all(7),
                          activeIconColor:
                              Theme.of(context).colorScheme.primary,
                          iconColor: Theme.of(context).colorScheme.onSurface,
                          controller: controller,
                          customButtons: customButtons,
                          toolBarConfig: customToolBarList),
                    ),
                    const Spacer(),
                    ResponsiveVisibility(
                        visible: false,
                        visibleWhen: const [Condition.largerThan(name: MOBILE)],
                        child: SizedBox(
                            width: 200,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              child: (defaultTargetPlatform ==
                                          TargetPlatform.iOS ||
                                      defaultTargetPlatform ==
                                          TargetPlatform.macOS)
                                  ? CupertinoButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          setState(() => loader = true);
                                          reply(widget.message);
                                        }
                                      },
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          loader == true
                                              ? LocalizationService.of(context)
                                                      ?.translate(
                                                          'loader_button_label') ??
                                                  ''
                                              : LocalizationService.of(context)
                                                      ?.translate(
                                                          'reply_message_button_label') ??
                                                  '',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            loader = true;
                                          });
                                          reply(widget.message);
                                        } else {
                                          setState(() {
                                            loader = false;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          loader == true
                                              ? LocalizationService.of(context)
                                                      ?.translate(
                                                          'loader_button_label') ??
                                                  ''
                                              : LocalizationService.of(context)
                                                      ?.translate(
                                                          'reply_message_button_label') ??
                                                  '',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontWeight: FontWeight.bold),
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
                              FontAwesomeIcons.circleChevronRight,
                              size: 18,
                            )))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}
