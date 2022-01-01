import 'package:asi_takip/service/auth.dart';
import 'package:asi_takip/register.dart';
import 'package:asi_takip/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asi_takip/reset.dart';
// ignore_for_file: prefer_const_constructors

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key=GlobalKey<FormState>();
  AuthService _authService = AuthService();
  bool isLoading=false;
  String errorMessage='';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          title: Text("Hoşgeldiniz",
            style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

          ),
          centerTitle: true,
        ),
        body: Form(
            key:_key,
            child:Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .5,
                  width: size.width * .85,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400.withOpacity(.85),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: Offset(-6.0, -6.0),
                        blurRadius: 12.0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        offset: Offset(6.0, 6.0),
                        blurRadius: 10.0,
                      ),
                    ],),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              controller: _passwordController,
                              validator: validatePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                ),
                                hintText: 'Parola',
                                prefixText: ' ',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
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
                            height: size.height * 0.013,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPasswordPage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  "Şifreni mi unuttun?",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
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
                                      .signIn(
                                      _emailController.text, _passwordController.text)
                                      .then((value) {
                                    return Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  });
                                }on FirebaseAuthException catch(error){
                                  if(error.code=='user-not-found'){
                                    errorMessage='No user found with this email.';
                                  }
                                  else if(error.code=='wrong-password'){
                                    errorMessage='Wrong email/password combination.';
                                  }
                                  else{
                                    errorMessage=error.message!;
                                  }
                                }

                              }
                              if(mounted){
                                setState(() {
                                  isLoading=false;
                                });
                              }

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 2),
                                  //color: colorPrimaryShade,
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child:isLoading?
                                    SizedBox(
                                      child: CircularProgressIndicator(),
                                      height: 23.0,
                                      width: 25.0,
                                    ):
                                    Text(
                                      "Giriş yap",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 1,
                                  width: 75,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Kayıt ol",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  height: 1,
                                  width: 75,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
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