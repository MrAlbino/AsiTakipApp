import 'package:asi_takip/service/auth.dart';
import 'package:asi_takip/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore_for_file: prefer_const_constructors

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController = TextEditingController();
  final GlobalKey<FormState> _key=GlobalKey<FormState>();
  String errorMessage='';
  bool isLoading=false;
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          title: Text("Kayıt Ol",
            style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

          ),
          centerTitle: true,
        ),
        body: Form(
            key:_key,
            child:Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: size.height * .65,
                      width: size.width * .85,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400.withOpacity(.8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.75),
                                blurRadius: 10,
                                spreadRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                  controller: _nameController,
                                  validator: validateUsername,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Kullanıcı adı',
                                    prefixText: ' ',
                                    hintStyle: TextStyle(color: Colors.white),
                                    focusColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  )),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFormField(
                                  controller: _emailController,
                                  validator: validateEmail,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                    ),
                                    hintText: 'E-Mail',
                                    prefixText: ' ',
                                    hintStyle: TextStyle(color: Colors.white),
                                    focusColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  )),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  validator: validatePassword,
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Parola',
                                    prefixText: ' ',
                                    hintStyle: TextStyle(color: Colors.white),
                                    focusColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  )),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  controller: _passwordAgainController,
                                  validator: (val){
                                    if(val!=_passwordController.text){
                                      return 'Passwords do not match.';
                                    }
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Parola Tekrar',
                                    prefixText: ' ',
                                    hintStyle: TextStyle(color: Colors.white),
                                    focusColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  )),

                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Center(
                                child: Text(errorMessage,style: TextStyle(color: Colors.red),),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              InkWell(
                                onTap: () async{
                                  setState(() {
                                    isLoading=true;
                                    errorMessage='';

                                  });
                                  if(_key.currentState!.validate()){
                                    try{
                                      await _authService
                                          .register(
                                          _nameController.text,
                                          _emailController.text,
                                          _passwordController.text)
                                          .then((value) {
                                        return Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage()));
                                      });
                                    }on FirebaseAuthException catch(error){
                                      errorMessage=error.message!;
                                    }

                                  }
                                  setState(() {
                                    isLoading=false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 2),
                                      //color: colorPrimaryShade,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                        child: isLoading?
                                        SizedBox(
                                          child: CircularProgressIndicator(),
                                          height: 23.0,
                                          width: 25.0,
                                        ):
                                        Text(
                                          "Kaydet",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            )));
  }
}

String? validateUsername(String? formUsername){
  if(formUsername==null||formUsername.isEmpty){
    return 'Username is required';
  }
  return null;
}
String? validateEmail(String? formEmail){
  if(formEmail==null||formEmail.isEmpty){
    return 'Email address is required.';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)){
    return 'Invalid E-mail Address format.';
  }
  return null;
}
String? validatePassword(String? formPassword){
  if(formPassword==null||formPassword.isEmpty){
    return 'Password is required.';
  }
  return null;
}