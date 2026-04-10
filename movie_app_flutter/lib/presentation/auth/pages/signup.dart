import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/common/helper/navigation/app_navigation.dart';
import 'package:movie_app/core/configs/theme/app_colors.dart';
import 'package:movie_app/domain/auth/usecases/sigup.dart';
import 'package:movie_app/presentation/auth/pages/component/AppButton.dart';
import 'package:movie_app/presentation/auth/pages/sigin.dart';
import 'package:movie_app/presentation/auth/pages/signup.dart';
import 'package:movie_app/presentation/home/pages/home.dart';

import '../../../common/message/display_message.dart';
import '../../../data/auth/model/signup_req_params.dart';
import '../../../service_locator.dart';

class SignupPage extends StatelessWidget {
   SignupPage({super.key});
  final TextEditingController _emailCon=TextEditingController();
  final TextEditingController _passwordCon=TextEditingController();
   final ValueNotifier<bool> _isLoading = ValueNotifier(false);
   final ValueNotifier<bool> _obscureNotifier=ValueNotifier<bool>(true);
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
              _signupButton(context),
              const SizedBox(height: 10,),
              _sigupText(context)



            ],
          )),
    );

  }
  Widget _siginText(){
    return Text(
      'Sign Up',
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
   Widget _signupButton(BuildContext context) {
     return ValueListenableBuilder<bool>(
       valueListenable: _isLoading,
       builder: (context, isLoading, child) {
         return ElevatedButton(
           onPressed: isLoading ? null : () async {
             _isLoading.value = true;

             final result = await sl<SignupUseCase>().call(
               params: SignupReqParams(
                 email: _emailCon.text,
                 password: _passwordCon.text,
               ),
             );
             _isLoading.value = false;

             result.fold(
                   (error) {
                 DisplayMessage.errorMessage(error, context);
               },
                   (success) {
                 AppNavigation.pushAndRemove(context, const HomePage());
               },
             );
           },
           child: isLoading
               ? const CircularProgressIndicator()
               : const Text("Sign Up"),
         );
       },
     );
   }
  Widget _sigupText(BuildContext context){
    return Text.rich(
        TextSpan(
            children: [
              const TextSpan(
                  text: "Do you have account ?"
              ),
              TextSpan(
                  text: 'Sign In',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                  recognizer: TapGestureRecognizer()..onTap=(){

                    AppNavigation.push(context, Sigin());
                  }
              )
            ]
        )
    );
  }
}
