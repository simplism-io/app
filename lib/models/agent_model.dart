class AgentModel {
  final String id;
  final String email;
  final String organisationId;
  final String? name;
  final String avatar;
  final DateTime? created;
  final DateTime? modified;

  AgentModel(
      {required this.id,
      required this.organisationId,
      required this.email,
      this.name,
      required this.avatar,
      required this.created,
      required this.modified});

  AgentModel.fromMap(
      {required Map<String, dynamic> map, required String emailFromAuth})
      : id = map['id'],
        organisationId = map['organisation_id'],
        name = map['name'],
        email = emailFromAuth,
        avatar = map['avatar'],
        created = DateTime.parse(map['created']),
        modified = DateTime.parse(map['modified']);
}
