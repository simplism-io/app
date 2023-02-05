import 'package:flutter/foundation.dart';
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
        if (kDebugMode) {
          print('New incoming message');
        }
        await getMessages();
      },
    ).subscribe();
  }

  Future<void> getMessages() async {
    if (kDebugMode) {
      print('Trying to load messages');
    }
    messages = await supabase
        .from('messages')
        .select(
            'id, subject, body, incoming, created, channel_id, channels(channel), emails(*), errors(*)')
        .eq('organisation_id', organisationId);
    notifyListeners();
  }

  Future sendMessageProcedure(
      messageId, channelId, subject, bodyHtml, bodyText, attachments) async {
    if (kDebugMode) {
      print('Trying to send message');
    }
    bool error = false;
    final resultCreateMessage =
        await createMessage(channelId, subject, bodyText);

    if (resultCreateMessage != null) {
      //SWITCH BASE BASED ON CHANNEL
      final newMessageId = resultCreateMessage;

      final originalEmail = await supabase
          .from('emails')
          .select()
          .eq('message_id', messageId)
          .single();

      if (originalEmail != null) {
        final email = createEmail(
            newMessageId,
            originalEmail['email_address_id'],
            originalEmail['mailbox_id'],
            bodyHtml);
        // ignore: unnecessary_null_comparison
        if (email != null) {
          if (kDebugMode) {
            print('Transaction complete');
          }
        }
      } else {
        if (kDebugMode) {
          error = true;
          print('originalEmail is null');
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

  Future createMessage(channelId, subject, bodyText) async {
    if (kDebugMode) {
      print('Trying to create message');
    }
    final message = await supabase
        .from('messages')
        .insert({
          'organisation_id': organisationId,
          'channel_id': channelId,
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

  Future createEmail(newMessageId, emailAddressId, mailboxId, bodyHtml) async {
    if (kDebugMode) {
      print('Trying to create email');
    }
    final email = await supabase
        .from('emails')
        .insert({
          'message_id': newMessageId,
          'email_address_id': emailAddressId,
          'mailbox_id': mailboxId,
          'body_html': bodyHtml
        })
        .select()
        .single();

    if (email != null) {
      return email['id'];
    } else {
      return null;
    }
  }
}
