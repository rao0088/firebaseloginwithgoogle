import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:rentalapp/modal/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
class EditUser extends StatefulWidget {
  final String id;
  final String datacol;
  EditUser(this.id,this.datacol);

  @override
  _EditUserState createState() => _EditUserState(id,datacol);
}

class _EditUserState extends State<EditUser> {

  String id , datacol;
  var downloadUrl;
  final databaseReference = Firestore.instance;

  bool isLoading = true;
  User _user;
  _EditUserState(this.id, this.datacol);

  getUser(id,datacol) async{
    databaseReference.collection(datacol).document(id).get().then((datasnapshot){


        _user =User.fromDocument(datasnapshot);

        _edname.text=_user.name;
        _edphone.text=_user.phone;
        _edaddress.text=_user.address;
        //_edphotourl.text=_user.photourl;

        setState(() {
          _name = _user.name;
          _phone = _user.phone;
          _address=_user.address;
          _photourl=_user.photourl;
          isLoading = false;
        });

    });
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
        _photourl = downloadUrl;
      }

    });

  }

  navigatetolastscreen(BuildContext context){
    //Navigator.of(Context).pop();
    Navigator.of(context).pop();
  }

  // update contact

  updateUser( BuildContext context) async{

    if(_name.isNotEmpty&&_phone.isNotEmpty&&_address.isNotEmpty){
      User userdata = User.withId(this.id, this._name, this._phone, this._address, this._photourl);
      await databaseReference.collection(datacol).document(id).updateData(userdata.toJson());
      navigatetolastscreen(context);
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

  String _name="";
  String _phone="";
  String _address="";
  String  _photourl;

  TextEditingController _edname =TextEditingController();
  TextEditingController _edphone =TextEditingController();
  TextEditingController _edaddress =TextEditingController();
  //TextEditingController _edphotourl =TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser(id,datacol);
    //print("this is $datacol" );
    //print("this is $id" );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              //image view
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      this.pickImage();
                    },
                    child: Center(
                      child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: _photourl == "empty"
                                    ? AssetImage("assets/256.png")
                                    : NetworkImage(_photourl),
                              ))),
                    ),
                  )),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  controller: _edname,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  controller: _edphone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              //
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  controller: _edaddress,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              // update button
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                  onPressed: () {
                    updateUser(context);
                  },
                  color: Colors.red,
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
