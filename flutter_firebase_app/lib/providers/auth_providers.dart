import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_service.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

final authStateProvider = StreamProvider<User?>((ref) {
  final service = ref.watch(firebaseServiceProvider);
  return service.authStateChanges();
});

final userNameProvider = FutureProvider<String?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  final service = ref.watch(firebaseServiceProvider);
  return service.fetchUserName(user.uid);
});
