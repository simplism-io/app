import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../constants/drawers/private_menu_end_drawer.dart';
import '../../constants/icon_buttons/go_back_icon_button.dart';
import '../../constants/icon_buttons/go_back_text_button.dart';
import '../../constants/icons/alert_icon.dart';
import '../../constants/icons/email_icon.dart';
import '../../constants/links/logo_header_link.dart';
import '../../services/localization_service.dart';
import '../../services/message_service.dart';

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
    final customButtons = [
      InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['txt', 'pdf']);

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
    ];

    reply(message) async {
      setState(() async {
        loader = true;
        bodyHtml = await controller.getText();
        bodyText = formatHtmlString(bodyHtml!);
      });
      final result = await MessageService().sendMessageProcedure(
          message['id'],
          message['channel_id'],
          message['subject'],
          bodyHtml,
          bodyText,
          attachments);
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
      }
    }

    String truncateString(String data, int length) {
      return (data.length >= length) ? '${data.substring(0, length)}...' : data;
    }

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
                            ? CupertinoIcons.chevron_left
                            : FontAwesomeIcons.chevronLeft,
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
      body: Column(
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
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
                  child: Row(
                    children: [
                      const SizedBox(width: 40, child: Text('avtr')),
                      Text(
                        widget.message['channels']['channel'] == 'alert'
                            ? truncateString(
                                LocalizationService.of(context)?.translate(
                                        widget.message["subject"]) ??
                                    '',
                                ResponsiveValue(context,
                                    defaultValue: 20,
                                    valueWhen: [
                                      const Condition.largerThan(
                                          name: TABLET, value: 50),
                                      const Condition.largerThan(
                                          name: MOBILE, value: 30)
                                    ]).value!)
                            : truncateString(widget.message["subject"], 15),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      getIcon(widget.message['channels']['channel']),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        child: widget.message['channels']['channel'] == 'email'
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Html(
                                  data: widget.message['emails']["body_html"] ??
                                      '',
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  widget.message['channels']['channel'] ==
                                          'alert'
                                      ? LocalizationService.of(context)
                                              ?.translate(
                                                  widget.message['body']) ??
                                          ''
                                      : widget.message['body'] ?? '',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Column(children: [
                SizedBox(
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
                            hintText: 'Hint text goes here',
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
                                                  padding: EdgeInsets.all(8),
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
                                                    style:
                                                        TextStyle(fontSize: 10),
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
                ResponsiveRowColumn(
                  layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  // columnPadding: EdgeInsets.fromLTRB(
                  //     ResponsiveValue(context, defaultValue: 30.0, valueWhen: [
                  //       const Condition.smallerThan(name: TABLET, value: 10.0)
                  //     ]).value!,
                  //     10,
                  //     30,
                  //     10),
                  children: [
                    ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: Card(
                          child: ToolBar(
                              padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  5.0,
                                  ResponsiveValue(context,
                                      defaultValue: 5.0,
                                      valueWhen: [
                                        const Condition.smallerThan(
                                            name: TABLET, value: 15.0)
                                      ]).value!,
                                  5.0),
                              controller: controller,
                              customButtons: customButtons,
                              toolBarConfig: customToolBarList),
                        )),
                    ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          child: (defaultTargetPlatform == TargetPlatform.iOS ||
                                  defaultTargetPlatform == TargetPlatform.macOS)
                              ? CupertinoButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() => loader = true);
                                      reply(widget.message);
                                    }
                                  },
                                  color: Theme.of(context).colorScheme.primary,
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
                        )),
                  ],
                ),
              ]))
        ],
      ),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}
