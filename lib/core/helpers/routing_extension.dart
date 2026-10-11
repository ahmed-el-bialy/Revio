import 'package:flutter/cupertino.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, [Object? arguments]) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushAndRemoveUntil({
    required String routeName,
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, [Object? arguments]) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  Future<bool> maybePop<T extends Object?>([T? result]) =>
      Navigator.of(this).maybePop(result);
}
