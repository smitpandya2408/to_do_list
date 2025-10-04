import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signIn({required String email, required String password}) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _db.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return cred;
  }

  Future<void> signOut() => _auth.signOut();

  Future<String?> fetchUserName(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['name']?.toString();
  }
}
