import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double size;
  const Loader({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onBackground)),
      )),
    );
  }
}
