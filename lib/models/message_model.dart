import 'dart:convert';

class Message {
  final String objectid;
  final String id;
  final List<dynamic> chats;

  Message({
    required this.objectid,
    required this.id,
    required this.chats,
  });

  Map<String, dynamic> toMap() {
    return {
      'chats': chats,
      'objectid': objectid,
      'id': id,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      chats: List<Map<String, dynamic>>.from(
        map['chats']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      objectid: map['_id'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  Message copyWith({
    List<dynamic>? chats,
    String? objectid,
    String? id,
  }) {
    return Message(
      chats: chats ?? this.chats,
      objectid: objectid ?? this.objectid,
      id: id ?? this.id,
    );
  }
}
