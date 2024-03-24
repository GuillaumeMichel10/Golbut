import 'package:flutter/material.dart';
import 'package:open_hygiene/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String _newPassword = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
  }

  Future<void> _updateUserInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.updateUserEmail(_emailController.text);
      if (_newPassword.isNotEmpty) {
        await _authService.updateUserPassword(_newPassword);
      }
      await _authService.updateUserCity(_cityController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Informations mises à jour avec succès")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors de la mise à jour des informations: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Nouvel email'),
                validator: (value) => value!.isEmpty || !value.contains('@') ? "Entrez un email valide" : null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nouveau mot de passe (laisser vide pour ne pas changer)'),
                obscureText: true,
                onChanged: (value) => _newPassword = value,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Ville'),
                validator: (value) => value!.isEmpty ? "Entrez une ville" : null,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text('Mettre à jour les informations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
