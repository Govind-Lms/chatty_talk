import 'package:chaty_talk/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({ @required this.heading,@required  this.subtitle});
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35.0,horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 25.0,),
              Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 25.0,),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: (){
                   Navigator.of(context).pushNamed('search_screen');
                },
                color: UniversalVariables.lightBlueColor,
                child: Text('Start Searching'.toUpperCase()),
              )
            ],
          ),
        ),
      )    
    );
  }
}