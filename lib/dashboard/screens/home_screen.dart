import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobilappmercedes/config/palette.dart';
import 'package:mobilappmercedes/config/styles.dart';
import 'package:mobilappmercedes/dashboard/widgets/custom_app_bar.dart';

//import 'package:mobilappmercedes/dashboard/widgets/widgets.dart';
import 'package:mobilappmercedes/event_editing.dart';
import 'package:mobilappmercedes/event_editing_main.dart';
import 'package:mobilappmercedes/screens/main_screen.dart';
import 'package:mobilappmercedes/seconhandsale/secondhandsalemain.dart';
import 'package:mobilappmercedes/seconhandsale/secondhandsalescreen.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations.dart';
import 'package:mobilappmercedes/suggestedlocations/suggested_locations_main.dart';
import 'package:mobilappmercedes/widgets/calendar_widget/calendar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _country = 'USA';
  var userData = {};
  var firebaseUser = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  void initState() {
    getImage();

    super.initState();

    //getImage();
    // 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASQAAACsCAMAAADlsyHfAAAA9lBMVEUrtlYnMzMMp1AAi1b///8tuVr6/vwnJDAnt1UAo0Wz38OY1K8pr1MoLTIdakAAp0gSsknO7deJ0p0ftE8pf0YnLzInKTEAg0fn8OsYf0UApULX7+F3zY9pwoteq4hYwnbx+vQdKysAjFPp9esoVTsiSTtJv20piUkumm0WZkZEn3ZGUFDx8vIAiU+Vx7Gx1cUaXEIoTTkPllYWnVYJoE4oXD0pekUnQTYqnU8nODQrv1kLklYNeU8RcUvC5ss/vGWV1qcArjwnHy8nFy4oYz5MqnYqk0wqn1AeUT4IglJrr48gb0FCYVY0hWUzn20PQTF+uZ47smoRR6IPAAAIYElEQVR4nO2dC1ecRhSAEYiMDah1HUxjGg3xEW1tdF1dF5PWptZHtk3b//9nCuyyPObBBQdY3Pudk5MTBYb5lrmXO8MSTUMQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBEEQBJln1kNIs8011poier9uBxw0ZYmErW3/1lBrqui9NwMO1psibM3spqTvG6PDkm42mqLDknbWew0RSTpou9clIRsbyy9vmvtobzbMm5sXjTWniN7vywcN5uS112av11xzqlhf3mnuNknTdbO5xtTRqCRdXzG1Bj8TVaQk9V7UjB5g6sCN58llImn9vblcP9A2zDdzFLvSkt70SI3Y4YW0Yur6GmDj9e35lWTXyCDCDP7ohdtqcyzJP/ti1YzpAjb643CeJe3RpXp5Z0K2clESSkJJKAklCUFJAFASAJQEACUBQEkAUBIAlAQAJQF4oiTqupQ6Lni3RZTkDjcHmm/fXVjAHRdQkjvWSLg3IVcj2J6LJ8na9OPDEBslcaEXfnIccuWiJA7OIL3sA9t30STRMz99IHIIuZQWTZJzmV0/tC2UxPZkMycJhxuLk5eEw42F3mZj0hUONx6ZA5Gxg5I4XcmMN1uwVfaICydpydUTS/4F/0JyzjI/XzxJdHQ/DUuErPLDtjv299KWFk/SEqWXWvSkzNUZ35GzR4g9TB10ASUF3XH2xuPboWCmhI6C4xI9JXAhJQUiHIcK9qLUjiZS7hJLCypJ1te7yaH9zZmlLkuytRokWbNbBHIbW+quJKI/2uoluavJHTmJbwS6K8k2DM9WLck5y9xqTqd3uyvJMwzjmqiVREd2uhly73RbUt8I6auVlJ22DFOc1WFJu38aEwYqJVl3+Sf6/Uu3u5KWj6eStl6pk2Rd+kxLfpjiuilprQ5J7i3rKExxtKOStlKS3vbUSKJn3KZIkOJgkpwf5krSdUbSuaIryeZ/xYjcW1BJr+dHEukbGUnevgpFzr3oa1hBiuucJHJvVJIkv9zYxJZq8RIs6cc5kaQbVSTRh1PZbLZ7KXakaT0TMqAjSWuNeZBhG5UkjQxvX9xT54KX2Gb0TMm+WUm6LTtQU1xXk/QYbDsS/ZLuy9vsmTbgIZ1I0socWCKTaqSsJPdzWOk9CgYcFSW2mJ4JWZ+bStIbUiGEnBtVJDlHoSPD+8y3ZAkT25SeqfmHhZZiSS1bIgOjiiT64E029o54ltzDou9gB5I0f1y0ID6T1K4l26giiQ6NGQ9saHHH0qAdEkrSiGCNjiOp1bBkVJIUBe2YYd6Sc1H8Xf7e5A0TzL4iSW1a6leS5HxKOTIec7+lQ0DDE0nEFi2wMJJaG3Bx0C4paRq0Z3zKDBpK9eILKb6SCp6wTEtqydIsaJeT5JxmHQUpLt1T9wry4oyppIIUl5HUjiXdqCKJ7ht5vFR9YhUmtohYkiZ6eIAjqQ1LtlFJ0hLjKGBWY6TXj2TMJGlkT5zicpJaCN7XlSTRR1aRMatPnD3gS2oSSZotTnE5SY1bIv1sL4GSnM8eIyjkMeooKLFFpCSRAVhSwwMunEKqIIkJ2jGT+sSFJLaIlKR4lQkiqVFLRM/3MpB0UiiJE7RnloL6xJVMs+XaDwrcZDLN3xRYYiU1acnO9/H4ePnrcaGkYX63NA9fNmFBO2Bnx9zZSf4pSnEcSQ2GpfygOXkVvvhxci0Fkk74M2KCoB0zhr9oKv+eyXCVCSapMUv5oB1LevshxHj19dtfP/H4+4OMbwdwmDeW8qfgeJIaspSuRjKSdicEf//MY1cdjKT4QQqApEbCUqYayQ23kHC4/fOO5eFEil36ta6ZF6RyUxxfUhOWmKAdStpeDj7eSeTmB24qDdqGAU7+ISR68V/2LbLkkrUkkNSAJW4fo4vBkEhakgft83Kvg4wup9zP/FtmxIkk1R6WmKCdhyspO4XE0Ffyykwmp4ok1WyJE7QhktwjwZ32hGs152bn14SFkmodcLygDZAkrEamqDq7ewsqqU5LTDUCkkT35Y6UXfz57+9KJNVniZfYAJJG8h0GSgJSBBlbUEm1WbqW91YgqaAaKZnY5GRXmaSS6gnebDUCkiSaQpqiJrElpKfgpJJqsQRIbDxJBUFbTWJLnWV6lUkuqYYBx04hgSTNFrQFKP84yb0LlaTeEihos5KKqhHl5xmkOAsqSXnr8gtCJKkgaCtMbAnJgxSFktRaAgbtvCTnk9St0sSWOtl4lalYksrRDg3aOUn5Be0cfYVnmGWa4oolKbQEqUY4kgqCtqfs/JjznX5dFyBJ3YADB+2MpKIppBpL8emDFBBJqizZ4KCdkTQyPDGBo2r/2QQM/9CBSlJjiYCqEUYSfTiSsbpZL0OwJBWWygTtzJVEpTg1Ax5uKoI3s6ANltQ+QElPtwStRros6akDrlRiSyQ5zY4tARZU0hMtlQvasaSj0yyrLXEHlfQUSyWqkbSkrdzC4/laS6yAJVUPS2UT21TSx19yvGyPXaCkypZKVSMzTv79mOO7NvkP5qjygCsftCeWtrKstArUUVVLpaoRIQP4abZMBUVVgjaH87a7XoLyjqoEbZZ+2x0vQ9ngTQbyiVcg1233uxwlLZWuRrh4bfe6LOUkKXHUoaAdU8ZR+WrkeTgqYUlR0O5SYkuAOio7hcSnU4ktARi81QTtjiW2BJClitVInrb7Wh2IpMUN2jGFihRVI112VGhpoRNbgtyRmqDd0cSWIA3eaoK213Yfn47MkpoppLZ7qALxYMOgnYBBGwLfUaV5/2friG9pwasRFl7wVuLIa7tnKmEdqalG2u6XWjCxQcDEBiHtCKsRAangraYaeUaJLSGxpKQa8druTz2oDdpt96YuVAbt55bYEkJJWI0Uof0PYGQgEDMO/q4AAAAASUVORK5CYII=';
    //fileContentBase64 =
    // 'data:image/png;base64,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';
  }

  getImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;

      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.email)
          .get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      print("**Burada hata var");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: CustomAppBar(),
            backgroundColor: Colors.black,
            body: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
                _buildHeader(screenHeight),
                _buildPreventionTips(screenHeight),
                // _buildYourOwnTest(screenHeight),
              ],
            ),
          );
  }

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Palette.bprimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Mercedes Media',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 50,
                ),
                CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        MemoryImage(base64.decode(userData['Photo']))
                            as ImageProvider),
                Text(" ",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15.0,
                    )),
                Text(
                  userData['KullaniciAdi'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Now, You will start discover..',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EventMainScreen()));
                      },
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.add_box_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Create Event',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calendar()));
                      },
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Calendar',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPreventionTips(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'More Fun, More Yourself..',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Spacer(
                    flex: 20,
                  ),
                  FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 140.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                    color: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    icon: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Event',
                      style: Styles.buttonTextStyle,
                    ),
                    textColor: Colors.white,
                  ),
                ]),
            SizedBox(height: screenHeight * 0.03),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Spacer(
                    flex: 20,
                  ),
                  FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 94.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondHandSaleMain()));
                    },
                    color: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    icon: const Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Second Hand Sale',
                      style: Styles.buttonTextStyle,
                    ),
                    textColor: Colors.white,
                  ),
                ]),
            SizedBox(height: screenHeight * 0.03),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Spacer(
                    flex: 20,
                  ),
                  FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 84.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuggestedLocationsMain()));
                    },
                    color: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    icon: const Icon(
                      Icons.location_history,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Suggested Locations',
                      style: Styles.buttonTextStyle,
                    ),
                    textColor: Colors.white,
                  ),
                ]),
          ],
        ),
      ),
    );
  }

/*  SliverToBoxAdapter _buildYourOwnTest(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.all(10.0),
        height: screenHeight * 0.15,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAD9FE4), Palette.primaryColor],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //Image.asset('assets/images/own_test.png'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Event',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Discover Mercedes Event',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  maxLines: 2,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }*/
}
