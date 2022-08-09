import 'package:flutter/material.dart';

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
