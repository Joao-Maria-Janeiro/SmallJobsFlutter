import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:small_jobs/job_description.dart';

class MyJobsScreen extends StatefulWidget {

  final String token;

  MyJobsScreen({Key key, this.token}) : super(key: key);

  @override
  _MyJobsScreenState createState() => new _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  List data = [];

  Future<String> getData() async {
    var res = await http.get(
        Uri.encodeFull(
            "https://small-jobs-rest.herokuapp.com/users/my-created-jobs"),
            headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + widget.token
        });
        setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      print(resBody);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }


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
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return new JobDescriptionScreen(
                                    token: widget.token,
                                    whereFrom: 0,
                                    id: data[index]["id"],
                                    title: data[index]["title"],
                                    description: data[index]["description"],
                                    endDate: data[index]["end_date"],
                                    endTime: data[index]["end_time"],
                                    location: data[index]["location"],
                                    payment: data[index]["payment"],
                                    phone: data[index]["phone_number"],
                                    publisher: data[index]["employer"],
                                    startDate: data[index]["start_date"],
                                    startTime: data[index]["start_time"],
                                  );
                                })),
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
                                          Text(data[index]["title"],
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: 16.0,
                                                  fontFamily: "Montserrat-Bold",
                                                  color:Color(0xFF2a2d3f))),
                                          SizedBox(
                                            height: 24.0,
                                          ),
                                          Text(data[index]["payment"].toString(),
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontSize: 12.0,
                                                  fontFamily: "Montserrat-Medium",
                                                  color: Color(0xFF2a2d3f))),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Text("Start: " + data[index]["start_date"] + "\nEnd: " + data[index]["end_date"],
                                                style: TextStyle(
                                                    letterSpacing: 1.5,
                                                    fontSize: 22.0,
                                                    fontFamily: "Montserrat-Bold",
                                                    color: Color(0xFF2a2d3f))),
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

}
