import 'package:rekreacija_desktop/models/sport_category.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';

class SportCategoryProvider extends BaseProvder<SportCategory>{
  SportCategoryProvider():super("SportCategory");

   @override
  SportCategory fromJson(data){
    return SportCategory.fromJson(data);
  }
}