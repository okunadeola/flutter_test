
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/article.dart';
import 'package:flutter_tests/main.dart';
import 'package:flutter_tests/news_change_notifier.dart';
import 'package:flutter_tests/news_page.dart';
import 'package:flutter_tests/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';


class MockNewsService extends Mock implements NewsService {}

void main() {

  late MockNewsService mockNewsService;

  setUp((){
    mockNewsService = MockNewsService();
  });

    final articlesFromService = [
         Article(title: "title", content: "contents"),
    ];



      void arrangeNewServiceReturns3Articles(){
      when(() => mockNewsService.getArticles()).thenAnswer((_)  async => articlesFromService);
    }



      void arrangeNewServiceReturns3ArticlesWithDelay(){
      when(() => mockNewsService.getArticles()).thenAnswer((_)  async {
      await Future.delayed(const Duration(seconds: 2));
      return articlesFromService;

      });
    }





  Widget createWidgetUnderTest(){
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }


  testWidgets("title is displayed", (WidgetTester tester) async {
    arrangeNewServiceReturns3Articles();
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text("News"), findsOneWidget);
  });



  testWidgets("loading indicator is displayed while waiting for articles", (WidgetTester tester) async{
    arrangeNewServiceReturns3ArticlesWithDelay();
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator),    findsOneWidget);

    await tester.pumpAndSettle();

  });


  
  testWidgets("articles are displayed", (WidgetTester tester) async{
    arrangeNewServiceReturns3Articles();
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();

    for (var article  in articlesFromService) {
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content),  findsOneWidget);
    }

  });


  

}
