import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/common/helper/navigation/app_navigation.dart';
import 'package:movie_app/core/configs/assets/app_image.dart';
import 'package:movie_app/presentation/auth/pages/sigin.dart';
import 'package:movie_app/presentation/home/pages/home.dart';
import 'package:movie_app/presentation/splash/bloc/splash_cubit.dart';
import 'package:movie_app/presentation/splash/bloc/splash_state.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit,SplashState>(
        listener: (context,state){
          if(state is UnAuthenticated){
              AppNavigation.pushReplacement(context,
                  Sigin());
          }
          if(state is Authenticated){
              AppNavigation.pushReplacement(context, HomePage());
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage(
                          AppImages.splashBackground
                      ) )
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff1A1B20).withOpacity(0),
                      Color(0xff1A1B20)
        
        
                ])
              ),
            )
          ],
        ),
      ),
    );
  }
}
