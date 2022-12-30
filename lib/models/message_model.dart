import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MessageModel {
  final String id;
  final String organisationId;
  final String title;
  final String body;
  final DateTime created;
  final bool isMine;

  MessageModel({
    required this.id,
    required this.organisationId,
    required this.title,
    required this.body,
    required this.created,
    required this.isMine,
  });

  MessageModel.fromMap({
    required Map<String, dynamic> map,
    required String uid,
  })  : id = map['id'],
        organisationId = map['organisation_id'],
        title = map['title'],
        body = map['body'],
        created = DateTime.parse(map['created']),
        isMine = uid == map['agent_id'];
}
