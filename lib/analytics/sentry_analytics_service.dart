import 'package:quick_log/quick_log.dart';
import 'package:sentry/sentry.dart';

/// Class that uses Sentry to log transactions.
///
/// These transactions are meant to track performance throughout parabeac_core.
class SentryService {
  static final _logger = Logger('$SentryService');
  static var transactions = <String, ISentrySpan>{};

  /// Starts a main transaction.
  ///
  /// @id The unique name of the transaction.
  /// @operation The operation that is being performed.
  /// @description Optional description of the transaction.
  static void startTransaction(String id, String operation,
      {String description}) {
    if (!transactions.containsKey(id)) {
      final transaction =
          Sentry.startTransaction(id, operation, description: description);

      transactions[id] = transaction;
    } else {
      _logger
          .error('Transaction $id already exists. Cannot start transaction.');
    }
  }

  /// Starts a child transaction from a parent transaction with a unique [id].
  ///
  /// @id The unique name of the `parent` transaction.
  /// @operation The `unique` operation that is being performed by the `child`. This will be used to identify child transactions.
  /// @description Optional description of the transaction.
  static void startChildTransactionFrom(String id, String operation,
      {String description}) {
    if (transactions.containsKey(id) && !transactions.containsKey(operation)) {
      final transaction =
          transactions[id].startChild(operation, description: description);

      transactions[operation] = transaction;
    } else {
      _logger.error(
          'Transaction \"$id\" does not exist or transaction \"$operation\" already exists. Cannot start child transaction.');
    }
  }

  /// Finishes transaction with a unique [id].
  ///
  /// @id The unique name of the transaction.
  static Future<void> finishTransaction(String id) async {
    if (transactions.containsKey(id)) {
      await transactions[id].finish();
      transactions.remove(id);
    } else {
      _logger.error(
          'Transaction $id does not exist. Cannot finish transaction.');
    }
  }
}
