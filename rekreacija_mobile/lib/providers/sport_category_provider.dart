import 'package:rekreacija_mobile/models/sport_category.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';

class SportCategoryProvider extends BaseProvider<SportCategory> {
  SportCategoryProvider() : super("SportCategory");

  @override
  SportCategory fromJson(data) {
    return SportCategory.fromJson(data);
  }
}
