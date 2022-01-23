    import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
    
    
    class SendEmail extends StatefulWidget {
      @override
      SendEmailState createState() => SendEmailState();

    }

    class SendEmailState extends State<SendEmail>{
      final controllerTo = TextEditingController();
      final controllerSubject = TextEditingController();
      final controllerMessage = TextEditingController();
    @override
      // noSuchMethod(Invocation invocation) {
      //   return super.noSuchMethod(invocation);
      // }
    @override
    Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: Text("Send Email"),
          centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(title: "To", controller: controllerTo),
            const SizedBox(height: 16),
            buildTextField(title: "Subject", controller: controllerSubject),
            const SizedBox(height: 16),
            buildTextField(
              title: "Message", 
              controller: controllerMessage,
              maxLines: 8
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text("SEND"),
              onPressed: () => launchEmail(
                toEmail: controllerTo.text,
                subject: controllerSubject.text,
                message: controllerMessage.text,
              ),
            )
          ],
        ),
      ),
    );

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final url = 
          'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else{
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );

}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'sarpkanozcan77@gmail.com',
  query: encodeQueryParameters(<String, String>{
    'subject': 'Example Subject & Symbols are allowed!'
  }),
);

// launch(emailLaunchUri.toString());    
