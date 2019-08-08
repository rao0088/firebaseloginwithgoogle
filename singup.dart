import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SingUp extends StatefulWidget {
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey <FormState> _formkey =GlobalKey<FormState>();

  String _name,_email,_password;

  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user){
      if(user!=null){
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }
navigatorToSign(){

    Navigator.pushReplacementNamed(context, "/LoginPage");
}
  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  showError(String errorMessage){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error Message'),
            content: Text(errorMessage),
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

  singUp() async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
      try{
//        FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = (await _auth.
        createUserWithEmailAndPassword(email: _email, password: _password))
            .user;
        if(user != null) {

          UserUpdateInfo updateInfo =UserUpdateInfo();
          updateInfo.displayName=_name;
          user.updateProfile(updateInfo);

        }

      }catch(e){
        showError(e.message);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SingUp Page'),
      ),
      body:  Container(
        child: Center(
          child: ListView(
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:EdgeInsets.only(top:20.0),
                        child: TextFormField(
                          validator:(input){
                            if(input.isEmpty){
                              return'Name';
                            }

                          },
                          decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          onSaved: (input)=>_name =input,
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(top:20.0),
                        child: TextFormField(
                          validator:(input){
                            if(input.isEmpty){
                              return'Email Feild Required';
                            }

                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          onSaved: (input)=>_email=input,
                        ),
                      ),

                      Container(
                        padding:EdgeInsets.only(top:20.0),
                        child: TextFormField(
                          validator:(input){
                            if(input.length<6){
                              return'password sould be Lenth 6 Digit';
                            }

                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          onSaved: (input)=>_password=input,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:20.0),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(100.0,20.0,100.0,20.0),
                          color: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          onPressed: singUp,
                          child: Text('Sign Up',style: TextStyle(
                              color: Colors.white
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
