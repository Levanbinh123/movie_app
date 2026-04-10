

import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/movie.dart';

class GetSimilarMoviesUseCase extends UseCase<Either,int> {

  @override
  Future<Either> call({int ? params}) async {
    return await sl<MovieRepository>().getSimilarMovies(params!);
  }

}