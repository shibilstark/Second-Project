import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/application/comments/comment_cubit.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/screens/new_post/new_post.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:uuid/uuid.dart';

class DetailFeedScreen extends StatelessWidget {
  const DetailFeedScreen({Key? key, required this.post, required this.user})
      : super(key: key);

  final UserModel user;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    FocusNode _focusNode = FocusNode();
    return Scaffold(
      appBar: PreferredSize(
          child: DetailFeedAppBar(
            profile: user.profileImage,
            time: post.createdAt.toString(),
            name: user.name,
            postId: post.postId,
            userId: post.userId,
            postUrl: post.post!,
          ),
          preferredSize: appBarHeight),
      body: Padding(
        padding: EdgeInsets.only(bottom: 60.sm),
        child: DetailFeedBody(post: post),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          color: primaryColor.withOpacity(0.2),
          height: 60.sm,
          padding: EdgeInsets.symmetric(vertical: 5.sm, horizontal: 10.sm),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _controller,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      hintText: "Comment...",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.5))),
                ),
              ),
              Gap(W: 10.sm),
              CircleAvatar(
                backgroundColor: primaryColor,
                child: IconButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        PostComment postComment = PostComment(
                            reacterId: Global.USER_DATA.id,
                            commentText: _controller.text.trim(),
                            time: DateTime.now(),
                            postId: post.postId,
                            commentId: Uuid().v4());

                        context
                            .read<CommentCubit>()
                            .commentThePost(comment: postComment);
                      }
                      _controller.clear();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                    icon: Icon(
                      Icons.send,
                      color: pureWhite,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailFeedAppBar extends StatelessWidget {
  const DetailFeedAppBar(
      {Key? key,
      required this.profile,
      required this.time,
      required this.name,
      required this.userId,
      required this.postId,
      required this.postUrl})
      : super(key: key);
  final String? profile;
  final String time;
  final String name;
  final String postId;
  final String userId;
  final String postUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5.sm,
      title: Row(
        children: [
          profile == null
              ? CircleAvatar(
                  radius: 15.sm,
                  backgroundColor: primaryColor,
                )
              : CircleAvatar(
                  radius: 15.sm,
                  backgroundColor: primaryColor,
                  backgroundImage: NetworkImage(profile!),
                ),
          Gap(W: 10.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shibil Hassan",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 14.sm),
              ),
              Gap(H: 2.sm),
              Text(
                DateTime.now().toIso8601String(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sm),
              ),
            ],
          )
        ],
      ),
      actions: [
        DropdownButton<String>(
          disabledHint: SizedBox(),
          underline: SizedBox(),
          icon: Icon(Icons.more_vert),
          items: _dropDowns.map((e) {
            return DropdownMenuItem<String>(
              child: Text(e),
              value: e,
              onTap: () {},
            );
          }).toList(),
          onChanged: (String? value) {
            if (value == "Delete") {
              context
                  .read<InterMediatCubit>()
                  .deletePost(postId: postId, postUrl: postUrl);

              showLoadingDialog(context);
            } else {}
          },
        )
      ],
    );
  }
}

List<String> _dropDowns = ["Delete", "Report"];
showLoadingDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess || state is ProfileError) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        child: AlertDialog(
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.sm,
                  width: 20.sm,
                  child: CircularProgressIndicator(color: primaryColor),
                ),
                Gap(W: 10.sm),
                Text(
                  "Loading...",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15.sm, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
        ),
      ),
    );

class DetailFeedBody extends StatelessWidget {
  const DetailFeedBody({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
      child: ListView(
        children: [
          DetailFeedPostWidget(post: post),
          Gap(H: 10.sm),
          CommentsWidget()
        ],
      ),
    );
  }
}

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          log("emitted commentLoading");
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CommentSuccess) {
          log("emitted commentSuccess");
          return ListView(
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(state.comments.length, (index) {
              final currentComment = state.comments[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.sm)),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.sm, horizontal: 15.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentComment.userModel.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 14.sm,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                          ),
                          Gap(H: 5.sm),
                          Text(
                            currentComment.comment,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 14.sm),
                          ),
                        ],
                      ),
                    ),
                    Gap(H: 10.sm)
                  ],
                ),
              );
            }),
          );
        } else {
          return Center(
            child: Text("Error"),
          );
        }
      },
    );
  }
}

class DetailFeedPostWidget extends StatelessWidget {
  const DetailFeedPostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        post.type == PostType.image
            ? Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: 450.sm),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .color!
                        .withOpacity(0.1)),
                child: Image.network(
                  post.post!,
                  fit: BoxFit.contain,
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxHeight: 450.sm),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.1)),
                    child: Image.network(
                      post.videoThumbnail!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20.sm,
                    backgroundColor: commonBlack.withOpacity(0.6),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: pureWhite,
                    ),
                  )
                ],
              ),
        Gap(H: 5.sm),
        IconTheme(
          data: Theme.of(context).iconTheme,
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
              IconButton(
                  onPressed: () {}, icon: Icon(FontAwesomeIcons.comment)),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),
            ],
          ),
        ),
        post.discription == null
            ? SizedBox()
            : ReadMoreText(
                post.discription!,
                trimMode: TrimMode.Line,
                trimLines: 2,
                trimCollapsedText: 'Read More',
                trimExpandedText: 'Read Less',
                lessStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 13.sm,
                    color: primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500),
                moreStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 13.sm,
                    color: primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15.sm),
              ),
        Gap(H: 10.sm),
        Row(
          children: [
            Text(
              "${post.lights.length} Likes",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: primaryColor, fontSize: 13.sm),
            ),
            Gap(W: 20.sm),
            Text(
              "${post.comments.length} Comments",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: primaryColor, fontSize: 13.sm),
            ),
          ],
        ),
      ],
    );
  }
}
