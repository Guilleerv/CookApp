import 'package:flutter/material.dart';

class DetallesReceta extends StatelessWidget {
  final Map<String, dynamic> receta;

  const DetallesReceta({Key? key, required this.receta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta['nombre']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descripción, Personas y Tiempo
            Text("Descripción: ${receta['descripcion']}"),
            Text("Personas: ${receta['personas']}"),
            Text("Tiempo: ${receta['tiempo']}"),
            SizedBox(height: 16),

            // Lista de Ingredientes
            _SectionTitle('Ingredientes'),
            _buildIngredientesList(receta['ingredientes']),
            SizedBox(height: 16),

            // Lista de Pasos
            _SectionTitle('Pasos a Seguir'),
            _buildPasosList(receta['pasos']),
          ],
        ),
      ),
    );
  }

  // Método para construir la lista de ingredientes
  Widget _buildIngredientesList(List<dynamic> ingredientes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          ingredientes.map((ingrediente) => Text('- $ingrediente')).toList(),
    );
  }

  // Método para construir la lista de pasos
  Widget _buildPasosList(List<dynamic> pasos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pasos
          .asMap()
          .map((index, paso) => MapEntry(
                index,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Paso ${index + 1}:'),
                    Text('- $paso'),
                    SizedBox(height: 8),
                  ],
                ),
              ))
          .values
          .toList(),
    );
  }

  // Widget para el título de una sección
  Widget _SectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
