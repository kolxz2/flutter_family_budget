import 'package:flutter/material.dart';
import 'package:flutter_family_budget/domain/use_cases/transaction_bloc/transaction_bloc.dart';

class SearchAlert extends StatefulWidget {
  const SearchAlert({Key? key, required this.transactionBloc})
      : super(key: key);

  final TransactionBloc transactionBloc;

  @override
  State<SearchAlert> createState() => _SearchAlertState(transactionBloc);
}

class _SearchAlertState extends State<SearchAlert> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController category = TextEditingController();
  TextEditingController wallet = TextEditingController();
  TextEditingController type = TextEditingController();
  bool _searcherByDate = false;

  final TransactionBloc transactionBloc;

  _SearchAlertState(this.transactionBloc);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: const Text('New organisation data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            child: TextField(
              controller: category,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search by category',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 200,
            child: TextField(
              controller: wallet,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search by wallet',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 200,
            child: TextField(
              controller: type,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search by type',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: !_searcherByDate
                    ? null
                    : () {
                        _selectDate(context);
                      },
                child: Text("${_selectedDate.toLocal()}".split(' ')[0]),
              ),
              Switch(
                // This bool value toggles the switch.
                value: _searcherByDate,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    _searcherByDate = value;
                    _selectedDate = DateTime.now();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            transactionBloc.add(SearchTransactionEvent(
                date: _selectedDate,
                tag: category.text,
                wallet: wallet.text,
                isSearchingByDate: _searcherByDate,
                type: type.text));
            Navigator.pop(context);
          },
          child: const Text('Search'),
        ),
      ],
    );
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
