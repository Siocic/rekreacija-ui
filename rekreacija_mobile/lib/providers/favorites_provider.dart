import 'package:rekreacija_mobile/models/favorites_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';

class FavoritesProvider extends BaseProvider<FavoritesModel> {
  FavoritesProvider() : super("Favorites");

  @override
  FavoritesModel fromJson(data) {
    return FavoritesModel.fromJson(data);
  }
}
