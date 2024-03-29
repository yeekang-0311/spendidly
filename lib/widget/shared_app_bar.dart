import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SharedAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  final bool isSettings;

  const SharedAppBar(
      {Key? key,
      required this.title,
      required this.isBackButton,
      required this.isSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromRGBO(67, 88, 110, 43),
      leading: isBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {Navigator.pop(context)},
            )
          : IconButton(
              icon: SvgPicture.asset(
                "assets/icons/menu.svg",
                height: 10,
              ),
              onPressed: () => {Scaffold.of(context).openDrawer()},
            ),
      centerTitle: true,
      title: Text(title),
      actions: [
        isSettings
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/settings/");
                },
                icon: const Icon(Icons.settings),
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
