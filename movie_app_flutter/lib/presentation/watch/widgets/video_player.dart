import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/presentation/watch/bloc/trailer_cubit.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../bloc/trailer_state.dart';

class VideoPlayer extends StatefulWidget {
  final int id;
  const VideoPlayer({required this.id,super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  YoutubePlayerController? _controller;
  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      _controller?.close();
      super.dispose();
    }

    return BlocProvider(
      create: (context)=>TrailerCubit()..getMovieTrailer(widget.id),
      child: BlocListener<TrailerCubit, TrailerState>(
          listener: (context, state){
            if(state is TrailerLoaded){
              _controller=state.controller;
            }
          },
        child: BlocBuilder<TrailerCubit, TrailerState>
          (builder: (context, state){
            if(state is TrailerLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(state is TrailerLoaded){
              return YoutubePlayer(controller: state.controller,
              aspectRatio: 16/9,
              );
            }
            if(state is FailuerLoadTrailer){
              return Center(child: Text(state.errorMessage),);
            }
            return Container();
        }),

      ),
    );
  }
}