import 'package:dartz/dartz.dart';
import 'package:movie_app/data/auth/model/signin_req_params.dart';
import 'package:movie_app/data/auth/model/signup_req_params.dart';
import 'package:movie_app/data/auth/source/auth_api_service.dart';
import 'package:movie_app/domain/auth/repositories/auth.dart';
import 'package:movie_app/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<Either> signup(SignupReqParams params) async {
    var data = await sl<AuthService>().signup(params);
    return data.fold(
            (error) {
          return Left(error);
        },
            (data) async {
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('token',data['user']['token']);
          return Right(data);}
    );
  }
  @override
  Future<Either<dynamic, dynamic>> signin(SigninReqParams req)async {
    var data =await sl<AuthService>().signin(req);
    return data.fold((error){
      return Left(error);
    },(data)async{
      final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      if (data['token'] != null) {
        await sharedPreferences.setString('token', data['user']['token']);
      }
      return Right(data);
        }
    );
  }
  @override
  Future<bool> isLoggedIn() async{
    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var token=sharedPreferences.get('token');
    if(token==null){
      return false;
    }else{
      return true;
    }
  }

}


