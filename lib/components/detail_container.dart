import 'package:flutter/material.dart';

import 'box_container.dart';

class DetailContainer extends StatelessWidget {
  final List<Widget> children;
  const DetailContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((child) => BoxContainer(child: Column(
        children: [
          child,
        ],
      ))).toList(),
    );
  }
}
