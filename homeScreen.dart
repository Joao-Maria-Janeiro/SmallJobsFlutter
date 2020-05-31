import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:small_jobs/job_description.dart';
import 'package:small_jobs/my_jobs.dart';
import 'package:small_jobs/add_job.dart';
import 'package:small_jobs/history.dart';
import 'data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {

  final String token;
  final String first_name;
  final String last_name;
  final String email;
  final String age;
  final String phone;
  final String description;
  List<String> skills = [];

  HomeScreen({Key key, this.token, this.first_name, this.last_name, this.email, this.age, this.phone, this.description}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  List data;


  Future<String> getData() async {
    var res = await http.get(
        Uri.encodeFull("https://small-jobs-rest.herokuapp.com/jobs/all"),
            headers: {"Accept": "application/json"});
        setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
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
    return new Scaffold(
        appBar: new AppBar(title: new Text("Small jobs"),
            backgroundColor: Color(0xff00555a)
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: new Text(widget.email),
                accountName: new Text(widget.first_name + " " + widget.last_name),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                      backgroundColor: Color(0xff00555a)
                  ),
                  onTap: () => print("This is your current account."),
                ),
              ),
              new ListTile(
                  title: new Text("My jobs"),
                  trailing: new Icon(Icons.history),
                  onTap: () {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (
                            BuildContext context) =>
                        new MyJobsScreen(
                          token: widget.token,
                        )
                        )
                    );
                  }
              ),
              new ListTile(
                  title: new Text("History"),
                  trailing: new Icon(Icons.history),
                  onTap: () {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (
                            BuildContext context) =>
                        new HistoryScreen(
                          token: widget.token,
                        )
                        )
                    );
                  }
              ),
              new ListTile(
                  title: new Text("Payment"),
                  trailing: new Icon(Icons.payment),
                  onTap: () {
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                title: new Text("Log out"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
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
                                    whereFrom: 1,
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
      floatingActionButton: FloatingActionButton(
        onPressed: addJob,
        tooltip: 'New Job',
        child: Icon(Icons.add),
      ),
    );
  }

  void addJob() {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddJobScreen(
            token: widget.token,
          );
        }));
  }


}
