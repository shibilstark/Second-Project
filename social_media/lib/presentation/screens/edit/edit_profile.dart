import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/intermediat/inter_mediat_cubit.dart';
import 'package:social_media/application/profile/profile_cubit.dart';

import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';

import 'package:social_media/domain/models/edit_profile/edit_profile_model.dart';

import 'package:social_media/presentation/util/functions/pickers.dart';
import 'package:social_media/presentation/widgets/gap.dart';
import 'package:social_media/presentation/widgets/theme_switch.dart';

enum ImageType { profile, cover }

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  Future<bool?> _showWarning(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Are You Sure?",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    "Yes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Discard",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final will = await _showWarning(context);

        if (will == true) {
          _cover.value = null;
          _profile.value = null;
          _cover.notifyListeners();
          _profile.notifyListeners();
        }

        return will ?? false;
      },
      child: Scaffold(
        appBar: const PreferredSize(
            child: EditProfileAppBar(), preferredSize: appBarHeight),
        body: EditProfileBody(),
      ),
    );
  }
}

showProfileUpdatingDialog(context) => showDialog(
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
                  "Updating Profile",
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

class EditProfileAppBar extends StatelessWidget {
  const EditProfileAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -5,
      leading: IconButton(
        onPressed: () {
          _cover.value = null;
          _profile.value = null;

          _cover.notifyListeners();
          _profile.notifyListeners();

          Navigator.pop(context);
        },
        icon: IconTheme(
            data: Theme.of(context).iconTheme,
            child: const Icon(Icons.arrow_back)),
      ),
      title: Text(
        "Edit Profile",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [const ThemeSwitchButtom()],
    );
  }
}

final _key = GlobalKey<FormState>();
ValueNotifier<String?> _cover = ValueNotifier(null);
ValueNotifier<String?> _profile = ValueNotifier(null);

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          final user = state.user;

          _cover.value = user.coverImage;
          _profile.value = user.profileImage;
          _cover.notifyListeners();
          _profile.notifyListeners();

          TextEditingController _nameController = TextEditingController();
          TextEditingController _discController = TextEditingController();

          _nameController.text = user.name;
          if (user.discription != null) {
            _discController.text = user.discription!;
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
            child: ValueListenableBuilder(
                valueListenable: _cover,
                builder: (context, val, _) {
                  return ValueListenableBuilder(
                      valueListenable: _profile,
                      builder: (context, val, _) {
                        return SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              height: 220.sm,
                              child: Stack(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.sm),
                                        child: _cover.value == null
                                            ? Container(
                                                color: primaryColor
                                                    .withOpacity(0.2),
                                                height: 150.sm,
                                              )
                                            : _cover.value == user.coverImage
                                                ? Container(
                                                    height: 150.sm,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.2),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                _cover
                                                                    .value!))),
                                                  )
                                                : Container(
                                                    height: 150.sm,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.2),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: FileImage(
                                                                File(_cover
                                                                    .value!)))),
                                                  ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10.sm),
                                        child: CircleAvatar(
                                          radius: 15.sm,
                                          backgroundColor: softGrey,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.camera_alt,
                                                color: commonBlack,
                                                size: 15.sm,
                                              ),
                                              onPressed: () async {
                                                showImageSelectDialog(
                                                    context, ImageType.cover);
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        _profile.value == null
                                            ? CircleAvatar(
                                                backgroundColor: primaryColor,
                                                radius: 70.sm,
                                              )
                                            : _profile.value ==
                                                    user.profileImage
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        primaryColor,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            _profile.value!),
                                                    radius: 70.sm,
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        primaryColor,
                                                    backgroundImage: FileImage(
                                                        File(_profile.value!)),
                                                    radius: 70.sm,
                                                  ),
                                        CircleAvatar(
                                          radius: 15.sm,
                                          backgroundColor: softGrey,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.camera_alt,
                                                color: commonBlack,
                                                size: 15.sm,
                                              ),
                                              onPressed: () async {
                                                showImageSelectDialog(
                                                    context, ImageType.profile);
                                              }),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Gap(H: 30.sm),
                            Form(
                              key: _key,
                              child: TextFormField(
                                validator: ((value) => value!.length <= 3 ||
                                        value.isEmpty
                                    ? "Name Cant be empty or less than 3 char"
                                    : null),
                                style: Theme.of(context).textTheme.bodyMedium,
                                controller: _nameController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: primaryColor.withOpacity(0.2),
                                    border: InputBorder.none,
                                    hintText: "Name...",
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
                            Gap(H: 20.sm),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyMedium,
                              controller: _discController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: primaryColor.withOpacity(0.2),
                                  border: InputBorder.none,
                                  hintText: "About Me...",
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
                            Gap(H: 40.sm),
                            Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryColor),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    pureWhite),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    vertical: 10.sm,
                                                    horizontal: 15.sm))),
                                        onPressed: () {
                                          if (_key.currentState!.validate()) {
                                            final newName =
                                                _nameController.text.trim();
                                            final newDisc = _discController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _discController.text.trim();

                                            final newProfile = _profile.value;
                                            final newCover = _cover.value;
                                            final model = EditProfileModel(
                                                name: newName,
                                                discription: newDisc,
                                                cover: newCover,
                                                profile: newProfile);

                                            if (model.name == user.name &&
                                                model.cover ==
                                                    user.coverImage &&
                                                model.discription ==
                                                    user.discription &&
                                                model.profile ==
                                                    user.profileImage) {
                                              Navigator.pop(context);
                                            } else {
                                              context
                                                  .read<InterMediatCubit>()
                                                  .upadateProfile(model: model);
                                              showProfileUpdatingDialog(
                                                  context);
                                            }
                                          }
                                        },
                                        child: const Text("Update"))),
                              ],
                            )
                          ]),
                        );
                      });
                }),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

showImageSelectDialog(BuildContext context, ImageType type) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    final image = await Utility.pickImage();

                    if (image == null) {
                      Navigator.pop(context);
                    } else {
                      if (type == ImageType.cover) {
                        _cover.value = image;
                        _cover.notifyListeners();
                      } else {
                        _profile.value = image;
                        _profile.notifyListeners();
                      }
                      Navigator.pop(context);
                    }
                  },
                  dense: true,
                  leading: IconTheme(
                      data: Theme.of(context).iconTheme,
                      child: Icon(Icons.camera_alt)),
                  title: Text(
                    "Pick From Gallery",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (type == ImageType.cover) {
                      _cover.value = null;
                      _cover.notifyListeners();
                    } else {
                      _profile.value = null;
                      _profile.notifyListeners();
                    }
                    Navigator.pop(context);
                  },
                  dense: true,
                  leading: IconTheme(
                      data: Theme.of(context).iconTheme,
                      child: Icon(Icons.visibility_off)),
                  title: Text(
                      type == ImageType.cover
                          ? "Remove Cover Pic"
                          : "Remove Profile Pic",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ));
}
