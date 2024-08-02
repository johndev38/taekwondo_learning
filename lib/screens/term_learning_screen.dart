import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';

class TermLearningScreen extends StatefulWidget {
  final String belt;
  final List<String> belts;

  TermLearningScreen({required this.belt, required this.belts});

  @override
  _TermLearningScreenState createState() => _TermLearningScreenState();
}

class _TermLearningScreenState extends State<TermLearningScreen> {
  List<Map<String, dynamic>> terms = [];

  @override
  void initState() {
    super.initState();
    loadTerms();
  }

  Future<void> loadTerms() async {
    final String response = await rootBundle.loadString('assets/terms.json');
    final data = await json.decode(response);

    setState(() {
      if (data[widget.belt] != null) {
        terms = List<Map<String, dynamic>>.from(data[widget.belt]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termes pour ${widget.belt}'),
      ),
      body: terms.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: terms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(terms[index]['term'] ?? ''),
            subtitle: Text(terms[index]['explanation'] ?? ''),
          );
        },
      ),
    );
  }
}
