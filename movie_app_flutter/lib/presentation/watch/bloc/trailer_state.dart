import 'package:youtube_player_iframe/youtube_player_iframe.dart';
abstract class TrailerState{}
class TrailerLoading extends TrailerState{
}
class TrailerLoaded extends TrailerState {
  final YoutubePlayerController controller;

  TrailerLoaded({
    required this.controller,
  });
}
class FailuerLoadTrailer extends TrailerState{
  final String errorMessage;
  FailuerLoadTrailer({required this.errorMessage});
}