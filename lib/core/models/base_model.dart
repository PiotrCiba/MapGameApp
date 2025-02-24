// core/models/base_model.dart
abstract class BaseModel {
  String id;

  BaseModel({
    required this.id,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return ConcreteBaseModel(
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson();
}

class ConcreteBaseModel extends BaseModel {
  ConcreteBaseModel({
    required super.id,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

abstract class Identifiable {
  String get id;
}