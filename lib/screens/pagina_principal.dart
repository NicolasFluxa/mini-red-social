import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  Future<void> _toggleLike(QueryDocumentSnapshot publicacion) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final postId = publicacion.id;
    final userId = currentUser.uid;

    final likeDocRef = FirebaseFirestore.instance
        .collection('publicaciones')
        .doc(postId)
        .collection('likes')
        .doc(userId);

    final likeSnapshot = await likeDocRef.get();

    if (likeSnapshot.exists) {
      await likeDocRef.delete();
      await FirebaseFirestore.instance
          .collection('publicaciones')
          .doc(postId)
          .update({'likes': FieldValue.increment(-1)});
    } else {
      await likeDocRef.set({'liked': true});
      await FirebaseFirestore.instance
          .collection('publicaciones')
          .doc(postId)
          .update({'likes': FieldValue.increment(1)});
    }
  }

  Future<bool> _hasLiked(String postId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final likeDoc =
        await FirebaseFirestore.instance
            .collection('publicaciones')
            .doc(postId)
            .collection('likes')
            .doc(currentUser.uid)
            .get();

    return likeDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.home, color: Colors.white),
        title: Text('Mini red social', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/perfil');
            },
            icon: Icon(Icons.person, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/pagina_principal');
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('publicaciones')
                .orderBy('fecha', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No hay publicaciones',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            );
          }

          final publicaciones = snapshot.data!.docs;

          return ListView.builder(
            itemCount: publicaciones.length,
            itemBuilder: (context, index) {
              final publicacion = publicaciones[index];
              final imageUrl = publicacion['imagenUrl'] ?? '';
              final email = publicacion['email'] ?? 'Anónimo';
              final texto = publicacion['texto'] ?? '';
              final likes = publicacion['likes'] ?? 0;
              final timestamp = publicacion['fecha'] as Timestamp?;
              final fecha =
                  timestamp != null
                      ? DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(timestamp.toDate())
                      : 'Sin fecha';
              final postId = publicacion.id;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text('No se pudo cargar la imagen'),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 10),
                      Text(texto, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 6),
                      Text(
                        'Publicado por: $email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Fecha: $fecha',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 6),
                      FutureBuilder<bool>(
                        future: _hasLiked(postId),
                        builder: (context, snapshot) {
                          final hasLiked = snapshot.data ?? false;
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () => _toggleLike(publicacion),
                                child: Icon(
                                  Icons.favorite,
                                  color: hasLiked ? Colors.red : Colors.grey,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('$likes likes'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/crear_publicacion');
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
