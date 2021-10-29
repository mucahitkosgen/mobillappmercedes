import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("Go homapage"),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
