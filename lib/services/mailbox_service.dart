import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MailBoxService extends ChangeNotifier {
  Map? mailboxStatus;

  Future loadMailBoxes() async {
    return await supabase.from('mailboxes').select('*, emails(id)').eq(
        'organisation_id',
        supabase.auth.currentSession!.user.userMetadata!['organisation_id']);
  }

  Future loadMailBox(mailBoxId) async {
    return await supabase
        .from('mailboxes')
        .select('id, tested')
        .eq('id', mailBoxId);
  }

  Future createMailBox(
      email, password, imapUrl, imapPort, smtpUrl, smtpPort, tested) async {
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
              .auth.currentSession!.user.userMetadata!['organisation_id'],
          'active': false,
          'tested': tested
        })
        .select()
        .single();

    if (mailbox != null) {
      return mailbox['id'];
    } else {
      return false;
    }
  }

  Future markMailBoxAsTested(mailboxId) async {
    try {
      if (kDebugMode) {
        print('Trying to update mailbox');
      }
      final mailbox = await supabase
          .from('mailboxes')
          .update({'active': true, 'tested': true})
          .match({'id': mailboxId})
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
    }
  }

  Future updateMailBox(
      id, email, password, imapUrl, imapPort, smtpUrl, smtpPort, active) async {
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
            'active': active,
            'tested': true
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
    }
  }

  Future deleteMailbox(mailBoxId) async {
    await supabase.from('mailboxes').delete().match({'id': mailBoxId});
  }
}
