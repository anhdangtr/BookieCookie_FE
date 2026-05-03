import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../data/models/user_model.dart';

class ManualAddBookViewModel extends ChangeNotifier {
  ManualAddBookViewModel({
    required this.user,
    this.token,
    ApiService? apiService,
  }) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  final UserModel user;
  final String? token;

  bool isSubmitting = false;
  String? errorMessage;

  Future<bool> createBook({
    required String title,
    String? author,
    String status = 'plan_to_read',
    int? rating,
    String? note,
    int? readingYear,
    String? startDate,
    String? finishDate,
    String? coverImagePath,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.postMultipart(
        '/user-books/manual',
        fields: {
          'user_id': user.id.toString(),
          'title': title,
          'author': author ?? '',
          'status': status,
          'rating': rating?.toString() ?? '',
          'reading_year': readingYear?.toString() ?? '',
          'start_date': startDate ?? '',
          'finish_date': finishDate ?? '',
          'note': note ?? '',
        },
        fileField: 'cover',
        filePath: coverImagePath,
        headers: token == null ? null : {'Authorization': 'Bearer $token'},
      );

      if (result['success'] == true) {
        isSubmitting = false;
        notifyListeners();
        return true;
      }

      errorMessage = result['message'] as String? ?? 'Could not create book';
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    isSubmitting = false;
    notifyListeners();
    return false;
  }
}
