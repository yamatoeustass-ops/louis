import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transcription_result.dart';
import 'whisper_local_service.dart';

enum TranscriptionMode {
  local,      // On-device whisper.cpp
  cloud,      // FastAPI backend
  auto,       // Auto-select based on conditions
}

class TranscriptionService extends ChangeNotifier {
  WhisperLocalService? _localService;
  bool _isInitialized = false;
  bool _isProcessing = false;
  double _progress = 0.0;
  TranscriptionMode _mode = TranscriptionMode.auto;
  String? _cloudBaseUrl;
  bool _preferLocalWhenOffline = true;
  
  // Cloud API configuration
  static const String DEFAULT_CLOUD_URL = 'http://192.168.1.100:8000';
  
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  double get progress => _progress;
  TranscriptionMode get mode => _mode;
  bool get isLocalMode => _mode == TranscriptionMode.local;
  String? get cloudBaseUrl => _cloudBaseUrl;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Load preferences
    final prefs = await SharedPreferences.getInstance();
    _cloudBaseUrl = prefs.getString('cloud_url') ?? DEFAULT_CLOUD_URL;
    _preferLocalWhenOffline = prefs.getBool('prefer_local') ?? true;
    
    // Initialize local whisper.cpp service
    try {
      _localService = WhisperLocalService();
      await _localService!.initialize();
      debugPrint('Whisper local service initialized');
    } catch (e) {
      debugPrint('Failed to initialize local service: $e');
    }
    
    _isInitialized = true;
    notifyListeners();
  }
  
  Future<void> setMode(TranscriptionMode newMode) async {
    _mode = newMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mode', newMode.name);
    notifyListeners();
  }
  
  Future<void> setCloudUrl(String url) async {
    _cloudBaseUrl = url;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cloud_url', url);
    notifyListeners();
  }
  
  Future<TranscriptionResult> transcribe(
    File videoFile, {
    Function(double)? onProgress,
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized');
    }
    
    _isProcessing = true;
    _progress = 0.0;
    notifyListeners();
    
    try {
      // Determine which mode to use
      final useLocal = await _shouldUseLocal();
      
      debugPrint('Transcription mode: ${useLocal ? 'LOCAL' : 'CLOUD'}');
      
      final TranscriptionResult result;
      
      if (useLocal) {
        if (_localService == null) {
          throw Exception('Local service not available. Please enable cloud mode.');
        }
        
        result = await _transcribeLocal(videoFile, onProgress: onProgress);
      } else {
        result = await _transcribeCloud(videoFile, onProgress: onProgress);
      }
      
      _progress = 1.0;
      notifyListeners();
      
      return result;
    } catch (e) {
      // Fallback: if cloud fails and local is available, try local
      if (_mode != TranscriptionMode.local && _localService != null) {
        debugPrint('Cloud failed, falling back to local: $e');
        try {
          final result = await _transcribeLocal(videoFile, onProgress: onProgress);
          _progress = 1.0;
          notifyListeners();
          return result;
        } catch (localError) {
          throw Exception('Both transcription methods failed. Cloud: $e, Local: $localError');
        }
      }
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }
  
  Future<bool> _shouldUseLocal() async {
    switch (_mode) {
      case TranscriptionMode.local:
        return true;
      case TranscriptionMode.cloud:
        return false;
      case TranscriptionMode.auto:
        // Auto mode: prefer local for short videos, offline, or user preference
        if (!_preferLocalWhenOffline) {
          return false;
        }
        
        // Check network connectivity (simplified - in production use connectivity_plus)
        final isOnline = await _checkConnectivity();
        
        if (!isOnline) {
          return true; // Must use local when offline
        }
        
        // For videos < 60 seconds, prefer local
        // (In production, check actual video duration)
        return true; // Default to local for battery/privacy
    }
  }
  
  Future<bool> _checkConnectivity() async {
    try {
      final response = await http.get(
        Uri.parse('$_cloudBaseUrl/health'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  Future<TranscriptionResult> _transcribeLocal(
    File videoFile, {
    Function(double)? onProgress,
  }) async {
    if (_localService == null) {
      throw Exception('Local service not initialized');
    }
    
    // Extract audio from video using FFmpeg
    final audioFile = await _extractAudio(videoFile);
    
    // Transcribe with whisper.cpp
    final result = await _localService!.transcribe(
      audioFile,
      onProgress: (progress) {
        _progress = progress * 0.9; // 90% for transcription
        onProgress?.call(_progress);
        notifyListeners();
      },
    );
    
    _progress = 1.0;
    notifyListeners();
    
    return result;
  }
  
  Future<TranscriptionResult> _transcribeCloud(
    File videoFile, {
    Function(double)? onProgress,
  }) async {
    // Upload and transcribe via cloud API
    final uri = Uri.parse('$_cloudBaseUrl/transcribe');
    
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      videoFile.path,
    ));
    
    final streamedResponse = await request.send().timeout(
      const Duration(minutes: 5),
      onTimeout: () => throw Exception('Upload timeout'),
    );
    
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode != 200) {
      throw Exception('Cloud API error: ${response.statusCode} - ${response.body}');
    }
    
    // Parse response
    final jsonData = http.jsonDecode(response.body);
    
    _progress = 1.0;
    notifyListeners();
    
    return TranscriptionResult.fromJson(jsonData);
  }
  
  Future<File> _extractAudio(File videoFile) async {
    // In production, use ffmpeg_kit_flutter
    // For now, return the video file path (whisper.cpp can handle video directly)
    final tempDir = await getTemporaryDirectory();
    final audioPath = '${tempDir.path}/audio_${Random().nextInt(10000)}.wav';
    
    // FFmpeg command: extract audio from video
    // ffmpeg -i input.mp4 -vn -acodec pcm_s16le -ar 16000 -ac 1 output.wav
    
    // Note: Actual FFmpeg implementation would go here
    // Using ffmpeg_kit_flutter package
    
    return File(videoFile.path); // Placeholder
  }
  
  Future<void> downloadModel(String modelSize) async {
    await _localService?.downloadModel(modelSize);
  }
  
  bool get isModelDownloaded => _localService?.isModelDownloaded ?? false;
  
  Future<Map<String, dynamic>> getStats() async {
    return {
      'mode': _mode.name,
      'is_local_available': _localService != null,
      'is_model_downloaded': isModelDownloaded,
      'cloud_url': _cloudBaseUrl,
    };
  }
}
