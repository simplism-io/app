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
        .select('id, verified')
        .eq('id', mailBoxId)
        .select()
        .single();
  }

  Future loadMailBoxWithoutId(email) async {
    return await supabase
        .from('mailboxes')
        .select('id')
        .eq('email', email)
        .select();
  }

  Future createOrUpdateMailBox(
      email, password, imapUrl, imapPort, smtpUrl, smtpPort) async {
    final mailBoxLoaded = await loadMailBoxWithoutId(email);

    print(mailBoxLoaded);

    String? mailBoxId;

    if (mailBoxLoaded.length == 0) {
      if (kDebugMode) {
        print('Creating mailbox');
      }
      final mailBoxCreated = await supabase
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
            'verified': false,
            'active': false
          })
          .select()
          .single();
      mailBoxId = mailBoxCreated['id'];
    } else {
      if (kDebugMode) {
        print('Updating mailbox');
        final mailBoxUpdated = await supabase
            .from('mailboxes')
            .update({
              'email': email,
              'password': password,
              'imap_url': imapUrl,
              'imap_port': imapPort,
              'smtp_url': smtpUrl,
              'smtp_port': smtpPort,
              'verified': false,
              'active': true,
            })
            .match({'id': mailBoxLoaded[0]['id']})
            .select()
            .single();

        mailBoxId = mailBoxUpdated['id'];
      }
    }

    if (mailBoxId != null) {
      return mailBoxId;
    } else {
      return null;
    } //   mailBoxId = mailBoxCreated['id'];
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
            'verified': true,
            'active': active
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

  Future verifyMailBox(id) async {
    try {
      if (kDebugMode) {
        print('Trying to confirm mailbox');
      }
      final mailbox = await supabase
          .from('mailboxes')
          .update({'verified': true})
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

  Future activateMailBox(id) async {
    try {
      if (kDebugMode) {
        print('Trying to confirm mailbox');
      }
      final mailbox = await supabase
          .from('mailboxes')
          .update({'active': true})
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

  Future deleteMailBox(mailBoxId) async {
    return supabase.from('mailboxes').delete().match({'id': mailBoxId});
  }
}
