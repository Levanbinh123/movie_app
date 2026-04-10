import 'package:dartz/dartz.dart';

import '../../../core/usecases/usecase.dart';
import '../../../service_locator.dart';
import '../repositories/tv.dart';


class GetTVKeywordsUseCase extends UseCase<Either,int> {

  @override
  Future<Either> call({int ? params}) async {
    return await sl<TVRepository>().getKeywords(params!);
  }

}