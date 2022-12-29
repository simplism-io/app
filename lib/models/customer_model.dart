class CustomerModel {
  CustomerModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.created,
      required this.modified});

  final String id;
  final String email;
  final String name;
  final DateTime? created;
  final DateTime? modified;

  CustomerModel.fromMap(
      {required Map<String, dynamic> map, required String emailFromAuth})
      : id = map['id'],
        name = map['name'],
        email = emailFromAuth,
        created = DateTime.parse(map['created']),
        modified = DateTime.parse(map['modified']);
}
