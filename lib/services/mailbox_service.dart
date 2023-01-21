import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MailBoxService {
  Future loadMailboxes() async {
    return await supabase.from('mailboxes').select().eq('organisation_id',
        supabase.auth.currentSession!.user.userMetadata!['organisation_id']);
  }

  Future createMailbox(
      email, password, imapUrl, imapPort, smtpUrl, smtpPort) async {
    final mailbox = await supabase
        .from('mailboxes')
        .insert({
          'email': email,
          'password': password,
          'imap_url': imapUrl,
          'imap_port': imapPort,
          'smtp_url': smtpUrl,
          'smtp_port': smtpPort,
          'organisation_id': supabase
              .auth.currentSession!.user.userMetadata!['organisation_id']
        })
        .select()
        .single();

    if (mailbox != null) {
      return true;
    } else {
      return false;
    }
  }

  Future updateMailbox(
      id, email, password, imapUrl, imapPort, smtpUrl, smtpPort) async {
    try {
      if (kDebugMode) {
        print('Trying to update mailbox');
      }
      final mailbox = await supabase
          .from('mailboxes')
          .update({
            'email': email,
            'password': password,
            'imap_url': imapUrl,
            'imap_port': imapPort,
            'smtp_url': smtpUrl,
            'smtp_port': smtpPort,
          })
          .match({'id': id})
          .select()
          .single();

      if (mailbox != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
