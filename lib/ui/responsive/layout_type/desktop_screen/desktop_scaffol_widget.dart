import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_family_budget/domain/use_cases/login_bloc/login_bloc.dart';
import 'package:flutter_family_budget/domain/use_cases/transaction_bloc/transaction_bloc.dart';
import 'package:flutter_family_budget/ui/responsive/widgets/transaction_list/transaction_user_list.dart';

import '../../widgets/edit_menu/edit_meny_widget_admin.dart';
import '../../widgets/edit_menu/edit_meny_widget_user.dart';
import '../../widgets/login_page.dart';
import '../../widgets/menu/menu_widget_admin.dart';
import '../../widgets/menu/menu_widget_user.dart';
import '../../widgets/transaction_list/transaction_admin_list.dart';

class DesktopAdminScaffoldWidget extends StatelessWidget {
  const DesktopAdminScaffoldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Expanded(child: MenuWidget()),
        Expanded(
          child: TransactionListAdminWidget(),
          flex: 3,
        ),
        Expanded(
          child: EditMenuAdminWidget(),
          flex: 1,
        ),
      ]),
    );
  }
}

class DesktopUserScaffoldWidget extends StatelessWidget {
  const DesktopUserScaffoldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: MenuWidgetUser()),
          Expanded(
            child: TransactionListUserWidget(),
            flex: 3,
          ),
          Expanded(
            child: EditMenuUserWidget(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is IsLoginState) {
          if (state.isAdmin) {
            final transactionBloc = BlocProvider.of<TransactionBloc>(context);
            transactionBloc.add(GetCategoriesMembersEvent());
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DesktopAdminScaffoldWidget(),
              ),
            );
          } else {
            final transactionBloc = BlocProvider.of<TransactionBloc>(context);
            transactionBloc.add(GetCategoriesMembersEvent());
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DesktopUserScaffoldWidget(),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return LoginPage();
      },
    );
  }
}
