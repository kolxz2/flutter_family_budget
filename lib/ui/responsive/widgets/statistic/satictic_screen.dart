import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_family_budget/ui/responsive/widgets/statistic/statistic_widget.dart';

import '../menu/menu_widget_admin.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Expanded(child: MenuWidget()),
        Expanded(
          child: StatisticWidget(),
          flex: 3,
        ),
      ]),
    );
  }
}
