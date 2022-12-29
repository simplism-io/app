class AgentModel {
  AgentModel({
    required this.id,
    required this.organisationId,
    required this.email,
    //required this.avatar,
    // required this.created,
    // required this.modified
  });

  final String id;
  final String email;
  final String organisationId;
  //final String avatar;
  // final DateTime? created;
  // final DateTime? modified;

  AgentModel.fromMap(
      {required Map<String, dynamic> map, required String emailFromAuth})
      : id = map['id'],
        organisationId = map['organisation_id'],
        email = emailFromAuth;
  // avatar = map['avatar'];
  // created = DateTime.parse(map['created']),
  // modified = DateTime.parse(map['modified']);
}
