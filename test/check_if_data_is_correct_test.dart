import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';

void main() {
  AuthCubit cubit = AuthCubit(isTest: true);
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController repeatedPasswordController;

  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.EMPTY_EMAIL', () {
    const expected = AuthEnum.EMPTY_EMAIL;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      repeatedPasswordController = TextEditingController();
    });

    test('unset email and password', () {
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
      );
      expect(actual, expected);
    });

    test('unset email, password and repeatedPassword', () {
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('empty email and password', () {
      emailController.text = '';
      passwordController.text = '';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
      );
      expect(actual, expected);
    });

    test('empty email, password and repeatedPassword', () {
      emailController.text = '';
      passwordController.text = '';
      repeatedPasswordController.text = '';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('empty email and set password', () {
      emailController.text = '';
      passwordController.text = 'password';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
      );
      expect(actual, expected);
    });

    test(
        'empty email and set password and repeatedPassword '
        'which are the same', () {
      emailController.text = '';
      passwordController.text = 'password';
      repeatedPasswordController.text = 'password';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test(
        'empty email and set password and repeatedPassword '
        'which are not the same', () {
      emailController.text = '';
      passwordController.text = 'password';
      repeatedPasswordController.text = 'password1';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });
  });

  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.EMPTY_PASSWORD', () {
    const expected = AuthEnum.EMPTY_PASSWORD;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      repeatedPasswordController = TextEditingController();
    });

    test('set email and unset password', () {
      emailController.text = 'email';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
      );
      expect(actual, expected);
    });

    test('set email and unset password and repeatedPassword', () {
      emailController.text = 'email';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('set email and empty password', () {
      emailController.text = 'email';
      passwordController.text = '';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
      );
      expect(actual, expected);
    });

    test('set email and empty password and repeatedPassword', () {
      emailController.text = 'email';
      passwordController.text = '';
      repeatedPasswordController.text = '';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('set email and repeatedPassword but password is unset', () {
      emailController.text = 'email';
      repeatedPasswordController.text = 'password';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('set email and repeatedPassword but password is empty', () {
      emailController.text = 'email';
      passwordController.text = '';
      repeatedPasswordController.text = 'password';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });
  });

  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.WRONG_REPEATED_PASSWORD', () {
    const expected = AuthEnum.WRONG_REPEATED_PASSWORD;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      repeatedPasswordController = TextEditingController();
    });

    test('set email and password but unset repeatedPassword', () {
      emailController.text = 'email';
      passwordController.text = 'password';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('set email and password but empty repeatedPassword', () {
      emailController.text = 'email';
      passwordController.text = 'password';
      repeatedPasswordController.text = '';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });

    test('set email, password and repeatedPassword which are not the same', () {
      emailController.text = 'email';
      passwordController.text = 'password';
      repeatedPasswordController.text = 'password2';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });
  });
  group(
      'check_if_data_is_correct_test: '
      'every tests should return AuthEnum.CORRECT_INPUT', () {
    const expected = AuthEnum.CORRECT_INPUT;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      repeatedPasswordController = TextEditingController();
    });

    test('set email, password and repeatedPassword which are the same', () {
      emailController.text = 'email';
      passwordController.text = 'password';
      repeatedPasswordController.text = 'password';
      final actual = cubit.checkIfDataIsCorrect(
        emailController.text,
        passwordController.text,
        repeatedPassword: repeatedPasswordController.text,
      );
      expect(actual, expected);
    });
  });
}
