import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  late FirebaseAnalytics analytics = FirebaseAnalytics.instance;
 
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
 
  User? get currentUser => _firebaseAuth.currentUser;
 
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
 
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await analytics.logEvent(name: "login_email_user", parameters: {
        "email": email,
        "message": "Användaren har loggat in"
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
 
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
 
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}