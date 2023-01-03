import 'package:base/widgets/icons/email_icon_widget.dart';
import 'package:base/widgets/loaders/loader_spinner_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/message_service.dart';

class MessageSectionWidget extends StatefulWidget {
  const MessageSectionWidget({super.key});

  @override
  State<MessageSectionWidget> createState() => _MessageSectionWidgetState();
}

class _MessageSectionWidgetState extends State<MessageSectionWidget> {
  @override
  Future<void> dispose() async {
    await supabase.removeAllChannels();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> messages =
        Provider.of<MessageService>(context, listen: true).messages;

    return messages.isEmpty
        ? const LoaderSpinnerWidget()
        : ListView.builder(
            reverse: true,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Card(
                      color: Theme.of(context).colorScheme.surface,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            messages[index]['channels']['channel'] == 'Email'
                                ? const EmailIconWidget()
                                : Container(),
                            Text(
                              messages[index]["subject"] ?? '',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      )),
                  Card(
                      // color: Theme.of(context).colorScheme.surface,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Text(
                              messages[index]["body"] ?? '',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () => {MessageService().sendEmailMessage()},
                      child: Text('Reply'))
                ],
              );
            });
  }
}
