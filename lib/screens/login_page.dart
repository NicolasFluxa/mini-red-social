import 'package:flutter/material.dart';

//Firebase auth
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controladores para los textfields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                //Correo electronico
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electroníco',
                    prefixIcon: Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //Contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
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
                      fnIniciarSesion(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    icon: Icon(Icons.login),
                    label: Text('Iniciar sesion'),
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
  
  Future<void> fnIniciarSesion(String email, String password) async {
  if (email.trim().isEmpty || password.trim().isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, completa los campos'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  FirebaseAuth.instance
    .signInWithEmailAndPassword(email: email, password: password)
    .then((UserCredential userCredential) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/pagina_principal');
    })
    .catchError((error) {
      String mensaje = 'Ocurrió un error al iniciar sesión';
      
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          mensaje = 'No existe una cuenta con ese correo';
        } else if (error.code == 'wrong-password') {
          mensaje = 'Contraseña incorrecta';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.red,
        ),
      );
    });
}
}