import 'package:flutter/cupertino.dart';
import 'package:main_gui/data/repository/repository.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var res = DefaultRepository();
  var songs = await res.loadData();
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
