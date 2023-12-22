import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[az]").hasMatch(value)) {
          return ("Please Enter Valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Password is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password min 3 Character");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
    //Tombol login
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        color: Colors.redAccent,
        child: const Text(
          "login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(
                        //   height: 200,
                        //   child: Image.asset(
                        //     "assets/logo.png",
                        //     fit: BoxFit.scaleDown,
                        //   ),
                        // ),
                        const SizedBox(height: 45),
                        emailField,
                        const SizedBox(height: 10),
                        passwordField,
                        const SizedBox(height: 45),
                        loginButton,
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Dont have an account? "),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const RegistrationScreen())),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.deepOrangeAccent[400],
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
