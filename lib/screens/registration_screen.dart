import 'package:app_parkir/firebase_auth/firebase_auth_services.dart';
import 'package:app_parkir/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();

  @override
  void dispose() {
    namaC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.dispose();
  }

  // final databaseReference =
  //     FirebaseDatabase.instance.ref("parkiran/juru_parkir"); //untuk insert lewat firebase

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: namaC,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return (" name is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid first name min 3 Character");
        }
        return null;
      },
      onSaved: (value) {
        namaC.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nama Depan",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailC,
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
        emailC.text = value!;
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
      controller: passC,
      obscureText: true,
      onSaved: (value) {
        passC.text = value!;
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
      controller: confirmPassC,
      obscureText: true,
      validator: (value) {
        if (confirmPassC.text != passC.text) {
          return "password dont match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPassC.text = value!;
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
        onPressed: () async {
          if ((_formKey.currentState!.validate())) {
            _signUp();
            // try {
            //   await databaseReference
            //       .child(DateTime.now().microsecond.toString())
            //       .set({
            //     'pegawai': namaC.text.toString(),
            //     'email': emailC.text.toString(),
            //     'password': paasC.text.toString()
            //   });

            //   showDialog<String>(
            //     context: context,
            //     builder: (BuildContext context) => AlertDialog(
            //       title: const Text('Berhasil Input Data'),
            //       content: Container(
            //         height: 200,
            //       ),
            //       actions: [
            //         TextButton(
            //             onPressed: () {
            //               Navigator.pop(context);
            //               Navigator.pushReplacement(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => LoginScreen()));
            //             },
            //             child: Text("Ke Halaman Login"))
            //       ],
            //     ),
            //   );
            // } catch (e) {}
          }

          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                          height: 200,
                          child: Image.asset(
                            "assets/images/parkdin.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        const SizedBox(height: 25),
                        firstNameField,
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

  void _signUp() async {
    String username = namaC.text;
    String email = emailC.text;
    String pass = passC.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, pass);
    if (user != null) {
      print("user berhasil ditambahkan");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
