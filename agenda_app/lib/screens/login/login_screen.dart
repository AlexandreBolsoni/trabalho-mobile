import 'package:flutter/material.dart';
import '../../screens/administrativo/admin_page.dart';
import '../../widgets/card_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginCard(
      onSuccess: () => _handleLogin(context),
    );
  }
}
