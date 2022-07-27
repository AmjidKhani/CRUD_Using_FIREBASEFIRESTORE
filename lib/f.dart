
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class notfirstattept extends StatefulWidget {
  const notfirstattept({Key? key}) : super(key: key);

  @override
  State<notfirstattept> createState() => _notfirstatteptState();
}

class _notfirstatteptState extends State<notfirstattept> {
  final CollectionReference _khan =FirebaseFirestore.instance.collection("Products");
  final TextEditingController namecontroller=TextEditingController();
  final TextEditingController pricecontroller=TextEditingController();
  Future<void> created([DocumentSnapshot? documentSnapshot])async {

    await showModalBottomSheet(
      isScrollControlled: true,
      context:context,
      builder: (BuildContext ctx) {
        return Padding(padding: EdgeInsets.only
          (
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom+20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: namecontroller,
                decoration: const InputDecoration(labelText: "Name"),

              ),
              TextField(
                controller: pricecontroller,
                decoration: const InputDecoration(labelText: "price"),
                keyboardType:const TextInputType.numberWithOptions(),
              ),
              const SizedBox(
                height: 20,

              ),

              ElevatedButton(
                  onPressed: ()async
                  {
                    final String name=namecontroller.text;
                    final double? price =double.tryParse( pricecontroller.text);
                    await _khan.add({"name":name,"price":price});
                    pricecontroller.text="";
                    namecontroller.text="";
                  },
                  child: const Text("ADD")
              )

            ],
          ),
        );
      },


    );
  }
  Future<void>deleted(String Productid)async {
    await _khan.doc(Productid).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:Text("You Have Been Successfully Delete")));

  }
  Future<void> updated(DocumentSnapshot documentSnapshot)async {
    if(DocumentSnapshot!=null){
      namecontroller.text=documentSnapshot["name"];
      pricecontroller.text=documentSnapshot["price"].toString();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context:context,
      builder: (BuildContext ctx) {
        return Padding(padding: EdgeInsets.only
          (
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom+20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: namecontroller,
                decoration: const InputDecoration(labelText: "Name"),

              ),
              TextField(
                controller: pricecontroller,
                decoration: const InputDecoration(labelText: "price"),
                keyboardType:const TextInputType.numberWithOptions(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: ()async

                  {
                    final String name=namecontroller.text;
                    final double? price =double.tryParse( pricecontroller.text);

                   await _khan.doc(documentSnapshot.id).update({"name":name,"price":price});
                  },
                  child: const Text("Update")
              )

            ],
          ),
        );
      },


    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _khan.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>streamSnapshot)
    {

      return ListView.builder(
      itemCount: streamSnapshot.data?.docs.length,
      itemBuilder: (context,index)
    {
      final DocumentSnapshot documentSnapshot=streamSnapshot.data!.docs[index];
      return  Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(documentSnapshot["name"]),
          subtitle: Text(documentSnapshot["price"].toString()),
trailing: SizedBox(
  width: 150,
  child: Row(
    children: [
      IconButton(onPressed: ()
      {
        updated(documentSnapshot);
      },
          icon:const Icon(Icons.edit)),
      IconButton(onPressed: ()async
      {
       deleted(documentSnapshot.id);
      },
          icon:const Icon(Icons.delete)),

      IconButton(onPressed: ()
      {
created(documentSnapshot);
      },
          icon:const Icon(Icons.add)),
    ],
  ),
),
        ),
      );

    }
    );
    }
    );

  }
}
