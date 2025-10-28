import 'dart:convert';
import 'dart:io';
import 'package:diety/data/models/notification_model.dart';
import 'package:diety/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:diety/presentation/widgets/session_manager.dart';
import 'package:logger/logger.dart'; // Import a logging package
import 'package:diety/data/models/recipe_model.dart';
import 'package:diety/data/models/recipe_detail_model.dart';
import 'package:diety/data/models/topic_model.dart';
import 'package:diety/data/models/category_recipes_model.dart';
import 'package:diety/data/models/type_repas_model.dart';
import 'package:diety/presentation/widgets/const.dart' as constants;

final _logger = Logger(); // Initialize a logger instance

class ApiService {
  Future<Map<String, dynamic>> login(
    String phoneNumber,
    String password,
  ) async {
    final url = Uri.parse('${constants.baseUrl}diet/auth');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone_number': phoneNumber, 'password': password}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['status'] == 'success') {
        return responseBody;
      } else if (response.statusCode == 404 &&
          responseBody['status'] == 'error') {
        return responseBody;
      } else {
        throw Exception(
          responseBody['message'] ??
              'Login failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Login Error: $e'); // Use logger for error
      throw Exception('بيانات اعتماد غير صالحة');
    }
  }

  Future<Map<String, dynamic>> editUser({
    required String name,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('${constants.baseUrl}diet/editUser');
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();
    _logger.d("token: $token");
    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'phone': phoneNumber, 'name': name}),
      );

      final responseBody = jsonDecode(response.body); // Removed 'new'
      _logger.d("responseBody: $responseBody");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseBody['user'] != null) {
        return responseBody['user'];
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to update profile.');
      }
    } on http.ClientException catch (e) {
      // Catches network-related errors (e.g., no internet, DNS failure)
      _logger.e('Network Error in editUser: $e'); // Use logger
      throw Exception(
        'Could not connect to the server. Please check your internet connection.',
      );
    } catch (e) {
      // Catches other errors, like JSON parsing failures or unexpected issues.
      _logger.e('Unexpected Error in editUser: $e'); // Use logger
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<Recipe> getMySaves() async {
    final url = Uri.parse('${constants.baseUrl}diet/mySaves');
    final sessionManager = SessionManager();
    final userId = await sessionManager.getUserId();
    final token = await sessionManager.getToken();

    if (userId == null || token == null) {
      // If the user is not logged in, they have no saved recipes.
      // Return an empty Recipe object instead of throwing an error.
      // This is a valid state and should be handled gracefully by the UI.
      print('getMySaves: User not authenticated, returning empty list.');
      return Recipe(recipes: []);
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! Map<String, dynamic> || data['recipes'] is! List) {
          _logger.w(
            // Use logger for warning
            'getMySaves: Unexpected response format. Returning empty list.',
          );
          return Recipe(recipes: []);
        }

        // With the robust fromJson constructor, we can parse directly.
        // The try-catch inside the map handles any truly malformed records
        // without crashing the entire process.
        final List<Recipes> validRecipes = (data['recipes'] as List)
            .map((item) {
              try {
                return item is Map<String, dynamic>
                    ? Recipes.fromJson(item)
                    : null;
              } catch (e) {
                _logger.e(
                  // Use logger for error
                  'getMySaves: Could not parse a recipe, skipping. Error: $e',
                );
                return null;
              }
            })
            .whereType<Recipes>() // Filter out nulls from failed parses
            .toList();

        return Recipe(recipes: validRecipes);
      } else {
        throw Exception(
          'Failed to load saved recipes. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('getMySaves Error: $e'); // Use logger
      // Propagate the actual error instead of masking it as a connection issue.
      // This provides better insight into what failed (e.g., JSON parsing).
      throw Exception('Failed to parse saved recipes: $e');
    }
  }

  Future<CategoryRecipesResponse> filterRecipes({
    required List<String> meals,
    required List<String> ingredients,
    required List<String> methods,
    required List<String> diets,
    required int kcalMin,
    required int kcalMax,
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse('${constants.baseUrl}diet/filter');
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final body = {
      "meal": meals,
      "ingredient": ingredients,
      "method": methods,
      "diet": diets,
      "kcalMin": kcalMin,
      "kcalMax": kcalMax,
      "page": page,
      "limit": limit,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CategoryRecipesResponse.fromJson(data);
      } else {
        throw Exception('Failed to load filtered recipes.');
      }
    } catch (e) {
      _logger.e('filterRecipes Error: $e'); // Use logger
      throw Exception('Could not connect to the server.');
    }
  }

  Future<CategoryRecipesResponse> searchRecipes({
    required String searchQuery,
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
      '${constants.baseUrl}diet/search?searchQuery=${Uri.encodeComponent(searchQuery)}&page=$page&limit=$limit',
    );
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Origin': 'https://www.diety.tn',
          'Referer': 'https://www.diety.tn/',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CategoryRecipesResponse.fromJson(data);
      } else {
        throw Exception('Failed to search recipes.');
      }
    } catch (e) {
      _logger.e('searchRecipes Error: $e'); // Use logger
      throw Exception('Could not connect to the server.');
    }
  }

  Future<List<Topic>> getTopics() async {
    final url = Uri.parse('${constants.baseUrl}diet/topic');
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TopicModel.fromJson(data).topic ?? [];
      } else {
        throw Exception('Failed to load topics.');
      }
    } catch (e) {
      _logger.e('getTopics Error: $e'); // Use logger
      throw Exception('Could not connect to the server.');
    }
  }

  Future<List<TypeRepasItem>> getTypeRepas() async {
    final url = Uri.parse('${constants.baseUrl}diet/typeRepas');
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return TypeRepasItem.fromJsonList(data);
      } else {
        throw Exception('Failed to load meal types.');
      } // Removed 'new'
    } catch (e) {
      _logger.e('getTypeRepas Error: $e'); // Use logger
      throw Exception('Could not connect to the server.');
    }
  }

  Future<List<Recipes>> getRandomRecipes() async {
    final url = Uri.parse('${constants.baseUrl}diet/randomRecipes');
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Recipes.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load random recipes.');
      } // Removed 'new'
    } catch (e) {
      _logger.e('getRandomRecipes Error: $e'); // Use logger
      throw Exception('Could not connect to the server.');
    }
  }

  Future<CategoryRecipesResponse> getRecipesByCategory({
    required String category,
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
      '${constants.baseUrl}diet/recipesByCategories/${Uri.encodeComponent(category)}?page=$page&limit=$limit',
    );
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CategoryRecipesResponse.fromJson(data);
      } else {
        throw Exception('Failed to load recipes for category $category.');
      }
    } catch (e) {
      print('getRecipesByCategory Error: $e');
      throw Exception('Could not connect to the server.');
    }
  }

  Future<RecipeDetailModel> getRecipeById(int recipeId) async {
    final url = Uri.parse('${constants.baseUrl}diet/recipe/$recipeId');
    final sessionManager = SessionManager();
    final token = await sessionManager.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RecipeDetailModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to load recipe with id $recipeId. Status code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      _logger.e('getRecipeById Error: $e'); // Use logger
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> saveRecipe(int recipeId) async {
    final url = Uri.parse('${constants.baseUrl}diet/saveRecipe');
    final sessionManager = SessionManager();
    final userId = await sessionManager.getUserId();
    final token = await sessionManager.getToken();

    if (userId == null || token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId, 'recipeId': recipeId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // The server returned an error.
        final responseBody = jsonDecode(response.body);
        throw Exception(
          responseBody['message'] ?? 'Failed to save recipe status.',
        );
      }
      // Success, no need to return anything.
    } catch (e) {
      _logger.e('saveRecipe Error: $e'); // Use logger for error
      throw Exception(
        'Could not update favorite status. Please try again.',
      ); // Removed 'new'
    }
  }

  Future<User> uploadImage({required File imageFile}) async {
    final url = Uri.parse('${constants.baseUrl}diet/uploadImage');
    final sessionManager = SessionManager();
    final userId = await sessionManager.getUserId();
    final token = await sessionManager.getToken();

    if (token == null || userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Send userId as a regular field in the multipart request
      request.fields['userId'] = userId.toString();
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // This 'image' key must match your backend's expected key
          imageFile.path,
        ),
      );
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        // The API returns { "imageUrl": "..." }. We need to merge this with the existing user.
        final User? currentUser = await sessionManager.getUser();
        if (currentUser == null) {
          throw Exception('Could not find current user to update image.');
        }

        // The toJson() method might return a String or a Map. We handle both.
        final dynamic userJson = currentUser.toJson();
        Map<String, dynamic> userMap;
        if (userJson is String) {
          userMap = jsonDecode(userJson); // Decode the string into a map
        } else if (userJson is Map<String, dynamic>) {
          userMap = userJson; // It's already a map
        } else {
          throw Exception('Unexpected format from User.toJson()');
        }

        userMap['image'] = responseBody['imageUrl'];
        return User.fromJson(userMap);
      } else {
        // Try to parse a specific error message from the server response
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('error')) {
            throw Exception(errorBody['error']);
          }
        } catch (_) {
          // Fallback for unexpected error formats
          throw Exception('Failed to upload image: ${response.body}');
        }
        throw Exception('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      _logger.e('uploadImage Error: $e');
      throw Exception('Could not upload image. Please try again.');
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    final sessionManager = SessionManager();
    final userId = await sessionManager.getUserId();
    final token = await sessionManager.getToken();

    if (userId == null || token == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('${constants.baseUrl}notifications?userId=$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications.');
      }
    } catch (e) {
      _logger.e('getNotifications Error: $e');
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final url = Uri.parse('${constants.baseUrl}readNotification');
    final sessionManager = SessionManager();
    final userId = await sessionManager.getUserId();
    final token = await sessionManager.getToken();

    if (userId == null || token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'notificationId': notificationId, 'userId': userId}),
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception(
          responseBody['message'] ?? 'Failed to mark notification as read.',
        );
      }
    } catch (e) {
      _logger.e('markNotificationAsRead Error: $e');
      throw Exception('Could not mark notification as read.');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final url = Uri.parse('${constants.baseUrl}deleteNotification');
    final sessionManager = SessionManager();
    final userId = await sessionManager.getUserId();
    final token = await sessionManager.getToken();

    if (userId == null || token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'notificationId': notificationId, 'userId': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete notification.');
      }
    } catch (e) {
      _logger.e('deleteNotification Error: $e');
      throw Exception('Could not delete notification.');
    }
  }
}
