// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:mobilappmercedes/data/suggested_posts_model.dart';
import 'package:mobilappmercedes/utils/text_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextUtils _textUtils = TextUtils();

  List<SuggestedPostModel> suggestedPostList = [];

  @override
  void initState() {
    super.initState();

    addData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          searchBarWidget(),
          const SizedBox(
            height: 10,
          ),
          suggestedPostsWidget()
        ],
      ),
    );
  }

  Widget searchBarWidget() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF262626)),
      child: Row(),
    );
  }

  Widget suggestedPostsWidget() {
    return Column(
      children: [
        for (int i = 0; i < suggestedPostList.length; i++)
          if (suggestedPostList[i].containsVideo)
            showWithVideoWidget(i)
          else
            showWithoutVideoWidget(i)
      ],
    );
  }

  Widget showWithVideoWidget(int index) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.335,
                    height: MediaQuery.of(context).size.width * 0.335,
                    child: Image.network(
                      suggestedPostList[index].contentLink1,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.335,
                    height: MediaQuery.of(context).size.width * 0.335,
                    child: Image.network(
                      suggestedPostList[index].contentLink2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(left: 2),
                height: MediaQuery.of(context).size.width * 0.67,
                child: Image.network(
                  suggestedPostList[index].contentLink3,
                  fit: BoxFit.fill,
                ),
              )),
        ],
      ),
    );
  }

  Widget showWithoutVideoWidget(int index) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(right: 1),
              height: MediaQuery.of(context).size.width * 0.33,
              child: Image.network(
                suggestedPostList[index].contentLink1,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(right: 1, left: 1),
              height: MediaQuery.of(context).size.width * 0.33,
              child: Image.network(
                suggestedPostList[index].contentLink2,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 1),
              height: MediaQuery.of(context).size.width * 0.33,
              child: Image.network(
                suggestedPostList[index].contentLink3,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addData() {}
}
