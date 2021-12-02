import 'package:flutter/material.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';

class PostViewWidget extends StatefulWidget {
  const PostViewWidget({Key? key}) : super(key: key);

  @override
  _PostViewWidgetState createState() => _PostViewWidgetState();
}

class _PostViewWidgetState extends State<PostViewWidget> {
  final TextUtils _textUtils = TextUtils();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/logo.png",
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    _textUtils.bold16("@mercedesmediaofficial", Colors.white)
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/f1.jpg",
            height: 300,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/like.png",
                      color: Colors.white,
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Image.asset(
                        "assets/icons/comment.png",
                        color: Colors.white,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/icons/save.png",
                  color: Colors.white,
                  width: 25,
                  height: 25,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _textUtils.bold14("@mercedesmediaofficial", Colors.white),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _textUtils.normal14(
                        "Let's celebrate our success!", Colors.white),
                    const SizedBox(
                      width: 10,
                      height: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _textUtils.normal14("View all 6 comments", Colors.grey),
                const SizedBox(
                  height: 5,
                ),
                Row()
              ],
            ),
          )
        ],
      ),
    );
  }
}
