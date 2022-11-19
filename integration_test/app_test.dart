import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_recommender/constants/genres.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    Future<void> wait(WidgetTester tester, {double times = 2}) async {
      for (int i = 0; i < times; i++) {
        await tester.pumpAndSettle(const Duration(milliseconds: 50));
      }
    }

    testWidgets(
      'log in, add new movie, verify it, remove it, log out',
      (tester) async {
        app.main();
        await wait(tester);

        // Provide credentials:
        await tester.enterText(
          find.byKey(const Key('login_page_email_field')),
          'test@test.test',
        );
        await tester.enterText(
          find.byKey(const Key('login_page_password_field')),
          '123456',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await wait(tester);

        // Tap 'Sign in' and wait for loading new page:
        await tester.tap(find.byType(ElevatedButton));
        await wait(tester, times: 30);
        expect(find.byType(ElevatedButton), findsNothing);

        // Tap FAB and wait for loading dialog:
        await tester.tap(find.byType(FloatingActionButton));
        await wait(tester, times: 10);
        expect(find.text(ADD_NEW_MOVIE), findsOneWidget);

        // Provide movie details in input fields:
        await tester.enterText(
          find.byKey(const Key('movie_dialog_title_field')),
          'Integration Test Example',
        );
        await tester.enterText(
          find.byKey(const Key('movie_dialog_director_field')),
          'Nobody',
        );
        await tester.enterText(
          find.byKey(const Key('movie_dialog_year_field')),
          '2022',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await wait(tester, times: 10);

        // Choose genre:
        await tester.tap(find.byType(DropdownButton<String>));
        await wait(tester, times: 10);
        Finder inkwells = find.byType(InkWell);
        int thirdGenrePosition = inkwells.evaluate().length - genres.length + 2;
        await tester.tap(inkwells.at(thirdGenrePosition));
        await wait(tester, times: 20);
        expect(find.text(genres[2]), findsOneWidget);

        // Set movie attributes:
        await tester.dragUntilVisible(
          find.text(genres.last),
          find.byType(AlertDialog),
          const Offset(0, -50),
        );
        for (Element element in find.byType(RatingBar).evaluate()) {
          await tester.tap(find.byWidget(element.widget));
        }
        await wait(tester, times: 20);

        // Add movie:
        await tester.tap(find.text(OK));
        await wait(tester, times: 20);

        // Check if added:
        await tester.dragUntilVisible(
          find.text('Integration Test Example'),
          find.byType(ListView),
          const Offset(0, -50),
        );
        await wait(tester, times: 20);
        expect(find.text('Integration Test Example'), findsOneWidget);

        // Remove it:
        await tester.tap(find.byIcon(Icons.close).first);
        await wait(tester, times: 20);
        expect(find.text('Integration Test Example'), findsNothing);

        // Log out:
        await tester.tap(find.byIcon(Icons.logout));
        await wait(tester, times: 20);
        expect( find.byKey(const Key('login_page_email_field')), findsOneWidget);
      },
    );
  });
}
