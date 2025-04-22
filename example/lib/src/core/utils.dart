// coverage:ignore-file

abstract class Utils {
  static bool isUnitTest = false;

  static Future<void> delay([int milliseconds = 1000]) =>
      Future.delayed(Duration(milliseconds: isUnitTest ? 10 : milliseconds));
}
