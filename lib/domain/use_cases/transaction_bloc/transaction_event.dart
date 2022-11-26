part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class GetCategoriesMembersEvent extends TransactionEvent {}

class ChangedSelectedTransactionEvent extends TransactionEvent {
  final int? selectedRow;
  ChangedSelectedTransactionEvent({required this.selectedRow});
}

class AddTransactionEvent extends TransactionEvent {
  final double cash;
  final DateTime date;
  final String tag;
  final String member;
  final String type;
  final String wallet;
  AddTransactionEvent(
      {required this.date,
      required this.cash,
      required this.member,
      required this.tag,
      required this.wallet,
      required this.type});
}

class LoadTransactionEvent extends TransactionEvent {}

class ShowStatisticEvent extends TransactionEvent {}

class DeleteTransactionEvent extends TransactionEvent {}

class UpdateTransactionEvent extends TransactionEvent {
  final double cash;
  final DateTime date;
  final String tag;
  final String member;
  final String type;
  final String wallet;
  UpdateTransactionEvent(
      {required this.date,
      required this.cash,
      required this.member,
      required this.tag,
      required this.wallet,
      required this.type});
}

class SearchTransactionEvent extends TransactionEvent {
  final DateTime date;
  final String tag;
  final String type;
  final String wallet;
  final bool isSearchingByDate;
  SearchTransactionEvent(
      {required this.date,
      required this.tag,
      required this.wallet,
      required this.isSearchingByDate,
      required this.type});
}
