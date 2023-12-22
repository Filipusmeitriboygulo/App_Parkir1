import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstnameEditingController = TextEditingController();
  final secondnameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmpassEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstnameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("first name is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid first name min 3 Character");
        }
        return null;
      },
      onSaved: (value) {
        firstnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nama Depan",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondnameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Second Name is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Second Name min 3 Character");
        }
        return null;
      },
      onSaved: (value) {
        secondnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nama Belakang",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("email is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Email Format");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Password is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password");
        }
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final confirmPassField = TextFormField(
      autofocus: false,
      controller: confirmpassEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmpassEditingController.text !=
            passwordEditingController.text) {
          return "password dont match";
        }
        return null;
      },
      onSaved: (value) {
        confirmpassEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.red),
              onPressed: () {},
            )),
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
                        SizedBox(
                          height: 150,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 25),
                        firstNameField,
                        const SizedBox(height: 25),
                        secondNameField,
                        const SizedBox(height: 25),
                        emailField,
                        const SizedBox(height: 25),
                        passwordField,
                        const SizedBox(height: 25),
                        confirmPassField,
                        const SizedBox(height: 25),
                        signUpButton,
                        const SizedBox(height: 25),
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
