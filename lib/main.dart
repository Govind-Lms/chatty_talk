import 'package:chaty_talk/firebase/notifications/chat_notifications.dart';
import 'package:chaty_talk/provider/image_upload_provider.dart';
import 'package:chaty_talk/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'package:flutter/material.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthMethods repo =  AuthMethods();
  PushNotification pushNotification = PushNotification();
  @override
  Widget build(BuildContext context) {
    // repo.signOut();
    // 
    /// if you have multi Providers wrap the widget with MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ImageUploadProvider()),
        ChangeNotifierProvider(create: (_)=> UserProvider()),
      ],
      child: MaterialApp(
        title: 'Chatty Talk',
        routes:{
          'search_screen': (context) =>  SearchScreen(),
          'login': (context) =>  LoginScreen(),
          'chat_screen': (context) =>  ChatsScreen(),
          // 'forgetPassword': (context) => ForgotPassword(),
          // 'bottomNav': (context) => BottomNav(),
          // 'register': (context) => Register(),
        },
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: repo.getCurrentUser(),
          builder: (context , AsyncSnapshot<FirebaseUser>snapshot){
            if(snapshot.hasData){
              return HomeScreen();
            }
            else{
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
