import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/providers/base_provider.dart';

class ObjectProvider extends BaseProvider<ObjectModel> {
  ObjectProvider() : super("Object");

  @override
  ObjectModel fromJson(data) {
    return ObjectModel.fromJson(data);
  }
}
