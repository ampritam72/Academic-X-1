import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_model.dart';
import 'auth_provider.dart';
import 'routine_provider.dart';

class ChatProvider extends ChangeNotifier {
  final AuthProvider _auth;
  final RoutineProvider _routine;

  // Placeholder for the API Key. The user can replace this.
  static const String _apiKey = 'REPLACE_WITH_YOUR_GEMINI_API_KEY';
  
  ChatProvider(this._auth, this._routine);

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  // Get conversation stream (mocked)
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return Stream.value(_messages.reversed.toList());
  }

  // Send a message and handle AI response if needed
  Future<void> sendMessage(String chatId, String text, bool isAiChat) async {
    final message = ChatMessage(
      id: DateTime.now().toString(),
      text: text,
      type: ChatMessageType.user,
      timestamp: DateTime.now(),
    );

    _messages.add(message);
    notifyListeners();

    // 2. If it's an AI chat, generate a response
    if (isAiChat) {
      _isTyping = true;
      notifyListeners();

      try {
        final aiResponse = await _generateAIResponse(text);
        
        final aiMessage = ChatMessage(
          id: '${DateTime.now()}_ai',
          text: aiResponse,
          type: ChatMessageType.ai,
          timestamp: DateTime.now(),
        );

        _messages.add(aiMessage);
      } catch (e) {
        debugPrint('AI Error: $e');
      } finally {
        _isTyping = false;
        notifyListeners();
      }
    }
  }

  Future<String> _generateAIResponse(String userPrompt) async {
    if (_apiKey == 'REPLACE_WITH_YOUR_GEMINI_API_KEY') {
      return "Hello! I'm your Academic X AI. To enable my full brain, please add your Gemini API Key in 'chat_provider.dart'. \n\nHowever, I can still see your data: \nYou have ${_routine.routines.length} classes in your routine.";
    }

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      
      // Build context
      final context = _buildAIContext();
      final prompt = [Content.text("$context\n\nUser Question: $userPrompt")];
      
      final response = await model.generateContent(prompt);
      return response.text ?? "I'm sorry, I couldn't generate a response.";
    } catch (e) {
      return "I encountered an error while connecting to Gemini. Please check your API Key and internet connection.";
    }
  }

  String _buildAIContext() {
    String context = "You are 'Academic X AI Assistant', a helpful study companion for a university student. ";
    context += "You have access to the user's routine data. Please use this to be helpful.\n";

    final name = _auth.userData?['name'];
    if (name is String && name.trim().isNotEmpty) {
      context += "The user's name is $name.\n";
    }
    
    // Routine Data
    if (_routine.routines.isEmpty) {
      context += "The user has no classes in their routine currently.\n";
    } else {
      context += "User's Routine:\n";
      for (var r in _routine.routines) {
        context += "- ${r.day}: ${r.courseName} (${r.courseCode}) at ${r.startTime} in ${r.location}\n";
      }
    }
    
    context += "\nAnswer the user's question concisely and professionally.";
    return context;
  }
}
