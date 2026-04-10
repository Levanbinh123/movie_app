

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:movie_app/core/constants/api_url.dart';
import 'package:movie_app/core/network/dio_client.dart';
import 'package:movie_app/data/auth/model/signin_req_params.dart';
import 'package:movie_app/data/auth/model/signup_req_params.dart';
import '../../../service_locator.dart';

abstract class AuthService {
  Future<Either> signup(SignupReqParams req);
  Future<Either> signin(SigninReqParams params);
}
class AuthApiServiceImpl extends AuthService{
  @override
  Future<Either<dynamic, dynamic>> signup(SignupReqParams req) async {
    try{
      var response=await sl<DioClient>().post(
        ApiUrl.signup,
        data:req.toMap()
      );
      return Right(response.data);

    }on DioException catch(e){
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either<dynamic, dynamic>> signin(SigninReqParams params)async {
   try{
     var response=await sl<DioClient>().post(
          ApiUrl.signin,
       data: params.toMap()
     );
     return Right(response.data);
   }on DioException catch(e){
     String errorMessage="Da co loi xay ra";
     if (e.response != null) {
       // Kiểm tra nếu data là Map thì lấy ['message'], nếu không thì lấy toàn bộ data
       if (e.response!.data is Map) {
         errorMessage = e.response!.data['message']?.toString() ?? "Lỗi không xác định";
       } else {
         errorMessage = e.response!.data.toString();
       }
     }
     return Left(errorMessage);
   }
  }

}