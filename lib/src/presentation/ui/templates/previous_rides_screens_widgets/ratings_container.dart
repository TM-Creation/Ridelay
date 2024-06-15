import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/material.dart';

Widget ratingsContainer(double size, int selectedIndex) {
  return Row(
    children: List.generate(5, (index) {
      return Icon(Icons.star, size: size, color: Colors.white);
    }),
  );
}

