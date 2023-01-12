import 'package:base/widgets/forms/reply_form_widget.dart';
import 'package:base/widgets/icons/email_icon_widget.dart';
import 'package:base/widgets/loaders/loader_spinner_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/message_service.dart';

class InboxSectionWidget extends StatefulWidget {
  const InboxSectionWidget({super.key});

  @override
  State<InboxSectionWidget> createState() => _InboxSectionWidgetState();
}

class _InboxSectionWidgetState extends State<InboxSectionWidget> {
  Map<int, dynamic> showBody = {};

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

  @override
  Widget build(BuildContext context) {
    List<dynamic> messages =
        Provider.of<MessageService>(context, listen: true).messages;

    toggleBody(index) {
      setState(() {
        showBody[index] = !showBody[index];
      });
      return showBody[index];
    }

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
                  GestureDetector(
                    onTap: () => toggleBody(index),
                    child: messages[index]['incoming'] == true
                        ? Card(
                            color: Theme.of(context).colorScheme.surface,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: Row(
                                children: [
                                  messages[index]['channels']['channel'] ==
                                          'Email'
                                      ? const EmailIconWidget()
                                      : Container(),
                                  Text(
                                    messages[index]["subject"].capitalize() ??
                                        '',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ))
                        : Container(),
                  ),
                  showBody[index] == true
                      ? Card(
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      messages[index]["body"] ?? '',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: const [
                                        ReplyMessageFormWidget()
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: const [
                                        Spacer(),
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: ReplyMessageFormWidget()),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                      : Container(),
                ],
              );
            });
  }
}
