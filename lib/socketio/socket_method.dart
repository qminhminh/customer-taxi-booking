import 'package:customer_taxi_booking_app/socketio/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.internal.socket!;

  Socket get socketClient => _socketClient;

  // List<Message> listmess = [];

  // create room chat client
  void createRoomChat(String message, String idcus, String iddriver) {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    if (message.isNotEmpty) {
      _socketClient.emit(
        'createRoomChat',
        {
          'message': message,
          "time": time,
          "idcus": idcus,
          "iddriver": iddriver,
        },
      );
    }
  }
}
