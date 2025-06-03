import 'package:flutter/material.dart';
import '../../models/word.dart';
import 'package:audioplayers/audioplayers.dart';
import 'word_detail_screen.dart';
import '../../services/word_api.dart';
import 'lesson_screen.dart';

class WordListScreen extends StatefulWidget {
  final int userId;
  const WordListScreen({super.key, required this.userId});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final AudioPlayer _player = AudioPlayer();
  List<Word> selectedWords = [];
  List<int> learnedWordIds = [];
  List<Word> words = [];
  String _filterStatus = 'Tất cả'; // Lọc: 'Tất cả', 'Đã học', 'Chưa học'
  String _filterLetter = 'Tất cả'; // Lọc theo chữ cái đầu: 'Tất cả', 'A', 'B', ..., 'Z'

  @override
  void initState() {
    super.initState();
    fetchLearnedWords();
  }

  void fetchLearnedWords() async {
    final ids = await WordApi.getLearnedWords(widget.userId);
    setState(() {
      learnedWordIds = ids;
    });
  }

  void reloadScreen() {
    setState(() {
      selectedWords.clear();
      _filterStatus = 'Tất cả';
      _filterLetter = 'Tất cả';
    });
    fetchLearnedWords();
  }

  void _playAudio(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$assetPath'));
    } catch (e) {
      print('Không thể phát âm thanh: $e');
    }
  }

  bool isWordSelected(Word word) {
    return selectedWords.any(
      (w) =>
          w.word.toLowerCase() == word.word.toLowerCase() &&
          w.pos.toLowerCase() == word.pos.toLowerCase(),
    );
  }

  List<int> getSelectedWordIndices(List<Word> words) {
    final wordMap = {
      for (var i = 0; i < words.length; i++)
        '${words[i].word.toLowerCase()}_${words[i].pos.toLowerCase()}': i,
    };
    return selectedWords
        .map(
          (selectedWord) =>
              wordMap['${selectedWord.word.toLowerCase()}_${selectedWord.pos.toLowerCase()}'] ??
              -1,
        )
        .where((index) => index != -1)
        .toList();
  }

  List<Word> _filteredWords(List<Word> words) {
    List<Word> filteredByStatus = words;
    if (_filterStatus != 'Tất cả') {
      filteredByStatus = words.where((word) {
        final wordId = words.indexOf(word) + 1; // Hoặc word.id nếu có
        final isLearned = learnedWordIds.contains(wordId);
        final isSelected = selectedWords.any(
          (w) =>
              w.word.toLowerCase() == word.word.toLowerCase() &&
              w.pos.toLowerCase() == word.pos.toLowerCase(),
        );

        if (_filterStatus == 'Đã học') return isLearned;
        if (_filterStatus == 'Chưa học') return !isLearned;
        if (_filterStatus == 'Đã chọn') return isSelected;
        return true;
      }).toList();
    }

    if (_filterLetter == 'Tất cả') return filteredByStatus;
    return filteredByStatus.where((word) {
      if (word.word.isEmpty) return false;
      return word.word[0].toUpperCase() == _filterLetter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> letterOptions = [
      'Tất cả',
      ...List.generate(
        26,
        (index) => String.fromCharCode('A'.codeUnitAt(0) + index),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Danh sách từ vựng',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: FutureBuilder<List<Word>>(
        future: loadAllWordsFromList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi: ${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không tìm thấy từ nào',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            );
          }

          words = snapshot.data!;
          final filteredWords = _filteredWords(words);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      "Lọc trạng thái: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 120),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: _filterStatus,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                        items: ['Tất cả', 'Đã học', 'Chưa học', 'Đã chọn']
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        dropdownColor: Colors.grey[100],
                        onChanged: (value) {
                          setState(() {
                            _filterStatus = value!;
                          });
                        },
                      ),
                    ),
                    const Text(
                      "Lọc chữ cái: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 100),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: _filterLetter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                        items: letterOptions
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        dropdownColor: Colors.grey[100],
                        onChanged: (value) {
                          setState(() {
                            _filterLetter = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    final isSelected = isWordSelected(word);
                    final wordId = words.indexOf(word) + 1; // or word.id
                    final isLearned = learnedWordIds.contains(wordId);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: isLearned ? Colors.green[50] : Colors.grey[100],
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word.word,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  word.usPhonetic,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isLearned ? Colors.red : Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              word.level,
                              style: TextStyle(
                                color: isLearned ? Colors.amber[700] : Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    word.senses.isNotEmpty
                                        ? word.senses[0].definition
                                        : 'Không có định nghĩa',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  word.pos,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.volume_up,
                                    size: 20,
                                    color: Colors.indigo,
                                  ),
                                  label: const Text(
                                    'US',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.indigo,
                                  ),
                                  onPressed: () => _playAudio(word.usAudio),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.volume_up_outlined,
                                    size: 20,
                                    color: Colors.indigo,
                                  ),
                                  label: const Text(
                                    'UK',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.indigo,
                                  ),
                                  onPressed: () => _playAudio(word.ukAudio),
                                ),
                                const Spacer(),
                                if (!isLearned)
                                  ElevatedButton.icon(
                                    icon: Icon(
                                      isSelected ? Icons.check : Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      isSelected ? 'Đã chọn' : 'Thêm vào bài học',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected ? Colors.green : Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedWords.removeWhere(
                                            (w) =>
                                                w.word.toLowerCase() ==
                                                    word.word.toLowerCase() &&
                                                w.pos.toLowerCase() ==
                                                    word.pos.toLowerCase(),
                                          );
                                        } else if (selectedWords.length < 10) {
                                          selectedWords.add(word);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Chỉ được chọn tối đa 10 từ!'),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedWords.length < 5) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng chọn ít nhất 5 từ')),
            );
          } else {
            final selectedIndices = getSelectedWordIndices(words);

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonScreen(
                  selectedWords: selectedWords,
                  selectedIndices: selectedIndices,
                  userId: widget.userId,
                ),
              ),
            );

            setState(() {
              selectedWords.clear();
            });
            reloadScreen();
          }
        },
        backgroundColor: Colors.blue,
        label: const Text(
          'Bắt đầu bài học',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}