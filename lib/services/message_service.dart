import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'attachment_service.dart';
import 'email_service.dart';

final supabase = Supabase.instance.client;

class MessageService extends ChangeNotifier {
  late List messages;
  final organisationId =
      supabase.auth.currentSession!.user.userMetadata!['organisation_id'];

  MessageService() {
    messages = [];
    getNewMessages();

    supabase.channel('public:messages').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          event: 'INSERT',
          schema: 'public',
          table: 'messages',
          filter: 'organisation_id=eq.$organisationId'),
      (payload, [ref]) async {
        if (kDebugMode) {
          print('New incoming message');
        }
        await getNewMessages();
      },
    ).subscribe();
  }

  Future<void> getNewMessages() async {
    if (kDebugMode) {
      print('Trying to load messages');
    }
    messages = await supabase
        .from('messages')
        .select(
            'id, subject, created, incoming, channel_id, channels(channel), customer_id, customers(name), errors(*)')
        .eq('organisation_id', organisationId)
        .order('created', ascending: false);
        print(messages);
    notifyListeners();
  }

  Future getMessageHistory(
    customerId,
  ) async {
    final messageHistory = await supabase
        .from('messages')
        .select(
            'id, subject, body, incoming, created, channel_id, channels(channel), customer_id, customers(name), emails(body_html), messages_agents(agent_id, agents(id, name)), errors(*)')
        .eq('customer_id', customerId)
        .order('created', ascending: true);
    return messageHistory;
  }

  Future sendMessageProcedure(messageId, channelId, channel, customerId,
      subject, bodyHtml, bodyText, attachments, agentId) async {
    if (kDebugMode) {
      print('Trying to send message');
    }
    bool error = false;
    final resultCreateMessage =
        await createMessage(channelId, customerId, subject, bodyText);

    if (resultCreateMessage != null) {
      final newMessageId = resultCreateMessage;
      final resultCreateMessageAgent =
          await createMessageAgent(newMessageId, agentId);

      if (resultCreateMessageAgent == true) {
        switch (channel) {
          case "email":
            final originalEmail = await EmailService().getEmail(messageId);

            if (originalEmail != null) {
              final emailId = await EmailService().createEmail(
                  newMessageId,
                  originalEmail['mailbox_id'],
                  originalEmail['email_addresses_id'],
                  bodyHtml);
              // ignore: unnecessary_null_comparison
              if (emailId != null) {
                if (attachments.length > 0) {
                  final resultCreateAttachments = await AttachmentService()
                      .createAttachments(attachments, newMessageId);
                  if (resultCreateAttachments == true) {
                    if (kDebugMode) {
                      print('Transaction complete');
                    }
                  } else {
                    error = true;
                    deleteMessage(newMessageId);
                  }
                } else {
                  if (kDebugMode) {
                    print('Transaction complete');
                  }
                }
              } else {
                error = true;
                deleteMessage(newMessageId);
              }
            } else {
              if (kDebugMode) {
                error = true;
                print('originalEmail is null');
              }
            }
            break;
          case "viber":
            break;
        }
      } else {
        error = true;
        if (kDebugMode) {
          print('resultCreateMessageAgent is null');
        }
      }
    } else {
      error = true;
      if (kDebugMode) {
        print('resultCreateMessage is null');
      }
    }
    if (error == false) {
      return true;
    } else {
      return false;
    }
  }

  Future createMessage(channelId, customerId, subject, bodyText) async {
    if (kDebugMode) {
      print('Trying to create message');
    }
    final message = await supabase
        .from('messages')
        .insert({
          'organisation_id': organisationId,
          'channel_id': channelId,
          'customer_id': customerId,
          'subject': subject,
          'body': bodyText,
          'incoming': false
        })
        .select()
        .single();

    if (message != null) {
      return message['id'];
    } else {
      return null;
    }
  }

  Future createMessageAgent(messageId, agentId) async {
    if (kDebugMode) {
      print('Trying to create message agent');
    }
    final messageAgent = await supabase
        .from('messages_agents')
        .insert({
          'message_id': messageId,
          'agent_id': agentId,
        })
        .select()
        .single();

    if (messageAgent != null) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteMessage(messageId) async {
    await supabase.from('messages').delete().match({'id': messageId});
  }
}
