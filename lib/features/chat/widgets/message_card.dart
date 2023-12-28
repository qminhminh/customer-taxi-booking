import 'package:customer_taxi_booking_app/constants/utils.dart';
import 'package:customer_taxi_booking_app/features/chat/helpers/my_date_uitls.dart';
import 'package:customer_taxi_booking_app/features/chat/services/chat_services.dart';
import 'package:customer_taxi_booking_app/models/message_model.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isMe = userProvider.user.id == widget.message.chats.first['fromId'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          for (final chatItem in widget.message.chats)
            MessageBubble(
              chatItem: chatItem,
              isMe: isMe,
              id: userProvider.user.id,
              context: context,
            ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final dynamic chatItem;
  final bool isMe;
  final String id;
  final BuildContext context;

  const MessageBubble(
      {Key? key,
      required this.chatItem,
      required this.isMe,
      required this.id,
      required this.context})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final ChatServices _chatServices = ChatServices();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        _showBottomSheet(widget.chatItem, widget.id);
      },
      child: Row(
        mainAxisAlignment: widget.id == widget.chatItem['fromId']
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          widget.id == widget.chatItem['fromId']
              ? _greenMessage()
              : _blueMessage(),
          const SizedBox(width: 4),
          Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.chatItem['sent']),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightGreen,
          ),
          color: Colors.green.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Text(
          widget.chatItem['msg'],
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _blueMessage() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlue,
          ),
          color: Colors.blue.shade50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Text(
          widget.chatItem['msg'],
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ),
    );
  }

  void _showBottomSheet(dynamic chatItem, String id) {
    showModalBottomSheet(
        context: widget.context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              _OpionItem(
                  icon: const Icon(
                    Icons.copy_all_rounded,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Copy Text',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: chatItem['msg']))
                        .then((value) {
                      Navigator.pop(widget.context);
                    });
                  }),
              const Divider(
                color: Colors.black54,
                endIndent: 4,
                indent: 4,
              ),
              if (id == chatItem['fromId'])
                _OpionItem(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTap: () {
                      Navigator.pop(widget.context);

                      _showMessageUpdate(chatItem, widget.id);
                    }),
              if (id == chatItem['fromId'])
                _OpionItem(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: 'Delete Messgase',
                  onTap: () {
                    _chatServices.deleteMessage(
                        context: context,
                        toId: chatItem['toId'],
                        sent: chatItem['sent']);
                  },
                ),
              if (id == chatItem['fromId'])
                const Divider(
                  color: Colors.black54,
                  endIndent: 4,
                  indent: 4,
                ),
              _OpionItem(
                  icon: const Icon(
                    Icons.access_time,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name:
                      'Send at: ${MyDateUtil.getMessgaeTime(context: widget.context, time: chatItem['sent'])}',
                  onTap: () {}),
              _OpionItem(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: chatItem['read'].isEmpty
                      ? 'Read at: Not seen yet'
                      : 'Read at: ${MyDateUtil.getMessgaeTime(context: widget.context, time: chatItem['read'])}',
                  onTap: () {}),
            ],
          );
        });
  }

  void _showMessageUpdate(dynamic chatItem, String id) {
    String msgchange = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 28,
            ),
            Text('  Update Message')
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (val) {
            setState(() {
              msgchange = val;
            });
          },
          initialValue: chatItem['msg'],
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancle',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          MaterialButton(
            onPressed: () {
              _chatServices.updateMessageMsg(
                  toId: chatItem['toId'],
                  sent: chatItem['sent'],
                  msg: msgchange,
                  context: context);
              showSnackBar(context, 'Update $msgchange successfull!');
              Navigator.pop(context);
            },
            child: const Text(
              'Update',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}

class _OpionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OpionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 15, bottom: 25),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                fontSize: 15,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
