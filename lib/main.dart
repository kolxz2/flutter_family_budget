import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_family_budget/domain/use_cases/login_bloc/login_bloc.dart';
import 'package:flutter_family_budget/domain/use_cases/transaction_bloc/transaction_bloc.dart';
import 'package:flutter_family_budget/ui/responsive/layout_type/desktop_screen/desktop_scaffol_widget.dart';
import 'package:flutter_family_budget/ui/responsive/layout_type/mobile_screen/mobile_scaffold_widget.dart';
import 'package:flutter_family_budget/ui/responsive/resposive_layout.dart';
import 'package:window_size/window_size.dart';

import 'data/repository/login_user_data_implementation.dart';
import 'data/repository/transaction_repository_implem.dart';
import 'ui/responsive/layout_type/tablet_screen/tablet_scaffol_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Flutter Demo');
    setWindowMinSize(const Size(300, 300));
    setWindowMaxSize(Size.infinite);
  }
  runApp(BlocWrapper());
}

class BlocWrapper extends StatelessWidget {
  BlocWrapper({Key? key}) : super(key: key);

  // final TablesRepository repository = TablesRepositoryImplementation();
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = LoginBloc(
        loginUserDataRepositoryImplementation:
            LoginUserDataRepositoryImplementation());
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => loginBloc,
        ),
        BlocProvider(
          create: (context) => TransactionBloc(
              transactionRepository: TransactionRepositoryImlem(),
              loginBloc: loginBloc),
        )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ResponsiveLayout(
        mobileScaffold: MobileScaffoldWidget(),
        desktopScaffold: DesktopScreen(),
        tabletScaffold: TabletScaffoldWidget(),
      ),
    );
  }
}
