# CookApp
## EQUIPO
1. Guillermo Ramos Lider de equipo
2. Brayan Flores Encargado del diseño
3. Ignacio Muñoz Arquitecto de Software
4. Diego Moya Desarrollador principal

## Descripción 

La aplicación está diseñada para brindar un espacio práctico y personalizado donde los usuarios pueden almacenar una amplia variedad de recetas culinarias. Su propósito es facilitar la creación y el acceso rápido a estas recetas en cualquier momento y desde cualquier lugar, satisfaciendo así la necesidad de una plataforma versátil para aquellos momentos de inspiración o interés por cocinar.

Al iniciar la aplicación, los usuarios serán recibidos con instrucciones claras y una interfaz intuitiva. El proceso comienza con un formulario completo destinado a recopilar todos los detalles esenciales de las recetas. Aquí, podrán ingresar información como el título de la receta, una imagen representativa, lista de ingredientes, pasos de preparación, entre otros detalles relevantes.

Una vez completado el proceso de ingreso de datos, la aplicación organizará estas recetas personalizadas en una pestaña específica, proporcionando un acceso rápido y sencillo para su visualización posterior. Los usuarios tendrán la comodidad de revisar y utilizar estas recetas almacenadas en cualquier momento, permitiéndoles experimentar con nuevas creaciones culinarias o acceder a sus platos favoritos de manera ágil.

## Funcionalidades Claves

1. Añadir Recetas:
   - Permite a los usuarios compartir sus recetas con el resto de las personas que interactúen con la aplicación.
     
2. Visualizar Recetas:
   - Los usuarios son capaces de visualizar recetas que suban personas de todo el mundo, viendo detalles como la cantidad de personas, tiempo, ingredientes y pasos a seguir.
    


## Diseño
![Google Pixel 4 Presentation](https://github.com/Guilleerv/CookApp/assets/74439275/f9113fe4-1644-4945-955e-0efa3056ac39)
![Google Pixel 4](https://github.com/Guilleerv/CookApp/assets/74439275/39968d56-5dc7-4d86-80da-8741c01a02fa)
![Google Pixel 4 (1)](https://github.com/Guilleerv/CookApp/assets/74439275/469e8c97-a731-49a1-9f10-3a7527413172)
![Google Pixel 4 (2)](https://github.com/Guilleerv/CookApp/assets/74439275/27ffaa0e-c2ba-48e4-8a67-fa2a01a26481)
![Google Pixel 4 (3)](https://github.com/Guilleerv/CookApp/assets/74439275/1c81ba81-40cc-4404-a3bc-4b11704913dc)



## Arquitectura
### Estructura de Archivos Propuesta:

La estructura de archivos para el proyecto CookApp se organiza de la siguiente manera:

```plaintext
cookapp/
|-- lib/
|   |-- main.dart
|   |-- firebase_options.dart
|   |-- services/
|   |   |-- add_service.dart
|   |   |-- firebase_service.dart
|   |   |-- upload_image.dart
|   |-- screens/
|   |   |-- carousel_screen.dart
|   |   |-- creation_recipe.dart
|   |   |-- view_screen.dart
|   |-- widgets/
|   |   |-- detallesreceta.dart   
|-- assets/
|   |-- images/
|   |   |-- logo.png
|   |   |-- welcome_image.png
|   |   |-- welcome_image2.png
|   |   |-- welcome_image3.png
|-- ...
```

- **`lib/screens/`:** Contiene las pantallas principales de la aplicación.
- **`lib/widgets/`:** Contiene widgets reutilizables en las pantallas.
- **`lib/services/`:** Contiene servicios especificos relacionados con la conexión con la base de datos firebase.
- **`assets/`:** Contiene archivos estáticos como imágenes.

### Arquitectura de Software Utilizada:

La arquitectura de software utilizada sigue una estructura de capas más simple:

### Descripción de Capas:

1. **Capa de Presentación (UI):**
   - **Ubicación:** En la carpeta `lib/screens/`.
   - **Propósito:** Contiene las pantallas responsables de la interfaz de usuario, en este caso serían tres, la vista de creación de recetas, la visualización de recetas y la pantalla dónde se visualiza el carrusel de bienvenida.

2. **Widgets Reutilizables:**
   - **Ubicación:** En la carpeta `lib/widgets/`.
   - **Propósito:** Contiene widgets reutilizables en varias pantallas, en este caso es el que permite visualizar los detalles de la receta.

3. **Capa de Servicios:**
   - **Ubicación:** En la carpeta `lib/services/`.
   - **Propósito:** Contiene servicios específicos, en este caso los que nos permiten conectarnos con firebase, como la carga de imagenes o el añadir las recetas.

### Diagrama de Capas:

```plaintext
  +--------------------------+
  |   Capa de Presentación   |
  +--------------------------+
                |
  +--------------------------+
  |  Widgets Reutilizables   |
  +--------------------------+
                |
  +--------------------------+
  |    Capa de Servicios     |
  +--------------------------+
```
