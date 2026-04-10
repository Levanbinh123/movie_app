import 'package:dartz/dartz.dart';
import 'package:movie_app/data/movie/model/movie.dart';
import 'package:movie_app/data/movie/sources/movie.dart';
import 'package:movie_app/domain/movie/repositories/movie.dart';

import '../../../common/mapper/movie.dart';
import '../../../common/mapper/trailer.dart';
import '../../../core/model/trailer.dart';
import '../../../service_locator.dart';

class MovieRepositoryImpl extends MovieRepository{
  @override
  Future<Either<dynamic, dynamic>> getMovieTRailer(int movieId)async {
    var returnedData = await sl <MovieService> ().getMovieTrailer(movieId);
    return returnedData.fold(
            (error) {
          return Left(error);
        },
            (data) {
          var movies = TrailerMapper.toEntity(TrailerModel.fromJson(data['trailer']));
          return Right(movies);
        }
    );
  }

  @override
  Future<Either<dynamic, dynamic>> getNowPlayingMovies() async{
    var returnedData = await sl < MovieService > ().getNowPlayingMovies();

    return returnedData.fold(
            (error) {
          return Left(error);
        },
            (data) {
          var movies = List.from(data['content']).map((item) => MovieMapper.toEntity(MovieModel.fromJson(item))).toList();
          return Right(movies);
        }
    );
  }

  @override
  Future<Either<dynamic, dynamic>> getRecommentdationMovies(int movieId)async {
    var returnedData = await sl < MovieService > ().getMovieTrailer(movieId);
    return returnedData.fold(
            (error) {
          return Left(error);
        },
            (data) {
          var movies = TrailerMapper.toEntity(TrailerModel.fromJson(data['trailer']));
          return Right(movies);
        }
    );
  }

  @override
  Future<Either<dynamic, dynamic>> getSimilarMovies(int movieId) async{
    var returnedData = await sl < MovieService > ().getSimilarMovies(movieId);
    return returnedData.fold(
            (error) {
          return Left(error);
        },
            (data) {
          var movies = List.from(data['content']).map((item) => MovieMapper.toEntity(MovieModel.fromJson(item))).toList();
          return Right(movies);
        }
    );
  }

  @override
  Future<Either<dynamic, dynamic>> getTrendingMovies() async{
    var returnedData = await  sl<MovieService>().getTrendingMovies();

    return returnedData.fold(
            (error) {
          return Left(error);
        } ,
            (data) {
          var movies = List.from(data['content']).map((item) => MovieMapper.toEntity(MovieModel.fromJson(item))).toList();
          return Right(movies);
        }
    );
  }

  @override
  Future<Either<dynamic, dynamic>> searchMovie(String query) async {
    var returnedData = await sl < MovieService > ().searchMovie(query);
    return returnedData.fold(
            (error) {
          return Left(error);
        },
            (data) {
          var movies = List.from(data['content']).map((item) => MovieMapper.toEntity(MovieModel.fromJson(item))).toList();
          return Right(movies);
        }
    );
  }
  
}