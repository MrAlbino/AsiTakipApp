import 'package:flutter/material.dart';
import './home.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//var uuid = const Uuid();
//final FirebaseAuth _auth = FirebaseAuth.instance;


class AddChildPage extends StatefulWidget{
  const AddChildPage({Key? key}) : super(key: key);

  @override
  _AddChildPage createState()=> _AddChildPage();
}

class _AddChildPage extends State<AddChildPage>{
  double _destinationDay=1;


  //final _fs=  FirebaseFirestore.instance;


  TextEditingController nameController = TextEditingController();
  TextEditingController explanationController = TextEditingController();
  TextEditingController destinationDayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //CollectionReference todosRef= _fs.collection('todos');
    //CollectionReference todosRef= _fs.collection('testCollection');
    //CollectionReference todosRef= _fs.collection('todos');
    //CollectionReference usersRef= _fs.collection('Users');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:  Text("Asi",
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
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
                    const Text("Hedef Adı",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                    const Text("Hedef Açıklaması",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    TextFormField(
                      style: const TextStyle(
                          color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                      ),
                      controller: explanationController,
                    ),
                  ],
                )
                ),
              ),
              Expanded(
                flex: 2,
                child: MyContainer(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Hedef Gün",style:TextStyle(
                        color:Colors.black54,fontSize: 20,fontWeight: FontWeight.bold
                    ),
                    ),
                    Text(_destinationDay.round().toString(), style: const TextStyle(
                        color:Colors.lightBlue,fontSize: 25,fontWeight: FontWeight.bold
                    ),
                    ),
                    Slider(
                      thumbColor: Colors.orange,
                      max: 365,
                      min:1,
                      value: _destinationDay,
                      onChanged: (double value){
                        setState(() {
                          _destinationDay = value;

                        });
                      },
                    ),
                  ],
                )
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
      margin: const EdgeInsets.fromLTRB(12,5,12,0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)
        ,color: colorUser,
      ),
    );
  }
}