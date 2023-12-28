// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:customer_taxi_booking_app/constants/error_handing.dart';
import 'package:customer_taxi_booking_app/constants/global_variables.dart';
import 'package:customer_taxi_booking_app/constants/utils.dart';
import 'package:customer_taxi_booking_app/models/message_model.dart';
import 'package:customer_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatServices {
  Future<List<Message>> getListMessages(
      BuildContext context, String toId) async {
    List<Message> list = [];

    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('$uri/api/chat/messages'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
        body: jsonEncode({
          'idcus': userprovider.user.id,
          'iddriver': toId,
        }),
      );

      if (res.statusCode == 200) {
        final decodedData = jsonDecode(res.body);
        if (decodedData is Map<String, dynamic>) {
          final chatObject = Message.fromJson(jsonEncode(decodedData));
          list.add(chatObject);
        } else {
          // In ra thông báo lỗi nếu dữ liệu phản hồi không phải là một đối tượng.
          print('Dữ liệu phản hồi không phải là một đối tượng: $decodedData');
        }
      } else {
        // Xử lý lỗi HTTP status code khác 200 ở đây
        print('Mã trạng thái Phản hồi HTTP: ${res.statusCode}');
      }
      print('HTTP Response Status Code: ${res.statusCode}');
      print('HTTP Response Body: ${res.body}');
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
    return list;
  }

  static String getConversationID(String id1, String id2) {
    String smallerID = id1.hashCode <= id2.hashCode ? id1 : id2;
    String largerID = id1.hashCode <= id2.hashCode ? id2 : id1;
    return '${largerID}_$smallerID'; // Sử dụng một định dạng tùy chọn cho chatId
  }

  // update mess in chat
  void updateMessageMsg({
    required String toId,
    required String sent,
    required String msg,
    required BuildContext context,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.put(
        Uri.parse('$uri/api/chat/messages/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
        body: jsonEncode({
          'idcus': userprovider.user.id,
          'iddriver': toId,
          'sent': sent,
          'msg': msg,
        }),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'update read success');
            print(res);
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  // dleete mess in chat
  void deleteMessage({
    required BuildContext context,
    required String toId,
    required String sent,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.delete(
        Uri.parse('$uri/api/chat/message/delete'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
        body: jsonEncode({
          'idcus': userprovider.user.id,
          'iddriver': toId,
          'sent': sent,
        }),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Delete message successful!');
            Navigator.pop(context);
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }
}
