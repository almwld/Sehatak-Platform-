import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseService {
  Future<void> initialize();
  FirebaseAuth get auth;
  FirebaseFirestore get firestore;
  FirebaseStorage get storage;
  User? get currentUser;
}

class FirebaseServiceImpl implements FirebaseService {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    
    _isInitialized = true;
  }

  @override
  FirebaseAuth get auth => _auth;

  @override
  FirebaseFirestore get firestore => _firestore;

  @override
  FirebaseStorage get storage => _storage;

  @override
  User? get currentUser => _auth.currentUser;
}
