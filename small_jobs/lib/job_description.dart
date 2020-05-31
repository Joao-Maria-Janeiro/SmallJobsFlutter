import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:small_jobs/pending_users.dart';
import 'package:slider_button/slider_button.dart';


List data = [];
String token;
int id;
int whereFrom;
String publisher;

class JobDescriptionScreen extends StatefulWidget {
  final int whereFrom;
  final String token;
  final int id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final double payment;
  final String location;
  final String phone;
  final String publisher;

  JobDescriptionScreen({
    Key key,
    this.whereFrom,
    this.token,
    this.id,
    this.description,
    this.title,
    this.payment,
    this.startDate,
    this.startTime,
    this.endTime,
    this.endDate,
    this.phone,
    this.publisher,
    this.location,
  }) : super(key: key);

  @override
  _JobDescriptionScreenState createState() => new _JobDescriptionScreenState();
}

class _JobDescriptionScreenState extends State<JobDescriptionScreen> {
  Future<String> getData() async {
    var res = await http.post(
        Uri.encodeFull(
            "https://small-jobs-rest.herokuapp.com/jobs/get-all-job-qeued-users"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + widget.token
        },
        body: jsonEncode({"id": widget.id}));
    setState(() {
      var resBody = json.decode(res.body);
      data = resBody;
      print(resBody);
    });
  }

  @override
  void initState() {
    super.initState();
    token = widget.token;
    id = widget.id;
    whereFrom = widget.whereFrom;
    publisher = widget.publisher;
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Small jobs"), backgroundColor: Color(0xff00555a)),
      body: ListView(children: [
//            ImageBanner("assets/images/aaa.jpg"),
        CreateTitle("Title:", widget.title),
        TextSection("Description:", widget.description),
        TextSection("Start Date:", widget.startDate + " : " + widget.startTime),
        TextSection("End Date:", widget.endDate + " : " + widget.endTime),
        TextSection("Payment:", widget.payment.toString()),
        TextSection("Location:", widget.location),
        TextSection("Published by:", widget.publisher),
        TextSection("Phone Number:", widget.phone),
        SizedBox(height: 20),
        CreateButton(),
      ]),
    );
  }
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final int notificationCount;

  const NamedIcon({
    Key key,
    this.onTap,
    @required this.text,
    @required this.iconData,
    this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(iconData),
                Text(text, overflow: TextOverflow.ellipsis),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text('$notificationCount'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (whereFrom == 0) {
      return Row(
        children: <Widget>[
          NamedIcon(
            iconData: Icons.notifications,
            text: "Pending",
            notificationCount: data.length,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder:
                      (BuildContext context) {
                    return new PendingUsersScreen(
                      token: token,
                      users: data,
                      id: id,
                    );
                  }));
            },
          ),
          InkWell(
            child: Icon(Icons.edit),
            onTap: () {},
          )
          /*RaisedButton(
              child: Icon(Icons.edit),
              padding: EdgeInsets.all(),
              onPressed: () {

              },
            ),*/
        ],
      );
        //title: Text('Notifications'),
    } else if (whereFrom == 1) {
      return Center(child: SliderButton(
        vibrationFlag: false,
        action: () {
          print("\nActivated\n");
          ///Do something here
          acceptJob();
          _showDialog(context);
        },
        label: Text(
          "Slide to Accept",
          style: TextStyle(
              color: Colors.lightGreen, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        icon: Text(
          "",
          style: TextStyle(
            color: Colors.lightGreen,
            fontWeight: FontWeight.w400,
            fontSize: 44,
          ),
        ),
        buttonColor: Colors.white,
        backgroundColor: Colors.lightGreen,
        /*highlightedColor: Colors.white,
        baseColor: Colors.red,*/

      ));
    } else if (whereFrom == 2) {
      return RaisedButton(
        child: Text('Accept'),
        onPressed: () {},
      );
    }
  }

  void acceptJob() async{
    print("\n\nChegou aqui\n\n");
    var res = await http.post(
        Uri.encodeFull(
            "https://small-jobs-rest.herokuapp.com/jobs/employee-accept-job"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + token
        },
        body: jsonEncode({"id": id}));
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text(publisher + " is reviewing your request"),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

class CreateTitle extends StatelessWidget {
  final String _title;
  final String _body;
  static const double _hPad = 16.0;

  CreateTitle(this._title, this._body);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(_hPad, 10.0, _hPad, _hPad),
              child: Text(_body, style: TextStyle(fontSize: 25.0))),
        ]);
  }
}

class TextSection extends StatelessWidget {
  final String _title;
  final String _body;
  static const double _hPad = 12.0;

  TextSection(this._title, this._body);

  @override
  Widget build(BuildContext context) {
    return Flexible(child: Row(mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(_hPad, 10.0, _hPad, 2.0),
            child: Text(_title, style: TextStyle(fontSize: 20.0)),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(_hPad, 10.0, _hPad, 2.0),
              child: Text(_body)),
        ]));
  }
}
