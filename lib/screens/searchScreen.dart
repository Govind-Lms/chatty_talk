import 'screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods repo= AuthMethods();
  List<UserModel> userList;
  String query= "";
  TextEditingController searchController= TextEditingController();

  @override
  void initState() {
    super.initState();
    repo.getCurrentUser().then((FirebaseUser user){
      repo.fetchAllUsers(user).then((List<UserModel>list){
        userList = list;
      });
    });
  }

  buildSuggestions(String query){
    final List <UserModel> suggestionLists = query.isEmpty 
        ? 
        []
        : 
      // userList.where((UserModel user) => user.username.contains(query.toLowerCase())|| (user.name.contains(query.toLowerCase())));
      userList.where((UserModel user) {
        String getUsername= user.username.toLowerCase();
        String _query=  query.toLowerCase();
        String getName= user.name.toLowerCase();
        bool matchUsername= getUsername.contains(_query);
        bool matchName= getName.contains(_query);
        return (matchUsername || matchName);
      }).toList();
      return ListView.builder(
        itemCount: suggestionLists.length,
        itemBuilder: ((context, index){
          UserModel searchUser= UserModel(
            uid: suggestionLists[index].uid,
            email: suggestionLists[index].email,
            profilePhoto: suggestionLists[index].profilePhoto,
            name: suggestionLists[index].name,
            username: suggestionLists[index].username,
            state: suggestionLists[index].state,
            status: suggestionLists[index].status,
          );
          return CustomTile(
            mini: false,
            leading: CircleAvatar(backgroundImage: NetworkImage(searchUser.profilePhoto),backgroundColor: Colors.grey,), 
            title: Text(searchUser.username,style: TextStyle(color: UniversalVariables.greyColor),), 
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context)=> ChatsScreen(
                  receiverUserModel: searchUser,
                )
              ));
            },

          );
        })
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()=> Navigator.pop(context),
        ),
        elevation: 0.0,
        bottom: PreferredSize(
          child: Padding(
            padding:  EdgeInsets.only(left: 20.0),
            child: TextField(
              controller: searchController,
              onChanged: (val){
                setState(() {
                  query= val;
                });
              },
              cursorColor: UniversalVariables.blackColor,
              autofocus: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20.0,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: Icon(Icons.close, color: Colors.white),
                  onPressed: (){
                    /// searchController.clear();
                    WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
                  },
                ),
                border: InputBorder.none,
                hintText: 'Search'
              ),
              ),
            ),
             preferredSize: const Size.fromHeight(kToolbarHeight),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: buildSuggestions(query),
        ),
    );
  }
}
