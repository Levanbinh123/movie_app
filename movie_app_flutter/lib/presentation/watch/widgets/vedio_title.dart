import 'package:flutter/cupertino.dart';

class VideoTite extends StatelessWidget {
  final String title;
  const VideoTite({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),
    );
  }
}
