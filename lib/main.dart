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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // valida el formulario primero
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    // simulamos una llamada (API) para que el loader tenga sentido
    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = false);

    if (email.endsWith('@sena.edu.co') && password.length >= 4) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(userName: "Aprendiz Sena"),
        ),
      );
    } else {
      if (!mounted) return;
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/LOGO_BIENESTARMIND.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
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

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo SENA',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final v = (value ?? '').trim();
                  if (v.isEmpty) return 'Ingresa tu correo institucional';
                  if (!v.contains('@')) return 'Formato de correo no válido';
                  if (!v.endsWith('@sena.edu.co')) return 'Debe ser @sena.edu.co';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword ? 'Mostrar' : 'Ocultar',
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _login(),
                validator: (value) {
                  final v = value ?? '';
                  if (v.isEmpty) return 'Ingresa tu contraseña';
                  if (v.length < 4) return 'Mínimo 4 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F9C18),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('INGRESAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}