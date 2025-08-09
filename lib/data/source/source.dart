import 'dart:convert';

import '../model/song.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    const url = "https://thantrieu.com/resources/braniumapis/songs.json";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final bodyContent = utf8.decode(response.bodyBytes);// nhận diện được tiếng Việt
      var songWrapper = jsonDecode(bodyContent) as Map;// chuyển đổi sang json sau đó chuyênr sang dạng map
      var songList = songWrapper['songs'];// lấy ca thành phần bên trong node songs -- tham khảo json từ url trả về
      List<Song> songs = songList.map((song)=>Song.fromJson(song)).toList();// gọi hàm fromJson trong class Song để chuyển đổi json sang 1 object thuộc class Song
      return songs;
    }
    return null;
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }
}
