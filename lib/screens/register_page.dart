
import 'package:flutter/material.dart';

//firebase auth
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controladores para los textfields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfController.dispose();
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
                const Icon(Icons.lock, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Registrar Usuario',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 32),

                // Campo correo
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electronico',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo confirmar contraseña
                TextField(
                  controller: _passwordConfController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botón register
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      fnRegistrarUsuario(
                        _emailController.text,
                        _passwordController.text,
                        _passwordConfController.text,
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("Registrar"),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('¿Ya tienes una cuenta? LogIn',
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
  
  Future<void> fnRegistrarUsuario(String email, String password, String confPassword) async {
    if (email.trim().isEmpty || password.trim().isEmpty || confPassword.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (password != confPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas son distintas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro exitoso'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, '/');
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ocurrio un erro.Intente nuevamente'),
                backgroundColor: Colors.red,
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }



  }
}