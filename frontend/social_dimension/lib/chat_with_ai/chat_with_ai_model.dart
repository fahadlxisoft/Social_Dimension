import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_with_ai_widget.dart' show ChatWithAiWidget;

class ChatWithAiModel extends FlutterFlowModel<ChatWithAiWidget> {
  // State fields for stateful widgets in this page.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // API endpoint
  final String apiUrl = "http://localhost:8080/";

  // Function to send user input to backend and receive response
  Future<String?> getAiResponse(String message) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?m=${Uri.encodeComponent(message)}'),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to fetch response: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
