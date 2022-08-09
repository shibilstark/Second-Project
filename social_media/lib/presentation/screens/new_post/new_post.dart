import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/application/post/post_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/core/controllers/text_controllers.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/local_models/post_type_model.dart';
import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/util/functions/pickers.dart';
import 'package:social_media/presentation/widgets/common_appbar.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:uuid/uuid.dart';

const dummyProfilePicture = "assets/dummy/dummyDP.png";

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: appBarHeight,
          child: CommonAppBar(title: "Add New Post")),
      body: NewPostBody(),
    );
  }
}

class NewPostBody extends StatelessWidget {
  const NewPostBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    ValueNotifier<PostTypeModel?> post = ValueNotifier(null);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewPostDiscriptionField(controller: _controller),
            Gap(H: 20.sm),
            NewPostSelecionWidget(post: post),
            Gap(H: 20.sm),
            NewPostViewWidget(post: post),
            Gap(H: 40.sm),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            foregroundColor:
                                MaterialStateProperty.all(pureWhite),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 10.sm, horizontal: 15.sm))),
                        onPressed: () {
                          if (post.value == null) {
                            Fluttertoast.showToast(msg: "Select a image/video");
                          } else {
                            final date = DateTime.now();

                            final newPost = PostModel(
                                postId: Uuid().v4(),
                                userId: Global.USER_DATA.id,
                                post: post.value!.file,
                                createdAt: date,
                                laseEdit: date,
                                comments: [],
                                lights: [],
                                type: post.value!.type,
                                videoThumbnail:
                                    post.value!.type == PostType.video
                                        ? post.value!.thumbnail
                                        : null,
                                discription: _controller.text.trim().isEmpty
                                    ? null
                                    : _controller.text.trim(),
                                tag: null,
                                reports: []);

                            context
                                .read<PostCubit>()
                                .uplaodPost(model: newPost);

                            showPostUploadingDialog(context);
                          }
                        },
                        child: const Text("Post"))),
              ],
            )
          ],
        ),
      ),
    );
  }
}

showPostUploadingDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: BlocConsumer<PostCubit, PostState>(listener: (context, state) {
          if (state is PostSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
          if (state is PostError) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          if (state is PostUploading) {
            return StreamBuilder<TaskSnapshot>(
                stream: state.uploadStream,
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    final percentage = ((snapShot.data!.bytesTransferred /
                                snapShot.data!.totalBytes) *
                            100)
                        .toStringAsFixed(2);

                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.sm,
                            width: 20.sm,
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                          Gap(W: 10.sm),
                          Text(
                            "Uploading $percentage %",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 15.sm,
                                    fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    );
                  }
                  return Container(
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
                          "Loading",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 15.sm,
                                  fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  );
                });
          }

          return Container(
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
                  "Loading",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 15.sm, fontWeight: FontWeight.normal),
                )
              ],
            ),
          );
        }),
      ),
    );

class NewPostViewWidget extends StatelessWidget {
  const NewPostViewWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final ValueNotifier<PostTypeModel?> post;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: post,
        builder: (context, PostTypeModel? model, _) {
          return post.value == null
              ? SizedBox()
              : post.value!.type == PostType.image
                  ? InkWell(
                      onTap: () => Navigator.pushNamed(context, OFFLINE_IMAGE,
                          arguments:
                              ScreenArgs(args: {"path": post.value!.file})),
                      child: Container(
                        // width: double.infinity,
                        constraints: BoxConstraints(maxHeight: 400.sm),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color!
                                .withOpacity(0.1)),

                        child: Container(
                          constraints: BoxConstraints(maxHeight: 400.sm),
                          width: double.infinity,
                          child: FadeInImage(
                              fadeInDuration: Duration(milliseconds: 100),
                              fit: BoxFit.fitHeight,
                              image: FileImage(File(post.value!.file)),
                              placeholder: AssetImage(dummyProfilePicture)),
                        ),
                      ),
                    )
                  : Container(
                      // width: double.infinity,
                      constraints: BoxConstraints(maxHeight: 400.sm),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .color!
                              .withOpacity(0.1)),

                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, OFFLINE_VIDEO_PLAYER,
                            arguments:
                                ScreenArgs(args: {"path": post.value!.file})),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxHeight: 400.sm),
                              width: double.infinity,
                              child: FadeInImage(
                                  fadeInDuration: Duration(milliseconds: 100),
                                  fit: BoxFit.fitHeight,
                                  image:
                                      FileImage(File(post.value!.thumbnail!)),
                                  placeholder: AssetImage(dummyProfilePicture)),
                            ),
                            CircleAvatar(
                              backgroundColor: commonBlack.withOpacity(0.6),
                              radius: 25.sm,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: pureWhite,
                                size: 25.sm,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
        });
  }
}

class NewPostSelecionWidget extends StatelessWidget {
  const NewPostSelecionWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final ValueNotifier<PostTypeModel?> post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30.sm,
          child: TextButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5.sm, horizontal: 10.sm))),
              onPressed: () async {
                final image = await Utility.pickImage();

                if (image == null) {
                  return;
                } else {
                  post.value = PostTypeModel(
                      file: image, type: PostType.image, thumbnail: null);
                  post.notifyListeners();
                }
              },
              icon: IconTheme(
                  data: Theme.of(context).iconTheme,
                  child: Icon(Icons.camera_alt, size: 18.sm)),
              label: Text("Add A Photo",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16.sm))),
        ),
        SizedBox(
          height: 30.sm,
          child: TextButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5.sm, horizontal: 10.sm))),
              onPressed: () async {
                final video = await Utility.pickVideo();

                if (video == null) {
                  return;
                } else {
                  final thumb =
                      await Utility.generateVideoThumbnail(videoPath: video);
                  post.value = PostTypeModel(
                      file: video, type: PostType.video, thumbnail: thumb!);
                  post.notifyListeners();
                }
              },
              icon: IconTheme(
                  data: Theme.of(context).iconTheme,
                  child: Icon(Icons.video_call, size: 18.sm)),
              label: Text("Add A Video",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 16.sm))),
        ),
      ],
    );
  }
}

class NewPostDiscriptionField extends StatelessWidget {
  const NewPostDiscriptionField({
    Key? key,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discrption",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.sm,
              ),
        ),
        Gap(H: 5.sm),
        TextFormField(
          style: Theme.of(context).textTheme.bodyMedium,
          controller: _controller,
          maxLines: 5,
          decoration: InputDecoration(
              filled: true,
              fillColor: primaryColor.withOpacity(0.2),
              border: InputBorder.none,
              hintText: "Write Something here",
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.5))),
        ),
      ],
    );
  }
}
