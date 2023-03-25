import 'package:flutter/material.dart';

import '../../theme/colors/light_colors.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets padding;
  final Color warna;
  TopContainer(
      {required this.height,
      required this.width,
      required this.child,
      required this.padding,
      required this.warna});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null ? padding : EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
          color: warna,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25))),
      height: height,
      width: width,
      child: child,
    );
  }
}
