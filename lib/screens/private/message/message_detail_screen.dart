import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:html/parser.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jiffy/jiffy.dart';
import '../../../constants/drawers/private_menu_end_drawer.dart';
import '../../../constants/icon_buttons/go_back_icon_button.dart';
import '../../../constants/icon_buttons/go_back_text_button.dart';
import '../../../constants/links/logo_header_link.dart';
import '../../../constants/loaders/loader.dart';
import '../../../services/localization_service.dart';
import '../../../services/message_service.dart';
import '../../../services/util_service.dart';
import 'messages_by_customer_screen.dart';

class MessageDetailScreen extends StatefulWidget {
  final Map message;
  final Map agent;

  const MessageDetailScreen(
      {super.key, required this.message, required this.agent});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  bool showPreviousMessages = false;
  bool loader = false;

  toggleShowPreviousMessages() {
    setState(() {
      showPreviousMessages = !showPreviousMessages;
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
      body: Column(
        children: [
          ResponsiveVisibility(
              visible: false,
              visibleWhen: const [Condition.largerThan(name: MOBILE)],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                Text(
                  widget.message['channels']['channel'] == 'alert'
                      ? UtilService().truncateString(
                          LocalizationService.of(context)
                                  ?.translate(widget.message["subject"]) ??
                              '',
                          20)
                      : UtilService().truncateString(
                          widget.message["subject"],
                          ResponsiveValue(context,
                              defaultValue: 50,
                              valueWhen: [
                                const Condition.largerThan(
                                    name: TABLET, value: 75),
                                const Condition.smallerThan(
                                    name: TABLET, value: 25)
                              ]).value!),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text('Agent avatar')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Divider(color: Theme.of(context).colorScheme.surface),
          ),
          showPreviousMessages == true
              ? Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: showPreviousMessages == true
                          ? FutureBuilder(
                              builder: (ctx, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        '${snapshot.error} occurred',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  } else if (snapshot.data.length > 0 &&
                                      showPreviousMessages == true) {
                                    final messages = snapshot.data;
                                    return SizedBox(
                                      child: SingleChildScrollView(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: messages.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Column(
                                                children: [
                                                  showPreviousMessages ==
                                                              true &&
                                                          index == 0
                                                      ? TextButton(
                                                          onPressed: () => {
                                                                toggleShowPreviousMessages()
                                                              },
                                                          child: Text(
                                                              'Hide previous messages in this conversation with ${widget.message['customers']['name']}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)))
                                                      : Container(),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                      child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(7, 0, 7, 0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            Jiffy(messages[
                                                                        index]
                                                                    ['created'])
                                                                .fromNow(),
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  )),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        messages[index]['messages_agents']
                                                                    .length >
                                                                0
                                                            ? 60
                                                            : 0,
                                                        0,
                                                        messages[index]['messages_agents']
                                                                    .length >
                                                                0
                                                            ? 0
                                                            : 60,
                                                        0),
                                                    child: Card(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                      elevation: 0,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10.0,
                                                                    10.0,
                                                                    10.0,
                                                                    0),
                                                            child: Text(
                                                              messages[index][
                                                                          'customers']
                                                                      ['name'] +
                                                                  ':',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          messages[index]['channels']
                                                                      [
                                                                      'channel'] ==
                                                                  'email'
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          10),
                                                                  child:
                                                                      HtmlWidget(
                                                                    messages[index]['emails'][0]
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
                                                                    messages[index]['channels']['channel'] ==
                                                                            'alert'
                                                                        ? LocalizationService.of(context)?.translate(messages[index]['body']) ??
                                                                            ''
                                                                        : messages[index]['body'] ??
                                                                            '',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  showPreviousMessages ==
                                                              true &&
                                                          messages.length ==
                                                              (index + 1)
                                                      ? Column(
                                                          children: [
                                                            SizedBox(
                                                                height: 20),
                                                            TextButton(
                                                                onPressed:
                                                                    () => {
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .push(MaterialPageRoute(builder: (context) => MessagesByCustomerScreen(customer: widget.message['customers'], agent: widget.agent)))
                                                                        },
                                                                child: Text(
                                                                    'See all messages by ${widget.message['customers']['name']}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12))),
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              );
                                            }),
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                        child: Text(
                                            'There are no previous messages'));
                                  }
                                }
                                return const Center(
                                  child: Loader(size: 50.0),
                                );
                              },
                              future: MessageService()
                                  .getCustomerMessagesWithSameSubject(
                                      widget.message['customer_id'],
                                      widget.message['subject']),
                            )
                          : Container()),
                )
              : Container(),
          showPreviousMessages == false
              ? const SizedBox(height: 10)
              : Container(),
          showPreviousMessages == false
              ? TextButton(
                  onPressed: () => {toggleShowPreviousMessages()},
                  child: Text(
                      'See previous messages in this conversation with ${widget.message['customers']['name']}',
                      style: TextStyle(fontSize: 12)))
              : Container(),
          showPreviousMessages == false
              ? const SizedBox(height: 10)
              : Container(),
          showPreviousMessages == false
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                      child: Text(Jiffy(widget.message['created']).fromNow(),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    )),
                  ],
                )
              : Container(),
          showPreviousMessages == false
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(
                              widget.message['incoming'] == true
                                  ? widget.message['customers']['name'] + ':'
                                  : widget.message['messages_agents'].length > 0
                                      ? widget.message['messages_agents'][0]
                                              ['agents']['name'] +
                                          ':'
                                      : 'Agent name',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        widget.message['channels']['channel'] == 'email'
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: HtmlWidget(
                                  widget.message['emails'][0]['body_html'] ??
                                      '',
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                      ],
                    ),
                  ),
                )
              : Container(),
          showPreviousMessages == false ? SizedBox(height: 20) : Container(),
          showPreviousMessages == false
              ? TextButton(
                  onPressed: () => {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => MessagesByCustomerScreen(
                                    customer: widget.message['customers'],
                                    agent: widget.agent)))
                      },
                  child: Text(
                      'See all messages by ${widget.message['customers']['name']}',
                      style: TextStyle(fontSize: 12)))
              : Container(),
        ],
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
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.surface)),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.965,
                  ),
                  context: context,
                  builder: (context) => SizedBox(
                        height: 240,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: [
                                  Card(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    child: SizedBox(
                                      height:
                                          // attachments.isNotEmpty ? 220 : 168,
                                          attachments.isNotEmpty ? 220 : 158,
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
                                                hintTextStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                                textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
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
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: ToolBar(
                                            toolBarColor: Colors.black,
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
                                            Condition.smallerThan(name: TABLET)
                                          ],
                                          child: IconButton(
                                              onPressed: () =>
                                                  {Navigator.of(context).pop()},
                                              icon: const Icon(FontAwesomeIcons
                                                  .circleXmark))),
                                      ResponsiveVisibility(
                                          visible: false,
                                          visibleWhen: const [
                                            Condition.largerThan(name: TABLET)
                                          ],
                                          child: TextButton(
                                              onPressed: () =>
                                                  {Navigator.of(context).pop()},
                                              child: Text(LocalizationService
                                                          .of(context)
                                                      ?.translate(
                                                          'close_button_label') ??
                                                  ''))),
                                      ResponsiveVisibility(
                                          visible: false,
                                          visibleWhen: const [
                                            Condition.largerThan(name: MOBILE)
                                          ],
                                          child: SizedBox(
                                              child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5.0, 5.0, 5.0, 5.0),
                                            child: (defaultTargetPlatform ==
                                                        TargetPlatform.iOS ||
                                                    defaultTargetPlatform ==
                                                        TargetPlatform.macOS)
                                                ? CupertinoButton(
                                                    onPressed: () async {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        setState(() =>
                                                            loader = true);
                                                        reply(widget.message);
                                                      }
                                                    },
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
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
                                                      if (formKey.currentState!
                                                          .validate()) {
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
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
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
                                                size: 25,
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
