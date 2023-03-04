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

  Future loadMailBoxWithoutId(email) async {
    return await supabase
        .from('mailboxes')
        .select('id, tested')
        .eq('email', email)
        .single();
  }

  Future createOrUpdateMailBox(
      email, password, imapUrl, imapPort, smtpUrl, smtpPort, tested) async {
    final mailboxLoaded = await loadMailBoxWithoutId(email);

    String? mailBoxId;

    if (mailboxLoaded != null) {
      final mailboxCreated = await supabase
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
      mailBoxId = mailboxCreated['id'];
    } else {
      final mailboxUpdated = await supabase
          .from('mailboxes')
          .update({
            'email': email,
            'password': password,
            'imap_url': imapUrl,
            'imap_port': imapPort,
            'smtp_url': smtpUrl,
            'smtp_port': smtpPort,
            'active': false,
            'tested': false
          })
          .match({'id': mailboxLoaded['id']})
          .select()
          .single();
      mailBoxId = mailboxUpdated['id'];
    }

    if (mailBoxId != null) {
      return mailBoxId;
    } else {
      return null;
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

  Future confirmMailBox(id) async {
    try {
      if (kDebugMode) {
        print('Trying to confirm mailbox');
      }
      final mailbox = await supabase
          .from('mailboxes')
          .update({'active': true, 'tested': true})
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
