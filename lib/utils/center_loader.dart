import 'package:flutter/material.dart';

class CenterCircularLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
}
