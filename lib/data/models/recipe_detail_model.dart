class RecipeDetailModel {
  final int id;
  final String title;
  final String? videoPath;
  final String? imgPath;
  final int? kcal;
  final int? totalTime;
  final int? preparationTime;
  final int? nbrServes;
  final List<IngredientGroup> ingredients;
  final List<Step> steps;
  final List<Macro> macros;
  final List<Micro> micros;
  final List<Ustensil> ustensiles;

  RecipeDetailModel({
    required this.id,
    required this.title,
    this.videoPath,
    this.imgPath,
    this.kcal,
    this.totalTime,
    this.preparationTime,
    this.nbrServes,
    required this.ingredients,
    required this.steps,
    required this.macros,
    required this.micros,
    required this.ustensiles,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    // Group ingredients by title
    final Map<String, List<Ingredient>> groupedIngredients = {};
    if (json['ingredients'] != null) {
      for (var item in json['ingredients']) {
        final ingredient = Ingredient.fromJson(item);
        final title = ingredient.title ?? 'Ingrédient';
        if (groupedIngredients.containsKey(title)) {
          groupedIngredients[title]!.add(ingredient);
        } else {
          groupedIngredients[title] = [ingredient];
        }
      }
    }

    return RecipeDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? 'No Title',
      videoPath: json['videoPath'],
      imgPath: json['imgPath'],
      kcal: (json['kcal'] as num?)?.toInt(),
      totalTime: (json['total_time'] as num?)?.toInt(),
      preparationTime: (json['preparation_time'] as num?)?.toInt(),
      nbrServes: (json['nbr_serves'] as num?)?.toInt(),
      ingredients: groupedIngredients.entries
          .map((entry) => IngredientGroup(title: entry.key, items: entry.value))
          .toList(),
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => Step.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      macros:
          (json['macro'] as List<dynamic>?)
              ?.map((e) => Macro.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      micros:
          (json['micro'] as List<dynamic>?)
              ?.map((e) => Micro.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      ustensiles:
          (json['ustensiles'] as List<dynamic>?)
              ?.map((e) => Ustensil.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class IngredientGroup {
  final String title;
  final List<Ingredient> items;
  IngredientGroup({required this.title, required this.items});
}

class Ingredient {
  final String ingredient;
  final String unite;
  final double qteGramme;
  final String? title;

  Ingredient({
    required this.ingredient,
    required this.unite,
    required this.qteGramme,
    this.title,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredient: json['ingredient'] ?? '',
      unite: json['unite'] ?? '',
      qteGramme: (json['qte_gramme'] as num?)?.toDouble() ?? 0.0,
      title: json['title'],
    );
  }
}

class Step {
  final String title;
  final String description;

  Step({required this.title, required this.description});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Macro {
  final String title;
  final double value;
  final String unit;

  Macro({required this.title, required this.value, required this.unit});

  factory Macro.fromJson(Map<String, dynamic> json) {
    String title = json['title'] ?? '';
    // Standardize titles
    if (title.contains('كربوهيدرات')) {
      title = 'الكربوهيدرات';
    } else if (title.contains('بروتينات')) {
      title = 'البروتين';
    } else if (title.contains('دهون')) {
      title = 'الدهون';
    } else if (title.contains('ألياف')) {
      title = 'الألياف';
    }

    return Macro(
      title: title,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? 'غ',
    );
  }
}

class Micro {
  final String title;
  final double value;
  final String unit;

  Micro({required this.title, required this.value, required this.unit});

  factory Micro.fromJson(Map<String, dynamic> json) {
    return Micro(
      title: json['title'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
    );
  }
}

class Ustensil {
  final String title;
  Ustensil({required this.title});

  factory Ustensil.fromJson(Map<String, dynamic> json) {
    return Ustensil(title: json['title'] ?? '');
  }
}
