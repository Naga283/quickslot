import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:quickslot_app/features/auth/domain/models/user.dart';
import 'package:quickslot_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:quickslot_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:quickslot_app/features/auth/presentation/views/login_view.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.completer);

  final Completer<User> completer;

  @override
  Future<User> createUser({required String name, required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<User> getUserById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<User> login({required String username, required String password}) {
    return completer.future;
  }
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync(
      'quickslot_login_widget_test_',
    );
    Hive.init(tempDir.path);
    await Hive.openBox('auth_cache');
    await Hive.openBox('bookings_cache');
  });

  setUp(() async {
    await Hive.box('auth_cache').clear();
    await Hive.box('bookings_cache').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  testWidgets(
    'shows loader while login is in progress and stores user on success',
    (tester) async {
      final loginCompleter = Completer<User>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(loginCompleter),
            ),
          ],
          child: const MaterialApp(home: LoginView()),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Login'));
      await tester.pump();

      expect(find.text('Logging in...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loginCompleter.complete(
        const User(
          id: '11111111-1111-4111-8111-111111111111',
          name: 'John Doe',
          email: 'john.doe@example.com',
        ),
      );
      await tester.pumpAndSettle();

      final cachedUser = Hive.box('auth_cache').get('current_user') as Map;
      expect(cachedUser['email'], 'john.doe@example.com');
    },
  );
}
