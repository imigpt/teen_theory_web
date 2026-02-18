import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:teen_theory/Models/CommonModels/google_calender_model.dart';
import 'package:teen_theory/Services/google_auth_service.dart';

class GoogleCalendarService {
  static final GoogleCalendarService _instance = GoogleCalendarService._internal();
  factory GoogleCalendarService() => _instance;
  GoogleCalendarService._internal();

  final GoogleAuthService _authService = GoogleAuthService();
  static const String _baseUrl = 'https://www.googleapis.com/calendar/v3';

  /// Fetch calendar events from Google Calendar API
  Future<GoogleCalenderModel?> fetchCalendarEvents({
    DateTime? timeMin,
    DateTime? timeMax,
    int maxResults = 100,
  }) async {
    try {
      // Get access token
      final String? accessToken = await _authService.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token available');
        return null;
      }

      // Set default time range (last 30 days to next 90 days)
      final DateTime startTime = timeMin ?? DateTime.now().subtract(const Duration(days: 30));
      final DateTime endTime = timeMax ?? DateTime.now().add(const Duration(days: 90));

      // Build request URL
      final Uri uri = Uri.parse('$_baseUrl/calendars/primary/events').replace(
        queryParameters: {
          'timeMin': startTime.toUtc().toIso8601String(),
          'timeMax': endTime.toUtc().toIso8601String(),
          'maxResults': maxResults.toString(),
          'singleEvents': 'true',
          'orderBy': 'startTime',
        },
      );

      // Make API request
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return GoogleCalenderModel.fromJson(jsonData);
      } else {
        debugPrint('Failed to fetch events: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching calendar events: $e');
      return null;
    }
  }

  /// Fetch events for a specific date
  Future<List<Item>> fetchEventsForDate(DateTime date) async {
    try {
      final DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final GoogleCalenderModel? calendarData = await fetchCalendarEvents(
        timeMin: startOfDay,
        timeMax: endOfDay,
      );

      return calendarData?.items ?? [];
    } catch (e) {
      debugPrint('Error fetching events for date: $e');
      return [];
    }
  }

  /// Get events grouped by date
  Map<DateTime, List<Item>> groupEventsByDate(List<Item> events) {
    final Map<DateTime, List<Item>> groupedEvents = {};

    for (final event in events) {
      if (event.start?.dateTime != null) {
        final DateTime eventDate = DateTime(
          event.start!.dateTime!.year,
          event.start!.dateTime!.month,
          event.start!.dateTime!.day,
        );

        if (!groupedEvents.containsKey(eventDate)) {
          groupedEvents[eventDate] = [];
        }
        groupedEvents[eventDate]!.add(event);
      }
    }

    return groupedEvents;
  }

  /// Check if event has Google Meet link
  bool hasMeetLink(Item event) {
    return event.hangoutLink != null && event.hangoutLink!.isNotEmpty;
  }

  /// Get Google Meet link from event
  String? getMeetLink(Item event) {
    return event.hangoutLink;
  }

  /// Create a calendar event with Google Meet link
  Future<Map<String, dynamic>?> createCalendarEventWithMeet({
    required String summary,
    required String description,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String timeZone = 'Asia/Kolkata',
  }) async {
    try {
      // Get access token
      final String? accessToken = await _authService.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('No access token available');
        return null;
      }

      // Generate unique request ID for Google Meet
      final String requestId = 'meet-${DateTime.now().millisecondsSinceEpoch}';

      // Build request body
      final Map<String, dynamic> requestBody = {
        'summary': summary,
        'description': description,
        'start': {
          'dateTime': startDateTime.toIso8601String(),
          'timeZone': timeZone,
        },
        'end': {
          'dateTime': endDateTime.toIso8601String(),
          'timeZone': timeZone,
        },
        'conferenceData': {
          'createRequest': {
            'requestId': requestId,
            'conferenceSolutionKey': {
              'type': 'hangoutsMeet',
            },
          },
        },
      };

      // Build request URL with conferenceDataVersion parameter
      final Uri uri = Uri.parse(
        '$_baseUrl/calendars/primary/events?conferenceDataVersion=1',
      );

      // Make API request
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        debugPrint('Event created successfully');
        debugPrint('Google Meet link: ${jsonData['hangoutLink']}');
        return jsonData;
      } else {
        debugPrint('Failed to create event: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating calendar event: $e');
      return null;
    }
  }
}
