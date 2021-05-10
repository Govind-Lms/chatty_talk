import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  final FirebaseMessaging fcm= FirebaseMessaging();
  void initialize(){
    fcm.configure(
      onMessage: (Map<String, dynamic> message)async{
        print('onMessage: $message');
        // _showItemDialog(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String,dynamic> message)async{
        print('onLaunch: $message');
        //navigateToItemDetail(message);
      },
      onResume: (Map<String,dynamic> message)async{
        print('onResume: $message');
        //navigateToItemDetail(message);
      }
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
// class _HomePageState extends State<HomePage> {
//   PushNotificationModel _notificationInfo;
//   FirebaseMessaging _messaging = FirebaseMessaging();
//   int _totalNotifications;
//   @override
//   void initState() {
//     _totalNotifications = 0;
//     super.initState();
//   }
//   void registerNotification() async {
//     // await _messaging.requestNotificationPermissions(
//     //   IosNotificationSettings(
//     //     alert: true,
//     //     badge: true,
//     //     provisional: false,
//     //     sound: true,
//     //   ),
//     // );
//     _messaging.getToken().then((token) {
//       print('Token: $token');
//     }).catchError((e) {
//       print(e);
//     });
//     _messaging.configure(
//       onLaunch: (message) async {
//         print('onLaunch: $message');
//         PushNotificationModel notification = PushNotificationModel.fromJson(message);
//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });
//       },
//       onResume: (message) async {
//         print('onResume: $message');
//         PushNotificationModel notification = PushNotificationModel.fromJson(message);
//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });
//       },
//       onBackgroundMessage: _firebaseMessagingBackgroundHandler,
//       onMessage: (message) async {
//         showSimpleNotification(
//           Text(_notificationInfo.title),
//           leading: NotificationBadge(totalNotifications: _totalNotifications),
//           subtitle: Text(_notificationInfo.body),
//           background: Colors.cyan[700],
//           duration: Duration(seconds: 2),
//         );
//       },
//     );
//   }
//   Future<dynamic> _firebaseMessagingBackgroundHandler(Map<String, dynamic> message,) async {
//     print('onBackgroundMessage received: $message');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // ...
//           _notificationInfo != null
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('hi',style: TextStyle(color: Colors.cyan[700],),),
//                     Text(
//                       'TITLE: ${_notificationInfo.title ?? _notificationInfo.dataTitle}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'BODY: ${_notificationInfo.body ?? _notificationInfo.dataBody}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
// class NotificationBadge extends StatelessWidget {
//   final int totalNotifications;
//   const NotificationBadge({@required this.totalNotifications});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       decoration: new BoxDecoration(
//         color: Colors.red,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             '$totalNotifications',
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class PushNotificationModel {
//   PushNotificationModel({
//     this.title,
//     this.body,
//     this.dataTitle,
//     this.dataBody,
//   });
//   String title;
//   String body;
//   String dataTitle;
//   String dataBody;
//   factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
//     return PushNotificationModel(
//       title: json["notification"]["title"],
//       body: json["notification"]["body"],
//       dataTitle: json["data"]["title"],
//       dataBody: json["data"]["body"],
//     );
//   }
// }
