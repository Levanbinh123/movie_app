import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/common/helper/navigation/app_navigation.dart';
import 'package:movie_app/presentation/auth/pages/sigin.dart';
import 'package:movie_app/presentation/home/widget/category_text.dart';
import 'package:movie_app/presentation/home/widget/now_playing_movies.dart';
import 'package:movie_app/presentation/home/widget/popular_tv.dart';
import 'package:movie_app/presentation/home/widget/trending_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../search/pages/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
void _logout(BuildContext context)async{
  final prefs=await SharedPreferences.getInstance();
  await prefs.remove('token');

  print(prefs.get('token'));
  AppNavigation.pushAndRemove(context,Sigin());
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: true,
        action: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: (){
                AppNavigation.push(context, const SearchPage());
              },
            ),
            IconButton(onPressed: (){
              _logout(context);
            },
                icon: const Icon(Icons.logout))
          ],
        ),
        title: SvgPicture.asset(
            AppVectors.logo
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryText(title: 'Trendings '),
            TrendingMovies(),
            SizedBox(height: 16,),
            CategoryText(title: 'Now Playing'),
            SizedBox(height: 16,),
            NowPlayingMovies(),
            SizedBox(height: 16,),
            CategoryText(title: 'Popular TV'),
            SizedBox(height: 16,),
            PopularTv(),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
}