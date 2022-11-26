import 'package:flutter/material.dart';

import 'edit_meny_widget_admin.dart';

class EditMenuScreen extends StatefulWidget {
  const EditMenuScreen({Key? key}) : super(key: key);

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: EditMenuAdminWidget(),
    );
  }
}
