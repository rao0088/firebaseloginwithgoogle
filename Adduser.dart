import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:rentalapp/modal/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  FirebaseUser userauth;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final databaseReference = Firestore.instance;
  String name,phone,address,photourl="empty";
  var downloadUrl;

  
  saveUser(BuildContext context) async{
    if(name.isNotEmpty&&phone.isNotEmpty&&address.isNotEmpty){

      User data = User(this.name,this.phone,this.address,this.photourl);

      await databaseReference.collection(userauth.email).document()
          .setData(data.toJson());
      navigateToLastScreen(context);

    }else{
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Error Message'),
              content: Text("All Feild Are Required"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

  navigateToLastScreen(context){

    Navigator.of(context).pop();

  }


  Future pickImage() async {

    File file = await ImagePicker.pickImage(
        source: ImageSource.camera,
      maxHeight: 300.0,
      maxWidth: 350.0
    );
    String filename = basename(file.path);

    uploadImage( file,filename);
  }

  void uploadImage(File file,String filename) async{

    StorageReference storageReference = FirebaseStorage.instance.ref().child(filename);

    storageReference.putFile(file).onComplete.then((firebaseFile) async{

      downloadUrl = await firebaseFile.ref.getDownloadURL();

    });
    setState(() {
      if(downloadUrl!=null) {
        photourl = downloadUrl;
      }

    });

  }


  getUser() async{
    FirebaseUser firebaseUser =await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser !=null){
      setState(() {
        this.userauth = firebaseUser;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    this.getUser();
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Add Data'),
      ),
      body: ListView(
        children: <Widget>[
          Container(

            margin:EdgeInsets.only(top: 20.0),
            child: GestureDetector(
              onTap: (){
                this.pickImage();
              },
              child: Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: photourl =='empty' ? AssetImage("assets/256.png") : NetworkImage(photourl),
                    ),
                  ),
                ),
              ),
            ),
            
          ),

          // AddName

          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  name = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
// phone number
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  phone = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
//   address
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  address = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),

       // Save button

       Container(
         padding: EdgeInsets.only(top: 20.0),
         child: RaisedButton(
           padding: EdgeInsets.fromLTRB(100,20,100,20),
           onPressed: (){
             saveUser(context);
           },
           child: Text('Submit',style: TextStyle(
             fontSize: 20.0,
           ),),
         ),
       ),
        ],
      ),
      
    );
  }
}
