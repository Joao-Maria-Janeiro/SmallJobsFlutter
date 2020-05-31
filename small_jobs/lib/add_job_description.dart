import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:small_jobs/return.dart';

class AddJobDescriptionScreen extends StatefulWidget {

  final String token;
  final String title;
  final double payment;
  final String description;
  final String location;
  final String phone;
  final DateTime dateStart;
  final DateTime dateEnd;
  final TimeOfDay timeStart;
  final TimeOfDay timeEnd;

  AddJobDescriptionScreen({Key key, this.token, this.description, this.title, this.payment, this.location, this.phone, this.dateStart, this.dateEnd, this.timeStart, this.timeEnd}) : super(key: key);

  @override
  _AddJobDescriptionScreenState createState() => new _AddJobDescriptionScreenState();
}

class _AddJobDescriptionScreenState extends State<AddJobDescriptionScreen> {
  Future<String> getData() async {
    print(widget.timeStart.hour.toString() + ":" +
        widget.timeStart.minute.toString());
    print(widget.dateStart.toString().split(" ")[0].trim());
    var res = await http.post(
        Uri.encodeFull("https://small-jobs-rest.herokuapp.com/jobs/create"),
        headers: {
          "Accept": "application/json",
          "Authorization":
          "Bearer " + "575f4d7708003ebe5bd5ff7c0d02aa0f230e0172"
        }, body: jsonEncode({
      "title": widget.title,
      "description": widget.description,
      "start_date": widget.dateStart.toString().split(" ")[0].trim(),
      "end_date": widget.dateEnd.toString().split(" ")[0].trim(),
      "start_time": widget.timeStart.hour.toString() + ":" +
          widget.timeStart.minute.toString(),
      "end_time": widget.timeEnd.hour.toString() + ":" +
          widget.timeEnd.minute.toString(),
      "payment": widget.payment,
      "location": widget.location,
      "phone_number": widget.phone
    }));
    setState(() {
      var resBody = res.body;
      print(resBody);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text("Nome",
                style: TextStyle(
                    fontSize: 30.0,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2D2F37))),
            Text("Descricao",
              style: TextStyle(
                  fontSize: 30.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2D2F37)),),
            RaisedButton(
              child: Text("Finalizar"),
              onPressed: () {
                getData();
                _showDialog();
              },
            ),
          ],

        )
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Successfully Created Job"),
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
