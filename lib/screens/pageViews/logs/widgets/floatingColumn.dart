import 'package:chaty_talk/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class FloatingColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: UniversalVariables.fabGradient,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: 25.0,
          ),
          padding: EdgeInsets.all(15.0),
        ),
        SizedBox(height: 15.0,),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: UniversalVariables.blackColor,
            border: Border.all(
              width: 2.0,
              color: UniversalVariables.gradientColorEnd,
            )
          ),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.gradientColorEnd,
            size: 25.0,
          ),
          padding: EdgeInsets.all(15.0),
        ),
        
      ],
      
    );
  }
}