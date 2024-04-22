bool validateStructurePassword(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool validateStructureEmail(String value) {
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

bool validatePhoneNumber(String value) {
  if (value[0] != "+") {
    return false;
  }
  return true;
}
