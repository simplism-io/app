import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ErrorService extends ChangeNotifier {
  late List mailbox_errors;
  final organisationId =
      supabase.auth.currentSession!.user.userMetadata!['organisation_id'];

  ErrorService() {
    mailbox_errors = [];

    supabase.channel('public:messages').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
          event: 'INSERT',
          schema: 'public',
          table: 'error_triggers',
          filter: 'organisation_id=eq.$organisationId'),
      (payload, [ref]) async {
        print(payload);

        switch (payload) {
          case 'mailbox_errors':
            if (kDebugMode) {
              print('New mailbox error');
              await getMailboxErrors();
              notifyListeners();
            }
            print('zero!');

            //await getMessages();

            break; // The switch statement must be told to exit, or it will execute every case.
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

  getMailboxErrors() async {
    if (kDebugMode) {
      print('Trying to load mailbox errors');
    }
    mailbox_errors = await supabase
        .from('mailbox_errors')
        .select()
        .eq('organisation_id', organisationId);
    notifyListeners();
  }
}
