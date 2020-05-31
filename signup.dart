import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:small_jobs/homeScreen.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();
  File _file;

  final _formKey = new GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final first_nameController = TextEditingController();
  final last_nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  String firstname;
  String lastname;
  String email;
  String age;
  String phone;
  String description;
  List<String> skills = [];

  bool _isLoginForm;
  bool _isLoading;

  File _image;

  void signup() async {
    try {
      var res = await http.post(
          Uri.encodeFull('https://small-jobs-rest.herokuapp.com/users/signup'),
          headers: {"Accept": "application/json"},
          body: jsonEncode({
            "username": usernameController.text,
            "email": emailController.text,
            "password": passController.text,
            "first_name": first_nameController.text,
            "last_name": last_nameController.text,
            "age": ageController.text,
            "phone_number": phoneController.text,
            "description": descriptionController.text,
            "skills": [
              "saltar a corda",
              "chouriço assado",
              "minetar"
            ]
          }));
      setState(() {
        var resBody = json.decode(res.body);
        debugPrint(resBody.toString());
      });
      login();
    } catch(error) {
      debugPrint("Signup FAILED\n");
    }
  }

  void login() async {
    try {
      var res = await http.post(Uri.encodeFull('https://small-jobs-rest.herokuapp.com/users/login'), headers: {"Accept": "application/json"}, body: jsonEncode({"email": emailController.text, "password": passController.text}));
      setState(() {
        var resBody = json.decode(res.body);
        debugPrint(resBody.toString());
        firstname = resBody["first_name"];
        lastname = resBody["last_name"];
        email = resBody["email"];
      });
      Navigator.of(this.context).push(
          new MaterialPageRoute(builder: (
              BuildContext context) =>
          new HomeScreen(
            first_name: this.firstname,
            last_name: this.lastname,
            email: this.email,
          )
          )
      );
    } catch(error) {
      debugPrint("LOGIN FAILED\n");
    }

  }

  @override
  void initState() {
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void resetForm() {
    _formKey.currentState.reset();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        _paths = null;
//          _path = await FilePicker.getFilePath(
//              type: _pickingType, fileExtension: _extension);
        _file = await FilePicker.getFile(type: _pickingType);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
      });
    }
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(
        strokeWidth: 4.0,
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {

    Future getImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xff00555a),
      body: Builder(
        builder: (context)=> Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                showCircularProgress(),
                Container(
                  padding: EdgeInsets.all(2.0),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2 - 120.0,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child:CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child:ClipOval(
                            child: SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image != null) ? Image.file(_image, fit: BoxFit.fill)
                                  : Image.network(
                                "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:60.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2 + 650.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 20.0),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.5,
                                      color: Color(0xFFA2A3B1)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff32a05f), width: 3.0)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF9F8FC), width: 3.0)),
                                ),
                                controller: usernameController,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 20.0),
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.5,
                                      color: Color(0xFFA2A3B1)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff00555a), width: 3.0)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF9F8FC), width: 3.0)),
                                ),
                                controller: first_nameController,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 20.0),
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                        color: Color(0xFFA2A3B1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff32a05f), width: 3.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF9F8FC), width: 3.0)),
                                  ),
                                  controller: last_nameController,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
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
                                            color: Color(0xff32a05f), width: 3.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF9F8FC), width: 3.0)),
                                  ),
                                  controller: emailController,
                                  //onSaved: (value) => _email = value
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
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
                                          color: Color(0xFFF9F8FC), width: 3.0)),
                                ),
                                controller: passController,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 20.0),
                                    labelText: 'Age',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                        color: Color(0xFFA2A3B1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff32a05f), width: 3.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF9F8FC), width: 3.0)),
                                  ),
                                  controller: ageController,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 20.0),
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                        color: Color(0xFFA2A3B1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff32a05f), width: 3.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF9F8FC), width: 3.0)),
                                  ),
                                  controller: phoneController,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 20.0),
                                    labelText: 'Describe Yourself',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                        color: Color(0xFFA2A3B1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff32a05f), width: 3.0)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF9F8FC), width: 3.0)),
                                  ),
                                  controller: descriptionController,
                              ),
                            ],
                          ),
                        ),

                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: new RaisedButton(
                            onPressed: () => _openFileExplorer(),
                            child: new Text("Open file picker"),
                          ),
                        ),


                        //TODO: insert the file picker here and save the image

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(),
                            FloatingActionButton(
                              backgroundColor: Color(0xff00555a),
                              child: Icon(Icons.arrow_forward),
                              onPressed: () async {
                                // save the fields..
                                //final form = _formKey.currentState;
                                //form.save();
                                signup();
                              },
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
