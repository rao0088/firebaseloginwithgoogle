import 'package:cloud_firestore/cloud_firestore.dart';
class User{
  String _id;
  String _name;
  String _phone;
  String _address;
  String _photourl;

  // construster for  adding data

  User(this._name,this._phone,this._address,this._photourl);

  // construster for  Editing  data

  User.withId(this._id,this._name,this._phone,this._address,this._photourl);

  //getter  for data getting

  String get id => this._id;
  String get name => this._name;
  String get phone => this._phone;
  String get address => this._address;
  String get photourl => this._photourl;

  // setters

 set name(String name){
  this._name = name;
  }

  set phone(String phone){
    this._phone = phone;
  }

  set address(String address){
    this._address = address;
  }

  set photourl(String photourl){
    this._photourl = photourl;
  }



   User.fromDocument(DocumentSnapshot doc){

      this._id = doc['id'];
      this._name=doc['name'];
      this._phone=doc['phone'];
      this._address= doc['address'];
      this._photourl= doc['photourl'];

  }

  Map<String, dynamic> toJson(){
   return{
     "name": _name,
     "phone":_phone,
     "address":_address,
     "photourl":_photourl
   };

  }


}