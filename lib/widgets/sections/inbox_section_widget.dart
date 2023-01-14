import 'package:base/widgets/forms/reply_message_form_widget.dart';
import 'package:base/widgets/icons/email_icon_widget.dart';
import 'package:base/widgets/loaders/loader_spinner_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../services/form_service.dart';
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

    toggleBody(index, messages) {
      setState(() {
        showBody[index] = !showBody[index];
      });
      return showBody[index];
    }

    return messages.isEmpty
        ? const LoaderSpinnerWidget()
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
                          onTap: () => toggleBody(index, messages),
                          child: messages[index]['incoming'] == true
                              ? Card(
                                  color: Theme.of(context).colorScheme.surface,
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 10, 10),
                                    child: Row(
                                      children: [
                                        messages[index]['channels']
                                                    ['channel'] ==
                                                'Email'
                                            ? const EmailIconWidget()
                                            : Container(),
                                        Text(
                                          messages[index]["subject"] ?? '',
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 10, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            messages[index]["body"] ?? '',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5)
                                    ],
                                  ),
                                ))
                            : Container(),
                        showBody[index] == true
                            ? ReplyMessageFormWidget(message: messages[index])
                            : Container()
                      ],
                    );
                  }),
            ),
          );
  }
}
