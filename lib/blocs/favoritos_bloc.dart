import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosBloc implements BlocBase {
  Map<String, Video> _favoritos = {};

  //adicionando o BehaviorSubject no Lugar do StreamController
  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  Stream<Map<String, Video>> get outFav => _favController.stream;

  FavoritosBloc() {
    SharedPreferences.getInstance().then((prefs) {

      if (prefs.getKeys().contains("favorites")) {
        _favoritos = json.decode(prefs.getString("favorites")).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();

        _favController.add(_favoritos);
      }
    });
  }

  // passar dados para dentro do bloc Através de função
  void toggleFavoritos(Video video) {
    if (_favoritos.containsKey(video.id))
      _favoritos.remove(video.id);
    else
      _favoritos[video.id] = video;

    _favController.sink.add(_favoritos);

    _saveFave();
  }

  void _saveFave() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favoritos));
    });
  }

  @override
  void dispose() {
    _favController.close();
  }
}
