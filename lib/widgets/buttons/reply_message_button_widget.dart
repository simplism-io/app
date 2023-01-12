import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';

class ReplyMessageButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const ReplyMessageButtonWidget({super.key, required this.formKey});

  @override
  State<ReplyMessageButtonWidget> createState() =>
      _ReplyMessageButtonWidgetState();
}

class _ReplyMessageButtonWidgetState extends State<ReplyMessageButtonWidget> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
      child: Column(
        children: [
          const SizedBox(height: 4),
          SizedBox(
            width: 100.0,
            child: (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? CupertinoButton(
                    onPressed: () async {
                      if (widget.formKey.currentState!.validate()) {
                        setState(() => loader = true);
                        // await MessageService()
                        // .sendMessageProcedure(
                        //     messages[index]
                        //         ['id'],
                        //     messages[index]
                        // //         ['channel_id'],
                        //     'testSubject',
                        //     'testMessage')
                        //toggleReplyForm()
                      } else {
                        setState(() {
                          loader = false;
                        });
                      }
                    },
                    color: Theme.of(context).colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        loader == true
                            ? LocalizationService.of(context)
                                    ?.translate('loader_button_label') ??
                                ''
                            : LocalizationService.of(context)
                                    ?.translate('reply_message_button_label') ??
                                '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      if (widget.formKey.currentState!.validate()) {
                        setState(() => loader = true);
                        // await MessageService()
                        // .sendMessageProcedure(
                        //     messages[index]
                        //         ['id'],
                        //     messages[index]
                        // //         ['channel_id'],
                        //     'testSubject',
                        //     'testMessage')
                        //toggleReplyForm()
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
                                    ?.translate('loader_button_label') ??
                                ''
                            : LocalizationService.of(context)
                                    ?.translate('reply_message_button_label') ??
                                '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
