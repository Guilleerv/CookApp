import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRecipe({
    required String title,
    required String description,
    required String people,
    required String time,
    required List<String> ingredients,
    required List<String> steps,
    required String imageUrl,
  }) async {
    try {
      await _firestore.collection('receta').add({
        'nombre': title,
        'descripcion': description,
        'ingredientes': ingredients,
        'personas': people,
        'tiempo': time,
        'pasos': steps,
        'foto': imageUrl,
      });
      // ignore: empty_catches
    } catch (e) {}
  }
}
