import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_blog/page/blogs_page.dart';


Future main() async {
  //Screen rotation settings
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
//Main page layout for home screen
class MyApp extends StatelessWidget {
  static final String title = 'Blogs SQLite';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink,
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        )),
    home: BlogsPage(), //blog page homepage method
  );
}
