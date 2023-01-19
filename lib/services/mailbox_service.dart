import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MailBoxService extends ChangeNotifier {
  final String key = "theme";
  late bool _email;

  // bool get darkTheme => _email;

  // MailBoxService() {
  //   _email = false;
  //   loadFromPrefs();
  // }

  toggleEmail(email) {
    //_email = !_darkTheme;
    //saveToPrefs();
  }

  // loadFromPrefs() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   _email = pref.getBool(key) ?? SystemTheme.isDarkMode;
  //   if (kDebugMode) {
  //     print('Theme loaded from storage. DarkTheme is: $_darkTheme');
  //   }
  //   notifyListeners();
  // }

  // saveToPrefs() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   await pref.setBool(key, _darkTheme);
  //   if (kDebugMode) {
  //     print('Theme saved in storage. DarkTheme is: $_darkTheme');
  //   }
  //   notifyListeners();
  // }

  Future loadMailboxes() async {
    return await supabase.from('mailboxes').select().eq('organisation_id',
        supabase.auth.currentSession!.user.userMetadata!['organisation_id']);
  }

  Future createMailbox(email, password, imap, smtp) async {
    final mailbox = await supabase
        .from('mailboxes')
        .insert({
          'email': email,
          'password': password,
          'imap': imap,
          'smtp': smtp,
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
}
