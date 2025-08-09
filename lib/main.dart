import 'package:flutter/cupertino.dart';
import 'package:main_gui/data/repository/repository.dart';

void main() async{
  var respository = DefaultRepository();
  var songs = await respository.loadData();
  if(songs != null){
    for(var song in songs){
      debugPrint(song.toString());
    }
  }

}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
