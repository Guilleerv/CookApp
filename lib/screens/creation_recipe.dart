import 'package:cookapp/screens/view_screnn.dart';
import 'package:cookapp/services/add_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cookapp/services/upload_image.dart';

void main() {
  runApp(const MyApp());
}

class RecipesCreation extends StatefulWidget {
  const RecipesCreation({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecipesCreationState createState() => _RecipesCreationState();
}

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
  bool _isButtonDisabled = false;

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
      case 1:
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
    _titleController.clear();
    _descriptionController.clear();
    _peopleController.clear();
    _timeController.clear();
    _ingredientControllers.clear();
    _stepDescriptionControllers.clear();
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
          backgroundColor: Colors.orange,
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
          backgroundColor: Colors.green,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
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
        floatingActionButton: _currentPageIndex == 3
            ? ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () async {
                        setState(() {
                          _isButtonDisabled = true;
                        });
                        await _addRecipe();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewRecetas(),
                          ),
                        );
                      },
                child: const Text('Guardar'),
              )
            : null,
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
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? kIsWeb
                  ? Image.network(_image!.path, height: 100, width: 100)
                  : Image.file(_image!, height: 100, width: 100)
              : const Text('Selecciona una foto',
                  style: TextStyle(color: Colors.black)),
          ElevatedButton(
            onPressed: widget.onImagePicked,
            child: const Text('Seleccionar Foto'),
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
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Detalles de la Receta'),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Ej: Lasaña Boloñesa.',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.black),
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: Colors.black),
                hintText:
                    'Ej: Receta de rica lasaña boloñesa que me enseñó a hacer mi madre.',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: peopleController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de Personas',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Ej: 4-6 personas',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: timeController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
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
      ),
    );
  }
}

class IngredientsPage extends StatefulWidget {
  final List<TextEditingController> ingredientControllers;

  const IngredientsPage({Key? key, required this.ingredientControllers})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Ingredientes', textColor: Colors.black),
              const SizedBox(height: 16),
              for (int i = 0; i < widget.ingredientControllers.length; i++)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.ingredientControllers[i],
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Ingrediente ${i + 1}',
                              labelStyle: const TextStyle(color: Colors.black),
                              hintText: 'Ej: 500 grs de carne',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              widget.ingredientControllers.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.ingredientControllers.add(TextEditingController());
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                ),
                child: const Text('Agregar Ingrediente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepsPage extends StatefulWidget {
  final List<TextEditingController> stepDescriptionControllers;

  const StepsPage({
    Key? key,
    required this.stepDescriptionControllers,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Pasos a Seguir', textColor: Colors.black),
              const SizedBox(height: 16),
              for (int i = 0; i < widget.stepDescriptionControllers.length; i++)
                Column(
                  children: [
                    TextField(
                      controller: widget.stepDescriptionControllers[i],
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Paso ${i + 1}',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        hintText:
                            'Ej: En una olla grande calentar el Sofrito Gourmet junto a la zanahoria, el apio y tocino (opcional).',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          widget.stepDescriptionControllers.removeAt(i);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.stepDescriptionControllers
                        .add(TextEditingController());
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                ),
                child: const Text('Agregar Paso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;

  const _SectionTitle(this.title, {this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RecipesCreation();
  }
}
