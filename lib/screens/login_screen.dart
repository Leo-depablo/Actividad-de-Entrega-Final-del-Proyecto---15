import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder para el logo
              const SizedBox(
                width: 150,
                height: 150,
                child: Placeholder(color: Colors.transparent),
              ),
              const SizedBox(height: 16),
              const Text(
                'CRM',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              _buildTextField(
                hintText: 'Correo electrónico',
                icon: Icons.email,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hintText: 'Contraseña',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 24),
              _buildLoginButton(context),
              const SizedBox(height: 16),
              _buildForgotPasswordLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 16),
        onPressed: () {
          // Navegar al Dashboard al presionar el botón
          Navigator.pushReplacementNamed(context, '/');
        },
        child: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        // Lógica para olvidar contraseña
      },
      child: const Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }
}
