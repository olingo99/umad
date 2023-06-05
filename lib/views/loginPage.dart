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
    usernameController.text = "postman";                      ///For testing purposes, fill the username and password fields with some values
    passwordController.text = "123456";                       
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umad?'),
        centerTitle: true,
      ),
      body: _loginForm(),
    );
  }

  /*
  Form field for the username in the login page
  can take any string as input
  only check if the field is empty as validation
  */
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

  /*
  Form field for the password in the login page
  can take any string as input
  only check if the field is empty as validation
  */
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

  /*
  Buttton to submit the form and try to login
  Triggers the validation chekcs on the form fields
  If validation is OK, try to login with the username and password using the userService
  */
  Widget __signinButton(){
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {                                                                                                              ///Form fields validation check
            final response = userService.tryLogin(usernameController.text, passwordController.text);                                                          ///Try to login with the username and password                                
            response.then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId:value.iduser)))).catchError( (e) => {    ///If login is OK, go to the home page
              ScaffoldMessenger.of(context).showSnackBar(                                                                                                     ///If login is not OK, show a snackbar with an error message
                const SnackBar(content: Text('Wrong username or password')),
              )
            });
        } else {                                                                                                                                              ///If validation is not OK, show a snackbar with an error message
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

  /*
  Buttton to submit the form and try to register a new account
  Triggers the validation chekcs on the form fields
  If validation is OK, try to register a new account with the username and password using the userService
  */

  Widget __signupButton(){
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {                                                                                ///Form fields validation check                             
            userService.checkUserName(usernameController.text).then((value) {                                                   ///Check if the username is already taken
              if (value){                                                                                                       ///If username is already taken, show a snackbar with an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Username already exist')),
                );
              }
              else{                                                                                                             ///If username is not taken, try to register a new account with the username and password using the userService
                userService.addUser(usernameController.text, passwordController.text).then((value) {                         
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId:value.iduser)));               ///If registration is OK, go to the home page
                }).catchError((e){                                                                                               ///If an error occurs while trying to cregister the new account, show a snackbar with an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Something went wrong')),
                  );
                });
              }
            }).catchError((e){                                                                                                   ///If an error occurs while trying to check if username exists, show a snackbar with an error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something went wrong')),
            );
            });

        } else {                                                                                                                ///If validation is not OK, show a snackbar with an error message
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



  /*
  Build the login form widget, composed of 2 text input widgets and 2 buttons one to login and one to register
  contains all the positiong of the widget
  */
  Widget _loginForm(){
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,                                                                                ///Center the widgets in the column
            mainAxisAlignment: MainAxisAlignment.center,                                                                                  ///Center the widgets in the cross axis                   
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
