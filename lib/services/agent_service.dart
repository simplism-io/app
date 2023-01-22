import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'organisation_service.dart';

final supabase = Supabase.instance.client;

class AgentService extends ChangeNotifier {
  Future signInUsingEmailAndPassword(email, password) async {
    if (kDebugMode) {
      print('Trying to sign in');
    }
    AuthResponse result = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (EmailValidator.validate(result.user!.email!)) {
      return true;
    } else {
      return false;
    }
  }

  Future createAgentName(name) async {
    final agent = await supabase
        .from('agents')
        .update({'name': name})
        .match({'id': supabase.auth.currentUser!.id})
        .select()
        .single();

    if (agent != null) {
      return true;
    } else {
      return false;
    }
  }

  Future createAgent(userId, organizationId, isAdmin) async {
    final agent = await supabase
        .from('agents')
        .insert({
          'id': userId,
          'organisation_id': organizationId,
          'is_admin': isAdmin
        })
        .select()
        .single();

    if (agent != null) {
      return agent['id'];
    } else {
      return null;
    }
  }

  Future createAgentMetaData(organisationId, isAdmin) async {
    final UserResponse result = await supabase.auth.updateUser(
      UserAttributes(
        data: {'organisation_id': organisationId, 'is_admin': isAdmin},
      ),
    );
    if (EmailValidator.validate(result.user!.email!)) {
      return true;
    } else {
      return false;
    }
  }

  Future createAgentProcedure(organisation) async {
    bool error = false;

    if (kDebugMode) {
      print('Trying to save organisation ');
    }
    final organisationId =
        await OrganisationService().createOrganisation(organisation);
    if (organisationId != null) {
      final resultCreateAgentMetaData =
          await createAgentMetaData(organisationId, true);
      if (resultCreateAgentMetaData == true) {
        final agentId = await createAgent(
            supabase.auth.currentUser!.id, organisationId, true);
        if (agentId != null) {
          if (kDebugMode) {
            print('Succesfully created agent');
          }
        } else {
          await OrganisationService().deleteOrganisation(organisation);
          error = true;
        }
      } else {
        await OrganisationService().deleteOrganisation(organisation);
        error = true;
      }
    } else {
      error = true;

      if (error == false) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future signUpUsingEmailAndPassword({organisation, email, password}) async {
    bool error = false;
    try {
      if (kDebugMode) {
        print('Trying to sign up');
      }
      final organisationId =
          await OrganisationService().createOrganisation(organisation);
      if (organisationId != null) {
        AuthResponse result = await supabase.auth.signUp(
            email: email,
            password: password,
            data: {'organisation_id': organisationId, 'is_admin': true});
        if (EmailValidator.validate(result.user!.email!)) {
          final agentId =
              await createAgent(result.user!.id, organisationId, true);
          if (agentId != null) {
            if (kDebugMode) {
              print('Transaction complete');
            }
          } else {
            await OrganisationService().deleteOrganisation(organisation);
            error = true;
          }
        } else {
          await OrganisationService().deleteOrganisation(organisation);
          error = true;
        }
      } else {
        error = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (error == false) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signInUsingApple() async {
    if (kDebugMode) {
      print('Trying to sign in');
    }
    await supabase.auth.signInWithOAuth(
      Provider.apple,
      redirectTo: kIsWeb ? null : 'io.supabase.starter://login-callback/',
    );
  }

  Future<void> signInUsingGoogle() async {
    if (kDebugMode) {
      print('Trying to sign in');
    }
    await supabase.auth.signInWithOAuth(
      Provider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.starter://login-callback/',
    );
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> resetPassword(email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future updateEmail(id, email) async {
    if (kDebugMode) {
      print('Trying to update email');
    }
    final result = await supabase.auth.updateUser(
      UserAttributes(
        email: email,
      ),
    );

    if (EmailValidator.validate(result.user!.email!)) {
      return true;
    } else {
      return false;
    }
  }

  Future updateAgent(id, name, avatar) async {
    if (kDebugMode) {
      print('Trying to update profile');
    }
    final result = await supabase
        .from('agents')
        .update({'name': name, 'avatar': avatar})
        .match({'id': id})
        .select()
        .single();

    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  Future updateAgentProcedure(name, email, avatar) async {
    if (kDebugMode) {
      print('Trying to update email and profile procedure');
    }
    UserResponse emailUpdate =
        await updateEmail(supabase.auth.currentUser!.id, email);
    final profileUpdate =
        await updateAgent(supabase.auth.currentUser!.id, name, avatar);
    if (emailUpdate == true && profileUpdate == true) {
      return true;
    } else {
      return false;
    }
  }

  Future updatePassword(passwordNew) async {
    if (kDebugMode) {
      print('Trying to update profile');
    }
    UserResponse result = await supabase.auth.updateUser(
      UserAttributes(
        password: passwordNew,
      ),
    );
    if (EmailValidator.validate(result.user!.email!)) {
      return true;
    } else {
      return false;
    }
  }

  Future loadAgent() async {
    await Future.delayed(const Duration(seconds: 3));
    return await supabase
        .from('agents')
        .select()
        .eq('id', supabase.auth.currentUser!.id)
        .single();
  }
}
