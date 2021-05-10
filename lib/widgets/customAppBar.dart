import 'package:chaty_talk/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({Key key, this.title, this.actions, this.leading, this.centerTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          )
        )
      ),
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        elevation: 0.0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
      padding: EdgeInsets.all(10.0),
    );
  }
  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}
