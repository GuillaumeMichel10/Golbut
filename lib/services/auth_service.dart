import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_hygiene/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  Future<UserModel?> registerWithEmailAndPassword(String email, String password, String city, String? photoURL) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'city': city,
          'photoURL': photoURL ?? '',
        });
        return UserModel(uid: user.uid, email: user.email, city: city);
      }
    } catch (error) {
      print(error.toString());
      return null;
    }
    return null;
  }

  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> updateUserEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> updateUserPassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.updatePassword(newPassword);
  }

  Future<void> updateUserCity(String city) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'city': city}).catchError((error) {
        print("Erreur lors de la mise à jour de la ville: $error");
        throw error;
      });
    } else {
      print("Aucun utilisateur connecté trouvé");
      throw "Erreur : Aucun utilisateur connecté trouvé";
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
