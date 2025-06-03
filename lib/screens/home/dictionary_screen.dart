import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:app_tieng_anh/config/theme.dart';
import 'package:app_tieng_anh/models/dictionary_service.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _resultText = '';
  bool _isLoading = false;
  bool _isEnglishToVietnamese = true;
  bool _isLookupMode = true;

  LookupResult? _lastLookupResult;

  Future<void> _search() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
      _resultText = '';
      _lastLookupResult = null;
    });

    if (_isLookupMode) {
      final result = await DictionaryService.lookupEnglishWord(input);
      if (result == null) {
        setState(() {
          _resultText = 'Không tìm thấy kết quả.';
          _isLoading = false;
        });
        return;
      }

      String definitions = '';
      for (var meaning in result.meanings) {
        final partOfSpeech = meaning['partOfSpeech'] ?? '';
        final defs = meaning['definitions'] ?? [];
        definitions += '\n$partOfSpeech:\n';
        for (var def in defs) {
          definitions += '- ${def['definition'] ?? ''}\n';
          if (def['example'] != null && (def['example'] as String).isNotEmpty) {
            definitions += '  Ví dụ: "${def['example']}"\n';
          }
        }
      }

      setState(() {
        _resultText = definitions.trim();
        _isLoading = false;
        _lastLookupResult = result;
      });
    } else {
      String from = _isEnglishToVietnamese ? 'en' : 'vi';
      String to = _isEnglishToVietnamese ? 'vi' : 'en';

      final translated = await DictionaryService.translate(input, from, to);

      setState(() {
        _resultText = translated ?? 'Không tìm thấy kết quả.';
        _isLoading = false;
        _lastLookupResult = null;
      });
    }
  }

  Future<void> _playAudio() async {
    if (_lastLookupResult == null || _lastLookupResult!.audioUrl.isEmpty) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(_lastLookupResult!.audioUrl));
    } catch (e) {
      print('Lỗi phát âm thanh: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phonetic = _lastLookupResult?.phonetic ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Tra từ điển & Dịch',
          style: AppTextStyles.appName.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input field
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                labelText: 'Nhập từ hoặc câu',
                labelStyle: AppTextStyles.subTitle_1.copyWith(
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.buttonGreen),
                ),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _resultText = '';
                            _lastLookupResult = null;
                          });
                        },
                      ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              onChanged: (_) {
                if (_resultText.isNotEmpty) {
                  setState(() {
                    _resultText = '';
                    _lastLookupResult = null;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Mode & language direction selector
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Chế độ:',
                            style: AppTextStyles.subTitle_1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
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
                            child: DropdownButton<bool>(
                              value: _isLookupMode,
                              underline: const SizedBox(),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.buttonGreen,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: true,
                                  child: Text(
                                    'Tra từ điển (Anh)',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text(
                                    'Dịch văn bản',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                              dropdownColor: Colors.grey[100],
                              onChanged: (value) {
                                setState(() {
                                  _isLookupMode = value ?? true;
                                  _resultText = '';
                                  _lastLookupResult = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!_isLookupMode)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Anh → Việt',
                          style: AppTextStyles.subTitle_1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isEnglishToVietnamese,
                          activeColor: AppColors.buttonGreen,
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: (value) {
                            setState(() {
                              _isEnglishToVietnamese = value;
                              _resultText = '';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Việt → Anh',
                          style: AppTextStyles.subTitle_1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.search, color: Colors.white),
                label: Text(
                  'Tra cứu',
                  style: AppTextStyles.buttonTextPrimary.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                onPressed: _isLoading ? null : _search,
              ),
            ),
            const SizedBox(height: 30),

            // Result display
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonGreen,
                        strokeWidth: 5,
                      ),
                    )
                  : _resultText.isEmpty
                      ? Center(
                          child: Text(
                            'Kết quả sẽ hiển thị ở đây.',
                            style: AppTextStyles.subTitle_1.copyWith(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (phonetic.isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        'Phiên âm: ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          phonetic,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (_lastLookupResult != null && _lastLookupResult!.audioUrl.isNotEmpty)
                                        IconButton(
                                          icon: Icon(
                                            Icons.volume_up,
                                            color: AppColors.buttonGreen,
                                            size: 28,
                                          ),
                                          onPressed: _playAudio,
                                          tooltip: 'Phát âm thanh',
                                        ),
                                    ],
                                  ),
                                if (phonetic.isNotEmpty) const SizedBox(height: 16),
                                Text(
                                  _resultText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}