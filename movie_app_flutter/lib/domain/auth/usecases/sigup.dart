import 'package:dartz/dartz.dart';
import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/data/auth/model/signup_req_params.dart';
import 'package:movie_app/domain/auth/repositories/auth.dart';

import '../../../service_locator.dart';

class SignupUseCase extends UseCase<Either,SignupReqParams> {
  @override
  Future<Either> call({SignupReqParams? params})async {
    return await sl<AuthRepository>().signup(params!);
  }
  
}