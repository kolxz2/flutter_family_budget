import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../domain/use_cases/transaction_bloc/transaction_bloc.dart';

List<PlutoColumn> columns = [
  /// Datetime Column definition
  PlutoColumn(
    title: 'Category',
    field: 'Category_field',
    type: PlutoColumnType.text(),
  ),

  /// Datetime Column definition
  PlutoColumn(
    title: 'Cash',
    field: 'Cash_field',
    type: PlutoColumnType.number(),
  ),

  /// Datetime Column definition
  PlutoColumn(
    title: 'Date',
    field: 'date_field',
    type: PlutoColumnType.date(),
  ),

  /// Number Column definition
  PlutoColumn(
    title: 'Member',
    field: 'Member_field',
    type: PlutoColumnType.text(),
  ),

  /// Number Column definition
  PlutoColumn(
    title: 'Wallet',
    field: 'Wallet_field',
    type: PlutoColumnType.text(),
  ),

  /// Number Column definition
  PlutoColumn(
    title: 'Type',
    field: 'Type_field',
    type: PlutoColumnType.text(),
  ),
];

class TransactionListAdminWidget extends StatefulWidget {
  const TransactionListAdminWidget({Key? key}) : super(key: key);

  @override
  State<TransactionListAdminWidget> createState() =>
      _TransactionListAdminWidgetState();
}

class _TransactionListAdminWidgetState
    extends State<TransactionListAdminWidget> {
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is LoadedTransactionState) {
          stateManager.removeAllRows();
          stateManager.appendRows(state.transactionRows);
        }
      },
      builder: (context, state) {
        return PlutoGrid(
          mode: PlutoGridMode.selectWithOneTap,
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.equal),
          ),
          columns: columns,
          rows: [],
          onSelected: (PlutoGridOnSelectedEvent event) {
            final tableOrganisationBloc =
                BlocProvider.of<TransactionBloc>(context);
            tableOrganisationBloc.add(
                ChangedSelectedTransactionEvent(selectedRow: event.rowIdx));
            //  print(event.rowIdx);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            // print(event);
          },
          onLoaded: (PlutoGridOnLoadedEvent event) =>
              stateManager = event.stateManager,
        );
      },
    );
  }
}
