import 'package:diety/data/models/recipe_model.dart';

class FilterModel {
  List<Recipes>? recipes;
  int? total;

  FilterModel({this.recipes, this.total});

  FilterModel.fromJson(Map<String, dynamic> json) {
    if (json['recipes'] != null) {
      recipes = <Recipes>[];
      json['recipes'].forEach((v) {
        recipes!.add(Recipes.fromJson(v));
      });
    }
    total = (json['total'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}
