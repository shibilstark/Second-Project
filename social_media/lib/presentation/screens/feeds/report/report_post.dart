import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/application/main/main_cubit.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/core/constants/constants.dart';
import 'package:social_media/presentation/router/router.dart';
import 'package:social_media/presentation/screens/new_post/new_post.dart';
import 'package:social_media/presentation/widgets/common_appbar.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class ReportTypeScreen extends StatelessWidget {
  const ReportTypeScreen({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CommonAppBar(title: 'Report'), preferredSize: appBarHeight),
      body: ReportBodyWidget(postId: postId),
    );
  }
}

// class ReportType {
//   // static const none = " none";
//   static const nudity = "nudity";
//   static const violence = "violence";
//   static const falseInformation = "falseInformation";
//   static const hateSpeech = "hateSpeech";
//   static const terrorism = "terrorism";
//   static const somthingElse = "somthingElse";
// }

final reportTileContents = [
  "Nudity",
  "Violence",
  "False Information",
  "Hate Speech",
  "Terrorism",
  "Something Else"
];

class ReportBodyWidget extends StatelessWidget {
  const ReportBodyWidget({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    // ValueNotifier<ReportType> reportValue = ValueNotifier(ReportType.none);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 15.sm),
      child: SingleChildScrollView(
        child: Column(
            children: List.generate(reportTileContents.length, (index) {
          return ListTile(
            onTap: () {
              Navigator.popAndPushNamed(context, REPORT_SCREEN,
                  arguments: ScreenArgs(args: {
                    'reportType': reportTileContents[index],
                    'postId': postId
                  }));
            },
            title: Text(reportTileContents[index],
                style: Theme.of(context).textTheme.bodyMedium),
          );
        })),
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key, required this.reportType, required this.postId})
      : super(key: key);

  final String reportType;
  final String postId;

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: PreferredSize(
          child: CommonAppBar(title: 'Report'), preferredSize: appBarHeight),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.sm, horizontal: 15.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reportType,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 30.sm, fontWeight: FontWeight.w500),
              ),
              Gap(H: 20.sm),
              NewPostDiscriptionField(controller: _controller),
              Gap(H: 20.sm),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(commonWhite),
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor)),
                          onPressed: () {
                            if (_controller.text.trim().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Write Somthing, Then Report');
                            } else {
                              showReportLoading(context);
                              context.read<MainCubit>().reportPost(
                                  postId: postId,
                                  reportType: reportType,
                                  reportDiscription: _controller.text.trim());
                            }
                          },
                          child: Text("Submit Report"))),
                ],
              )
            ],
          )),
    );
  }
}

showReportLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              if (state is MainSuccess || state is MainError) {
                if (state is MainSuccess) {
                  Fluttertoast.showToast(msg: 'Post reported successfully');
                }
                if (state is MainError) {
                  Fluttertoast.showToast(
                      msg: 'Something went wrong, try again later');
                }
                Navigator.of(context).pop();
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
                      "Reporting post...",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15.sm, fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
              );
            },
          ));
}
