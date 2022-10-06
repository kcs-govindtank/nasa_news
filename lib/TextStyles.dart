
import 'package:flutter/material.dart';

class TextStyles{

  static TextStyle? descriptionText(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400);
  }

  static TextStyle? homeTitleText(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis);
  }

  static TextStyle? homeDescriptionText(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis);
  }

  static TextStyle? headerText(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.w800);
  }

}