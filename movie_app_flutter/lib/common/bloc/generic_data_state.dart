abstract class GenericDataState<T> {}

class DataLoading<T> extends GenericDataState<T> {}

class DataLoaded<T> extends GenericDataState<T> {
  final T data;
  DataLoaded({required this.data});
}

class FailureLoadData<T> extends GenericDataState<T> {
  final String errorMessage;
  FailureLoadData({required this.errorMessage});
}