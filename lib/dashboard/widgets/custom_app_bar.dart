import 'package:flutter/material.dart';
import 'package:mobilappmercedes/config/palette.dart';
import 'package:mobilappmercedes/config/palette.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.bprimaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.power_settings_new),
        iconSize: 28.0,
        onPressed: () {},
      ),
      actions: <Widget>[],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
