import 'package:bloc/bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/entity/trailler.dart';
import '../../../domain/movie/usecases/get_movie_trailer.dart';
import '../../../service_locator.dart';
import 'trailer_state.dart';
class TrailerCubit extends Cubit<TrailerState> {
  TrailerCubit() : super(TrailerLoading());

  void getMovieTrailer(int movieId) async {
    emit(TrailerLoading());

    var returnedData = await sl<GetMovieTrailerUseCase>().call(
      params: movieId,
    );

    returnedData.fold(
          (error) {
        emit(FailuerLoadTrailer(errorMessage: error));
      },
          (data) {
        //  data là List<TrailerEntity>
        final TrailerEntity trailers = data;


        final controller = YoutubePlayerController(
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        );

        final videoId = trailers.key;

        if (videoId == null || videoId.isEmpty) {
          emit(FailuerLoadTrailer(errorMessage: "Invalid video key"));
          return;
        }

        controller.loadVideoById(videoId: videoId);

        emit(TrailerLoaded(controller: controller));
      },
    );
  }
}