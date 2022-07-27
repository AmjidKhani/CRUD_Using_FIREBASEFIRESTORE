import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class nextscreen extends StatefulWidget {
  const nextscreen({Key? key}) : super(key: key);

  @override
  State<nextscreen> createState() => _nextscreenState();
}

class _nextscreenState extends State<nextscreen> {

  final CollectionReference _product=FirebaseFirestore.instance.collection("Products");
  final TextEditingController _nametextController=TextEditingController();
  final TextEditingController _pricetextController =TextEditingController();
  Future<void> _update(DocumentSnapshot documentSnapshot)async {
   if(documentSnapshot!=null){
    _nametextController.text=documentSnapshot["name"];
    _pricetextController.text=documentSnapshot["price"].toString();}
    await showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx ){
          return Padding(
              padding:EdgeInsets.only(
                left: 20,
                right: 20,
                  top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom+20,
              ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
             controller: _nametextController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                     controller: _pricetextController,
                  decoration: const InputDecoration(labelText: "Price"),
                ),

                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name=_nametextController.text.toString();
                        final  double? price=double.tryParse( _pricetextController.text);
                        if(price!=null){
                       await  _product.doc(documentSnapshot.id).update({"name":name,"price":price});
                          _pricetextController.text="";
                          _nametextController.text="";
                        }
                    },
                    child: const Text("Update"),
                )
              ],
            ),
          );}
    );
  }
  Future<void> _create([DocumentSnapshot? documentSnapshot])async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx ){
          return Padding(
            padding:EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom+20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 TextField(
                 controller: _nametextController,
                  decoration:const InputDecoration(labelText: "Name"),
                ),
                 TextField(
                  controller: _pricetextController,
                  decoration: const InputDecoration(labelText: "Price"),
                ),

                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String name=_nametextController.text;
                    final  double? price=double.tryParse( _pricetextController.text);
if(price!=null) {
  await _product.add({"name": name, "price": price});
  _pricetextController.text = "";
  _nametextController.text = "";
}  },
                  child: const Text("ADD"),
                )
              ],
            ),
          );}
    );
  }
  Future<void>_delete(String productId)async{
    await _product.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You Have Been Successfully Deleted Product")));
  }
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_create(),
      child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: _product.snapshots(),
        builder: (context, AsyncSnapshot <QuerySnapshot> streamSnapshot)
        {
    if(streamSnapshot.hasData){
      return ListView.builder(
      itemCount: streamSnapshot.data!.docs.length,
      itemBuilder:(context ,index) {
        final DocumentSnapshot documentSnapshot=streamSnapshot.data!.docs[index];
        return Card(
          margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          child: ListTile(
            title: Text(documentSnapshot["name"]),
            subtitle: Text(documentSnapshot["price"].toString()),
      trailing: SizedBox(
  width: 100,
  child: Row(
  children:[
    IconButton(
      onPressed: (){

        _update(documentSnapshot);
        },
      icon: const Icon(Icons.edit),

    ),
    IconButton(
      onPressed: (){

        _delete(documentSnapshot.id);
      },
      icon: const Icon(Icons.delete),

    ),

  ],
  ),
),
          ),
        );
    }
    );
    }
    return const Center(
      child:CircularProgressIndicator(),
    );
        }
      ),
    );
  }
}


