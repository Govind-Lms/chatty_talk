import 'package:chaty_talk/screens/screens.dart';
import 'package:flutter/material.dart';

class SkypeAppBar extends StatelessWidget implements PreferredSizeWidget{
  
  final dynamic title;
  final List<Widget> actions;
  const SkypeAppBar({Key key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.notifications,color: Colors.white,),
        onPressed: (){},
      ),
      centerTitle: true,
      title: title is String ? Text(title, style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      )) : title,
      actions: actions,
    );
  }
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}