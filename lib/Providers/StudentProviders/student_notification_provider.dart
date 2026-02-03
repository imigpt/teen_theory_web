import 'package:flutter/material.dart';
import 'package:teen_theory/Models/StudentModels/student_noti_model.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/app_logger.dart';

class StudentNotificationProvider extends ChangeNotifier {
  final List<Datum> _notifications = [];
  bool _isLoading = false;
  bool _hasFetched = false;
  String? _errorMessage;

  List<Datum> get notifications => List.unmodifiable(_notifications);
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;
  String? get errorMessage => _errorMessage;
  bool get hasData => _notifications.isNotEmpty;

  Future<void> fetchNotifications({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_hasFetched && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      StudentNotificationModel? apiResponse;
      String? apiError;

      await DioClient.studentNotificationApi(
        onSuccess: (response) => apiResponse = response,
        onError: (error) => apiError = error,
      );

      if (apiError != null) throw Exception(apiError);

      _notifications
        ..clear()
        ..addAll(apiResponse?.data ?? []);
      _notifications.sort((a, b) => _getDate(b).compareTo(_getDate(a)));

      _hasFetched = true;
    } catch (e, stack) {
      _errorMessage = e.toString();
      AppLogger.error(message: 'StudentNotificationProvider fetchNotifications error: $e\n$stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() => fetchNotifications(forceRefresh: true);

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  DateTime _getDate(Datum? datum) {
    final createdAt = datum?.createdAt;
    return (createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)).toLocal();
  }
}
