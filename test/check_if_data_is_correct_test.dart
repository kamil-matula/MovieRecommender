import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthCubit cubit = AuthCubit(isTest: true);

  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.EMPTY_EMAIL', () {
    const expected = AuthEnum.EMPTY_EMAIL;

    test('empty email and password', () async {
      final actual = await cubit.checkIfDataIsCorrect('', '', isTest: true);
      expect(actual, expected);
    });

    test('empty email, password and repeatedPassword', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        '',
        '',
        repeatedPassword: '',
        isTest: true,
      );
      expect(actual, expected);
    });

    test('empty email and set password', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        '',
        'password',
        isTest: true,
      );
      expect(actual, expected);
    });

    test(
        'empty email and set password and repeatedPassword '
        'which are the same', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        '',
        'password',
        repeatedPassword: 'password',
        isTest: true,
      );
      expect(actual, expected);
    });

    test(
        'empty email and set password and repeatedPassword '
        'which are not the same', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        '',
        'password',
        repeatedPassword: 'password1',
        isTest: true,
      );
      expect(actual, expected);
    });
  });

  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.EMPTY_PASSWORD', () {
    const expected = AuthEnum.EMPTY_PASSWORD;

    test('set email and empty password', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        'email',
        '',
        isTest: true,
      );
      expect(actual, expected);
    });

    test('set email and empty password and repeatedPassword', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        'email',
        '',
        repeatedPassword: '',
        isTest: true,
      );
      expect(actual, expected);
    });

    test('set email and repeatedPassword but password is empty', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        'email',
        '',
        repeatedPassword: 'password',
        isTest: true,
      );
      expect(actual, expected);
    });
  });

  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.WRONG_REPEATED_PASSWORD', () {
    const expected = AuthEnum.WRONG_REPEATED_PASSWORD;

    test('set email and password but empty repeatedPassword', () async {
      final actual = await cubit.checkIfDataIsCorrect(
        'email',
        'password',
        repeatedPassword: '',
        isTest: true,
      );
      expect(actual, expected);
    });

    test('set email, password and repeatedPassword which are not the same',
        () async {
      final actual = await cubit.checkIfDataIsCorrect(
        'email',
        'password',
        repeatedPassword: 'password2',
        isTest: true,
      );
      expect(actual, expected);
    });
  });
  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.CORRECT_INPUT', () {
    const expected = AuthEnum.CORRECT_INPUT;

    test('set email, password and repeatedPassword which are the same',
        () async {
      final actual = await cubit.checkIfDataIsCorrect(
        'email',
        'password',
        repeatedPassword: 'password',
        isTest: true,
      );
      expect(actual, expected);
    });
  });
}
