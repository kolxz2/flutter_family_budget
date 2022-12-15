import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_family_budget/domain/use_cases/login_bloc/login_bloc.dart';
import 'package:flutter_family_budget/ui/responsive/widgets/edit_menu/search_alert/search_alert.dart';

import '../../../../../domain/use_cases/transaction_bloc/transaction_bloc.dart';

class EditMenuUserWidget extends StatefulWidget {
  const EditMenuUserWidget({Key? key}) : super(key: key);

  @override
  State<EditMenuUserWidget> createState() => _EditMenuUserWidgetState();
}

class _EditMenuUserWidgetState extends State<EditMenuUserWidget> {
  late List<String> members = ['Transport', 'Medicine', 'Cherety', 'Food'];
  late List<String> tags = ['Transport', 'Medicine', 'Cherety', 'Food'];
  late List<String> type = ['Transport', 'Medicine', 'Cherety', 'Food'];
  late List<String> wallet = ['Transport', 'Medicine', 'Cherety', 'Food'];
  DateTime _selectedDate = DateTime.now();
  late String _selectedMember;
  late String _selectedCategory = tags.first;
  late String _selectedWallet = wallet.first;
  late String _selectedType = type.first;

  String userName = '';

  final TextEditingController _enteredCash = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      var state = BlocProvider.of<LoginBloc>(context).state;
      if (state is IsLoginState) {
        userName = state.name;
      }
    });
    return BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
      if (state is GetDateForCreatingTransactionState) {
        setState(() {
          tags = state.categories;
          type = state.type;
          wallet = state.wallet;
          _selectedCategory = tags.first;
          _selectedType = type.first;
          _selectedWallet = wallet.first;
          final transactionBloc = BlocProvider.of<TransactionBloc>(context);
          transactionBloc.add(LoadTransactionEvent());
        });
      }
    }, builder: (context, state) {
      Future.delayed(Duration.zero, () {
        if (state is GetDateForCreatingTransactionState) {
          setState(() {
            tags = state.categories;
            type = state.type;
            wallet = state.wallet;
            _selectedCategory = tags.first;

            _selectedType = type.first;
            _selectedWallet = wallet.first;
            final transactionBloc = BlocProvider.of<TransactionBloc>(context);
            transactionBloc.add(LoadTransactionEvent());
          });
        }
      });
      return ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("Transaction coast"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _enteredCash,
                      maxLines: 1,
                      // на телефоне открывает цыфры
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Text("₽", style: TextStyle(fontSize: 30)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Type coast"),
              DropdownButton<String>(
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                value: _selectedCategory,
                items: tags.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Transaction date"),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Select wallet"),
              DropdownButton<String>(
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedWallet = value!;
                  });
                },
                value: _selectedWallet,
                items: wallet.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Select type transaction"),
              DropdownButton<String>(
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedType = value!;
                  });
                },
                value: _selectedType,
                items: type.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  final transactionBloc =
                      BlocProvider.of<TransactionBloc>(context);
                  final loginBlocState =
                      BlocProvider.of<LoginBloc>(context).state;
                  if (loginBlocState is IsLoginState) {
                    transactionBloc.add(AddTransactionEvent(
                        date: _selectedDate,
                        cash: double.parse(_enteredCash.text),
                        member: loginBlocState.name,
                        tag: _selectedCategory,
                        wallet: _selectedWallet,
                        type: _selectedType));
                  }
                },
                child: Text("Add transaction"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightGreen)),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  final transactionBloc =
                      BlocProvider.of<TransactionBloc>(context);
                  transactionBloc.add(UpdateTransactionEvent(
                      date: _selectedDate,
                      cash: double.parse(_enteredCash.text),
                      member: _selectedMember,
                      tag: _selectedCategory,
                      wallet: _selectedWallet,
                      type: _selectedType));
                },
                child: Text("Edit transaction"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightGreen)),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  final tableOrganisationBloc =
                      BlocProvider.of<TransactionBloc>(context);
                  // _addContractAlert(tableOrganisationBloc);
                  showDialog(
                      context: context,
                      builder: (context) =>
                          SearchAlert(transactionBloc: tableOrganisationBloc));
                },
                child: Text("Search transaction"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightGreen)),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  final transactionBloc =
                      BlocProvider.of<TransactionBloc>(context);
                  transactionBloc.add(DeleteTransactionEvent());
                },
                child: Text("Delete transaction"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
            ],
          )
        ],
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
