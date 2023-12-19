import 'package:flutter/material.dart';

class CarouselScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const CarouselScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  int _currentPage = 1;

  void _nextPage() {
    setState(() {
      if (_currentPage < 3) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void _finish() {
    widget.onFinish();
  }

  Widget _buildIndicator(int pageNumber) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pageNumber == _currentPage ? Colors.orange : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a cookapp'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_currentPage == 1)
                    Image.asset(
                      'assets/images/welcome_image.png',
                      fit: BoxFit.cover,
                    )
                  else if (_currentPage == 2)
                    Image.asset(
                      'assets/images/welcome_image2.png',
                      fit: BoxFit.cover,
                    )
                  else if (_currentPage == 3)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Image.asset(
                        'assets/images/welcome_image3.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentPage == 1)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Buen día!',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Hoy es un día para almacenar tus recetas.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  if (_currentPage == 2)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instrucciones:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Presiona el botón "+" para agregar una nueva receta.',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '2. Completa los campos con los detalles de tu receta.',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '3. Guarda la receta presionando el botón "Guardar".',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  if (_currentPage == 3)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Estás a punto de comenzar tu propia ruta gastronómica!',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Solo presiona el botón para empezar.',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _previousPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Atrás'),
                            ),
                            ElevatedButton(
                              onPressed: _finish,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Finalizar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 1; i <= 3; i++) _buildIndicator(i),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  if (_currentPage < 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _previousPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Atrás'),
                        ),
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Siguiente'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (_currentPage != 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 1; i <= 3; i++) _buildIndicator(i),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
