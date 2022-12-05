import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tests/news_change_notifier.dart';
import 'package:flutter_tests/news_page.dart';
import 'package:flutter_tests/news_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(NewsService()),
        child: NewsPage(),
      ),
    );
  }
}
