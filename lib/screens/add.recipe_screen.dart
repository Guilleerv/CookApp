import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_screnn.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _ingredientsController = TextEditingController();
    _instructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredientes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa los ingredientes';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: 'Instrucciones'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa las instrucciones';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: _image != null
                    ? kIsWeb
                        ? Image.network(_image!.path, height: 100, width: 100)
                        : Image.file(_image!, height: 100, width: 100)
                    : Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: Icon(Icons.camera_alt, color: Colors.black),
                      ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Validar que se haya seleccionado una imagen
                    if (_image == null) {
                      // Muestra un mensaje o realiza alguna acción si no se seleccionó ninguna imagen
                      return;
                    }

                    // Upload image to Firebase Storage
                    String imageUrl = await _uploadImage();
                    print('Nombre de archivo: $imageUrl');

                    // Add recipe data to Firestore
                    Map<String, dynamic> newRecipe = {
                      'nombre': _titleController.text,
                      'ingredientes': _ingredientsController.text,
                      'pasos': _instructionsController.text,
                      'foto': imageUrl,
                    };

                    await _firestore.collection('receta').add(newRecipe);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewRecetas(),
                      ),
                    );
                  }
                },
                child: Text('Agregar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _uploadImage() async {
    if (_image != null) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          _storage.ref().child('recipe_images').child('$imageName.jpg');
      UploadTask uploadTask = reference.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return ''; // Devolver una cadena vacía si no hay imagen
    }
  }
}
