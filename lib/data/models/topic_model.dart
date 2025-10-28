class TopicModel {
  List<Topic>? topic;

  TopicModel({this.topic});

  TopicModel.fromJson(Map<String, dynamic> json) {
    if (json['topic'] != null) {
      topic = <Topic>[];
      json['topic'].forEach((v) {
        topic!.add(Topic.fromJson(v));
      });
    }
  }
}

class Topic {
  String? title;
  List<TopicRecipe>? recipe;

  Topic({this.title, this.recipe});

  Topic.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['recipe'] != null) {
      recipe = <TopicRecipe>[];
      json['recipe'].forEach((v) {
        recipe!.add(TopicRecipe.fromJson(v));
      });
    }
  }
}

class TopicRecipe {
  int? id;
  String? title;
  String? isPaying;
  String? imgPath;
  int? likes;
  int? totalTime;
  int? kcal; // Assuming kcal might be available, otherwise it will be null

  TopicRecipe({
    this.id,
    this.title,
    this.isPaying,
    this.imgPath,
    this.likes,
    this.totalTime,
    this.kcal,
  });

  TopicRecipe.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    title = json['title'];
    isPaying = json['is_paying'];
    imgPath = json['imgPath'];
    likes = (json['likes'] as num?)?.toInt();
    totalTime = (json['total_time'] as num?)?.toInt();
    // The topic API doesn't provide kcal, so we use 'likes' as a fallback for display purposes.
    kcal = (json['kcal'] as num?)?.toInt() ?? (json['kcal'] as num?)?.toInt();
  }
}

class Category {
  String? title;

  Category({this.title});

  Category.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }
}
