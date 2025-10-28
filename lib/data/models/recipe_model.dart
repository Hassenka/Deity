/// Safely parses a value to an integer. Returns 0 if parsing fails.
// ignore: unused_element
int _toInt(dynamic v) =>
    v == null ? 0 : (v is int ? v : int.tryParse(v.toString()) ?? 0);

/// Safely parses a value to a nullable integer. Returns null if parsing fails.
int? _toNullableInt(dynamic v) =>
    v == null ? null : (v is int ? v : int.tryParse(v.toString()));

class Recipe {
  String? message;
  List<Recipes>? recipes;

  Recipe({this.message, this.recipes});

  Recipe.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['recipes'] != null) {
      recipes = <Recipes>[];
      (json['recipes'] as List).forEach((v) {
        recipes!.add(Recipes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recipes {
  int? id;
  String? title;
  String? slug;
  String? description;
  String? difficulty;
  int? nbrServes;
  int? preparationTime;
  int? cookingTime;
  int? totalTime;
  int? cookingTemperature;
  String? videoLink;
  String? status;
  int? rank;
  String? seoDescription;
  String? seoTitle;
  String? idIntern;
  String? author;
  String? note;
  String? ingredientTitle;
  String? isPaying;
  String? videoPath;
  String? imgPath;
  int? likes;
  int? glucides;
  int? graisses;
  int? proteines;
  int? lipides;
  int? kcal;
  int? kcal100gr;
  int? fibres;
  dynamic rubrique;
  dynamic scheduledOn;
  String? scheduledAt;
  String? createdAt;
  String? updatedAt;
  List<TypeRepas>? typeRepas;
  List<UserRecipes>? userRecipes;
  List<dynamic>? userLikes;

  Recipes({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.difficulty,
    this.nbrServes,
    this.preparationTime,
    this.cookingTime,
    this.totalTime,
    this.cookingTemperature,
    this.videoLink,
    this.status,
    this.rank,
    this.seoDescription,
    this.seoTitle,
    this.idIntern,
    this.author,
    this.note,
    this.ingredientTitle,
    this.isPaying,
    this.videoPath,
    this.imgPath,
    this.likes,
    this.glucides,
    this.graisses,
    this.proteines,
    this.lipides,
    this.kcal,
    this.kcal100gr,
    this.fibres,
    this.rubrique,
    this.scheduledOn,
    this.scheduledAt,
    this.createdAt,
    this.updatedAt,
    this.typeRepas,
    this.userRecipes,
    this.userLikes,
  });

  Recipes.fromJson(Map<String, dynamic> json) {
    id = _toNullableInt(json['id']);
    title = json['title'] ?? '';
    slug = json['slug'] ?? '';
    description = json['description'] ?? '';
    difficulty = json['difficulty'] ?? '';
    nbrServes = _toNullableInt(json['nbr_serves']);
    preparationTime = _toNullableInt(json['preparation_time']);
    cookingTime = _toNullableInt(json['cooking_time']);
    totalTime = _toNullableInt(json['total_time']);
    cookingTemperature = _toNullableInt(json['cooking_temperature']);
    videoLink = json['video_link'] ?? '';
    status = json['status'] ?? '';
    rank = _toNullableInt(json['rank']);
    seoDescription = json['seoDescription'] ?? '';
    seoTitle = json['seoTitle'] ?? '';
    idIntern = json['id_intern'] ?? '';
    author = json['author'] ?? '';
    note = json['note'] ?? '';
    ingredientTitle = json['ingredient_title'] ?? '';
    isPaying = json['is_paying'] ?? '';
    videoPath = json['videoPath'] ?? '';
    imgPath = json['imgPath'] ?? '';
    likes = _toNullableInt(json['likes']);
    glucides = _toNullableInt(json['glucides']);
    graisses = _toNullableInt(json['graisses']);
    proteines = _toNullableInt(json['proteines']);
    lipides = _toNullableInt(json['lipides']);
    kcal = _toNullableInt(json['kcal']);
    kcal100gr = _toNullableInt(json['kcal100gr']);
    fibres = _toNullableInt(json['fibres']);
    rubrique = json['rubrique'];
    scheduledOn = json['scheduledOn'];
    scheduledAt = json['scheduledAt'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    if (json['typeRepas'] != null) {
      typeRepas = <TypeRepas>[];
      json['typeRepas'].forEach((v) {
        typeRepas!.add(TypeRepas.fromJson(v));
      });
    }
    if (json['userRecipes'] != null) {
      userRecipes = <UserRecipes>[];
      json['userRecipes'].forEach((v) {
        userRecipes!.add(UserRecipes.fromJson(v));
      });
    }
    userLikes = json['userLikes'] != null
        ? List<dynamic>.from(json['userLikes'])
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['difficulty'] = this.difficulty;
    data['nbr_serves'] = this.nbrServes;
    data['preparation_time'] = this.preparationTime;
    data['cooking_time'] = this.cookingTime;
    data['total_time'] = this.totalTime;
    data['cooking_temperature'] = this.cookingTemperature;
    data['video_link'] = this.videoLink;
    data['status'] = this.status;
    data['rank'] = this.rank;
    data['seoDescription'] = this.seoDescription;
    data['seoTitle'] = this.seoTitle;
    data['id_intern'] = this.idIntern;
    data['author'] = this.author;
    data['note'] = this.note;
    data['ingredient_title'] = this.ingredientTitle;
    data['is_paying'] = this.isPaying;
    data['videoPath'] = this.videoPath;
    data['imgPath'] = this.imgPath;
    data['likes'] = this.likes;
    data['glucides'] = this.glucides;
    data['graisses'] = this.graisses;
    data['proteines'] = this.proteines;
    data['lipides'] = this.lipides;
    data['kcal'] = this.kcal;
    data['kcal100gr'] = this.kcal100gr;
    data['fibres'] = this.fibres;
    data['rubrique'] = this.rubrique;
    data['scheduledOn'] = this.scheduledOn;
    data['scheduledAt'] = this.scheduledAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.typeRepas != null) {
      data['typeRepas'] = this.typeRepas!.map((v) => v.toJson()).toList();
    }
    if (this.userRecipes != null) {
      data['userRecipes'] = this.userRecipes!.map((v) => v.toJson()).toList();
    }
    data['userLikes'] = this.userLikes;
    return data;
  }
}

class TypeRepas {
  int? id;
  String? title;
  int? recipesId;

  TypeRepas({this.id, this.title, this.recipesId});

  TypeRepas.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    title = json['title'];
    recipesId = (json['recipesId'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['recipesId'] = this.recipesId;
    return data;
  }
}

class UserRecipes {
  int? id;
  String? userId;
  int? recipeId;

  UserRecipes({this.id, this.userId, this.recipeId});

  UserRecipes.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    userId = json['userId'];
    recipeId = (json['recipeId'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['recipeId'] = this.recipeId;
    return data;
  }
}
