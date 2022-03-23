import 'package:sentry/sentry.dart';

class SentryService {
  static var transactions = <String, ISentrySpan>{};

  static void startTransaction(String name, String operation,
      {String description}) {
    final transaction =
        Sentry.startTransaction(name, operation, description: description);

    transactions[name] = transaction;
    print('#################################');
    print(transactions[name].startTimestamp);
    print('#################################');
  }

  static void startChildTransactionFrom(String id, String operation,
      {String description}) {
    final transaction =
        transactions[id].startChild(operation, description: description);

    transactions[operation] = transaction;
  }

  static Future<void> finishTransaction(String name) async {
    await transactions[name].finish();

    print('#################################');
    print(transactions[name].endTimestamp);
    print('#################################');
  }
}
