import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/word.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;
  final AudioPlayer _player = AudioPlayer();

  WordDetailScreen({super.key, required this.word});

  void _playAudio(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$assetPath'));
    } catch (e) {
      print('Không thể phát âm thanh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(word.word)),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Từ: ${word.word}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Trình độ: ${word.level}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'Loại từ: ${word.pos}',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.volume_up),
                      label: Text('US'),
                      onPressed: () => _playAudio(word.usAudio),
                    ),
                    SizedBox(width: 4),
                    Text(
                      word.usPhonetic,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16), // khoảng cách giữa US và UK
                Row(
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.volume_up_outlined),
                      label: Text('UK'),
                      onPressed: () => _playAudio(word.ukAudio),
                    ),
                    SizedBox(width: 4),
                    Text(
                      word.ukPhonetic,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),
            Text(
              'Định nghĩa & Ví dụ:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            ...word.senses.map(
              (sense) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sense.senseIndex}. ${sense.definition}',
                      style: TextStyle(fontSize: 16),
                    ),
                    ...sense.examples.map(
                      (ex) => Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          '- $ex',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
