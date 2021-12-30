import 'package:asi_takip/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore_for_file: prefer_const_constructors

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _key=GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool isLoading=false;
  String errorMessage='';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          title: Text("Sıfırlama Maili Gönder",
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
                  height: size.height * .3,
                  width: size.width * .85,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400.withOpacity(.85),
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
                                      .resetPassword(
                                      _emailController.text)
                                      .then((value) {
                                    return Navigator.pop(context);
                                  });
                                }on FirebaseAuthException catch(error){
                                  if(error.code=='user-not-found'){
                                    errorMessage='Email does not exist.';
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
                                      "Gönder",
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

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Email address is required.';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return 'Invalid E-mail Address format.';
  }
  return null;
}