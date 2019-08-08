import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp/modal/user.dart';
import 'package:rentalapp/EditUser.dart';

class ViewUser extends StatefulWidget {
 final String id;
  final String datacol;
  ViewUser (this.id, this.datacol);
  @override
  _ViewUserState createState() => _ViewUserState(id,datacol);
}

 class _ViewUserState extends State<ViewUser> {

 String id , datacol;

  bool isLoading = true;
  _ViewUserState(this.id, this.datacol);

  final databaseReference = Firestore.instance;
  User _user;
  //var document;

  getUser(id,datacol) async{
    databaseReference.collection(datacol).document(id).get().then((datasnapshot){

      setState(() {
        _user =User.fromDocument(datasnapshot);
        isLoading = false;
      });

        });
  }

  navigatetolastscreen(){
    Navigator.of(context).pop();
  }

 navigatetoEdit(id,datacol){
   //Navigator.of(context).pop();
   Navigator.push(context, MaterialPageRoute(builder: (context) {
     return EditUser(id,datacol);
   }));
 }

  deleteuser(){
    showDialog(context: context,
      builder: (BuildContext context){
      return AlertDialog(
        title: Text('Delete'),
        content: Text('Are you Sure to Delete ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('delete'),
            onPressed: ()async{
              Navigator.of(context).pop();
              await databaseReference.collection(datacol).document(id).delete();
              navigatetolastscreen();
            },
          ),
        ],
      );

      });
  }

  @override
  void initState() {
    super.initState();
    getUser(id,datacol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          children: <Widget>[
            // header text container
            Container(
                height: 200.0,
                child: Image(
                  //
                  image: _user.photourl == "empty"
                      ? AssetImage("assets/256.png")
                      : NetworkImage(_user.photourl),
                  fit: BoxFit.contain,
                )),
            //name
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.perm_identity),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        "${_user.name}",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // phone
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _user.phone,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // email
            // address
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      Container(
                        width: 10.0,
                      ),
                      Text(
                        _user.address,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  )),
            ),
            // call and sms
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.phone),
                        color: Colors.red,
                        onPressed: () {
                          //callAction(_contact.phone);
                        },
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.message),
                        color: Colors.red,
                        onPressed: () {
                          //smsAction(_contact.phone);
                        },
                      )
                    ],
                  )),
            ),
            // edit and delete
            Card(
              elevation: 2.0,
              child: Container(
                  margin: EdgeInsets.all(20.0),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          navigatetoEdit(id,datacol);
                        },
                      ),
                      IconButton(
                        iconSize: 30.0,
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          deleteuser();
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
