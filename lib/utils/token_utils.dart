// import 'package:flutter/material.dart';

class TokenUtils {
  static int functionToDevelop(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

}
