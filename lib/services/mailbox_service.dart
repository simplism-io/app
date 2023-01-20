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

  //   Future updateMailbox(id, email, password, imap, smtp) async {
  //   try {
  //     if (kDebugMode) {
  //       print('Trying to update email');
  //     }
  //     return await supabase.auth.updateUser(
  //       UserAttributes(
  //         email: email,
  //       ),
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return false;
  //   }
  // }

  Future toggleMailbox(id, value) async {
    if (kDebugMode) {
      print('Trying to update profile');
    }
    final mailbox = await supabase
        .from('mailboxes')
        .update({'active': value}).match({'id': id});

    if (mailbox != null) {
      return true;
    } else {
      return false;
    }
  }
}
