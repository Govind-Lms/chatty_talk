import 'package:chaty_talk/enum/user_state.dart';
import 'package:chaty_talk/provider/user_provider.dart';
import 'package:chaty_talk/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods= AuthMethods();
    UserProvider userProvider= Provider.of<UserProvider>(context);
    // ignore: unused_element
    signOut() async{
      final bool isLoggedOut = await AuthMethods().signOut();
      if(isLoggedOut){
        authMethods.setUserState(uid: userProvider.getUser.uid, userState: UserState.Offline);
        Navigator
          .of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LoginScreen()), (route) => false);
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 35.0),
      child: Column(
        children: [
          // CustomAppBar(
          //   leading: IconButton(icon: Icon(Icons.arrow_drop_down_circle_sharp,color: Colors.white,),onPressed: ()=>Navigator.pop(context),),
          //   centerTitle: true,
          //   // title: ShimmeringLogo(),
          //   actions: [
          //     // ignore: deprecated_member_use
          //     FlatButton(onPressed: ()=> signOut(), child: Text('Sign Out',style: TextStyle(color: Colors.white,fontSize: 12.0),)),

          //   ],
          // ),
          UserDetailsBody(),
        ],
      ),
      
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods= AuthMethods();
    final UserProvider userProvider= Provider.of<UserProvider>(context);
    final UserModel userModel = userProvider.getUser;
    signOut() async{
      final bool isLoggedOut = await AuthMethods().signOut();
      if(isLoggedOut){
        authMethods.setUserState(uid: userProvider.getUser.uid, userState: UserState.Offline);
        Navigator
          .of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LoginScreen()), (route) => false);
      }
    }

    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [

            SizedBox(height: 20.0,),
            Container(width: 100.0,height: 5.0,
              decoration: BoxDecoration(
                color: UniversalVariables.greyColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(height: 20.0,),
            CachedImage(
              imageUrl: userModel.profilePhoto,
              isRound: true,
              radius: 100.0,
            ),
            SizedBox(height: 10.0,),
            Text(userModel.name.toUpperCase(),style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),),
            SizedBox(height: 0.0,),
            Text(userModel.username,style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              color: Colors.white,
            ),),

            SizedBox(height: 10.0,),
            Divider(thickness: 1.0,color: Colors.grey,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0,),
                Text('Email',style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.white,
                ),),
                Text(userProvider.getUser.email),

                SizedBox(height: 30.0,),
                Text('Birth-Date',style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.white,
                ),),
                Text(userProvider.getUser.state.toString()),

                SizedBox(height: 30.0,),Text('Gender',style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.white,
                ),),
                Text(userProvider.getUser.status.toString()),

                SizedBox(height: 10.0,),
                Divider(thickness: 1.0,color: Colors.grey,),
                SizedBox(height: 10.0,),
                
                // ignore: deprecated_member_use
                Center(child: FlatButton(onPressed: ()=> signOut(), 
                  color: UniversalVariables.blueColor,
                  child: Text('Sign Out',
                  style: TextStyle(color: Colors.white,fontSize: 12.0),),
                  ),
                ),

              ],
            )
          ],
        )
        // Row(children: [
          // CachedImage(
          //   imageUrl: userModel.profilePhoto,
          //   isRound: true,
          //   radius: 50.0,
          // ),
        //   SizedBox(width: 15.0,),
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
              // Text(userModel.name,style: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18.0,
              //   color: Colors.white,
              // ),),
              // SizedBox(width: 10.0,),
              // Text(userModel.email,style: TextStyle(
              //   fontWeight: FontWeight.normal,
              //   fontSize: 14.0,
              //   color: Colors.white,
              // ),),
        //     ],
        //   )
        // ],),
      ),
    );
  }
}
