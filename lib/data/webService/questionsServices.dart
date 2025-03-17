// lib/network/questions_web_services.dart
import 'package:devloper_app/constants/String.dart';
import 'package:dio/dio.dart';
import '../models/question.dart';

class QuestionsWebServices {
  final Dio dio;

  QuestionsWebServices()
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl, // your API base URL defined in your constants
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
        ));

  // Use POST to fetch questions using the provided request body.
  Future<List<Question>> fetchQuestions(Map<String, dynamic> requestBody) async {
    try {
      Response response = await dio.post(
        'generate-questions/',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print("Response data: ${response.data}");  
        
        var data = response.data;
        if (data is Map<String, dynamic>) {
          // Make sure the key "questions" exists:
          if (data.containsKey('questions')) {
            final List<dynamic> questionsJson = data['questions'] as List<dynamic>;
            // Map each JSON object into a Question model.
            return questionsJson
                .map((json) => Question.fromJson(json as Map<String, dynamic>))
                .toList();
          } else {
            throw Exception("Response does not contain 'questions' key.");
          }
        } else if(data is List) {
          // In case the response itself is a list (not expected here)
          return data
              .map((json) => Question.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching questions: $e");
      throw Exception('Error fetching questions');
    }
  }
}
