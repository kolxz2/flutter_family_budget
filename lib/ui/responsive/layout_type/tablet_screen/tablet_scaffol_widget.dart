import 'package:flutter/material.dart';

import '../../widgets/consts/const_widgets.dart';
import '../../widgets/edit_menu/edit_meny_widget_admin.dart';
import '../../widgets/menu/menu_widget_admin.dart';
import '../../widgets/transaction_list/transaction_admin_list.dart';

class TabletScaffoldWidget extends StatefulWidget {
  const TabletScaffoldWidget({Key? key}) : super(key: key);

  @override
  State<TabletScaffoldWidget> createState() => _TabletScaffoldWidgetState();
}

class _TabletScaffoldWidgetState extends State<TabletScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(children: [
        Expanded(
          child: TransactionListAdminWidget(),
          flex: 2,
        ),
        Expanded(
          child: EditMenuAdminWidget(),
          flex: 1,
        ),
      ]),
      drawer: const MenuWidget(),
    );
  }
}
