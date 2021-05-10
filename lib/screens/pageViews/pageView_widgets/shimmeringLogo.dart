import 'package:chaty_talk/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      child: Shimmer.fromColors(
        child: Image.asset('assets/images/app_logo.png'),
        baseColor: UniversalVariables.whiteColor, highlightColor: UniversalVariables.blueColor
      ),
    );
  }
}