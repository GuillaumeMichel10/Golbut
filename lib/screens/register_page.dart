import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_hygiene/screens/login_page.dart';
import 'package:open_hygiene/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String city = '';
  String error = '';
  File? _imageFile;

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> uploadFile() async {
    if (_imageFile == null) return null;

    String fileName = Path.basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
    firebase_storage.UploadTask uploadTask = ref.putFile(_imageFile!);
    await uploadTask.whenComplete(() => {});
    String fileURL = await ref.getDownloadURL();
    return fileURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Choisir une photo de profil'),
              ),
              _imageFile != null ? Image.file(_imageFile!, height: 100) : const Padding(padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Aucune image sélectionnée"),
              ),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Entrez un email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade200, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Entrez un mot de passe' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade200, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Entrez votre ville' : null,
                onChanged: (val) {
                  setState(() => city = val);
                },
                decoration: InputDecoration(
                  labelText: 'Ville',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo.shade200, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text("S'inscrire"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? photoURL = await uploadFile();
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password, city, photoURL);
                    if (result == null) {
                      setState(() => error = 'Veuillez fournir une adresse email valide');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
