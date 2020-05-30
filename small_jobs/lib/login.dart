import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:small_jobs/signup.dart';

import 'homeScreen.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _isLoading;
  String _errorMessage;
  int _textUndeline = 0xFFF9F8FC;

  String firstname;
  String lastname;
  String email;
  String age;
  String phone;
  String description;
  List<String> skills = [];


  void login() async {
    try {
      var res = await http.post(Uri.encodeFull('https://small-jobs-rest.herokuapp.com/users/login'), headers: {"Accept": "application/json"}, body: jsonEncode({"email": emailController.text, "password": passController.text}));
      setState(() {
        var resBody = json.decode(res.body);
        debugPrint(resBody.toString());
        firstname = resBody["first_name"];
        lastname = resBody["last_name"];
        email = resBody["email"];
        /*age = resBody["age"];
        phone = resBody["phone_number"];
        description = resBody["description"];*/
        //skills = resBody["skills"];*/

      });
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (
              BuildContext context) =>
          new HomeScreen(
            first_name: this.firstname,
            last_name: this.lastname,
            email: this.email,
            /*age: this.age,
            phone: this.phone,
            description: this.description,*/
            //skills: skills,
          )
          )
      );
    } catch(error) {
      debugPrint("LOGIN FAILED\n");
    }

  }


  // Check if form is valid before perform login or signup
  bool validateForm() {
    if (emailController.text != null && passController.text != null) {
      if (emailController.text != "" && passController.text != "") {
        return true;
      }
    }
    return false;
  }

  void validateAndSubmit() {

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
            backgroundColor: Colors.white,
          ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00555a),
      body: Stack(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              //showErrorMessage(),
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2 - 120.0,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/covid.png'),
                        fit: BoxFit.contain)),
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2 + 90.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0))),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 30.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2D2F37)),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 20.0),
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.5,
                              color: Color(0xFFA2A3B1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff00555a), width: 3.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(_textUndeline), width: 3.0)),
                        ),
                        validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                        controller: emailController,
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 20.0),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.5,
                              color: Color(0xFFA2A3B1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff00555a), width: 3.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(_textUndeline), width: 3.0)),
                        ),
                        validator: (value) =>
                        value.isEmpty ? 'Email can\'t be empty' : null,
                        controller: passController,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(),
                                FloatingActionButton(
                                  onPressed: () {
                                    if (validateForm()) {
                                      login();
                                    } else {
                                      setState(() {
                                        _textUndeline =
                                            Color
                                                .fromRGBO(255, 0, 0, 1)
                                                .hashCode;
                                      });
                                    }
                                  },
                                  backgroundColor: Color(0xff00555a),
                                  child: Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<Null>(builder:
                                                (BuildContext context) {
                                              return new SignUpScreen();
                                            }));
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFA2A4B1),
                                            decoration:
                                            TextDecoration.underline),
                                      ),
                                    ),
                                    Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFA2A3B1),
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          //showCircularProgress(),
        ],
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      _isLoading = false;
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
            height: 2.0,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
