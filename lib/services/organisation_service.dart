import 'package:email_validator/email_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OrganisationService {
  Future createOrganisation(organisation) async {
    return await supabase
        .from('organisations')
        .insert({'organisation': organisation});
  }

  Future getOrganisation(organisation) async {
    return await supabase
        .from('organisations')
        .select('id')
        .eq('organisation', organisation)
        .single();
  }

  Future<void> deleteOrganisation(organisation) async {
    await supabase
        .from('organisations')
        .delete()
        .match({'organisation': organisation});
  }

  Future updateOrganisationIdInUserMetaData(organisationId) async {
    final UserResponse result = await supabase.auth.updateUser(
      UserAttributes(
        data: {'organisation_id': organisationId},
      ),
    );
    if (EmailValidator.validate(result.user!.email!)) {
      return true;
    } else {
      return false;
    }
  }
}
