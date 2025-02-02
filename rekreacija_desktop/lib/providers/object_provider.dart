import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/providers/base_provider.dart';

class ObjectProvider extends BaseProvder<ObjectModel>{
  ObjectProvider():super("Object");

  @override
  ObjectModel fromJson(data){
    return ObjectModel.fromJson(data);
  }
}