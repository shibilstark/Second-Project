// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:social_media/domain/models/post_model/post_model.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';

class HomeFeedModel extends Equatable {
  PostModel post;
  UserModel user;

  HomeFeedModel({required this.post, required this.user});

  HomeFeedModel copyWith({
    PostModel? post,
    UserModel? user,
  }) {
    return HomeFeedModel(
      post: post ?? this.post,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [post, user];
}

class HomeDataModel extends Equatable {
  List<HomeFeedModel> homeFeedModel;
  List<UserModel> peoples;

  HomeDataModel({required this.peoples, required this.homeFeedModel});

  @override
  List<Object?> get props => [peoples, homeFeedModel];

  HomeDataModel copyWith({
    List<HomeFeedModel>? homeFeedModel,
    List<UserModel>? peoples,
  }) {
    return HomeDataModel(
      homeFeedModel: homeFeedModel ?? this.homeFeedModel,
      peoples: peoples ?? this.peoples,
    );
  }
}
