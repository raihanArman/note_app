import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:note_app/config/paths.dart';
import 'package:note_app/entities/user_entity.dart';
import 'package:note_app/models/user_model.dart';
import 'package:note_app/repositories/auth/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firestore;
  final auth.FirebaseAuth _auth;

  AuthRepository({
    FirebaseFirestore? firestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  void dispose() {}

  @override
  Future<User?> getCurrentUser() async {
    final currentUser = await _auth.currentUser;
    if (currentUser == null) return null;
    return await _firebaseUserToUser(currentUser);
  }

  @override
  Future<bool> isAnonymous() async {
    final currentUser = await _auth.currentUser;
    return currentUser!.isAnonymous;
  }

  @override
  Future<User> loginAnonymously() async {
    final authResult = await _auth.signInAnonymously();
    var data = await _firebaseUserToUser(authResult.user!);
    print("Mantap " + data.email);
    return data;
  }

  @override
  Future<User> loginWithEmaiLAndPassword(
      {required String email, required String password}) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return await _firebaseUserToUser(authResult.user!);
  }

  @override
  Future<User> logout() async {
    await _auth.signOut();
    return await loginAnonymously();
  }

  @override
  Future<User> signupWithEmaiLAndPassword({
    required String email,
    required String password,
  }) async {
    final currentUser = await _auth.currentUser;
    final authCredential =
        auth.EmailAuthProvider.credential(email: email, password: password);
    final authResult = await currentUser?.linkWithCredential(authCredential);
    final user = await _firebaseUserToUser(authResult!.user!);
    _firestore
        .collection(Paths.users)
        .doc(user.id)
        .set(user.toEntity().toDocument());
    return user;
  }

  Future<User> _firebaseUserToUser(auth.User user) async {
    DocumentSnapshot userDoc =
        await _firestore.collection(Paths.users).doc(user.uid).get();
    if (userDoc.exists) {
      User user = User.fromEntity(UserEntity.fromSnapshot(userDoc));
      return user;
    }

    return User(id: user.uid, email: '');
  }
}
