import 'package:dartz/dartz.dart';
import 'package:movie_app/data/auth/model/signin_req_params.dart';
import 'package:movie_app/data/auth/model/signup_req_params.dart';

abstract class AuthRepository{
  Future<Either> signup(SignupReqParams req);
  Future<Either>signin(SigninReqParams req);
  Future<bool> isLoggedIn();

}