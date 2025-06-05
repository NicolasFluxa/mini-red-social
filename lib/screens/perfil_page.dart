import 'package:flutter/material.dart';

//firebase auth y firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final user = FirebaseAuth.instance.currentUser;

  void eliminarPublicacion(DocumentReference ref) async {
    //falta un seguro que desea eliminar?
    await ref.delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Publicación eliminada')));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Perfil')),
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.person, color: Colors.white),
        title: Text('Mini red social', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/pagina_principal');
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Correo electrónico:'),
            subtitle: Text(user!.email ?? 'Sin correo'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('publicaciones')
                      .where('usuarioId', isEqualTo: user!.uid)
                      .orderBy('fecha', descending: true)
                      .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar publicaciones'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No has publicado nada aún.'));
                }

                final publicaciones = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: publicaciones.length,
                  itemBuilder: (context, index) {
                    final publicacion = publicaciones[index];
                    final texto = publicacion['texto'] ?? '';
                    final imagenUrl = publicacion['imagenUrl'] ?? '';
                    final likes = publicacion['likes'] ?? 0;

                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imagenUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imagenUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('No se pudo cargar la imagen'),
                                  );
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(texto),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text('Likes: $likes'),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                eliminarPublicacion(publicacion.reference);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
