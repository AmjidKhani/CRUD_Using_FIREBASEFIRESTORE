import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/material.dart';

class screenfirst extends StatefulWidget {
  const screenfirst({Key? key}) : super(key: key);

  @override
  State<screenfirst> createState() => _screenfirstState();
}
class _screenfirstState extends State<screenfirst> {
  final CollectionReference _products = FirebaseFirestore.instance.collection(
      "Products");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot["name"];
      _priceController.text = documentSnapshot["price"].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,

        context: context,
        builder: (BuildContext ctx) {
          return Padding(padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery
                  .of(ctx)
                  .viewInsets
                  .bottom + 20
          ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                      labelText: "Price"),
                ),
                const SizedBox(
                  height: 20,

                ),
                ElevatedButton(
                  onPressed: () async
                  {
                    final String name = _nameController.text;
                    final double? price = double.tryParse(
                        _priceController.text);
                    if (price != null) {
                      await _products.doc(documentSnapshot!.id).update(
                          {"name": name, "price": price});
                      _nameController.text = "";
                      _nameController.text = "";
                    }
                  },
                  child: const Text("Update"),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot>streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = streamSnapshot
                        .data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot["name"]),
                        subtitle: Text(documentSnapshot["price"].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _update(documentSnapshot);
                                },
                                icon: const Icon(Icons.edit),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}