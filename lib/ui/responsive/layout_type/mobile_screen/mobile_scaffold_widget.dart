import 'package:flutter/material.dart';

import '../../widgets/consts/const_widgets.dart';
import '../../widgets/edit_menu/edit_menu_screen.dart';
import '../../widgets/menu/menu_widget_admin.dart';
import '../../widgets/transaction_list/transaction_admin_list.dart';

class MobileScaffoldWidget extends StatefulWidget {
  const MobileScaffoldWidget({Key? key}) : super(key: key);

  @override
  State<MobileScaffoldWidget> createState() => _MobileScaffoldWidgetState();
}

class _MobileScaffoldWidgetState extends State<MobileScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: TransactionListAdminWidget(),
      drawer: const MenuWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditMenuScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
