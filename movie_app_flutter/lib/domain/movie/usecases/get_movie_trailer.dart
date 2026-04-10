import 'package:dartz/dartz.dart';
import 'package:movie_app/core/usecases/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/movie.dart';

class GetMovieTrailerUseCase extends UseCase<Either, int>{
  @override
  Future<Either> call({int ? params}) async {
    return await sl<MovieRepository>().getMovieTRailer(params!);
  }
  
}