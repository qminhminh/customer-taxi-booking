import 'dart:convert';

class User {
  final String id;
  final String blockStatus;
  final String email;
  final String password;
  final String name;
  final String phone;
  final String photo;
  final String type;
  final String token;

  User({
    required this.id,
    required this.blockStatus,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.photo,
    required this.type,
    required this.token,
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
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      blockStatus: map['blockStatus'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      photo: map['photo'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? blockStatus,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? photo,
    String? type,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      blockStatus: blockStatus ?? this.blockStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}
