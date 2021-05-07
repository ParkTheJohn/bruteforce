import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LoginService.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // color: Colors.lightBlueAccent,
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "FitRecur",
                    textAlign: TextAlign.center,
                    textScaleFactor: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    )
                  ),
                  Text(
                    "Start your workout today",
                    textScaleFactor: 0.7,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: -150,
              child: Container(
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.center,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
              alignment: Alignment.center,
              child: TextField(
                obscureText: hidePassword,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      icon: Icon(
                          hidePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      })
                  ),
                ),
              ),
            Positioned(
              bottom: 60,
              child: Container(
                color: Colors.blue,
                // padding: EdgeInsets.all(60.0),
                margin: EdgeInsets.all(20.0),
                alignment: Alignment.bottomCenter,
                child : ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(300, 50)),
                  ),
                  onPressed: () {
                    context.read<LoginService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                  child: Text("Login"),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                // color: Colors.blue,
                // margin: EdgeInsets.all(40.0),
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.bottomCenter,
                child : ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(300, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  onPressed: () {
                    context.read<LoginService>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                  child: Text("Create Account"),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
