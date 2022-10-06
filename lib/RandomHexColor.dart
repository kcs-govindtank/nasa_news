
import 'dart:math';
import 'dart:ui';

class RandomHexColor {
  static const Color one = Color(0xff239802);
  static const Color two = Color(0xfff30a0a);
  static const Color three = Color(0xff0944ff);
  static const Color four = Color(0xffd014fc);
  static const Color five = Color(0xffff7500);
  static const Color six = Color(0xff03b6b6);
  static const Color seven = Color(0xff600bfa);
  static const Color eight = Color(0xffa94803);
  static const Color nine = Color(0xff85d203);
  static const Color ten = Color(0xff9a7900);

  List<Color> hexColor = [one, two, three, four, five, six, seven, eight, nine, ten];

  static final _random = Random();

  Color colorRandom() {
    return hexColor[_random.nextInt(10)];
  }
}