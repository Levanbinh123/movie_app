import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/movie.dart';

class GetTrendingMoviesUseCase extends UseCase<Either,dynamic> {

  @override
  Future<Either> call({params}) async {
    return await sl<MovieRepository>().getTrendingMovies();
  }

}