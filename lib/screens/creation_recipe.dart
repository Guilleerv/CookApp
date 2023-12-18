// Importa las librerías necesarias
import 'package:cookapp/screens/view_screnn.dart';
import 'package:cookapp/services/add_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cookapp/services/upload_image.dart';

// La clase principal que inicia la aplicación
void main() {
  runApp(const MyApp());
}

// Widget principal de la aplicación
class RecipesCreation extends StatefulWidget {
  const RecipesCreation({Key? key}) : super(key: key);

  @override
  _RecipesCreationState createState() => _RecipesCreationState();
}

// Estado del widget principal
class _RecipesCreationState extends State<RecipesCreation> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _stepDescriptionControllers = [
    TextEditingController()
  ];
  File? _image;

  // Método para seleccionar una imagen
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addRecipe() async {
    if (_image == null) {
      return;
    }
    switch (_currentPageIndex) {
      case 1: // Página de detalles
        if (_titleController.text.isEmpty ||
            _descriptionController.text.isEmpty) {
          return;
        }
        break;
      default:
        break;
    }
    await _recipeService.addRecipe(
      title: _titleController.text,
      description: _descriptionController.text,
      people: _peopleController.text,
      time: _timeController.text,
      ingredients:
          _ingredientControllers.map((controller) => controller.text).toList(),
      steps: _stepDescriptionControllers
          .map((controller) => controller.text)
          .toList(),
      imageUrl: await uploadImage(_image!),
    );
  }

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
        body: PageView(
          controller: _pageController,
          children: [
            PhotoPage(onImagePicked: _pickImage),
            RecipeDetailsPage(
              titleController: _titleController,
              descriptionController: _descriptionController,
              peopleController: _peopleController,
              timeController: _timeController,
            ),
            IngredientsPage(ingredientControllers: _ingredientControllers),
            StepsPage(
              stepDescriptionControllers: _stepDescriptionControllers,
              onImagePicked: _pickImage,
            ),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.photo),
              label: 'Foto',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.details),
              label: 'Detalles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Ingredientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Pasos',
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            await _addRecipe();

            // Navegar a la vista de recetas (ViewRecetas) después de agregar la receta
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewRecetas(),
              ),
            );
          },
          child: Text('Agregar Receta'),
        ),
      ),
    );
  }
}

class PhotoPage extends StatefulWidget {
  final VoidCallback onImagePicked;

  const PhotoPage({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? kIsWeb
                  ? Image.network(_image!.path, height: 100, width: 100)
                  : Image.file(_image!, height: 100, width: 100)
              : Text('Selecciona una foto'),
          ElevatedButton(
            onPressed: widget.onImagePicked,
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
  final TextEditingController peopleController;
  final TextEditingController timeController;

  const RecipeDetailsPage({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.peopleController,
    required this.timeController,
  }) : super(key: key);

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
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: peopleController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Cantidad de Personas',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Ej: 4-6 personas',
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: timeController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Tiempo de Elaboración',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Ej: 1 hora 15 minutos',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Página para los ingredientes
class IngredientsPage extends StatefulWidget {
  final List<TextEditingController> ingredientControllers;

  const IngredientsPage({Key? key, required this.ingredientControllers})
      : super(key: key);

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
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
            for (int i = 0; i < widget.ingredientControllers.length; i++)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.ingredientControllers[i],
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Ingrediente ${i + 1}',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Ej: 500 grs de carne',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.black,
                        onPressed: () {
                          setState(() {
                            widget.ingredientControllers.removeAt(i);
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
                  widget.ingredientControllers.add(TextEditingController());
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

// Página para los pasos
class StepsPage extends StatefulWidget {
  final List<TextEditingController> stepDescriptionControllers;
  final VoidCallback onImagePicked;

  const StepsPage({
    Key? key,
    required this.stepDescriptionControllers,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
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
            for (int i = 0; i < widget.stepDescriptionControllers.length; i++)
              Column(
                children: [
                  TextField(
                    controller: widget.stepDescriptionControllers[i],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Paso ${i + 1}',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText:
                          'Ej: En una olla grande calentar el Sofrito Gourmet junto a la zanahoria, el apio y tocino (opcional).',
                    ),
                  ),
                  // Aquí puedes agregar el botón para seleccionar una imagen asociada al paso
                  ElevatedButton(
                    onPressed: widget.onImagePicked,
                    child: Text('Seleccionar Imagen para el Paso ${i + 1}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () {
                      setState(() {
                        widget.stepDescriptionControllers.removeAt(i);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.stepDescriptionControllers
                      .add(TextEditingController());
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

// Widget para el título de una sección
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

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RecipesCreation();
  }
}
