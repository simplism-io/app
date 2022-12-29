class AgentModel {
  AgentModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.avatar,
      required this.created,
      required this.modified});

  final String id;
  final String email;
  final String name;
  final String avatar;
  final DateTime? created;
  final DateTime? modified;

  AgentModel.fromMap(
      {required Map<String, dynamic> map, required String emailFromAuth})
      : id = map['id'],
        name = map['name'],
        email = emailFromAuth,
        avatar = map['avatar'],
        created = DateTime.parse(map['created']),
        modified = DateTime.parse(map['modified']);
}
