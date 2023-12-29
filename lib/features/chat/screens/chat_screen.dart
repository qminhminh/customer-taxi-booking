// ignore_for_file: avoid_print, unused_field, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:customer_taxi_booking_app/common/widgets/loader.dart';
import 'package:customer_taxi_booking_app/features/chat/services/chat_services.dart';
import 'package:customer_taxi_booking_app/features/chat/widgets/message_card.dart';
import 'package:customer_taxi_booking_app/models/message_model.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:customer_taxi_booking_app/socketio/socket_client.dart';
import 'package:customer_taxi_booking_app/socketio/socket_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.name,
    required this.image,
    required this.id,
  }) : super(key: key);

  final String name;
  final String image;
  final String id;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();
  final _socketClient = SocketClient.internal.socket!;
  Socket get socketClient => _socketClient;
  List<Message>? _list;
  final ChatServices chatServices = ChatServices();
  final StreamController<List<Message>> _messageStreamController =
      StreamController<List<Message>>();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    _messageStreamController.close();
  }

  fecthAllMessage() async {
    _list = await chatServices.getListMessages(context, widget.id);
    _messageStreamController.add(_list!);
  }

  @override
  void initState() {
    super.initState();
    fecthAllMessage();
    _setupSocketListeners();
  }

  _setupSocketListeners() {
    // Listen to the "feedbackserver" event
    socketClient.on('feedbackserver', (data) {
      print('Received feedback from server: $data');
      _refreshMessages();
    });
  }

  Future<void> _refreshMessages() async {
    _list = await chatServices.getListMessages(context, widget.id);
    _messageStreamController.add(_list!);
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            await _refreshMessages();
          },
          child: ClipOval(
            child: Image.network(
              widget.image == ''
                  ? "https://firebasestorage.googleapis.com/v0/b/taxi-booking-acb4b.appspot.com/o/Images%2Favatar.png?alt=media&token=fcd3d7f8-6915-440b-a617-d258e8a3fd15"
                  : widget.image,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.id,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      body: _buildSocketListener(userprovider.user.id),
    );
  }

  Widget _buildSocketListener(String proid) {
    return SocketListener(
      onReceive: (data) {
        print('Received feedback from server inside SocketListener: $data');
        _refreshMessages();
      },
      child: RefreshIndicator(
        onRefresh: _refreshMessages,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _messageStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message>? messages = snapshot.data;
                    return _buildMessageList(messages);
                  } else {
                    return const Loader();
                  }
                },
              ),
            ),
            _buildInputArea(proid),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List<Message>? messages) {
    return _list == null
        ? const Loader()
        : _list!.isEmpty
            ? const Center(child: Text('No messages available'))
            : ListView.builder(
                itemCount: _list!.length,
                reverse: true,
                padding: const EdgeInsets.only(top: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, intdex) {
                  return MessageCard(
                    message: _list![intdex],
                  );
                },
              );
  }

  Widget _buildInputArea(String userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {},
                      decoration: const InputDecoration(
                        hintText: 'Type...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              _sendMessage(userId);
            },
            minWidth: 0,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 5,
              left: 10,
            ),
            shape: const CircleBorder(),
            color: Colors.lightBlueAccent,
            child: const Icon(
              Icons.send,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String userId) async {
    if (textController.text.isNotEmpty) {
      _socketMethods.createRoomChat(
        textController.text,
        userId,
        widget.id,
      );

      // Không cần _refreshMessages() ở đây vì đã có lắng nghe sự kiện feedbackserver

      textController.text = '';
    }
  }
}

class SocketListener extends StatefulWidget {
  final Widget child;
  final void Function(dynamic data) onReceive;

  const SocketListener({Key? key, required this.child, required this.onReceive})
      : super(key: key);

  @override
  _SocketListenerState createState() => _SocketListenerState();
}

class _SocketListenerState extends State<SocketListener> {
  late final SocketMethods _socketMethods;

  @override
  void initState() {
    super.initState();
    _socketMethods = SocketMethods();
    _setupSocketListeners();
  }

  _setupSocketListeners() {
    final _socketClient = SocketClient.internal.socket;

    if (_socketClient != null) {
      _socketClient.on('feedbackserver', (data) {
        widget.onReceive(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
