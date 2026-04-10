import 'package:dartz/dartz.dart';

abstract class MovieRepository{
  Future<Either> getTrendingMovies();
  Future<Either>getNowPlayingMovies();
  Future<Either> getMovieTRailer(int movieId);
  Future<Either>getRecommentdationMovies(int movieId);
  Future<Either>getSimilarMovies(int movieId);
  Future<Either> searchMovie(String query);
}