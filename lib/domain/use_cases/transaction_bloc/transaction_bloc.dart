import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../repository/transaction_repository.dart';
import '../login_bloc/login_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;
  late final StreamSubscription streamSubscription;
  final LoginBloc loginBloc;
  String userName = '';

  TransactionBloc(
      {required this.transactionRepository, required this.loginBloc})
      : super(TransactionInitial()) {
    on<GetCategoriesMembersEvent>(_getCategoriesMembersEvent);
    on<ChangedSelectedTransactionEvent>(_changedSelectedTransactionEvent);
    on<AddTransactionEvent>(_addTransactionEvent);
    on<LoadTransactionEvent>(_loadTransactionEvent);
    on<DeleteTransactionEvent>(_deleteTransactionEvent);
    on<UpdateTransactionEvent>(_updateTransactionEvent);
    on<SearchTransactionEvent>(_searchTransactionEvent);
    on<ShowStatisticEvent>(_showStatisticEvent);
    streamSubscription = loginBloc.stream.listen((logState) async {
      userName = '';
      if (logState is IsLoginState) {
        if (!logState.isAdmin) {
          userName = logState.name;
        } else {
          userName = '';
        }
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  _showStatisticEvent(
      ShowStatisticEvent event, Emitter<TransactionState> emmit) async {
    Map<String, dynamic> statistic = {};
    var categoryAndMembers = transactionRepository.getcategory();
    List<String> allCategories = await categoryAndMembers;
    double totalSum = 0;
    for (var itemCategory in allCategories) {
      double cashSum = 0;
      for (var item in _transactionsRows) {
        var transactionRow = item.cells.values.map((e) => e.value).toList();
        if (transactionRow[0] == itemCategory &&
            transactionRow[5] == "expenses") {
          cashSum += transactionRow[1];
        }
      }
      totalSum += cashSum;
      statistic[itemCategory] = cashSum;
    }
    Map<String, int> statistic2 = {};
    statistic.forEach((key, value) {
      double total = (value.floor() / totalSum.floor() * 100);
      statistic2[key] = total.toInt();
    });
    emit(StatisticState(statistic2: statistic2));
    //print(statistic2);
  }

  _searchTransactionEvent(
      SearchTransactionEvent event, Emitter<TransactionState> emmit) async {
    _searchTransactionEventRemembered = event;
    _searchedTransactionsRows.clear();
    if (event.wallet == "" &&
        event.type == "" &&
        event.isSearchingByDate == false &&
        event.tag == "") {
      _isSearching = false;
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    } else if (event.isSearchingByDate == true) {
      _isSearching = true;
      for (var item in _transactionsRows) {
        var transactionRow = item.cells.values.map((e) => e.value);
        if (transactionRow.elementAt(3).toString().substring(0, 10) ==
            event.date.toLocal().toString().substring(0, 10)) {
          _searchedTransactionsRows.add(item);
        }
      }
      emit(LoadedTransactionState(transactionRows: _searchedTransactionsRows));
    } else if (event.wallet != "") {
      _isSearching = true;
      for (var item in _transactionsRows) {
        var transactionRow = item.cells.values.map((e) => e.value);
        if (transactionRow.elementAt(4) == event.wallet) {
          _searchedTransactionsRows.add(item);
        }
      }
      emit(LoadedTransactionState(transactionRows: _searchedTransactionsRows));
    } else if (event.type != "") {
      _isSearching = true;
      for (var item in _transactionsRows) {
        var transactionRow = item.cells.values.map((e) => e.value);
        if (transactionRow.elementAt(5) == event.type) {
          _searchedTransactionsRows.add(item);
        }
      }
      emit(LoadedTransactionState(transactionRows: _searchedTransactionsRows));
    } else if (event.tag != "") {
      _isSearching = true;
      for (var item in _transactionsRows) {
        var transactionRow = item.cells.values.map((e) => e.value);
        if (transactionRow.elementAt(0) == event.tag) {
          _searchedTransactionsRows.add(item);
        }
      }
      emit(LoadedTransactionState(transactionRows: _searchedTransactionsRows));
    } else {
      _isSearching = false;
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    }
  }

  _updateTransactionEvent(
      UpdateTransactionEvent event, Emitter<TransactionState> emmit) async {
    transactionRepository.uploadTransaction(
        _transactionsRows[_selectedTransaction], event);
    var rowLine = PlutoRow(
      cells: {
        'Category_field': PlutoCell(value: event.tag),
        'Cash_field': PlutoCell(value: event.cash),
        'Member_field': PlutoCell(value: event.member),
        'date_field': PlutoCell(value: event.date),
        'Wallet_field': PlutoCell(value: event.wallet),
        'Type_field': PlutoCell(value: event.type),
      },
    );
    if (_isSearching) {
      int editedTransaction = _findCurrentTransaction(
          _searchedTransactionsRows[_selectedTransaction]);
      _searchedTransactionsRows[_selectedTransaction] = rowLine;
      _transactionsRows[editedTransaction] = rowLine;
      emit(LoadedTransactionState(transactionRows: _searchedTransactionsRows));
    } else {
      _transactionsRows[_selectedTransaction] = rowLine;
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    }
  }

  int _findCurrentTransaction(PlutoRow element) {
    int transactionIndex = 0;
    for (var item in _transactionsRows) {
      if (item == _searchedTransactionsRows[_selectedTransaction]) {
        break;
      }
      transactionIndex += 1;
    }
    return transactionIndex;
  }

  _deleteTransactionEvent(
      DeleteTransactionEvent event, Emitter<TransactionState> emmit) async {
    transactionRepository
        .deleteTransaction(_transactionsRows.elementAt(_selectedTransaction));
    if (_isSearching) {
      int editedTransaction = _findCurrentTransaction(
          _searchedTransactionsRows[_selectedTransaction]);
      _searchedTransactionsRows.removeAt(_selectedTransaction);
      _transactionsRows.removeAt(editedTransaction);
      emit(LoadedTransactionState(transactionRows: _searchedTransactionsRows));
    } else {
      _transactionsRows.removeAt(_selectedTransaction);
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    }
  }

  _loadTransactionEvent(
      LoadTransactionEvent event, Emitter<TransactionState> emmit) async {
    if (userName == '') {
      _transactionsRows = await transactionRepository.getAllTransactions();
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    } else {
      _transactionsRows =
          await transactionRepository.getMemberTransaction(userName);
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    }
  }

  _getCategoriesMembersEvent(
      GetCategoriesMembersEvent event, Emitter<TransactionState> emmit) async {
    var categoryAndMembers =
        await transactionRepository.getDateForCreatingTransaction();
    emit(GetDateForCreatingTransactionState(
        categories: categoryAndMembers[0],
        members: categoryAndMembers[1],
        type: categoryAndMembers[2],
        wallet: categoryAndMembers[3]));
  }

  _changedSelectedTransactionEvent(ChangedSelectedTransactionEvent event,
      Emitter<TransactionState> emmit) async {
    _selectedTransaction = event.selectedRow!;
  }

  _addTransactionEvent(
      AddTransactionEvent event, Emitter<TransactionState> emmit) async {
    var rowLine = PlutoRow(
      cells: {
        'Category_field': PlutoCell(value: event.tag),
        'Cash_field': PlutoCell(value: event.cash),
        'Member_field': PlutoCell(value: event.member),
        'date_field': PlutoCell(value: event.date),
        'Wallet_field': PlutoCell(value: event.wallet),
        'Type_field': PlutoCell(value: event.type),
      },
    );
    await transactionRepository.addTransaction(event);
    if (_isSearching) {
      _transactionsRows.add(rowLine);
      _searchTransactionEvent(_searchTransactionEventRemembered!, emmit);
    } else {
      _transactionsRows.add(rowLine);
      emit(LoadedTransactionState(transactionRows: _transactionsRows));
    }
  }
}
