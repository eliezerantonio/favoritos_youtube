import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favoritos_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/search_data.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favoritos_screen.dart';
import 'package:fluttertube/widgets/videotile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideosBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/yt_logo_rgb_light.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                stream: BlocProvider
                    .of<FavoritosBloc>(context)
                    .outFav,

                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text("${snapshot.data.length}");
                  else
                    return Container();
                }),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Favoritos()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String resultado =
              await showSearch(context: context, delegate: DataSearch());
              if (resultado != null) bloc.inSearch.add(resultado);
            },
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
          stream: bloc.outVideos,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  } else if (index > 1) {
                    bloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            else
              return Container();
          }),
    );
  }
}
