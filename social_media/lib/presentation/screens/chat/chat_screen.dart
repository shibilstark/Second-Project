import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/chat/conversation.dart';
import 'package:social_media/domain/models/chat/message.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:social_media/presentation/widgets/theme_switch.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {Key? key, required this.conversationId, required this.recieverId})
      : super(key: key);

  final String conversationId;
  final String recieverId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(Collections.users)
            .doc(recieverId)
            .snapshots(),
        builder: (context, recieverSnapshot) {
          return Scaffold(
            appBar: PreferredSize(
              child: recieverSnapshot.hasData
                  ? RealChatAppBar(
                      user: UserModel.fromMap(recieverSnapshot.data!.data()!))
                  : DummyChatAppBar(),
              preferredSize: appBarHeight,
            ),
            body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection(Collections.users)
                    .doc(Global.USER_DATA.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = UserModel.fromMap(snapshot.data!.data()!);

                    // WidgetsBinding.instance-
                    //     .addPostFrameCallback((timeStamp) {});
                    return ChatBody(
                      converSationId: conversationId,
                      reciever:
                          UserModel.fromMap(recieverSnapshot.data!.data()!),
                      user: user,
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 1.sm,
                  ));
                }),
          );
        });
  }
}

class ChatBody extends StatelessWidget {
  const ChatBody({
    Key? key,
    required this.reciever,
    required this.converSationId,
    required this.user,
  }) : super(key: key);

  final UserModel user;
  final String converSationId;
  final UserModel reciever;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ScrollController _controller = ScrollController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sm, vertical: 10.sm),
      child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection(Collections.messages)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Text('No Messages yet');
                      } else {
                        final allmessages =
                            snapshot.data!.docs.map((messageData) {
                          return MessageModel.fromMap(messageData.data());
                        }).toList();

                        List<MessageModel> messages =
                            allmessages.where((element) {
                          return (element.conversationId == converSationId);
                        }).toList();

                        messages.sort(((a, b) {
                          return a.time.compareTo(b.time);
                        }));

                        return ListView(
                          controller: _controller,
                          children: messages.map((mes) {
                            return MessageTileWidget(
                              controller: _controller,
                              size: size,
                              reciever: reciever,
                              mes: mes,
                            );
                          }).toList(),
                        );
                      }
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 1.sm,
                      ));
                    }
                  })),
          ChatFieldWidget(
            commentViewController: _controller,
            converSationId: converSationId,
            postId: '',
          )
        ],
      ),
    );
  }
}

class MessageTileWidget extends StatelessWidget {
  const MessageTileWidget(
      {Key? key,
      required this.size,
      required this.controller,
      required this.reciever,
      required this.mes})
      : super(key: key);

  final Size size;
  final UserModel reciever;
  final MessageModel mes;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mes.senderId == Global.USER_DATA.id
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: size.width * 0.85.sm, minWidth: 80.sm),
              padding: EdgeInsets.symmetric(vertical: 8.sm, horizontal: 10.sm),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: mes.senderId == Global.USER_DATA.id
                        ? Radius.circular(10)
                        : Radius.circular(0),
                    bottomRight: mes.senderId == Global.USER_DATA.id
                        ? Radius.circular(0)
                        : Radius.circular(10),
                    topLeft: Radius.circular(10.sm),
                    topRight: Radius.circular(10.sm),
                  ),
                  color: mes.senderId == Global.USER_DATA.id
                      ? primaryColor.withOpacity(0.2)
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(0.08)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mes.senderId == Global.USER_DATA.id ? "Me" : reciever.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12.sm,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Gap(H: 3.sm),
                  Text(
                    mes.message,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15.sm,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
            Gap(H: 3.sm),
            Padding(
              padding: EdgeInsets.only(left: 20.sm, right: 5.sm),
              child: Text(
                timeago.format(mes.time),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 10.sm,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            Gap(H: 10.sm)
          ],
        ),
      ],
    );
  }
}

class DummyChatAppBar extends StatelessWidget {
  const DummyChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: IconTheme(
            data: Theme.of(context).iconTheme, child: Icon(Icons.arrow_back)),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 15.sm,
            backgroundColor: primaryColor,
          ),
          Container(
            height: 15.sm,
            width: 100.sm,
            color: primaryColor.withOpacity(0.2),
          )
        ],
      ),
      actions: [
        ThemeSwitchButtom(),
      ],
    );
  }
}

class RealChatAppBar extends StatelessWidget {
  const RealChatAppBar({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: IconTheme(
            data: Theme.of(context).iconTheme, child: Icon(Icons.arrow_back)),
      ),
      title: Row(
        children: [
          user.profileImage == null
              ? CircleAvatar(
                  radius: 15.sm,
                  backgroundColor: primaryColor,
                )
              : CircleAvatar(
                  radius: 15.sm,
                  backgroundColor: primaryColor,
                  backgroundImage: NetworkImage(user.profileImage!),
                ),
          Gap(W: 10.sm),
          Text(user.name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
      actions: [
        ThemeSwitchButtom(),
      ],
    );
  }
}

class ChatFieldWidget extends StatelessWidget {
  const ChatFieldWidget({
    Key? key,
    required this.postId,
    required this.converSationId,
    required this.commentViewController,
  }) : super(key: key);
  final String postId;
  final ScrollController commentViewController;
  final String converSationId;

  @override
  Widget build(BuildContext context) {
    final _commentController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.sm),
            child: TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _commentController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.2),
                  border: InputBorder.none,
                  hintText: "Write something...",
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(0.5))),
            ),
          ),
        ),
        Gap(W: 10.sm),
        InkWell(
          onTap: () async {
            if (_commentController.text.trim().isNotEmpty) {
              final id = Uuid().v4();
              final time = DateTime.now();

              final model = MessageModel(
                  conversationId: converSationId,
                  senderId: Global.USER_DATA.id,
                  id: id,
                  type: MessageType.text,
                  message: _commentController.text.trim(),
                  time: time);

              final collection =
                  FirebaseFirestore.instance.collection(Collections.messages);
              await collection.doc(id).set(model.toMap());
              FocusScope.of(context).unfocus();
              await commentViewController.animateTo(
                commentViewController.position.maxScrollExtent,
                duration: const Duration(
                  milliseconds: 200,
                ),
                curve: Curves.easeInOut,
              );
            }
          },
          child: CircleAvatar(
            radius: 20.sm,
            backgroundColor: primaryColor,
            child: Icon(
              Icons.send,
              color: pureWhite,
            ),
          ),
        )
      ],
    );
  }
}
