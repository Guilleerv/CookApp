import 'package:flutter/material.dart';
import 'package:cookapp/services/firebase_service.dart';

class ViewRecetas extends StatefulWidget {
  @override
  _ViewRecetasState createState() => _ViewRecetasState();
}

class _ViewRecetasState extends State<ViewRecetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
      ),
      body: FutureBuilder(
        future: getRecetas(),
        builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay recetas disponibles'),
            );
          } else {
            List<Map<String, dynamic>> recetas =
                (snapshot.data as List<dynamic>)
                    .map((dynamic item) => item as Map<String, dynamic>)
                    .toList();

            return ListView.builder(
              itemCount: recetas.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> receta = recetas[index];

                return ListTile(
                  leading: receta['imagen'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(receta['foto']),
                        )
                      : null,
                  title: Text(receta['nombre']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ingredientes: ${receta['ingredientes']}"),
                      Text("Instrucciones: ${receta['pasos']}"),
                    ],
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
