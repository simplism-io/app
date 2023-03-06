import 'package:jiffy/jiffy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/icons/alert_icon.dart';
import '../constants/icons/email_icon.dart';

final supabase = Supabase.instance.client;

class UtilService {
  final Uri url = Uri.parse('https://github.com/simplism-io');

  Future<void> launchSimplismGithub() async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String truncateString(String data, int length) {
    return (data.length >= length) ? '${data.substring(0, length)}...' : data;
  }

  getIcon(channel) {
    switch (channel) {
      case 'email':
        return const EmailIcon(size: 10);
      case 'alert':
        return const AlertIcon(size: 10);
    }
  }
}
