import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/transcription_result.dart';

/// Whisper.cpp FFI bindings for on-device transcription
/// 
/// whisper.cpp is a C/C++ port of OpenAI Whisper that runs efficiently on mobile CPUs
/// GitHub: https://github.com/ggerganov/whisper.cpp
class WhisperLocalService {
  static const String MODEL_REPO = 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main';
  
  final Map<String, String> _modelFiles = {
    'tiny': 'ggml-tiny.bin',
    'base': 'ggml-base.bin',
    'small': 'ggml-small.bin',
    'medium': 'ggml-medium.bin',
  };
  
  String _currentModel = 'base';
  bool _isModelDownloaded = false;
  DynamicLibrary? _whisperLib;
  
  bool get isModelDownloaded => _isModelDownloaded;
  String get currentModel => _currentModel;
  
  Future<void> initialize() async {
    // Check if model exists
    final modelPath = await _getModelPath(_currentModel);
    _isModelDownloaded = await File(modelPath).exists();
    
    // Load whisper.cpp shared library
    await _loadLibrary();
  }
  
  Future<void> _loadLibrary() async {
    try {
      if (Platform.isAndroid) {
        _whisperLib = await DynamicLibrary.open('libwhisper.so');
      } else if (Platform.isIOS) {
        _whisperLib = await DynamicLibrary.open('whisper.framework/whisper');
      }
    } catch (e) {
      // Library not bundled - will use fallback or error
      print('Failed to load whisper library: $e');
    }
  }
  
  Future<String> _getModelPath(String modelSize) async {
    final dir = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${dir.path}/whisper_models');
    await modelDir.create(recursive: true);
    return '${modelDir.path}/${_modelFiles[modelSize] ?? 'ggml-base.bin'}';
  }
  
  Future<void> downloadModel([String? modelSize]) async {
    final size = modelSize ?? _currentModel;
    final modelPath = await _getModelPath(size);
    
    if (await File(modelPath).exists()) {
      return; // Already downloaded
    }
    
    final url = '$MODEL_REPO/${_modelFiles[size]}';
    final client = http.Client();
    
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);
      
      final totalBytes = response.contentLength;
      final file = File(modelPath);
      final sink = file.openWrite();
      
      int downloadedBytes = 0;
      
      await response.stream.forEach((chunk) async {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        
        if (totalBytes != null && totalBytes > 0) {
          // Progress callback could be added here
        }
      });
      
      await sink.close();
      _isModelDownloaded = true;
    } finally {
      client.close();
    }
  }
  
  Future<TranscriptionResult> transcribe(
    File audioFile, {
    Function(double)? onProgress,
  }) async {
    if (!_isModelDownloaded) {
      throw Exception('Model not downloaded. Please download a model first.');
    }
    
    final modelPath = await _getModelPath(_currentModel);
    
    // Use whisper.cpp CLI or FFI
    // In production, you would:
    // 1. Use FFI to call whisper_init() and whisper_full()
    // 2. Or use process.run to call the whisper.cpp CLI
    
    // Placeholder implementation using whisper.cpp CLI approach
    return await _transcribeWithCli(modelPath, audioFile, onProgress: onProgress);
  }
  
  Future<TranscriptionResult> _transcribeWithCli(
    String modelPath,
    File audioFile, {
    Function(double)? onProgress,
  }) async {
    // This would use Process.run to execute whisper.cpp
    // Example command:
    // ./main -m ggml-base.bin -f audio.wav -ojf
    
    // For now, return a mock result
    // In production, integrate with whisper.cpp properly
    
    await Future.delayed(const Duration(seconds: 2)); // Simulate processing
    
    onProgress?.call(0.5);
    
    // Mock transcription result
    return TranscriptionResult(
      filename: audioFile.path.split('/').last,
      transcription: 'This is a mock transcription result. In production, this will contain actual AI-generated text from whisper.cpp.',
      words: [
        WordData(start: 0.0, end: 0.5, text: 'This'),
        WordData(start: 0.5, end: 0.8, text: 'is'),
        WordData(start: 0.8, end: 1.2, text: 'a'),
        WordData(start: 1.2, end: 1.8, text: 'mock'),
        WordData(start: 1.8, end: 2.5, text: 'transcription'),
        WordData(start: 2.5, end: 3.0, text: 'result'),
      ],
      srtUrl: null,
    );
  }
  
  Future<void> switchModel(String modelSize) async {
    if (!_modelFiles.containsKey(modelSize)) {
      throw Exception('Invalid model size: $modelSize');
    }
    
    _currentModel = modelSize;
    final modelPath = await _getModelPath(modelSize);
    _isModelDownloaded = await File(modelPath).exists();
  }
  
  Future<void> deleteModel(String modelSize) async {
    final modelPath = await _getModelPath(modelSize);
    final file = File(modelPath);
    if (await file.exists()) {
      await file.delete();
    }
    if (modelSize == _currentModel) {
      _isModelDownloaded = false;
    }
  }
  
  Future<int> getDownloadedModelSize() async {
    if (!_isModelDownloaded) return 0;
    
    final modelPath = await _getModelPath(_currentModel);
    final file = File(modelPath);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }
}
