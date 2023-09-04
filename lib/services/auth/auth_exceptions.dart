// Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordFoundAuthException implements Exception {}

//Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyinUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
