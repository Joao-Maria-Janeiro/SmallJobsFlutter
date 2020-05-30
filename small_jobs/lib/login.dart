import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:mercury/screens/add_help.dart';
//import 'package:mercury/screens/homeScreen.dart';
//import 'package:mercury/screens/signUp.dart';

//import '../services/authentication.dart';

class LoginScreen extends StatefulWidget {
  //LoginScreen(
    //  {this.auth, this.loginCallback, this.logoutCallback, this.origin});

  /*final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;
  final String origin;*/

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _isLoading;
  String _errorMessage;
  int _textUndeline = 0xFFF9F8FC;

  // Check if form is valid before perform login or signup
  bool validateForm() {
    if (emailController.text != null && passController.text != null) {
      if (emailController.text != "" && passController.text != "") {
        return true;
      }
    }
    return false;
  }

  // Perform login or signup
  /*void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    String userId = "";
    try {
      userId = await widget.auth.signIn(emailController.text, passController.text);
      print('Signed in: $userId');
      setState(() {
        _isLoading = false;
      });

      if (userId.length > 0 && userId != null) {
        widget.loginCallback();
        if (widget.origin.compareTo("preciso_de_ajuda") == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new AddHelpScreen(
              auth: widget.auth,
              loginCallback: widget.loginCallback,
              logoutCallback: widget.logoutCallback,
            );
          }));
        } else if (widget.origin.compareTo("quero_ajudar") == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new HomeScreen(
              auth: widget.auth,
              loginCallback: widget.loginCallback,
              logoutCallback: widget.logoutCallback,
            );
          }));
        }
      }
    } catch (e) {
      print('Error: $e');
      _errorMessage = e.message;
      setState(() {
        _isLoading = true;
      });
    }
  }*/

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
                                      //validateAndSubmit();
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
                                        /*Navigator.of(context).push(
                                            MaterialPageRoute<Null>(builder:
                                                (BuildContext context) {
                                              return new SignUpScreen(
                                                auth: widget.auth,
                                                loginCallback: widget
                                                    .loginCallback,
                                              );
                                            }));*/
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
