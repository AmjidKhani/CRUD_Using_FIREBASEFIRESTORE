import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class funcalling extends StatefulWidget {
  const funcalling({Key? key}) : super(key: key);

  @override
  State<funcalling> createState() => _funcallingState();
}

class _funcallingState extends State<funcalling> {
  final CollectionReference _abc=FirebaseFirestore.instance.collection("Products");

  TextEditingController textcontroller=TextEditingController();
  TextEditingController pricecontroller=TextEditingController();

                   // Create Function
  Future<void>_create([DocumentSnapshot? documentSnapshot])async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx){
          return Padding(padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom+20,
          ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textcontroller,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: pricecontroller,
                  decoration: const InputDecoration(labelText: "price"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton (
                    onPressed: () async
                    {
                      final String name=textcontroller.text;
                      final  double? price=double.tryParse( pricecontroller.text);
                      if(price!=null){

                        await _abc.add({"name":name,"price":price});
                         textcontroller.text = "";
                        pricecontroller.text = "";
                      }
                    },
                    child: const Text("ADD"))
              ],
            ),
          );
        });
  }
                   //Update Function

  Future<void>_update(DocumentSnapshot documentSnapshot)async {
    if(DocumentSnapshot!=null){

      textcontroller.text=documentSnapshot["name"];
      pricecontroller.text=documentSnapshot["price"].toString();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx){
        return Padding(padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom+20,
        ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textcontroller,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: pricecontroller,
                decoration: const InputDecoration(labelText: "price"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton (
                  onPressed: () async
                  {
                    final String name=textcontroller.text;
                  final  double? price=double.tryParse( pricecontroller.text);
                if(price!=null){
                  await _abc.doc(documentSnapshot.id).update({"name":name,"price":price});

                  textcontroller.text = "";
                  pricecontroller.text = "";
                  }
                  },
                  child: const Text("ADD"))
            ],
          ),
        );
    });
  }
                   //Delete Function
  Future<void> _delete(String ProductId)async {
    await _abc.doc(ProductId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:Text("You Have Been Successfully Delete")));
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>
          _create(),

        child:const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    body:StreamBuilder(
      stream: _abc.snapshots(),
        builder: ( context, AsyncSnapshot<QuerySnapshot> streamSnapshot)
    {
      return ListView.builder(
        itemCount: streamSnapshot.data?.docs.length,
          itemBuilder: (context, index){
          final DocumentSnapshot documentSnapshot= streamSnapshot.data!.docs[index];
          return  Card(
            margin: const EdgeInsets.all(10),
            child:ListTile(
              title: Text(documentSnapshot["name"]),
              subtitle: Text(documentSnapshot["price"].toString()),
           trailing: SizedBox(
             width: 100,
               child: Row(
                 children: [
                   IconButton(onPressed: (){
                     _update(documentSnapshot);
                   },
                       icon: const Icon(Icons.edit)),
                   IconButton(onPressed: (){
                    _delete(documentSnapshot.id);
                   },
                       icon: const Icon(Icons.delete),),
                 ],
               ),
             ),
           ),

          );
      },
      );
    }
    ),
    );
  }
}
