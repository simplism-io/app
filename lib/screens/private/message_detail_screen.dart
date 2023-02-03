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
  List? attachments;
  bool loader = false;
  Uint8List? attachmentBytes;
  //final HtmlEditorController controller = HtmlEditorController();
  final QuillEditorController controller = QuillEditorController();

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

  Future pickFiles() async {
    // Lets the user pick one file, but only files with the extensions `svg` and `pdf` can be selected
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['svg', 'pdf', 'txt']);

// The result will be null, if the user aborted the dialog
    if (result != null) {
      //File file = File(result.files.first.path);
      print(result);
    }
  }

  final customButtons = [
    InkWell(
        onTap: () async {
          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.any);

          print(result);
          if (result != null) {
            //File file = File(result.files.first.path);
          }
        },
        child: const Icon(
          FontAwesomeIcons.paperclip,
          size: 18,
        )),
  ];

  // return HtmlEditor(
  //   controller: controller,
  //   htmlEditorOptions: const HtmlEditorOptions(
  //     hint: 'Yes',
  //     adjustHeightForKeyboard: true,
  //     shouldEnsureVisible: true,
  //     // initialText: LocalizationService.of(context)
  //     //         ?.translate('reply_message_hinttext') ??
  //     //     '',
  //   ),
  //   htmlToolbarOptions: HtmlToolbarOptions(
  //     defaultToolbarButtons: [
  //       const FontButtons(subscript: false, superscript: false),
  //       const InsertButtons(otherFile: true, table: false, audio: false),
  //     ],
  //     toolbarPosition: ToolbarPosition.belowEditor,
  //     toolbarType: ToolbarType.nativeGrid,
  //     onOtherFileLinkInsert: (String url) {
  //       print(url);
  //       //return true;
  //     },
  //     onOtherFileUpload: (PlatformFile file) {
  //       dynamic attachmentAsBytes = file.bytes;
  //       String? base64Avatar = base64Encode(attachmentAsBytes);

  //       print(base64Avatar);

  //       setState(() {
  //         //SET BASE64 to attachments list
  //       });
  //     },
  //     mediaLinkInsertInterceptor: (String url, InsertFileType type) {
  //       print(url);
  //       return true;
  //     },
  //     mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
  //       print(file.name); //filename
  //       print(file.size); //size in bytes
  //       print(file.extension); //file extension (eg jpeg or mp4)
  //       return true;
  //     },
  //   ),
  //   otherOptions: OtherOptions(height: 200),
  //   callbacks: Callbacks(
  //     onBeforeCommand: (String? currentHtml) {
  //       print('html before change is $currentHtml');
  //     },
  //     onChangeContent: (String? changed) {
  //       print('content changed to $changed');
  //     },
  //     onChangeCodeview: (String? changed) {
  //       print('code changed to $changed');
  //     },
  //     onChangeSelection: (EditorSettings settings) {
  //       print('parent element is ${settings.parentElement}');
  //       print('font name is ${settings.fontName}');
  //     },
  //     onImageLinkInsert: (String? url) {
  //       print(url ?? "unknown url");
  //     },
  //     onImageUpload: (FileUpload file) async {
  //       print(file.name);
  //       // print(file.size);
  //       // print(file.type);
  //       print(file.base64);

  //       setState(() {
  //         //List attachment
  //       });
  //     },
  //     onImageUploadError:
  //         (FileUpload? file, String? base64Str, UploadError error) {
  //       print(describeEnum(error));
  //       print(base64Str ?? '');
  //       if (file != null) {
  //         print(file.name);
  //         print(file.size);
  //         print(file.type);
  //       }
  //     },
  //   ),
  // );

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
      ToolBarStyle.strike,
      ToolBarStyle.listBullet,
      ToolBarStyle.listOrdered,
      ToolBarStyle.align,
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            ResponsiveVisibility(
                visible: false,
                visibleWhen: [Condition.smallerThan(name: TABLET)],
                child: GoBackIconButton()),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: GoBackTextButton(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 10, 10),
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Card(
                            elevation: 0,
                            child: widget.message['channels']['channel'] ==
                                    'email'
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Html(
                                      data: widget.message['emails']
                                              ["body_html"] ??
                                          '',
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          ToolBar(
                              padding: const EdgeInsets.all(6),
                              controller: controller,
                              customButtons: customButtons,
                              toolBarConfig: customToolBarList),
                          QuillHtmlEditor(
                            hintText: 'Hint text goes here',
                            controller: controller,
                            height: 150,
                            onTextChanged: (text) =>
                                debugPrint('widget text change $text'),
                            isEnabled: true,
                            // to disable the editor set isEnabled to false (default value is true)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
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
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      endDrawer: PrivateMenuEndDrawer(agent: widget.agent),
    );
  }
}
