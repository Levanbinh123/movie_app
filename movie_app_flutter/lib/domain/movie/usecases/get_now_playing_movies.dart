import 'package:dartz/dartz.dart';
import 'package:movie_app/core/usecases/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/movie.dart';

class GetNowPlayingMoviesUseCase extends UseCase<Either, dynamic>{
  @override
  Future<Either> call({params}) async {
    return await sl<MovieRepository>().getNowPlayingMovies();
  }
}