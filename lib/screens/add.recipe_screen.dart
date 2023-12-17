import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const MyApp());
}

class RecipesCreation extends StatefulWidget {
  const RecipesCreation({Key? key}) : super(key: key);

  @override
  _RecipesCreationState createState() => _RecipesCreationState();
}

class _RecipesCreationState extends State<RecipesCreation> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _recipeTitleController = TextEditingController();
  final TextEditingController _recipeDescriptionController =
      TextEditingController();
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _stepDescriptionControllers = [
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title:
              const Text('Crear Receta', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PhotoPage(),
              RecipeDetailsPage(
                titleController: _recipeTitleController,
                descriptionController: _recipeDescriptionController,
              ),
              IngredientsPage(),
              StepsPage(),
              ElevatedButton(
                onPressed: () => _saveRecipe(),
                child: Text('Guardar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveRecipe() async {
    String title = _recipeTitleController.text;
    String description = _recipeDescriptionController.text;
    List<String> ingredients =
        _ingredientControllers.map((controller) => controller.text).toList();
    List<String> steps = _stepDescriptionControllers
        .map((controller) => controller.text)
        .toList();

    // Agrega líneas de impresión aquí
    print('Ingredientes: $ingredients');
    print('Pasos: $steps');

    try {
      await _firestore.collection('receta').add({
        'nombre': title,
        'descripcion': description,
        'ingredientes': ingredients,
        'pasos': steps,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Receta guardada con éxito'),
      ));
    } catch (e) {
      print('Error al guardar la receta: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al guardar la receta'),
      ));
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecipesCreation();
  }
}

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kIsWeb
              ? _image != null
                  ? Image.network(_image!.path, height: 100, width: 100)
                  : Text('Selecciona una foto')
              : _image != null
                  ? Image.file(_image!, height: 100, width: 100)
                  : Text('Selecciona una foto'),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Seleccionar Foto'),
          ),
        ],
      ),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  RecipeDetailsPage({
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Detalles de la Receta'),
          SizedBox(height: 16),
          TextField(
            controller: titleController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: 'Título',
              labelStyle: TextStyle(color: Colors.black),
              hintText: 'Ej: Lasaña Boloñesa.',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            style: TextStyle(color: Colors.black),
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Descripción',
              labelStyle: TextStyle(color: Colors.black),
              hintText:
                  'Ej: Receta de rica lasaña boloñesa que me enseñó a hacer mi madre.',
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class IngredientsPage extends StatefulWidget {
  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Ingredientes'),
            SizedBox(height: 16),
            for (int i = 0; i < _ingredientControllers.length; i++)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingredientControllers[i],
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Ingrediente ${i + 1}',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Ej: 500 grs de carne'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.black,
                        onPressed: () {
                          setState(() {
                            _ingredientControllers.removeAt(i);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ingredientControllers.add(TextEditingController());
                });
              },
              child: Text('Agregar Ingrediente'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepsPage extends StatefulWidget {
  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  final ImagePicker _picker = ImagePicker();
  final List<TextEditingController> _stepDescriptionControllers = [
    TextEditingController()
  ];
  final List<File?> _stepImages = [
    null
  ]; // Lista para almacenar imágenes de los pasos

  Future<void> _pickStepImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _stepImages[index] = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Pasos a Seguir'),
            SizedBox(height: 16),
            for (int i = 0; i < _stepDescriptionControllers.length; i++)
              Column(
                children: [
                  TextField(
                    controller: _stepDescriptionControllers[i],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: 'Paso ${i + 1}',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText:
                            'Ej: En una olla grande calentar el Sofrito Gourmet junto a la zanahoria, el apio y tocino (opcional).'),
                  ),
                  SizedBox(height: 8),
                  _stepImages[i] != null
                      ? kIsWeb
                          ? Image.network(_stepImages[i]!.path,
                              height: 100, width: 100)
                          : Image.file(_stepImages[i]!, height: 100, width: 100)
                      : Container(), // Mostrar imagen solo si está seleccionada
                  ElevatedButton(
                    onPressed: () => _pickStepImage(i),
                    child: Text('Añadir Imagen para el Paso ${i + 1}'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[300],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        _stepDescriptionControllers.removeAt(i);
                        _stepImages.removeAt(i);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _stepDescriptionControllers.add(TextEditingController());
                  _stepImages.add(null);
                });
              },
              child: Text('Agregar Paso'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
