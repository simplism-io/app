import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MessageService extends ChangeNotifier {
  late List messages;

  MessageService() {
    messages = [];
    getMessages();

    supabase.channel('public:messages').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: 'messages'),
      (payload, [ref]) {
        getMessages();
      },
    ).subscribe();
  }

  getMessages() async {
    messages = await supabase.from('messages').select('''
    id, subject, body, created, channels:channel_id (channel)
  ''').eq('organisation_id', supabase.auth.currentSession!.user.userMetadata!['organisation_id']);

    notifyListeners();
  }

  Future sendEmailMessage() async {
    return true;
  }

  Future sendViberMessage() async {
    return true;
  }

  Future sendWhatsAppMessage() async {
    return true;
  }

  Future sendTelegramMessage() async {
    return true;
  }
}
