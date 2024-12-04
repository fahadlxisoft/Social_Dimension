import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_with_ai_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

export 'chat_with_ai_model.dart';

class ChatWithAiWidget extends StatefulWidget {
  const ChatWithAiWidget({super.key});

  @override
  State<ChatWithAiWidget> createState() => _ChatWithAiWidgetState();
}

class _ChatWithAiWidgetState extends State<ChatWithAiWidget> {
  late ChatWithAiModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> messages = []; // List to hold chat messages
  bool isLoading = false; // To track loading state

  final String apiUrl = 'http://localhost:8080'; // Replace with your actual API URL

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatWithAiModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Function to send the message to the backend and get the response
  Future<void> getAiResponse(String userMessage) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/?m=${Uri.encodeComponent(userMessage)}'),
      );

      if (response.statusCode == 200) {
        final aiResponse = response.body;
        setState(() {
          messages.add('AI: $aiResponse'); // Add AI response to the chat
        });
      } else {
        setState(() {
          messages.add('AI: Error ${response.statusCode}');
        });
      }
    } catch (e) {
      setState(() {
        messages.add('AI: Error: $e');
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        messages[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: isLoading
                        ? null // Disable button if loading
                        : () async {
                            final userMessage = _model.textController?.text.trim();
                            if (userMessage != null && userMessage.isNotEmpty) {
                              setState(() {
                                messages.add('You: $userMessage'); // Add user message
                              });
                              _model.textController?.clear(); // Clear the input field
                              await getAiResponse(userMessage); // Get AI response
                            }
                          },
                  ),
                ],
              ),
            ),
            if (isLoading) CircularProgressIndicator(), // Show loading indicator when fetching AI response
          ],
        ),
      ),
    );
  }
}
