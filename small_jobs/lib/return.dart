

import 'package:flutter/material.dart';
import 'package:small_jobs/homeScreen.dart';

class ReturnScreen extends StatefulWidget {
  @override
  _ReturnScreenState createState() => new _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          Center(
            child: Text(
              'Successfully Created Job',
              style: TextStyle(
                  fontSize: 30.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2D2F37)),
            ),
          ),
          RaisedButton(
            child: Text("Voltar ao Menu"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new HomeScreen(

                    );
                  }));
            },
          ),
        ],
      )
    );
  }

}
