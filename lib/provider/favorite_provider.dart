import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FavoriteProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<int, String> _favorites = {}; // index => status

  List<int> get favoriteIndexes => _favorites.keys.toList();

  bool isFavorite(int index) => _favorites.containsKey(index);

  String getStatus(int index) => _favorites[index] ?? 'inactive';

  Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('favorites').doc(user.uid).get();
    if (doc.exists && doc.data()!.containsKey('favorites')) {
      final data = doc.data()!['favorites'] as Map<String, dynamic>;
      _favorites = {
        for (var entry in data.entries)
          int.parse(entry.key): entry.value['status'] ?? 'active',
      };
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int index) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (_favorites.containsKey(index)) {
      _favorites.remove(index);
    } else {
      _favorites[index] = 'active';
    }

    notifyListeners();

    final favoritesToSave = {
      for (var entry in _favorites.entries)
        entry.key.toString(): {'status': entry.value},
    };

    await _firestore.collection('favorites').doc(user.uid).set({
      'favorites': favoritesToSave,
    });
  }

  void clear() {
    _favorites.clear();
    notifyListeners();
  }
}
