import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter iOS native Widget',
      home: WidgetContentPage(),
    );
  }
}

class WidgetContentPage extends StatefulWidget {
  const WidgetContentPage({super.key});

  @override
  State<WidgetContentPage> createState() => _WidgetContentPageState();
}

class _WidgetContentPageState extends State<WidgetContentPage> {
  late final TextEditingController _textController;
  final appGroupName = 'group.howToFlutterIosNativeWidgetiOS16';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(),
            const SizedBox(height: 10),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Enter text to show in widget',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _textController.clear(),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton(
      onPressed: () {
        final String text = _textController.text;
        if (text.isNotEmpty) {
          WidgetKit.setItem(
            'widgetData',
            jsonEncode(WidgetData(text)),
            appGroupName,
          );
          WidgetKit.reloadAllTimelines();
        }
      },
      child: const Text('Show in widget'),
    );
  }
}

class WidgetData {
  final String text;

  WidgetData(this.text);

  WidgetData.fromJson(Map<String, dynamic> json) : text = json['text'];

  Map<String, dynamic> toJson() => {'text': text};
}
