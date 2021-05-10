import 'package:chaty_talk/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const CustomTile({
    this.leading,
    this.title,
    this.icon,
    this.subtitle,
    this.trailing,
    this.margin= const EdgeInsets.all(0),
    this.mini = true,
    this.onTap,
    this.onLongPress
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        child: Row(
          children:[
            leading,
            Expanded(child: Container(
              margin: EdgeInsets.only(left: mini ? 10 : 15),
              padding: EdgeInsets.symmetric(vertical: mini ? 3: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: UniversalVariables.separatorColor,
                  ),
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      SizedBox(height: 5.0,),
                      Row(
                        children: [
                          /// icon != null ? icon: Container(), ALSO SAME AS THE BELOW ONE
                          icon ?? Container(),
                          subtitle ?? Container(),
                        ],
                      ),
                    ],
                  ),
                  trailing ?? Container()
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}












