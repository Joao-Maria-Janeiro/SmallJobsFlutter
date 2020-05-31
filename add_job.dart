import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:small_jobs/add_job_description.dart';

class AddJobScreen extends StatefulWidget {

  final String token;

  AddJobScreen({Key key, this.token}) : super(key: key);


  @override
  _AddJobScreenState createState() => new _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final jobController = TextEditingController();
  final descriptionController = TextEditingController();
  final paymentController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();


  bool _isLoading;
  String _errorMessage;
  int _textUndeline = 0xFFF9F8FC;

  String _value = '';
  DateTime _dateStart;
  DateTime _dateEnd;
  TimeOfDay _hourStart;
  TimeOfDay _hourEnd;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Small jobs"),
            backgroundColor: Color(0xff00555a)
        ),
        body: Stack(
          children: <Widget>[
            ListView(
                shrinkWrap: true,
                children: <Widget>[
                  //showErrorMessage(),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2 + 400.0,
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
                                'Create a Job',
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
                                  labelText: 'Job Title',
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
                                value.isEmpty ? 'Title can\'t be empty' : null,
                                controller: jobController,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 20.0),
                                  labelText: 'Description',
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
                                controller: descriptionController,
                                validator: (value) =>
                                value.isEmpty ? 'Description can\'t be empty' : null,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 20.0),
                                  labelText: 'Payment',
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
                                controller: paymentController,
                                validator: (value) =>
                                value.isEmpty ? 'Payment can\'t be empty' : null,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 20.0),
                                  labelText: 'Location',
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
                                controller: locationController,
                                validator: (value) =>
                                value.isEmpty ? 'Location can\'t be empty' : null,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 20.0),
                                  labelText: 'Phone Number',
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
                                controller: phoneController,
                                validator: (value) =>
                                value.isEmpty ? 'Phone Number can\'t be empty' : null,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),

                              Text(_dateStart == null ? 'Pick the date' : _dateStart.toString() + " " + _hourStart.toString()),
                              Row(
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text('Start date'),
                                    onPressed: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: _dateStart == null ? DateTime.now() : _dateStart,
                                          firstDate: DateTime(2019),
                                          lastDate: DateTime(2021)
                                      ).then((date) {
                                        setState(() {
                                          _dateStart = date;
                                        });
                                      });
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text('Start hour'),
                                    onPressed: () {
                                      showTimePicker(
                                          initialTime: _hourStart == null ? TimeOfDay.now() : _hourStart,
                                          context: context,
                                      ).then((hour) {
                                        setState(() {
                                          _hourStart = hour;
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Text(_dateEnd == null ? 'Pick the date' : _dateEnd.toString() + " " + _hourEnd.toString()),
                              Row(
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text('End date'),
                                    onPressed: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: _dateEnd == null ? DateTime.now() : _dateEnd,
                                          firstDate: DateTime(2019),
                                          lastDate: DateTime(2021)
                                      ).then((date) {
                                        setState(() {
                                          _dateEnd = date;
                                        });
                                      });
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text('End hour'),
                                    onPressed: () {
                                      showTimePicker(
                                        initialTime: _hourEnd == null ? TimeOfDay.now() : _hourEnd,
                                        context: context,
                                      ).then((hour) {
                                        setState(() {
                                          _hourEnd = hour;
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(),
                                  FloatingActionButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return new AddJobDescriptionScreen(
                                              token: widget.token,
                                              title: jobController.text,
                                              description: descriptionController.text,
                                              payment: double.parse(paymentController.text),
                                              location: locationController.text,
                                              phone: phoneController.text,
                                              dateEnd: _dateEnd,
                                              dateStart: _dateStart,
                                              timeEnd: _hourEnd,
                                              timeStart: _hourStart,
                                            );
                                          }));
                                    },
                                    backgroundColor: Color(0xff00555a),
                                    child: Icon(Icons.arrow_forward),
                                  ),
                                ],
                              ),
                            ]
                        ),
                    ),
                  ),
                ]),
          ],
        )
    );
    //showCircularProgress(),
  }
}
