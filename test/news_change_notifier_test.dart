import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/article.dart';
import 'package:flutter_tests/news_change_notifier.dart';
import 'package:flutter_tests/news_service.dart';
import 'package:mocktail/mocktail.dart';




class MockNewsService extends Mock implements NewsService {}





void main(){
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp((){
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test("initial values are correct", (){
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });



  group("getArticles", (){
    final articlesFromService = [
         Article(title: "title", content: "contents"),
        Article(title: "title", content: "contents"),
        Article(title: "title", content: "contents")
    ];

    void arrangeNewsServiceReturns3Articles(){
      when(() => mockNewsService.getArticles()).thenAnswer((_)  async => articlesFromService);
    }


    test(
      "gets articles using the NewsService",
      () async {
        arrangeNewsServiceReturns3Articles();
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );


    test(
      """indicates loading of data, 
          sets articles to the ones from the service,
          indicates that the data is not being loaded anymore
      """,
      () async {
          arrangeNewsServiceReturns3Articles();
          final future = sut.getArticles();
          expect(sut.isLoading, true);
          await future;
          expect(sut.articles, articlesFromService);
          expect(sut.isLoading, false);
      },
    );


  });


}


