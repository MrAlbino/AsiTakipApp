import 'package:flutter/material.dart';
import 'dart:async';
import './home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asi_takip/service/auth.dart';
import 'login.dart';
var uuid = const Uuid();
final FirebaseAuth _auth = FirebaseAuth.instance;
AuthService _authService = AuthService();

class AddChildPage extends StatefulWidget{
  const AddChildPage({Key? key}) : super(key: key);

  @override
  _AddChildPage createState()=> _AddChildPage();
}

class _AddChildPage extends State<AddChildPage>{

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final _fs=  FirebaseFirestore.instance;


  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    CollectionReference childrenRef= _fs.collection('Children');
    CollectionReference usersRef= _fs.collection('Users');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title:  Text("Çocuk Ekle",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,

        actions: <Widget>[
          // First button - decrement
          IconButton(
            icon: const Icon(Icons.logout_outlined), // The "-" icon
            onPressed:() {
              _authService.signOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder:(context)=> LoginPage()));} // The `_decrementCounter` function
          ),

          // Second button - increment
        ],

      ),
      body:
      Form(
        child: Container(

          margin: const EdgeInsets.fromLTRB(0,0,0,12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,

                child: MyContainer(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Adı",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(

                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      controller: nameController,
                    ),
                  ],
                )
                ),
              ),
              Expanded(
                flex: 2,
                child: MyContainer(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Soyadı",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(

                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      controller: surnameController,
                    ),
                  ],
                )
                ),
              ),

              Expanded(
                flex: 2,
                child: MyContainer(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [

                    Text("${selectedDate.toLocal()}".split(' ')[0],style:const TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),),
                    const SizedBox(height: 20.0,),

                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Doğum Tarihini Seçiniz'),
                    ),
                  ],
                )
                ),
              ),
              Expanded(
                flex: 1,
                child :GestureDetector(
                  onTap: () async{

                        User? user =_auth.currentUser;
                         String userId = user!.uid;
                        Map<String, dynamic> childData= {
                           'name': nameController.text,
                          'surname': surnameController.text,
                          'parent': userId,
                          'birthOfDate': selectedDate,
                           'vaccines':[]
                         };

                         var id=uuid.v4();
                         await childrenRef.doc((id)).set(childData);

                         await usersRef.doc(userId).update({'children':FieldValue.arrayUnion([id])});
                         Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder:(context)=> const HomePage()));



                  },
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blue[200]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Oluştur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {

  final Color colorUser;
  final Widget child;
  const MyContainer({this.colorUser=Colors.white,required this.child,Key? key}) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return Container(



      child: child,
      margin: const EdgeInsets.fromLTRB(12,12,12,12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)

        ,color: colorUser,
        boxShadow: const [
          BoxShadow(
              color: Color(0xFF4ca5d8),
              offset: Offset(5, 5),
              blurRadius: 20.0,
              spreadRadius: 1.0),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-1.0, -1.0),
              blurRadius: 15.0,
              spreadRadius: 1.0),
        ],
      ),

    );
  }
}