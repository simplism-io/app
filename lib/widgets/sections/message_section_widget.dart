import 'package:base/widgets/icons/email_icon_widget.dart';
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

    return Column(
      children: [
        ListView.builder(
            reverse: true,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Card(
                  color: Theme.of(context).colorScheme.surface,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                  ));
            }),
      ],
    );

    // return StreamBuilder<List<MessageModel>>(
    //   stream: messages,
    //   builder: (
    //     context,
    //     snapshot,
    //   ) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const LoaderSpinnerWidget();
    //     } else if (snapshot.connectionState == ConnectionState.active ||
    //         snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.hasError) {
    //         return Text(snapshot.error.toString());
    //       } else if (snapshot.hasData) {
    //         final messages = snapshot.data!;
    //         return Column(
    //           children: [
    //             ListView.builder(
    //                 reverse: true,
    //                 shrinkWrap: true,
    //                 scrollDirection: Axis.vertical,
    //                 itemCount: messages.length,
    //                 itemBuilder: (context, index) {
    //                   final message = messages[index];
    //                   return Card(
    //                       color: Theme.of(context).colorScheme.surface,
    //                       margin: const EdgeInsets.symmetric(
    //                           vertical: 5, horizontal: 15),
    //                       child: Padding(
    //                         padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
    //                         child: Row(
    //                           children: [
    //                             ChannelService().getChannelName(
    //                                         message.channelId) ==
    //                                     'email'
    //                                 ? const EmailIconWidget()
    //                                 : Container(),
    //                             const SizedBox(width: 10),
    //                             Text(
    //                               message.subject,
    //                               style: const TextStyle(fontSize: 15),
    //                             ),
    //                           ],
    //                         ),
    //                       ));
    //                 }),
    //           ],
    //         );
    //       } else {
    //         return Text(
    //             LocalizationService.of(context)?.translate('no_data_message') ??
    //                 '');
    //       }
    //     } else {
    //       return Text('State: ${snapshot.connectionState}');
    //     }
    //   },
    // );
  }
}
