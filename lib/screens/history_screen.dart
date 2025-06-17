import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TaekwondoHistoryScreen extends StatefulWidget {
  const TaekwondoHistoryScreen({Key? key}) : super(key: key);

  @override
  TaekwondoHistoryScreenState createState() => TaekwondoHistoryScreenState();
}

class TaekwondoHistoryScreenState extends State<TaekwondoHistoryScreen> {
  List<dynamic> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final String response = await rootBundle.loadString('assets/history.json');
    final data = json.decode(response);
    setState(() {
      history = data['history'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histoire du Taekwondo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final section = history[index];
                return _buildSection(
                  context,
                  title: section['title'],
                  content: section['content'],
                );
              },
            ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required String content}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
