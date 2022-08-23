import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/cubit/chat_cubit.dart';
import 'package:social_media/core/collections/firebase_collections.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/chat/conversation.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/shimmers/search.dart';
import 'package:social_media/presentation/util/functions/debounce.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({Key? key}) : super(key: key);
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isFocused = ValueNotifier(false);
    ValueNotifier<bool> showIdle = ValueNotifier(true);
    TextEditingController _serachController = TextEditingController();
    FocusNode _searchNode = FocusNode();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
      child: Column(
        children: [
          // ConversationSearchField(
          //     isFocused: isFocused,
          //     showIdle: showIdle,
          //     searchNode: _searchNode,
          //     serachController: _serachController,
          //     debouncer: _debouncer),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: context.read<ChatCubit>().getChatStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final recievers = snapshot.data!.docs.map((e) {
                    final conversation = ConverSationModel.fromMap(e.data());

                    if (conversation.members.contains(Global.USER_DATA.id)) {
                      final reciever = conversation.members
                          .firstWhere((e) => e != Global.USER_DATA.id);

                      return reciever;
                    }

                    return '';
                  }).toList();

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: context.read<ChatCubit>().getUserStream(),
                      builder: (context, usersnapshot) {
                        if (usersnapshot.hasData) {
                          final users = usersnapshot.data!.docs.map((userData) {
                            return UserModel.fromMap(userData.data());
                          }).toList();

                          return Expanded(
                              child: ListView(
                            children: recievers.map((e) {
                              if (e == '') {
                                return SizedBox();
                              } else {
                                final userModel = users.firstWhere(
                                    (element) => element.userId == e);

                                final conversationId =
                                    ConverSationModel.fromMap(snapshot
                                            .data!.docs
                                            .firstWhere((element) {
                                  final conversation =
                                      ConverSationModel.fromMap(element.data());

                                  return (conversation.members
                                          .contains(Global.USER_DATA.id) &&
                                      conversation.members
                                          .contains(userModel.userId));
                                }).data())
                                        .conversationId;
                                return ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, CHAT_SCREEN,
                                        arguments: ScreenArgs(args: {
                                          'recieverId': userModel.userId,
                                          'id': conversationId
                                        }));

                                    log(conversationId);
                                  },
                                  leading: userModel.profileImage == null
                                      ? CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 15.sm,
                                        )
                                      : CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 15.sm,
                                          backgroundImage: NetworkImage(
                                              userModel.profileImage!),
                                        ),
                                  title: Text(userModel.name),
                                  // subtitle: Text(e),
                                );
                              }
                            }).toList(),
                          ));
                        } else {
                          return Expanded(child: SearchShimmerTiles());
                        }
                      });
                } else {
                  return Expanded(child: SearchShimmerTiles());
                }
              })
        ],
      ),
    );
  }
}

// onLongPress: () async {
//   final collection = await FirebaseFirestore
//       .instance
//       .collection(Collections.conversations)
//       .get();

//   final thisConversation =
//       ConverSationModel.fromMap(collection.docs
//           .firstWhere((element) =>
//               ConverSationModel.fromMap(
//                       element.data())
//                   .members
//                   .contains(
//                       Global.USER_DATA.id) &&
//               ConverSationModel.fromMap(
//                       element.data())
//                   .members
//                   .contains(e))
//           .data());

//   await FirebaseFirestore.instance
//       .collection(Collections.conversations)
//       .doc(thisConversation.conversationId)
//       .delete();
// },

class ConversationSearchField extends StatelessWidget {
  const ConversationSearchField({
    Key? key,
    required this.isFocused,
    required this.showIdle,
    required FocusNode searchNode,
    required TextEditingController serachController,
    required Debouncer debouncer,
  })  : _searchNode = searchNode,
        _serachController = serachController,
        _debouncer = debouncer,
        super(key: key);

  final ValueNotifier<bool> isFocused;
  final ValueNotifier<bool> showIdle;
  final FocusNode _searchNode;
  final TextEditingController _serachController;
  final Debouncer _debouncer;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.sm),
          child: SizedBox(
            height: 35.sm,
            child: ValueListenableBuilder(
                valueListenable: isFocused,
                builder: (context, bool val, _) {
                  return TextField(
                    focusNode: _searchNode,
                    onChanged: (value) {
                      if (_searchNode.hasFocus && value.trim().isNotEmpty) {
                        isFocused.value = true;
                        isFocused.notifyListeners();
                      } else {
                        isFocused.value = false;
                        isFocused.notifyListeners();
                      }
                      if (_serachController.text.trim().isNotEmpty) {}
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: _serachController,
                    decoration: InputDecoration(
                        suffixIcon: isFocused.value
                            ? IconButton(
                                icon: IconTheme(
                                    data: Theme.of(context).iconTheme,
                                    child: Icon(
                                      Icons.cancel,
                                      color: primaryColor,
                                      size: 15.sm,
                                    )),
                                onPressed: () {
                                  _serachController.clear();
                                  showIdle.notifyListeners();
                                  _searchNode.unfocus();
                                },
                              )
                            : SizedBox(),
                        filled: true,
                        fillColor: primaryColor.withOpacity(0.2),
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!
                                    .withOpacity(0.5))),
                  );
                }),
          ),
        ),
      ),
    ]);
  }
}
