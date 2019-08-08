
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:rentalapp/Viewuser.dart';
import 'package:rentalapp/Adduser.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth =FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  //final usersRef = Firestore.instance.collection('users');

  navigateToAddUser(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddUser();
    }));
  }

  navigateToViewUser(id,useremail){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ViewUser(id,useremail);
    }));
  }

  FirebaseUser user;
  bool isSignedIn= false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user){
      if(user==null){
        Navigator.pushReplacementNamed(context, "/LoginPage");
      }

    });
  }

  getUser() async{
    FirebaseUser firebaseUser =await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser !=null){
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
  }

  signOut() async{
    _auth.signOut();
  }
  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: Text('Home',style: TextStyle(color: Colors.white),),
      ),

     drawer: !isSignedIn?CircularProgressIndicator()
         : Drawer(
       elevation: 3.0,
       child: ListView(
         padding: EdgeInsets.zero,
         children: <Widget>[
//           DrawerHeader(
//             child: Text('Drawer Header'),
//             decoration: BoxDecoration(
//               color:Colors.green,
//             ),
//           ),
           UserAccountsDrawerHeader(
             accountName: Text(user.displayName),
             accountEmail: Text(user.email),
             currentAccountPicture: CircleAvatar(
               backgroundColor:
               Theme.of(context).accentColor,
               child: Text(
                 user.displayName[0].toUpperCase(),
                 style: TextStyle(fontSize: 40.0),
               ),
             ),
           ),
           Container(
             //color: Theme.of(context).primaryColor,
             padding: EdgeInsets.fromLTRB(30.0,20.0,30.0,20.0),
             child: RaisedButton.icon(
               color: Theme.of(context).primaryColor,
                 onPressed: signOut, icon: Icon(Icons.account_circle), label: Text('Logout')),
           ),
         ],
       ),
     ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'ADD',
        elevation: 5.0,
        onPressed: (){
         //print('click floating');
          navigateToAddUser();
        },
        child: Icon(Icons.add_circle),
      ),
      body: !isSignedIn?CircularProgressIndicator()
          : Container(

        child: FirestoreAnimatedList(
          query: databaseReference.collection(user.email).snapshots(),
          itemBuilder: (
              BuildContext context,
              DocumentSnapshot snapshot,
              Animation<double> animation,
              int index){
            return GestureDetector(
              onTap: (){
                navigateToViewUser(snapshot.documentID,user.email);
              },
              child: Card(
                color: Colors.white,
                elevation: 3.0,
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: snapshot.data['photourl'] =='empty' ? AssetImage("assets/256.png")
                                : NetworkImage(snapshot.data['photourl']),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${snapshot.data['name']}"),
                            Text("${snapshot.data['phone']}"),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

      ),

    );
  }
}
