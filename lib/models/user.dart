import 'dart:convert';

class UserCustomer {
  final String id;
  final String blockStatus;
  final String email;
  final String password;
  final String name;
  final String phone;
  final String photo;
  final String type;
  final String token;
  final String idf;

  UserCustomer({
    required this.id,
    required this.blockStatus,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.photo,
    required this.type,
    required this.token,
    required this.idf,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'blockStatus': blockStatus,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'photo': photo,
      'type': type,
      'token': token,
      'idf': idf,
    };
  }

  factory UserCustomer.fromMap(Map<String, dynamic> map) {
    return UserCustomer(
      id: map['_id'] ?? '',
      blockStatus: map['blockStatus'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      photo: map['photo'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      idf: map['idf'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCustomer.fromJson(String source) =>
      UserCustomer.fromMap(json.decode(source));

  UserCustomer copyWith(
      {String? id,
      String? blockStatus,
      String? email,
      String? password,
      String? name,
      String? phone,
      String? photo,
      String? type,
      String? token,
      String? idf}) {
    return UserCustomer(
      id: id ?? this.id,
      blockStatus: blockStatus ?? this.blockStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      type: type ?? this.type,
      token: token ?? this.token,
      idf: idf ?? this.idf,
    );
  }
}
