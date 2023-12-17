import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getRecetas() async {
  List receta = [];

  CollectionReference collectionReferenceReceta = db.collection('receta');
  QuerySnapshot queryReceta = await collectionReferenceReceta.get();
  queryReceta.docs.forEach((documento) {
    receta.add(documento.data());
  });

  return receta;
}
