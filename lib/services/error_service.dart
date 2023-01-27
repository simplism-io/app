import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ErrorService extends ChangeNotifier {
  late List mailboxErrors;
  final organisationId =
      supabase.auth.currentSession!.user.userMetadata!['organisation_id'];

  ErrorService() {
    mailboxErrors = [];
    getMailboxErrors();

    print('Setting up error trigger listener');

    supabase.channel('public:error_triggers').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          event: 'INSERT',
          schema: 'public',
          table: 'error_triggers',
          filter: 'organisation_id=eq.$organisationId'),
      (payload, [ref]) async {
        switch (payload.context) {
          case 'mailbox_errors':
            if (kDebugMode) {
              print('New mailbox error');
              await getMailboxErrors();
              notifyListeners();
            }
            print('zero!');

            //await getMessages();

            break;
          case 1:
            print('one!');
            break;
          case 2:
            print('two!');
            break;
          default:
            print('choose a different number!');
        }
      },
    ).subscribe();
  }

  Future<void> getMailboxErrors() async {
    if (kDebugMode) {
      print('Trying to load mailbox errors');
    }

    print(organisationId);

    mailboxErrors = await supabase
        .from('mailbox_errors')
        .select()
        .eq('organisation_id', organisationId);

    print(mailboxErrors);

    notifyListeners();
  }
}
