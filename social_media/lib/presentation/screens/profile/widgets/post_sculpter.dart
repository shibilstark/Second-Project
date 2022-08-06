import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media/core/colors/colors.dart';
import 'package:social_media/presentation/screens/profile/widgets/profile_info_section.dart';
import 'package:social_media/presentation/widgets/gap.dart';

class PostSculpterWidget extends StatelessWidget {
  const PostSculpterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Posts",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Divider()
        ],
      ),
    );
  }
}
