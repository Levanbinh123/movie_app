


import 'package:bloc/bloc.dart';

import '../../core/usecases/usecase.dart';
import 'generic_data_state.dart';

class GenericDataCubit<T> extends Cubit<GenericDataState> {
  GenericDataCubit() : super(DataLoading<T>());


  void getData<T>(UseCase usecase,{dynamic params}) async {
    var returnedData = await usecase.call(params: params);
    returnedData.fold(
            (error){
          emit(
              FailureLoadData(errorMessage: error)
          );
        },
            (data){
          emit(
              DataLoaded<T>(data: data)
          );
        }
    );
  }
}