import 'package:flutter/gestures.dart';
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        //color: Colors.lightBlueAccent,
        height: size.height,
        width: double.infinity,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/logo.png',
                scale: 0.9,
              ),
              // SizedBox(height: size.height * 0.001),
              Container(
                // color: Colors.grey,
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.025),
              Container(
                width: 300,
                child: TextField(
                  obscureText: hidePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          icon: Icon(hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          })),
                ),
              ),
              SizedBox(height: size.height * 0.025),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(300, 50)),
                ),
                onPressed: () {
                  context.read<LoginService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        context: context,
                      );
                },
                child: Text("Login"),
              ),
              SizedBox(height: size.height * 0.1),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  children: <TextSpan>[
                    TextSpan(text: 'Don\'t have an account? '),
                    TextSpan(
                      text: 'Create Account',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                      appBar: new AppBar(
                                        title: Text('Create Account'),
                                      ),
                                      body: Container(
                                          height: size.height,
                                          width: double.infinity,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.grey,
                                                    width: 300,
                                                    child: TextField(
                                                      controller:
                                                          emailController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Email",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.025),
                                                  Container(
                                                    width: 300,
                                                    child: TextField(
                                                      obscureText: hidePassword,
                                                      controller:
                                                          passwordController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Password",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.025),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(Size(
                                                                  300, 50)),
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<LoginService>()
                                                          .signUp(
                                                            email:
                                                                emailController
                                                                    .text
                                                                    .trim(),
                                                            password:
                                                                passwordController
                                                                    .text
                                                                    .trim(),
                                                          );
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        Text("Create Account"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    )),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
