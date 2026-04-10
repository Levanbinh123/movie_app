import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/common/widgets/appbar/app_bar.dart';
import 'package:movie_app/presentation/search/bloc/selectable_option_cubit.dart';
import 'package:movie_app/presentation/search/widgets/search_content.dart';
import 'package:movie_app/presentation/search/widgets/search_filed.dart';
import 'package:movie_app/presentation/search/widgets/search_option.dart';

import '../bloc/search_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text("Search"),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>SelectableOptionCubit()),
            BlocProvider(create: (context) => SearchCubit())
          ],
          child:  Padding(padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SearchFiled(),
              SizedBox(height: 16,),
              SearchOption(),
              SizedBox(height: 16,),
              Expanded(child: SearchContent())
            ],
          ),

          )),
    );
  }
}
