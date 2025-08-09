import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_gui/ui/discovery/discovery.dart';
import 'package:main_gui/ui/home/viewmodel.dart';
import 'package:main_gui/ui/settings/settings.dart';
import 'package:main_gui/ui/user/profile.dart';

import '../../data/model/song.dart';
import '../playing/playing.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    const SettingsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Music App')),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.album),
              label: 'Discovery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  //thay đổi giao diện của homepage ở đây

  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  @override
  void dispose() {
    _viewModel.songStream.close(); // giải phóng bộ nhớ
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(child: CircularProgressIndicator());
  }

  ListView getListView() {
    //separated phân tách các phần tử
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
          thickness: 1, // độ da 1px
          indent: 24, // cách bên trái
          endIndent: 24, //cách bên phải tương tự padding
        );
      },
      itemCount: songs.length,
      shrinkWrap: true, // tạo mảng cố định, có thể cuộn được
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(parent: this, song: songs[index]);
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void navigate(Song song) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return NowPlaying(songs: songs, playingSong: song);
        },
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            height: 400,
            color: Colors.grey,
            child: Center(
              child: Column(
                // xếp dọc các phần tử từ trên xuống dưới
                mainAxisAlignment: MainAxisAlignment.center,
                // căn giữa theo chiều dọc
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Modal bottom sheet'),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({required this.parent, required this.song});

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        // căn chỉnh padding lại cho item
        left: 24,
        right: 8,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/music_default_icon.png',
          // ảnh mặc định khi chưa load được ảnh từ link
          image: song.image,
          width: 48,
          height: 48,
          // avatar của bài hát
          imageErrorBuilder: (context, error, stackTrace) {
            // trường hợp load ảnh lỗi thì trả về ảnh mặc định
            return Image.asset(
              'assets/images/music_default_icon.png',
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        onPressed: () {
          parent.showBottomSheet();
        },
        icon: const Icon(Icons.more_horiz),
      ),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}
