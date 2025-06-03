import 'package:flutter/material.dart';

class LearnedWordsPage extends StatelessWidget {
  final List<String> words;

  const LearnedWordsPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ đã học'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body:
          words.isEmpty
              ? const Center(child: Text('Bạn chưa học từ nào.'))
              : ListView.separated(
                itemCount: words.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text(
                      words[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
    );
  }
}
