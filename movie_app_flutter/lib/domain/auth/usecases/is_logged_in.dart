import 'package:movie_app/core/usecases/usecase.dart';
import 'package:movie_app/domain/auth/repositories/auth.dart';

import '../../../service_locator.dart';

class IsLoggedInUseCase extends UseCase<bool, dynamic>{
  @override
  Future<bool> call({params})async {
    return await sl<AuthRepository>().isLoggedIn();
  }

}