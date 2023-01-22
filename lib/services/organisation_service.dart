import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OrganisationService {
  Future createOrganisation(organisationName) async {
    if (kDebugMode) {
      print('Trying to create organisation name');
    }
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
    if (kDebugMode) {
      print('Trying to delete organisation');
    }
    await supabase
        .from('organisations')
        .delete()
        .match({'organisation': organisation});
  }
}
