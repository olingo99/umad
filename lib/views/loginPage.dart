import 'package:flutter/material.dart';
import '../constanst.dart';
import 'homePage.dart';
import '../services/userService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../httpServiceWrapper.dart';



///First page of the app, the login page composed of 2 text input widgets and 2 buttons one to login and one to register

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final httpServiceWrapper = HttpServiceWrapper();
  final UserService userService = UserService();


  @override
  Widget build(BuildContext context) {
    usernameController.text = "postman";
    passwordController.text = "123456";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umad?'),
        backgroundColor: Constants().colorTopbar,
        centerTitle: true,
      ),
      body: _loginForm(),
    );
  }


  Widget _usernameField(){
    return TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                );
  }

  Widget _passwordField(){
    return TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                );
  }


  Widget __signinButton(){
    return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                              final response = userService.tryLogin(usernameController.text, passwordController.text);
                              response.then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId:value.iduser)))).catchError( (e) => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Wrong username or password')),
                                )
                              });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill input')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants().colorButton,
                          foregroundColor: Constants().colorText,
                        ),
                        child: const Text('Sign In'),
                      );
  }


  Widget __signupButton(){
    return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            try{
                              userService.checkUserName(usernameController.text).then((value) => {
                                if (value){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Username already exist')),
                                  )
                                }
                                else{
                                  userService.addUser(usernameController.text, passwordController.text).then((value) => {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId:value.iduser)))
                                  })
                                }
                              });
                            }
                            catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Wrong username or password')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill input')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants().colorButton,
                          foregroundColor: Constants().colorText,
                        ),
                        child: const Text('Sign up'),
                      );
  }

  Widget _loginForm(){
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: _usernameField(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: _passwordField(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                    child: Center(
                      child: __signinButton(),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                    child: Center(
                      child: __signupButton(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

}
