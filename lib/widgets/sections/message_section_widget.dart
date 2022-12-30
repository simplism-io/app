import 'package:flutter/material.dart';

import '../../models/message_model.dart';
import '../../services/localization_service.dart';
import '../builders/message_service.dart';
import '../loaders/loader_spinner_widget.dart';

class MessageSectionWidget extends StatefulWidget {
  const MessageSectionWidget({super.key});

  @override
  State<MessageSectionWidget> createState() => _MessageSectionWidgetState();
}

class _MessageSectionWidgetState extends State<MessageSectionWidget> {
  late final Stream<List<MessageModel>> messages;

  @override
  void initState() {
    messages = MessageService().loadMessages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: messages,
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderSpinnerWidget();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Card(
                          // In many cases, the key isn't mandatory
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(message.content!),
                          ));
                    }),
              ],
            );
          } else {
            return Text(
                LocalizationService.of(context)?.translate('no_data_message') ??
                    '');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
