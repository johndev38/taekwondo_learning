import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TaekwondoRulesScreen extends StatefulWidget {
  @override
  _TaekwondoRulesScreenState createState() => _TaekwondoRulesScreenState();
}

class _TaekwondoRulesScreenState extends State<TaekwondoRulesScreen> {
  List<dynamic> rules = [];

  @override
  void initState() {
    super.initState();
    loadRules();
  }

  Future<void> loadRules() async {
    final String response = await rootBundle.loadString('assets/rules.json');
    final data = json.decode(response);
    setState(() {
      rules = data['rules'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Règles d\'Arbitrage'),
      ),
      body: rules.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: rules.length,
        itemBuilder: (context, index) {
          final rule = rules[index];
          return _buildSection(
            context,
            title: rule['title'],
            content: rule['content'],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
