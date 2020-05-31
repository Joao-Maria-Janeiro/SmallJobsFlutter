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

class PendingUsersScreen extends StatefulWidget {

  final String token;
  final List users;
  final int id;

  PendingUsersScreen({Key key, this.id, this.token, this.users}) : super(key: key);


  @override
  _PendingUsersScreenState createState() => new _PendingUsersScreenState();
}

class _PendingUsersScreenState extends State<PendingUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: height * 0.9,
                  child: ListView.builder(
                    itemCount: widget.users.length,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            height: 280.0,
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(0.0, 10.0),
                                              blurRadius: 10.0)
                                        ],
                                        border: Border.all(width: 2.0, color: Color(0xffdae3eb)),
                                        borderRadius: BorderRadius.circular(12.0)),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 18.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(22.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(widget.users[index]["first_name"] + " " + widget.users[index]["last_name"],
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: 16.0,
                                                  fontFamily: "Montserrat-Bold",
                                                  color:Color(0xFF2a2d3f))),
                                          SizedBox(
                                            height: 24.0,
                                          ),
                                          Text(widget.users[index]["userprofile"]["age"].toString(),
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: 12.0,
                                                  fontFamily: "Montserrat-Medium",
                                                  color: Color(0xFF2a2d3f))),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text("TODO RATING",
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: 12.0,
                                                  fontFamily: "Montserrat-Medium",
                                                  color: Color(0xFF2a2d3f))),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              RaisedButton(
                                                child: Text('Decline'),
                                                color: Colors.red,
                                                onPressed: () {
                                                  decline(widget.id, widget.users[index]["email"]);
                                                },
                                              ),
                                              Container(
                                                width: 50,
                                              ),
                                              RaisedButton(
                                                child: Text('Accept'),
                                                color: Colors.green,
                                                onPressed: () {
                                                  accept(widget.id, widget.users[index]["email"]);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<String> accept(int id, String email) async {
    var res = await http.post(
        Uri.encodeFull(
            "https://small-jobs-rest.herokuapp.com/jobs/employer-accept-employee"),
            headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + widget.token
        },
            body: jsonEncode({"id": id, "email": email}));
        setState(() {
      var resBody = json.decode(res.body);
      print(resBody);
    });
  }

  void decline(int id, String email) async{
    var res = await http.post(
        Uri.encodeFull(
            "https://small-jobs-rest.herokuapp.com/jobs/employer-decline-employee"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + widget.token
        },
        body: jsonEncode({"id": id, "email": email}));
    setState(() {
      var resBody = json.decode(res.body);
      print(resBody);
    });
  }
}
