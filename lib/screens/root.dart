import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/loaders/loader.dart';
import '../services/agent_service.dart';
import 'private/agent/create_agent_name_screen.dart';
import 'private/organisation/create_organisation_screen.dart';
import 'private/message/messages_screen.dart';
import 'public/auth_screen.dart';
import 'public/index_screen.dart';

final supabase = Supabase.instance.client;

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Session? session;
  StreamSubscription<AuthState>? authSubscription;

  @override
  void initState() {
    authSubscription = supabase.auth.onAuthStateChange.listen((response) {
      if (kDebugMode) {
        print('AuthEvent recorded');
      }
      setState(() {
        session = response.session;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    session = supabase.auth.currentSession;
    return session == null
        ? (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android)
            ? const AuthScreen()
            : const IndexScreen()
        : FutureBuilder(
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final agent = snapshot.data!;
                  if (agent['name'] == null || agent['name'] == '') {
                    return const CreateAgentNameScreen();
                  } else {
                    return MessagesScreen(agent: agent);
                  }
                }
                if (!snapshot.hasData) {
                  if (supabase.auth.currentSession!.user
                          .userMetadata!['organisation_id'] !=
                      null) {
                    return const CreateOrganisationScreen();
                  } else {
                    if ((defaultTargetPlatform == TargetPlatform.iOS ||
                        defaultTargetPlatform == TargetPlatform.android)) {
                      return const AuthScreen();
                    } else {
                      return const IndexScreen();
                    }
                  }
                }
              }
              return const Loader(size: 50.0);
            },
            future: AgentService().loadAgent(),
          );
  }
}
