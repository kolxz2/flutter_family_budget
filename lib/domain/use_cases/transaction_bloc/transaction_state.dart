part of 'transaction_bloc.dart';

int _selectedTransaction = -1;
List<PlutoRow> _transactionsRows = [];
List<PlutoRow> _searchedTransactionsRows = [];
bool _isSearching = false;
SearchTransactionEvent? _searchTransactionEventRemembered;

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class GetDateForCreatingTransactionState extends TransactionState {
  final List<String> categories;
  final List<String> members;
  final List<String> wallet;
  final List<String> type;

  GetDateForCreatingTransactionState(
      {required this.categories,
      required this.members,
      required this.type,
      required this.wallet});
}

class TableTransactionState extends TransactionState {
  final List<PlutoRow> transactionRows;
  TableTransactionState({required this.transactionRows});
}

class StatisticState extends TransactionState {
  final Map<String, int> statistic2;

  StatisticState({required this.statistic2});
}

class LoadedTransactionState extends TransactionState {
  final List<PlutoRow> transactionRows;
  LoadedTransactionState({required this.transactionRows});
}
