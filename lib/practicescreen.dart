import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class firstscreen extends StatefulWidget {
  const firstscreen({Key? key}) : super(key: key);

  @override
  State<firstscreen> createState() => _firstscreenState();
}
class _firstscreenState extends State<firstscreen> {
  final CollectionReference _abc=FirebaseFirestore.instance.collection("Products");
  TextEditingController textcontroller=TextEditingController();
  TextEditingController pricecontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:StreamBuilder(
          stream:_abc.snapshots(),
          builder: ( context, AsyncSnapshot<QuerySnapshot>streamSnapshot)
           {
            if(streamSnapshot.hasData){
              return ListView.builder(
                  itemCount:streamSnapshot.data?.docs.length,
                  itemBuilder: (context, index)
                  {
                    final DocumentSnapshot documentSnapshot=streamSnapshot.data!.docs[index];
                   return Card(
                     margin: const EdgeInsets.all(10),

                     child: ListTile(
                       title: Text(documentSnapshot["name"]),
                       subtitle: Text(documentSnapshot["price"]),

                     )

                   ) ;
                  }

              );
            }
            return const Center
              (child: CircularProgressIndicator());
           },

        )
    );
  }
}
