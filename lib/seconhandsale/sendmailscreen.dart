 import 'package:flutter/material.dart';
import 'package:mobilappmercedes/config/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmail extends StatelessWidget {
  final mail;
  SendEmail({Key? key, required this.mail}) : super(key: key);

  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

  @override
  // noSuchMethod(Invocation invocation) {
  //   return super.noSuchMethod(invocation);
  // }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Send an Email"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          // Color: Colors.black,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextFieldd(title: "To", controller: controllerTo),
              const SizedBox(height: 16),
              buildTextField(title: "Subject", controller: controllerSubject),
              const SizedBox(height: 16),
              buildTextField(
                  title: "Message", controller: controllerMessage, maxLines: 8),
              const SizedBox(height: 32),
FlatButton.icon(
                padding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 35.0,
                ),
                onPressed: () => launchEmail(
                  toEmail: mail,
                  subject: controllerSubject.text,
                  message: controllerMessage.text,
                ),
                color: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                icon: const Icon(
                  Icons.mail_outline_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  'Send',
                  style: Styles.buttonTextStyle,
                ),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      );

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    toEmail = mail;
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

//     String? encodeQueryParameters(Map<String, String> params) {
//   return params.entries
//       .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//       .join('&');
// }

// final Uri emailLaunchUri = Uri(
//   scheme: 'mailto',
//   path: 'sarpkanozcan77@gmail.com',
//   query: encodeQueryParameters(<String, String>{
//     'subject': 'Example Subject & Symbols are allowed!'
//   }),
// );
//   String gerekli = emailLaunchUri.toString();
//     if (await canLaunch(gerekli)) {
//       await launch(gerekli);
//     }
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) =>
Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextField(
            style: TextStyle(color: Colors.white),
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
              ),
            ),
          ),
        ],
      );

  Widget buildTextFieldd({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) =>
Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
              ),
              labelText: mail,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'sarpkanozcan77@gmail.com',
  query: encodeQueryParameters(
      <String, String>{'subject': 'Example Subject & Symbols are allowed!'}),
);

// launch(emailLaunchUri.toString());  
