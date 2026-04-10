import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/tv.dart';


class SearchTVUseCase extends UseCase<Either,String> {

  @override
  Future<Either> call({String ? params}) async {
    return await sl<TVRepository>().searchTV(params!);
  }

}