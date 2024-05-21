/// email : "fasjk@gmail.com"
/// password : "22"

class Passangerloginmodel {
  Passangerloginmodel({
    String? email,
    String? password,
  }) {
    _email = email;
    _password = password;
  }

  Passangerloginmodel.fromJson(dynamic json) {
    _email = json['email'];
    _password = json['password'];
  }

  String? _email;
  String? _password;

  Passangerloginmodel copyWith({
    String? email,
    String? password,
  }) =>
      Passangerloginmodel(
        email: email ?? _email,
        password: password ?? _password,
      );

  String? get email => _email;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }
}
