import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/application/home/home_cubit.dart';
import 'package:social_media/application/search/search_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/global/global_variables.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/presentation/screens/comment/comment.dart';
import 'package:social_media/presentation/screens/feeds/feeds.dart';
import 'package:social_media/presentation/screens/home/home.dart';
import 'package:social_media/presentation/util/functions/debounce.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

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
          SearchFieldWIdget(
              isFocused: isFocused,
              searchNode: _searchNode,
              serachController: _serachController,
              debouncer: _debouncer,
              showIdle: showIdle),
          Gap(H: 10.sm),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: showIdle,
                builder: (context, bool val, _) {
                  return BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (_serachController.text.trim().isEmpty ||
                          _serachController.text.trim() == '') {
                        return SearchIdleWidget();
                      } else {
                        if (state is SearchLoading) {
                          return Container(
                            child: Center(child: Text("Loading")),
                          );
                        } else if (state is SearchSuccess) {
                          if (state.peoples.isEmpty) {
                            return Container(
                              child: Center(
                                  child: Text("No Users found in this name")),
                            );
                          } else {
                            return ListView(
                              children:
                                  List.generate(state.peoples.length, (index) {
                                return SearchResultTile(
                                    user: state.peoples[index]);
                              }),
                            );
                          }
                        } else {
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      }
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}

class SearchIdleWidget extends StatelessWidget {
  const SearchIdleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeSuccess) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sm),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Peoples You May Know",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    // childAspectRatio: 1 / 1,
                    crossAxisSpacing: 10.sm,
                    mainAxisSpacing: 10.sm),
                children: List.generate(state.peoples.length,
                    (index) => SearchIdleGrid(user: state.peoples[index])),
              ),
            ],
          );
        }
        return Container(
          child: Center(
            child: Text("Getting users...."),
          ),
        );
      },
    );
  }
}

class SearchIdleGrid extends StatelessWidget {
  const SearchIdleGrid({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.sm)),
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 20.sm),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        user.profileImage == null
            ? CircleAvatar(
                radius: 30.sm,
                backgroundColor: primaryColor,
              )
            : CircleAvatar(
                radius: 30.sm,
                backgroundColor: primaryColor,
                backgroundImage: NetworkImage(user.profileImage!),
              ),
        Gap(H: 20.sm),
        Text(
          user.name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ]),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          tileColor: scaffoldBlack.withOpacity(0.03),
          onTap: () {
            if (user.userId == Global.USER_DATA.id) {
              gotoProfileView();
            } else {}
          },
          leading: user.profileImage == null
              ? CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 20.sm,
                )
              : CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 20.sm,
                  backgroundImage: NetworkImage(user.profileImage!),
                ),
          title: Text(
            user.name,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ),
        Gap(H: 10.sm)
      ],
    );
  }
}

class SearchFieldWIdget extends StatelessWidget {
  const SearchFieldWIdget({
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

                      if (_serachController.text.trim().isNotEmpty) {
                        _debouncer.run(() {
                          context
                              .read<SearchCubit>()
                              .searchUser(query: _serachController.text.trim());
                        });
                      }
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
