import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_family_budget/domain/use_cases/login_bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userLogin = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userLogin.text = "Oksana";
    _userPassword.text = "123456";
    return Scaffold(
      body: Container(
        color: Colors.lightGreenAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TextField(
                  controller: _userLogin,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Login ',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                child: TextField(
                  controller: _userPassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User password',
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shadowColor: Colors.greenAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(100, 50),
                  ),
                  onPressed: () {
                    final loginBloc = BlocProvider.of<LoginBloc>(context);
                    loginBloc.add(TryLoginEvent(
                        userLogin: _userLogin.text,
                        userPassword: _userPassword.text));
                  },
                  child: const Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
