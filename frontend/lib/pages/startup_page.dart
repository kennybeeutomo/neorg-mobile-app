import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'login_page.dart';
import 'workspace_list_page.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _startup();
  }

  Future<void> _startup() async {
    final loggedIn = await _authService.loadToken();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const WorkspaceListPage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
