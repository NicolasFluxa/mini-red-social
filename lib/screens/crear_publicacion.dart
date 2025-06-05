import 'package:flutter/material.dart';

//firebase auth y firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrearPostPage extends StatefulWidget {
  const CrearPostPage({super.key});

  @override
  State<CrearPostPage> createState() => _CrearPostPageState();
}

class _CrearPostPageState extends State<CrearPostPage> {
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _imagenUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.home, color: Colors.white),
        title: Text('Crear publicacion', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/pagina_principal');
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ],
      ),
      
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: Colors.blue),
                SizedBox(height: 16),
                const Text(
                  'Login Red Social',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 32),
                //Texto o descripcion
                TextField(
                  controller: _textoController,
                  decoration: InputDecoration(
                    labelText: 'Descripcion',
                    prefixIcon: Icon(Icons.content_paste_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //URL
                TextField(
                  controller: _imagenUrlController,
                  decoration: InputDecoration(
                    labelText: 'Url de la imagen',
                    prefixIcon: Icon(Icons.image),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      fnPublicar(
                        _textoController.text,
                        _imagenUrlController.text,
                      );
                    },
                    icon: Icon(Icons.upload),
                    label: Text('Publicar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registro');
                  },
                  child: Text('¿No tienes cuenta? Registrate',
                  style: TextStyle(
                    color: Colors.blue[600]
                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }

  void fnPublicar(String texto, String url) async {
    
    final user = FirebaseAuth.instance.currentUser;

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Escribe algo primero')));
      return;
    }

    await FirebaseFirestore.instance.collection('publicaciones').add({
      'usuarioId': user?.uid,
      'email': user?.email,
      'texto': texto,
      'imagenUrl': url,
      'likes': 0,
      'fecha': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Publicado!')));
    Navigator.pushReplacementNamed(context, '/pagina_principal');
  }
}
