// main.dart

import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BienestarMind Móvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFF1F9C18, {
          50: Color(0xFFE3F2E2),
          100: Color(0xFFB8E1B6),
          200: Color(0xFF8ACF87),
          300: Color(0xFF5CB758),
          400: Color(0xFF38A833),
          500: Color(0xFF1F9C18),
          600: Color(0xFF1B9414),
          700: Color(0xFF168A0F),
          800: Color(0xFF11810A),
          900: Color(0xFF096F03),
        }),
        scaffoldBackgroundColor: const Color(0xFFE9F7EF),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.contains('@sena.edu.co') && password.length >= 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const DashboardScreen(userName: "Aprendiz Sena"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales inválidas. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // IMAGEN: Usando Image.asset (Placeholder)
            Image.asset(
              'assets/LOGO_BIENESTARMIND.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                // Muestra un placeholder si la imagen no se encuentra
                return const Icon(
                  Icons.psychology,
                  size: 80,
                  color: Color(0xFF1F9C18),
                );
              },
            ),
            const SizedBox(height: 30),

            const Text(
              "BienestarMind",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F9C18),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo SENA',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F9C18),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('INGRESAR'),
            ),
          ],
        ),
      ),
    );
  }
}
