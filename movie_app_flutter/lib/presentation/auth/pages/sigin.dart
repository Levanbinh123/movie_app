import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/common/helper/navigation/app_navigation.dart';
import 'package:movie_app/common/message/display_message.dart';
import 'package:movie_app/core/configs/theme/app_colors.dart';
import 'package:movie_app/data/auth/model/signin_req_params.dart';
import 'package:movie_app/domain/auth/usecases/signin.dart';
import 'package:movie_app/presentation/auth/pages/component/AppButton.dart';
import 'package:movie_app/presentation/auth/pages/signup.dart';
import 'package:movie_app/presentation/home/pages/home.dart';
import 'package:movie_app/service_locator.dart';

class Sigin extends StatelessWidget {
   Sigin({super.key});
  final TextEditingController _emailCon=TextEditingController();
  final TextEditingController _passwordCon=TextEditingController();
// Sử dụng ValueNotifier để quản lý trạng thái Loading mà không cần setState
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _obscureNotifier = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.only(top: 100,right: 16,left: 16),
          child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              _siginText(),
              const SizedBox(height: 30,),
              _emailFiled(),
          const SizedBox(height: 20,),
          _passwordField(),
          const SizedBox(height: 60,),
          _signinButton(context),
          const SizedBox(height: 10,),
          _sigupText(context)



        ],
      )),
    );

  }
  Widget _siginText(){
    return Text(
      'Sign In',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24
      ),
    );
  }
  Widget _emailFiled(){
    return TextField(
      controller: _emailCon,
      decoration: InputDecoration(
        hintText: 'Email'
      ),
    );
  }
  Widget _passwordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureNotifier,
      builder: (context, obscure, child) {
        return TextField(
          controller: _passwordCon,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                _obscureNotifier.value = !obscure;
              },
            ),
          ),
        );
      },
    );
  }

   Widget _signinButton(BuildContext context) {
     // ValueListenableBuilder sẽ chỉ render lại duy nhất cái nút khi giá trị biến đổi
     return ValueListenableBuilder<bool>(
       valueListenable: _isLoadingNotifier,
       builder: (context, isLoading, child) {
         return AppButton(
           text: 'Sign In',
           isLoading: isLoading,
           color: AppColors.primary,
           onPressed: () async {
             _isLoadingNotifier.value = true; // Bật loading

             final result = await sl<SigninUseCase>().call(
               params: SigninReqParams(
                 email: _emailCon.text,
                 password: _passwordCon.text,
               ),
             );

             _isLoadingNotifier.value = false; // Tắt loading

             result.fold(
                   (error) {
                 DisplayMessage.errorMessage(error, context);
               },
                   (success) {
                 AppNavigation.pushAndRemove(context, const HomePage());
               },
             );
           },
         );
       },
     );
   }
  Widget _sigupText(BuildContext context){
    return Text.rich(
      TextSpan(
        children: [
         const TextSpan(
              text: "Don't you have account ?"
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              color: Colors.blue
            ),
            recognizer: TapGestureRecognizer()..onTap=(){

              AppNavigation.push(context, SignupPage());
            }
          )
        ]
      )
    );
  }
}
