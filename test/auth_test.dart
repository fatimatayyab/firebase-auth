import 'package:test/test.dart';
import 'package:testproject/services/auth/auth_exceptions.dart';
import 'package:testproject/services/auth/auth_provider.dart';
import 'package:testproject/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialied to begin with', () {
      expect(provider.isinitialized, false);
    });

    test('Cannot Logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isinitialized, true);
    });
    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isinitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'abcd@gmail.com',
        password: 'anypw',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser =
          provider.createUser(email: 'some@gmail.com', password: '123');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordFoundAuthException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Logged In user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to logout and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isinitialized = false;
  bool get isinitialized => _isinitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isinitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isinitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isinitialized) throw NotInitializedException();
    if (email == 'abcd@gmail.com') throw UserNotFoundAuthException();
    if (password == '123') throw WrongPasswordFoundAuthException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false,
      email: 'abcd@gmail.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isinitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isinitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'abcd@gmail.com',
    );
    _user = newUser;
  }
}
