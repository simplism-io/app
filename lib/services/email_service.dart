import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class EmailService {
  Future getEmail(messageId) async {
    final email = await supabase
        .from('emails')
        .select()
        .eq('message_id', messageId)
        .single();

    if (email != null) {
      return email;
    } else {
      return null;
    }
  }

  Future createEmail(newMessageId, mailboxId, emailAddressId, bodyHtml) async {
    if (kDebugMode) {
      print('Trying to create email');
    }

    final email = await supabase
        .from('emails')
        .insert({
          'message_id': newMessageId,
          'mailbox_id': mailboxId,
          'email_addresses_id': emailAddressId,
          'body_html': bodyHtml,
          'executed': false
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
