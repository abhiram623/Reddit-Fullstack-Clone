import 'package:reddit_clone/feed/feed_screen.dart';
import 'package:reddit_clone/posts/add_post_screen.dart';

class Constants {
  static const bannerDefault =
      "https://th.bing.com/th/id/OIP.gSvP3sXUyXL_rR8cgHLCkAHaDt?w=315&h=175&c=7&r=0&o=5&dpr=1.3&pid=1.7";
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';
  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
    
  ];
}