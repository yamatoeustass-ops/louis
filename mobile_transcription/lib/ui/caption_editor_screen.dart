import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../services/transcription_service.dart';
import '../models/transcription_result.dart';
import '../utils/theme.dart';

class CaptionEditorScreen extends StatefulWidget {
  final File videoFile;
  final TranscriptionResult? result;

  const CaptionEditorScreen({
    super.key,
    required this.videoFile,
    this.result,
  });

  @override
  State<CaptionEditorScreen> createState() => _CaptionEditorScreenState();
}

class _CaptionEditorScreenState extends State<CaptionEditorScreen> {
  TranscriptionResult? _result;
  bool _isLoading = true;
  String? _error;
  Set<int> _selectedWords = {};

  @override
  void initState() {
    super.initState();
    _transcribe();
  }

  Future<void> _transcribe() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = context.read<TranscriptionService>();
      final result = await service.transcribe(
        widget.videoFile,
        onProgress: (progress) {
          if (mounted) {
            // Progress is handled by service
          }
        },
      );

      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _toggleWordSelection(int index) {
    setState(() {
      if (_selectedWords.contains(index)) {
        _selectedWords.remove(index);
      } else {
        _selectedWords.add(index);
      }
    });
  }

  void _selectAllWords() {
    setState(() {
      _selectedWords = Set.from(List.generate(_result?.words.length ?? 0, (i) => i));
    });
  }

  void _deselectAllWords() {
    setState(() {
      _selectedWords.clear();
    });
  }

  Future<void> _exportCaptions(String format) async {
    if (_result == null) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'captions_${DateTime.now().millisecondsSinceEpoch}.$format';
      final file = File('${dir.path}/$filename');

      String content;
      switch (format) {
        case 'srt':
          content = _result!.toSRT();
          break;
        case 'ass':
          content = _result!.toASS();
          break;
        case 'json':
          content = _result!.toJsonExport();
          break;
        default:
          return;
      }

      await file.writeAsString(content);

      // Share the file
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'ViralCaption Export',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Captions exported successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  void _copyToClipboard() {
    if (_result == null) return;

    Clipboard.setData(ClipboardData(text: _result!.transcription));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transcription copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caption Editor'),
        actions: [
          if (_result != null)
            PopupMenuButton<String>(
              onSelected: _exportCaptions,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'srt',
                  child: Row(
                    children: [
                      Icon(Icons.subtitles),
                      SizedBox(width: 8),
                      Text('Export SRT'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'ass',
                  child: Row(
                    children: [
                      Icon(Icons.format_color_text),
                      SizedBox(width: 8),
                      Text('Export ASS (Animated)'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'json',
                  child: Row(
                    children: [
                      Icon(Icons.data_object),
                      SizedBox(width: 8),
                      Text('Export JSON'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clipboard',
                  child: Row(
                    children: [
                      Icon(Icons.copy),
                      SizedBox(width: 8),
                      Text('Copy Text'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildEditor(),
    );
  }

  Widget _buildLoadingState() {
    return Consumer<TranscriptionService>(
      builder: (context, service, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: service.progress > 0 ? service.progress : null,
                  strokeWidth: 4,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                service.isLocalMode
                    ? 'Transcribing on device...'
                    : 'Transcribing in cloud...',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${(service.progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGradientStart,
                ),
              ),
              if (service.isLocalMode) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'First-time transcription may take longer. Subsequent transcriptions will be faster.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Transcription Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _transcribe,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor() {
    if (_result == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Word-level caption chips
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Word-Level Captions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: _selectAllWords,
                          child: const Text('Select All'),
                        ),
                        TextButton(
                          onPressed: _deselectAllWords,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF374151)),
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: List.generate(
                          _result!.words.length,
                          (index) {
                            final word = _result!.words[index];
                            final isSelected = _selectedWords.contains(index);

                            return GestureDetector(
                              onTap: () => _toggleWordSelection(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryGradientStart
                                      : AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : const Color(0xFF4B5563),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      word.text,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      '${word.start.toStringAsFixed(2)}s',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isSelected
                                            ? Colors.black54
                                            : const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Full text preview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: const Color(0xFF374151)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FULL TEXT',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _result!.transcription,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Text'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _exportCaptions('srt'),
                  icon: const Icon(Icons.download),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGradientStart,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
