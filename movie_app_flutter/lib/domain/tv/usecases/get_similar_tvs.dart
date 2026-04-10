import 'package:dartz/dartz.dart';
import 'package:movie_app/service_locator.dart';

import '../../../core/usecases/usecase.dart';
import '../repositories/tv.dart';


class GetSimilarTvsUseCase extends UseCase<Either,int> {

  @override
  Future<Either> call({int ? params}) async {
    return await sl<TVRepository>().getSimilarTVs(params!);
  }

}