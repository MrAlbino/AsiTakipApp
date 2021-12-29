import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class VaccinePage extends StatefulWidget{
  final String childId;
  final String childName;
  final String childSurname;
  final int userDay;

  const VaccinePage({Key? key,required this.childId,required this.childName,required this.childSurname,required this.userDay}) : super(key: key);

  @override
  _VaccinePageState createState()=> _VaccinePageState();
}


class _VaccinePageState extends State<VaccinePage>{
  final _fs=  FirebaseFirestore.instance;



  Color getMyColor(int userDay,int vaccineDay,bool isExist) {
    if (isExist) {
      return Colors.green;
    }
    else if(vaccineDay<userDay){
      return Colors.red;

    }
    else if(vaccineDay-userDay<=7&&vaccineDay-userDay>0){
      return Colors.yellow;
    }
    return Colors.grey;
  }


  @override
  Widget build(BuildContext context) {
    var childrenRef = _fs.collection('Children').doc(widget.childId);
    var childrenRef2=_fs.collection('Children');
    CollectionReference vaccinesRef= _fs.collection('Vaccines');
    bool isExist=false;
    var vaccines=[];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title:  Text(widget.childName+' '+widget.childSurname+' '+widget.userDay.toString()+' günlük',
          style: GoogleFonts.pacifico(fontSize: 25,color:Colors.white),

        ),
        centerTitle: true,
      ),
      body:Center(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: childrenRef2.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot1){
                return StreamBuilder<QuerySnapshot>(
                  /// Neyi dinlediğimiz bilgisi, hangi streami
                  stream: vaccinesRef.snapshots(),
                  /// Streamden her yerni veri aktığında, aşağıdaki metodu çalıştır
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {

                    if (asyncSnapshot.hasError) {
                      return const Center(
                          child: Text('Bir Hata Oluştu, Tekrar Deneyiniz'));
                    } else {
                      if (asyncSnapshot.hasData) {
                        List<DocumentSnapshot> listOfDocumentSnap =
                            asyncSnapshot.data.docs;
                        List<DocumentSnapshot> listOfDocumentSnap2=asyncSnapshot1.data.docs;
                        for(var doc in listOfDocumentSnap2){
                          if(doc.id==widget.childId){

                            vaccines=doc['vaccines'];
                          }
                        }
                        return Flexible(
                          child: ListView.builder(
                            itemCount: listOfDocumentSnap.length,
                            itemBuilder: (context, index) {
                              isExist=vaccines.contains(listOfDocumentSnap[index].id);

                              return Card(
                                color:getMyColor(widget.userDay,listOfDocumentSnap[index]['ejectionDay'],isExist),

                                child: ListTile(
                                  title: Text(
                                      '${listOfDocumentSnap[index]['name']}',
                                      style: const TextStyle(fontSize: 24)),
                                  subtitle: Text(
                                      "Aşı Günü: "+(listOfDocumentSnap[index]['ejectionDay']).toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [  if(isExist)...[
                                      IconButton(
                                        icon: const Icon(Icons.undo),
                                        onPressed: () async {

                                          childrenRef.update({'vaccines':FieldValue.arrayRemove([listOfDocumentSnap[index].id])});
                                        },
                                      ),
                                    ]
                                    else if(listOfDocumentSnap[index]['ejectionDay']<widget.userDay)...[
                                        IconButton(
                                          icon: const Icon(Icons.assignment_turned_in),
                                          onPressed: () async {

                                            await childrenRef.update({'vaccines':FieldValue.arrayUnion([listOfDocumentSnap[index].id])});
                                          },
                                        ),

                                      ]
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  },
                );}
              ),
            ],
          ),
        ),
      ),
    );
  }
}
