import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MessageService extends ChangeNotifier {
  late List messages;
  final organisationId =
      supabase.auth.currentSession!.user.userMetadata!['organisation_id'];

  MessageService() {
    messages = [];
    getMessages();

    supabase.channel('public:messages').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          event: 'INSERT',
          schema: 'public',
          table: 'messages',
          filter: 'organisation_id=eq.$organisationId'),
      (payload, [ref]) async {
        await getMessages();
      },
    ).subscribe();
  }

  getMessages() async {
    messages = await supabase.from('messages').select('''
    id, subject, body, incoming, created, channel_id, channels:channel_id (channel)
  ''').eq('organisation_id', organisationId);
    notifyListeners();
  }

  Future sendMessageProcedure(
    messageId,
    channelId,
    subject,
    body,
  ) async {
    final resultCreateMessage = await createMessage(channelId, subject, body);

    if (resultCreateMessage != null) {
      //SWITCH BASE BASED ON CHANNEL

      final originalEmail = await supabase
          .from('emails')
          .select()
          .eq('message_id', messageId)
          .single();

      print(originalEmail);
      if (originalEmail != null) {
        final email = createEmail(messageId, originalEmail['email_address_id'],
            originalEmail['mailbox_id']);
        print(email);
      } else {
        print('originalEmail is null');
      }
    } else {
      print('resultCreateMessage is null');
    }
  }

  Future createMessage(
    channelId,
    subject,
    body,
  ) async {
    final message = await supabase
        .from('messages')
        .insert({
          'organisation_id': organisationId,
          'channel_id': channelId,
          'subject': subject,
          'body': body,
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

  Future createEmail(messageId, emailAddressId, mailboxId) async {
    final List<Map<String, dynamic>> email = await supabase
        .from('emails')
        .insert({
          'message_id': messageId,
          'email_address_id': emailAddressId,
          'mailbox_id': mailboxId,
        })
        .select()
        .single();
    return email;
  }
}
