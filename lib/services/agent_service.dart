import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/agent_model.dart';

final supabase = Supabase.instance.client;

class AgentService extends ChangeNotifier {
  Future signInUsingEmailAndPassword(email, password) async {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future createOrganisation(organisation) async {
    return await supabase
        .from('organisations')
        .insert({'organisation': organisation});
  }

  Future getOrganisation(organisation) async {
    return await supabase
        .from('organisations')
        .select('id')
        .eq('organisation', organisation);
  }

  Future createAgent(userId, organizationId) async {
    return await supabase
        .from('agents')
        .insert({'id': userId, 'organisation_id': organizationId});
  }

  Future createOrganisationAndAgentProcedure(organisation) async {
    try {
      if (kDebugMode) {
        print('Trying to save organisation ');
      }
      final resultCreateOrganisation = await createOrganisation(organisation);
      if (resultCreateOrganisation == null) {
        final resultSelectOrganisation = await getOrganisation(organisation);
        if (resultSelectOrganisation != null) {
          final resultCreateAgent = await createAgent(
              supabase.auth.currentUser!.id, resultSelectOrganisation[0]['id']);
          if (resultCreateAgent == null) {
            return true;
          } else {
            await deleteOrganisation(organisation);
            return false;
          }
        } else {
          await deleteOrganisation(organisation);
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> deleteOrganisation(organisation) async {
    await supabase
        .from('organisations')
        .delete()
        .match({'organisation': organisation});
  }

  Future signUpUsingEmailAndPassword({organisation, email, password}) async {
    try {
      if (kDebugMode) {
        print('Trying to sign up');
      }
      final resultCreateOrganisation = await createOrganisation(organisation);
      if (resultCreateOrganisation == null) {
        final resultSelectOrganisation = await getOrganisation(organisation);
        if (resultSelectOrganisation != null) {
          AuthResponse result = await supabase.auth.signUp(
            email: email,
            password: password,
          );
          if (EmailValidator.validate(result.user!.email!)) {
            final resultCreateAgent = await createAgent(
                result.user!.id, resultSelectOrganisation[0]['id']);
            if (resultCreateAgent == null) {
              return true;
            } else {
              await deleteOrganisation(organisation);
              return false;
            }
          } else {
            await deleteOrganisation(organisation);
            return false;
          }
        } else {
          await deleteOrganisation(organisation);
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> signInUsingGoogle() async {
    try {
      if (kDebugMode) {
        print('Trying to sign in');
      }
      await supabase.auth.signInWithOAuth(
        Provider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.starter://login-callback/',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
    try {
      if (kDebugMode) {
        print('Trying to update email');
      }
      return await supabase.auth.updateUser(
        UserAttributes(
          email: email,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future updateProfile(id, fullName, avatar) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      return await supabase
          .from('profiles')
          .update({'full_name': fullName, 'avatar': avatar}).match({'id': id});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future updateProfileProcedure(fullName, email, avatar) async {
    try {
      if (kDebugMode) {
        print('Trying to update email and profile procedure');
      }
      UserResponse emailUpdate =
          await updateEmail(supabase.auth.currentUser!.id, email);
      final profileUpdate =
          await updateProfile(supabase.auth.currentUser!.id, fullName, avatar);
      if (EmailValidator.validate(emailUpdate.user!.email!) &&
          profileUpdate == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future updatePassword(passwordNew) async {
    try {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future loadAgent() async {
    return AgentModel.fromMap(
        map: await supabase
            .from('agents')
            .select()
            .eq('id', supabase.auth.currentUser!.id)
            .single(),
        emailFromAuth: supabase.auth.currentUser!.email!);
  }
}
