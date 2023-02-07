import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AttachmentService {
  Future createAttachments(attachments, newMessageId) async {
    if (kDebugMode) {
      print('Trying to create attachment');
    }

    bool error = false;

    attachments.forEach((attachment) async => {
          attachment = await supabase
              .from('attachments')
              .insert({
                'message_id': newMessageId,
                'name': attachment['name'],
                'base64': attachment['base64']
              })
              .select()
              .single(),
          if (attachment == null) {error = true}
        });

    if (error == false) {
      return true;
    } else {
      return false;
    }
  }
}
