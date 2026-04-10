import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoVoteAverage extends StatelessWidget {
  final double voteAverage;
  const VideoVoteAverage({super.key,required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.start,
          color: Colors.amber,
          size: 20,
        ),
        Text(
          '${voteAverage.toStringAsFixed(1)}'
        )
      ],
    );
  }
}
