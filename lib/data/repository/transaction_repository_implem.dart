import 'package:flutter_family_budget/domain/repository/transaction_repository.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../domain/use_cases/transaction_bloc/transaction_bloc.dart';

class TransactionRepositoryImlem implements TransactionRepository {
  final String _appSupportDirectory =
      r'C:\Users\kolxz\AndroidStudioProjects\flutter_family_budget\database';

  late final String path;
  late var _database;
  final databaseFactory = databaseFactoryFfi;

  TransactionRepositoryImlem() {
    sqfliteFfiInit();
    path = "$_appSupportDirectory\\family_budget.db";
  }

  @override
  Future<List<String>> getcategory() async {
    //  List<String> result = [];
    _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> tags = await _database.query('tag');
    List<String> receivedTags = tags.map((e) => e['title'].toString()).toList();
    await _database.close();
    return receivedTags;
  }

  @override
  Future<List<List<String>>> getDateForCreatingTransaction() async {
    List<List<String>> categoriesAndMembers = [];
    _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> members = await _database.query('members');
    final List<Map<String, dynamic>> tags = await _database.query('tag');
    final List<Map<String, dynamic>> transaction_type =
        await _database.query('transaction_type');
    final List<Map<String, dynamic>> wallets = await _database.query('wallets');

    List<String> receivedMembers =
        members.map((e) => e['name'].toString()).toList();
    List<String> receivedTags = tags.map((e) => e['title'].toString()).toList();
    List<String> receivedTransaction_type =
        transaction_type.map((e) => e['title'].toString()).toList();
    List<String> receivedWallets =
        wallets.map((e) => e['bank_account_id'].toString()).toList();
    categoriesAndMembers.add(receivedTags);
    categoriesAndMembers.add(receivedMembers);
    categoriesAndMembers.add(receivedTransaction_type);
    categoriesAndMembers.add(receivedWallets);
    await _database.close();
    return categoriesAndMembers;
  }

  @override
  Future<List<PlutoRow>> getAllTransactions() async {
    _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> transactions =
        await _database.query('transactions');
    final List<Map<String, dynamic>> membersBD =
        await _database.query('members');
    final List<Map<String, dynamic>> tagsBD = await _database.query('tag');
    final List<Map<String, dynamic>> transactionTypeBD =
        await _database.query('transaction_type');
    final List<Map<String, dynamic>> walletsBD =
        await _database.query('wallets');

    List<PlutoRow> transactionRows = [];
    for (var item in transactions) {
      String tag = tagsBD[item['tag'] - 1]['title'];
      double cash = item["cash"];
      String member = membersBD[item["member"] - 1]['name'];
      DateTime date = DateTime.parse(item["date"]);
      String wallet = walletsBD[item["wallet"] - 1]['bank_account_id'];
      String type = transactionTypeBD[item["type"] - 1]['title'];
      var rowLine = PlutoRow(
        cells: {
          'Category_field': PlutoCell(value: tag),
          'Cash_field': PlutoCell(value: cash),
          'Member_field': PlutoCell(value: member),
          'date_field': PlutoCell(value: date),
          'Wallet_field': PlutoCell(value: wallet),
          'Type_field': PlutoCell(value: type),
        },
      );
      transactionRows.add(rowLine);
    }
    await _database.close();
    return transactionRows;
  }

  @override
  Future<void> addTransaction(AddTransactionEvent event) async {
    List<String> tagMemberWalletType = [];
    tagMemberWalletType
      ..add(event.tag)
      ..add(event.member)
      ..add(event.wallet)
      ..add(event.type);
    List<int> searchedIDTagMemberWalletType =
        await _searchIDTagMemberWalletType(tagMemberWalletType);
    _database = await databaseFactory.openDatabase(path);
    await _database.insert('transactions', <String, dynamic>{
      'member': searchedIDTagMemberWalletType[1],
      'tag': searchedIDTagMemberWalletType[0],
      "cash": event.cash,
      "date": event.date.toString(),
      "wallet": searchedIDTagMemberWalletType[2],
      "type": searchedIDTagMemberWalletType[3],
    });
    await _database.close();
  }

  @override
  Future<void> uploadTransaction(
      PlutoRow updatingRow, UpdateTransactionEvent event) async {
    int desiredTransactionID = await _searchTransactionID(updatingRow);
    List<String> tagMemberWalletType = [];
    tagMemberWalletType
      ..add(event.tag)
      ..add(event.member)
      ..add(event.wallet)
      ..add(event.type);
    List<int> searchedIDTagMemberWalletType =
        await _searchIDTagMemberWalletType(tagMemberWalletType);
    _database = await databaseFactory.openDatabase(path);
    await _database.rawUpdate(
        'UPDATE transactions SET member = ?, tag = ?, cash = ?, date = ?, wallet = ?, type = ? WHERE id = ?',
        [
          searchedIDTagMemberWalletType[1],
          searchedIDTagMemberWalletType[0],
          event.cash,
          event.date.toString(),
          searchedIDTagMemberWalletType[2],
          searchedIDTagMemberWalletType[3],
          desiredTransactionID
        ]);
    await _database.close();
  }

  @override
  Future<void> deleteTransaction(PlutoRow deletingRow) async {
    int deletingRowID = await _searchTransactionID(deletingRow);
    _database = await databaseFactory.openDatabase(path);
    await _database
        .delete('transactions', where: ' id = ?', whereArgs: [deletingRowID]);
    await _database.close();
  }

  Future<List<int>> _searchIDTagMemberWalletType(
      List<String> stringMemberTagTypeWallet) async {
    List<int> tagMemberWalletType = [];
    //_database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> membersBD =
        await _database.query('members');
    final List<Map<String, dynamic>> tagsBD = await _database.query('tag');
    final List<Map<String, dynamic>> transactionTypeBD =
        await _database.query('transaction_type');
    final List<Map<String, dynamic>> walletsBD =
        await _database.query('wallets');

    Map<String, dynamic> member = membersBD.firstWhere(
        (element) => element['name'] == stringMemberTagTypeWallet[1]);
    Map<String, dynamic> tag = tagsBD.firstWhere(
        (element) => element['title'] == stringMemberTagTypeWallet[0]);
    Map<String, dynamic> type = transactionTypeBD.firstWhere(
        (element) => element['title'] == stringMemberTagTypeWallet[3]);
    Map<String, dynamic> wallet = walletsBD.firstWhere((element) =>
        element['bank_account_id'] == stringMemberTagTypeWallet[2]);
    tagMemberWalletType
      ..add(tag['id'])
      ..add(member['id'])
      ..add(wallet['id'])
      ..add(type['id']);
    // await _database.close();
    return tagMemberWalletType;
  }

  Future<int> _searchTransactionID(PlutoRow desiredRow) async {
    //  _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> transactions =
        await _database.query('transactions');

    List<String> getDeletingRow =
        desiredRow.cells.values.map((e) => e.value.toString()).toList();
    List<String> tagMemberWalletType = [];
    tagMemberWalletType
      ..add(getDeletingRow[0])
      ..add(getDeletingRow[2])
      ..add(getDeletingRow[4])
      ..add(getDeletingRow[5]);
    List<int> searchedIDTagMemberWalletType =
        await _searchIDTagMemberWalletType(tagMemberWalletType);
    for (var item in transactions) {
      if (searchedIDTagMemberWalletType[1] == item['member'] &&
          searchedIDTagMemberWalletType[0] == item['tag'] &&
          double.parse(getDeletingRow[1]) == item['cash'] &&
          getDeletingRow[3].toString().substring(0, 10) ==
              item['date'].toString().substring(0, 10) &&
          searchedIDTagMemberWalletType[2] == item['wallet'] &&
          searchedIDTagMemberWalletType[3] == item['type']) {
        await _database.close();
        return item['id'];
      }
    }
    // await _database.close();
    throw Exception("Don't find transaction on Deleting");
  }

  @override
  Future<List<PlutoRow>> getMemberTransaction(String memberNameAuth) async {
    _database = await databaseFactory.openDatabase(path);
    final List<Map<String, dynamic>> transactions =
        await _database.query('transactions');
    final List<Map<String, dynamic>> membersBD =
        await _database.query('members');
    final List<Map<String, dynamic>> tagsBD = await _database.query('tag');
    final List<Map<String, dynamic>> transactionTypeBD =
        await _database.query('transaction_type');
    final List<Map<String, dynamic>> walletsBD =
        await _database.query('wallets');

    List<PlutoRow> memberTransaction = [];
    for (var item in transactions) {
      String member = membersBD[item["member"] - 1]['name'];
      if (member == memberNameAuth) {
        String tag = tagsBD[item['tag'] - 1]['title'];
        double cash = item["cash"];

        DateTime date = DateTime.parse(item["date"]);
        String wallet = walletsBD[item["wallet"] - 1]['bank_account_id'];
        String type = transactionTypeBD[item["type"] - 1]['title'];
        var rowLine = PlutoRow(
          cells: {
            'Category_field': PlutoCell(value: tag),
            'Cash_field': PlutoCell(value: cash),
            'Member_field': PlutoCell(value: member),
            'date_field': PlutoCell(value: date),
            'Wallet_field': PlutoCell(value: wallet),
            'Type_field': PlutoCell(value: type),
          },
        );
        memberTransaction.add(rowLine);
      }
    }
    await _database.close();
    return memberTransaction;
  }
}
