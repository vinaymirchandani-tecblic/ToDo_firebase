import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var email = '';
  var password = '';
  var username = '';
  bool isLoginForm = false;

  startAuthetication() {
    //_formkey is an object of Global key which is used to identify any widget in the tree
    //Current state gives the current state of the form
    //The validate validates all the fields

    final validity = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (validity!) {
      _formKey.currentState?.save();
      submitForm(email,password,username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;

    try {
      if (isLoginForm) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String? uid = userCredential.user?.uid;

    //     Finally, the FirebaseFirestore instance is used to access the "users" collection and create a new
    // document with the uid as its ID using the doc() method. The set() method is then used to add the username
    // and email values to the document as key-value pairs in a JavaScript object. This creates a new document
    // in the "users" collection for the new user, with their uid, username, and email stored within it.
        await FirebaseFirestore.instance.collection('users').doc(uid).set({'username':username,'email':email});

      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!isLoginForm)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) =>
                        value!.isEmpty ? "Incorrect Username" : null,
                        onSaved: (value) => username = value!,
                        decoration: InputDecoration(
                          hintText: "Enter username",
                          hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder( borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: "Username",
                          labelStyle: GoogleFonts.roboto(),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return "Incorrect Email";
                        }
                        return null;
                      },
                      onSaved: (value) => email = value!,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "E-mail",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      obscuringCharacter: "*",
                      validator: (value) =>
                      value!.isEmpty ? "Incorrect Password" : null,
                      onSaved: (value) => password = value!,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "Password",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                        padding: EdgeInsets.all(5.0),
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(21.0)),
                              ),
                              backgroundColor: Colors.purple),
                          onPressed: () {
                            startAuthetication();
                          },
                          child: isLoginForm
                              ? Text(
                            "Login",
                            style: GoogleFonts.roboto(fontSize: 16),
                          )
                              : Text(
                            "Signup",
                            style: GoogleFonts.roboto(fontSize: 16),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLoginForm = !isLoginForm;
                            });
                          },
                          child: isLoginForm
                              ? RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  children: [
                                    TextSpan(
                                        text: "Not a member",
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.underline)),
                                    TextSpan(text: " ?")
                                  ]))
                              : RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.blue),
                                  children: [
                                    TextSpan(
                                        text: "Already a member",
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.underline)),
                                    TextSpan(text: " ?")
                                  ]))),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
