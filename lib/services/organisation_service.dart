import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OrganisationService {
  Future createOrganisation(organisationName) async {
    final organisation = await supabase
        .from('organisations')
        .insert({'organisation': organisationName})
        .select()
        .single();

    if (organisation != null) {
      return organisation["id"];
    } else {
      return null;
    }
  }

  Future<void> deleteOrganisation(organisation) async {
    await supabase
        .from('organisations')
        .delete()
        .match({'organisation': organisation});
  }
}
