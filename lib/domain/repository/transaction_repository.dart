import 'package:pluto_grid/pluto_grid.dart';

import '../use_cases/transaction_bloc/transaction_bloc.dart';

abstract class TransactionRepository {
  Future<List<List<String>>> getDateForCreatingTransaction() async {
    throw Exception();
  }

  Future<List<PlutoRow>> getAllTransactions() {
    throw Exception();
  }

  Future<void> addTransaction(AddTransactionEvent event) {
    throw Exception();
  }

  Future<void> deleteTransaction(PlutoRow deletingRow) {
    throw Exception();
  }

  Future<void> uploadTransaction(
      PlutoRow updatingRow, UpdateTransactionEvent event) {
    throw Exception();
  }

  Future<List<PlutoRow>> getMemberTransaction(String member) {
    throw Exception();
  }

  Future<List<String>> getcategory() async {
    List<String> result = [];

    return result;
  }
}
