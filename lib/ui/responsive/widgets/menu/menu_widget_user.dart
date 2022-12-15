import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/use_cases/login_bloc/login_bloc.dart';

class MenuWidgetUser extends StatefulWidget {
  const MenuWidgetUser({Key? key}) : super(key: key);

  @override
  State<MenuWidgetUser> createState() => _MenuWidgetUserState();
}

class _MenuWidgetUserState extends State<MenuWidgetUser> {
  String userName = " ";
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.lightGreen,
      child: ListView(
        children: [
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is IsLoginState) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.lightGreen),
                  accountName: Text(state.name),
                  accountEmail:
                      (state.isAdmin) ? Text("Administrator") : Text(""),
                );
              }
              throw Exception("Don't now");
            },
          ),
          /*         ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Transaction list"),
            onTap: () {
              final transactionBloc = BlocProvider.of<TransactionBloc>(context);
              transactionBloc.add(GetCategoriesMembersEvent());
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DesktopAdminScaffoldWidget(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text("Statistic"),
            onTap: () {
              final transaction = BlocProvider.of<TransactionBloc>(context);
              transaction.add(ShowStatisticEvent());
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StatisticScreen(),
                ),
              );
            },
          ),*/
          SizedBox(
            height: 100,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
