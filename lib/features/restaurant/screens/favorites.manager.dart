import 'package:flutter/foundation.dart';

class FavoritesManager {
  static final ValueNotifier<Set<String>> favoritesNotifier = ValueNotifier({});

  static String _generateId(String restaurantName, String foodItemName) {
    return '${restaurantName}_$foodItemName';
  }

  static void toggleFavorite(String restaurantName, String foodItemName) {
    final id = _generateId(restaurantName, foodItemName);

    final currentFavorites = Set<String>.from(favoritesNotifier.value);

    if (currentFavorites.contains(id)) {
      currentFavorites.remove(id);
    } else {
      currentFavorites.add(id);
    }

    favoritesNotifier.value = currentFavorites;
  }

  static bool isFavorite(String restaurantName, String foodItemName) {
    return favoritesNotifier.value.contains(_generateId(restaurantName, foodItemName));
  }

  static int getFavoritesCountForRestaurant(String restaurantName) {
    int count = 0;
    for (var favoriteId in favoritesNotifier.value) {
      if (favoriteId.startsWith('${restaurantName}_')) {
        count++;
      }
    }
    return count;
  }

  static void initializeFavorites() {
    final initialId = _generateId('Burger King', 'Combo Spicy Tender');
    favoritesNotifier.value = {initialId};
  }
}