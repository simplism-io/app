import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/biometric_service.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({Key? key}) : super(key: key);

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  bool hasAuthenticated = false;

  Future<dynamic> checkBiometrics() async {
    final isAvailable = BiometricService().checkBiometrics();
    return isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            String localAuthenticationStatus = hasAuthenticated.toString();
            if (kDebugMode) {
              print('Local authentication status $localAuthenticationStatus');
            }
            if (hasAuthenticated == true) {
              if (kDebugMode) {
                print('The user is already authenticated using biometrics');
              }
              return const App();
            } else {
              if (kDebugMode) {
                print('The user is not yet authenticated using biometrics');
              }
              if (snapshot.data == true) {
                BiometricService().authenticate().then((result) => setState(
                    () => result == true
                        ? hasAuthenticated = true
                        : hasAuthenticated = false));
                if (hasAuthenticated == true) {
                  if (kDebugMode) {
                    print('The user is now authenticated using biometrics');
                  }
                  return const App();
                } else {
                  if (kDebugMode) {
                    print(
                        'The user could not be authenticated using biometrics');
                  }
                  return Container();
                }
              } else {
                if (kDebugMode) {
                  print('User can NOT use local auth');
                }
                return const App();
              }
            }
          }
        }
        return const CircularProgressIndicator();
      },
      future: checkBiometrics(),
    ));
  }
}
