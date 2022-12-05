





import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/article.dart';
import 'package:flutter_tests/article_page.dart';
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
         Article(title: "title 1", content: "contents 1"),
         Article(title: "title 2", content: "contents 2"),
    ];



      void arrangeNewServiceReturns3Articles(){
      when(() => mockNewsService.getArticles()).thenAnswer((_)  async => articlesFromService);
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


  testWidgets("Tapping on the first aeticle exerpt opens the article page where the full article content is displayed", (WidgetTester tester) async{
    arrangeNewServiceReturns3Articles();

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();

    await tester.tap(find.text("contents 1"));

    await tester.pumpAndSettle();

    expect(find.byType(NewsPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
    expect(find.text("title 1"),  findsOneWidget);

  });


  

}
