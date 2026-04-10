import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/tv.dart';


class GetRecommendationTvsUseCase extends UseCase<Either,int> {

  @override
  Future<Either> call({int ? params}) async {
    return await sl<TVRepository>().getRecommendationTVs(params!);
  }

}