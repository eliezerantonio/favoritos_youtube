import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/blocs/favoritos_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/screens/home.dart';

void main() {
  Api api = Api();
  api.search("Flutter");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: VideosBloc(),
        child: BlocProvider(
          bloc: FavoritosBloc(),
          child: MaterialApp(
              title: 'Flutter Youtube',
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,
              home: Home()
          ),
        )
    );
  }
}
