import "package:flutter/material.dart";
import 'package:mini_red_social/screens/crear_publicacion.dart';

//Vistas de cada cosa
import 'package:mini_red_social/screens/login_page.dart';
import 'package:mini_red_social/screens/perfil_page.dart';
import 'package:mini_red_social/screens/register_page.dart';
import 'package:mini_red_social/screens/pagina_principal.dart';

//configuracion de firebase
import "package:firebase_core/firebase_core.dart";
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/registro': (context) => RegisterPage(),
        '/pagina_principal': (context) => PaginaPrincipal(),
        '/crear_publicacion': (context) => CrearPostPage(),
        '/perfil': (context) => PerfilPage(),

      },
    );
  }
}
