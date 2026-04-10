import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_app/domain/tv/usecases/search_tv.dart';
import 'package:movie_app/presentation/search/bloc/search_state.dart';
import 'package:movie_app/presentation/search/bloc/selectable_option_cubit.dart';

import '../../../domain/movie/usecases/search_movie.dart';
import '../../../service_locator.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit():super(SearchInitial());
  TextEditingController textEditingController=TextEditingController();
  void search(String query, SearchType searchType){
    if(query.isNotEmpty){
      emit(SearchLoading());
      switch(searchType){
        case SearchType.movie:
          searchMovie(query);
          break;
        case SearchType.tv:
          searchTV(query);
          break;
      }
    }
  }
  void searchMovie(String query) async {
    var returnedData = await sl<SearchMovieUseCase>().call(params: query);
    returnedData.fold(
            (errorMessage){
          emit(SearchFailure(errorMessage: errorMessage));
        },
            (data) {
          emit(MoviesLoaded(movies: data));
        }
    );
  }

  void searchTV(String query) async {
    var returnedData = await sl<SearchTVUseCase>().call(params: query);
    returnedData.fold(
            (errorMessage){
          emit(SearchFailure(errorMessage: errorMessage));
        },
            (data) {
          emit(TVsLoaded(tvs: data));
        }
    );
  }
}