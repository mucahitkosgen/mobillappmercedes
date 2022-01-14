import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobilappmercedes/dialogs/about_us.dart';
import 'package:mobilappmercedes/dialogs/policy_dialog.dart';
import 'package:mobilappmercedes/dialogs/terms_and_conditions_dialog.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF2979FF)),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 4,
        title: new Text("About"),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'privacy_policy.md',
                    );
                  },
                );
              },
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: Color(0xFF2979FF),
              ),
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF2979FF),
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TermsAndConditionsDialog(
                      mdFileName: 'terms_and_conditions.md',
                    );
                  },
                );
              },
              leading: Icon(
                Icons.plagiarism_outlined,
                color: Color(0xFF2979FF),
              ),
              title: Text(
                "Terms & Conditions",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF2979FF),
                size: 20,
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AboutUsDialog(
                      mdFileName: 'about_us.md',
                    );
                  },
                );
              },
              leading: Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF2979FF),
              ),
              title: Text(
                "About Us",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF2979FF),
                size: 20,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
              child: Image.asset(
                "assets/images/MercedesMediaAmblem.png",
                width: 150,
                height: 150,
                fit: BoxFit.fitHeight,
              ),
            )
          ],
        ),
      ),
    );
  }
}
