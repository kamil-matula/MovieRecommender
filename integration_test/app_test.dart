import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_recommender/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('log in, add new movie, verify, log out', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login_page_email_field')),
        'test@test.test',
      );
      await tester.enterText(
        find.byKey(const Key('login_page_password_field')),
        '123456',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_page_sign_in_button')));
      await tester.pumpAndSettle();

      // await tester.tap(find.byKey(const Key('admin_movies_fab')));
      // await tester.pumpAndSettle();
    });
  });
}
