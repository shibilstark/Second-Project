import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media/application/comment/comment_cubit.dart';

import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/comment/comment_model.dart';
import 'package:social_media/domain/models/local_models/post_comment_show_model.dart';
import 'package:social_media/presentation/widgets/common_appbar.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    // final commenViewController = ScrollController();
    // final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
          child: CommonAppBar(title: "Comments"), preferredSize: appBarHeight),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 10.sm),
        child: BlocBuilder<CommentCubit, CommentState>(
          builder: (context, state) {
            if (state is CommentLoading) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is CommentSuccess) {
              final ScrollController _controller = ScrollController();

              return Column(
                children: [
                  state.comments.isEmpty
                      ? Expanded(
                          child: Container(
                            child: Center(child: Text("No Comments Yet")),
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            // reverse: true,
                            controller: _controller,
                            children: List.generate(
                                state.comments.length,
                                (index) => CommentTile(
                                      comment: state.comments[index],
                                    )),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sm),
                    child: Container(
                      width: double.infinity,
                      child: CommentFieldWidget(
                          postId: postId,
                          commentViewController: _controller,
                          commentsCount: state.comments.length),
                    ),
                  ),
                  Gap(H: 10.sm)
                ],
              );
            } else {
              return Container(
                child: Center(child: Text("Error")),
              );
            }
          },
        ),
      ),
    );
  }
}

class CommentFieldWidget extends StatelessWidget {
  const CommentFieldWidget(
      {Key? key,
      required this.postId,
      required this.commentViewController,
      required this.commentsCount})
      : super(key: key);
  final String postId;
  final ScrollController commentViewController;
  final int commentsCount;

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
                  hintText: "Comment...",
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
          onTap: () {
            if (_commentController.text.trim().isNotEmpty) {
              final date = DateTime.now();
              final commentModel = PostComment(
                  reacterId: Global.USER_DATA.id,
                  commentText: _commentController.text.trim(),
                  time: date,
                  postId: postId,
                  commentId: Uuid().v4());
              context
                  .read<CommentCubit>()
                  .commentThePost(comment: commentModel);
            }

            FocusScope.of(context).unfocus();
            if (commentsCount != 0) {
              commentViewController.jumpTo(0);
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

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final PostCommentShowModel comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        comment.userModel.profileImage == null
            ? CircleAvatar(radius: 15.sm, backgroundColor: primaryColor)
            : CircleAvatar(
                radius: 15.sm,
                backgroundColor: primaryColor,
                backgroundImage: NetworkImage(comment.userModel.profileImage!),
              ),
        Gap(W: 10.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () {
                // if () {
                //   showDeleteCommentDialog(context, commentId: comment.postId);
                // }
              },
              child: Container(
                constraints: BoxConstraints(
                    minWidth: 80.sm,
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.sm)),
                padding:
                    EdgeInsets.symmetric(vertical: 10.sm, horizontal: 15.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userModel.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sm,
                          color: primaryColor),
                    ),
                    Gap(H: 5.sm),
                    // Text(
                    //   comment.comment,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    //       fontSize: 14.sm, fontWeight: FontWeight.normal),
                    // )
                    ReadMoreText(
                      "${comment.comment}   ",
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      trimCollapsedText: 'Read More',
                      trimExpandedText: '',
                      lessStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              fontSize: 13.sm,
                              color: primaryColor.withOpacity(0.7),
                              fontWeight: FontWeight.w500),
                      moreStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              fontSize: 13.sm,
                              color: primaryColor.withOpacity(0.7),
                              fontWeight: FontWeight.w500),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 14.sm),
                    ),
                  ],
                ),
              ),
            ),
            Gap(H: 10.sm)
          ],
        ),
        comment.userModel.userId == Global.USER_DATA.id
            ? IconButton(
                // padding: EdgeInsets.zero,
                onPressed: () {
                  showDeleteCommentDialog(context, comment: comment);
                },
                icon: IconTheme(
                    data: Theme.of(context).iconTheme,
                    child: Icon(
                      Icons.delete,
                      size: 15.sm,
                    )))
            : SizedBox()
      ],
    );
  }
}

showDeleteCommentDialog(BuildContext context,
    {required PostCommentShowModel comment}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(
              "Do you want to delete this comment?",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14.sm, color: primaryColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<CommentCubit>().deleteComment(
                        commentId: comment.id, postId: comment.postId);
                    showDeleteCommentLoading(context);
                  },
                  child: Text(
                    "Delete",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14.sm, color: primaryColor),
                  )),
            ],
          ));
}

showDeleteCommentLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => BlocConsumer<CommentCubit, CommentState>(
            listener: (context, state) {
              if (state is CommentSuccess || state is CommentError) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  content: Row(children: [
                    SizedBox(
                      height: 20.sm,
                      width: 20.sm,
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 1.5.sm,
                      ),
                    ),
                    Gap(W: 20.sm),
                    Text(
                      "Loading...",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15.sm, fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
              );
            },
          ));
}
