import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';

void main() {
  AuthCubit cubit = AuthCubit(isTest: true);

  group(
    'check_if_data_is_correct_test: '
    'every test should return AuthEnum.EMPTY_EMAIL',
    () {
      const AuthEnum expected = AuthEnum.EMPTY_EMAIL;

      test(
        'empty email and password',
        () async {
          AuthEnum actual = await cubit.validateAuthData('', '');
          expect(actual, expected);
        },
      );

      test(
        'empty email, password and repeatedPassword',
        () async {
          AuthEnum actual =
              await cubit.validateAuthData('', '', repeatedPassword: '');
          expect(actual, expected);
        },
      );

      test(
        'empty email and set password',
        () async {
          AuthEnum actual = await cubit.validateAuthData('', 'password');
          expect(actual, expected);
        },
      );

      test(
        'empty email and set password and repeatedPassword '
        'which are the same',
        () async {
          AuthEnum actual = await cubit.validateAuthData(
            '',
            'password',
            repeatedPassword: 'password',
          );
          expect(actual, expected);
        },
      );

      test(
        'empty email and set password and repeatedPassword '
        'which are not the same',
        () async {
          AuthEnum actual = await cubit.validateAuthData(
            '',
            'password',
            repeatedPassword: 'password1',
          );
          expect(actual, expected);
        },
      );
    },
  );

  group(
    'check_if_data_is_correct_test: '
    'every tests should return AuthEnum.EMPTY_PASSWORD',
    () {
      const AuthEnum expected = AuthEnum.EMPTY_PASSWORD;

      test(
        'set email and empty password',
        () async {
          AuthEnum actual = await cubit.validateAuthData('email', '');
          expect(actual, expected);
        },
      );

      test(
        'set email and empty password and repeatedPassword',
        () async {
          AuthEnum actual = await cubit.validateAuthData(
            'email',
            '',
            repeatedPassword: '',
          );
          expect(actual, expected);
        },
      );

      test(
        'set email and repeatedPassword but password is empty',
        () async {
          AuthEnum actual = await cubit.validateAuthData(
            'email',
            '',
            repeatedPassword: 'password',
          );
          expect(actual, expected);
        },
      );
    },
  );

  group(
    'check_if_data_is_correct_test: '
    'every tests should return AuthEnum.WRONG_REPEATED_PASSWORD',
    () {
      const AuthEnum expected = AuthEnum.WRONG_REPEATED_PASSWORD;

      test(
        'set email and password but empty repeatedPassword',
        () async {
          AuthEnum actual = await cubit.validateAuthData(
            'email',
            'password',
            repeatedPassword: '',
          );
          expect(actual, expected);
        },
      );

      test(
        'set email, password and repeatedPassword which are not the same',
        () async {
          AuthEnum actual = await cubit.validateAuthData(
            'email',
            'password',
            repeatedPassword: 'password2',
          );
          expect(actual, expected);
        },
      );
    },
  );

  group(
    'check_if_data_is_correct_test: '
    'every tests should return AuthEnum.CORRECT_INPUT',
    () {
      const AuthEnum expected = AuthEnum.CORRECT_INPUT;

      test(
        'set email, password',
        () async {
          final AuthEnum actual =
              await cubit.validateAuthData('email', 'password');
          expect(actual, expected);
        },
      );

      test(
        'set email, password and repeatedPassword which are the same',
        () async {
          final AuthEnum actual = await cubit.validateAuthData(
            'email',
            'password',
            repeatedPassword: 'password',
          );
          expect(actual, expected);
        },
      );
    },
  );
}
