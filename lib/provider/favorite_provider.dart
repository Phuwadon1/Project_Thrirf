import 'package:flutter/foundation.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteIndexes = [];

  List<int> get favoriteIndexes => _favoriteIndexes;

  bool isFavorite(int index) => _favoriteIndexes.contains(index);

  void toggleFavorite(int index) {
    if (_favoriteIndexes.contains(index)) {
      _favoriteIndexes.remove(index);
    } else {
      _favoriteIndexes.add(index);
    }
    notifyListeners();
  }
}
