import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import '../services/transcription_service.dart';
import '../models/transcription_result.dart';
import '../utils/theme.dart';
import 'caption_editor_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedVideo;
  VideoPlayerController? _videoController;
  bool _showSettings = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _selectedVideo = file;
        });

        // Initialize video preview
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking video: $e')),
        );
      }
    }
  }

  void _startTranscription() async {
    if (_selectedVideo == null) return;

    final service = context.read<TranscriptionService>();

    final result = await Navigator.push<TranscriptionResult>(
      context,
      MaterialPageRoute(
        builder: (context) => CaptionEditorScreen(
          videoFile: _selectedVideo!,
          result: null, // Will be generated
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ViralCaption AI',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Transcribe Shorts, Reels & TikToks',
                          style: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _showSettings = !_showSettings);
                      },
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ),
            ),

            // Settings Panel (collapsible)
            if (_showSettings)
              SliverToBoxAdapter(
                child: const SettingsPanel(),
              ),

            // Upload Area
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: _pickVideo,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedVideo != null
                            ? AppTheme.primaryGradientStart
                            : const Color(0xFF374151),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.surface,
                    ),
                    child: _selectedVideo == null
                        ? _buildUploadPlaceholder()
                        : _buildVideoPreview(),
                  ),
                ),
              ),
            ),

            // Action Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<TranscriptionService>(
                  builder: (context, service, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedVideo != null && !service.isProcessing
                            ? _startTranscription
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: service.isProcessing
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Processing...'),
                                  ],
                                )
                              : const Text(
                                  'Transcribe Video',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Mode Indicator
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<TranscriptionService>(
                  builder: (context, service, child) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            service.isLocalMode
                                ? Icons.phone_android
                                : Icons.cloud,
                            size: 20,
                            color: service.isLocalMode
                                ? Colors.green
                                : Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              service.isLocalMode
                                  ? 'On-device transcription (Offline)'
                                  : 'Cloud transcription',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          if (service.isProcessing)
                            Text(
                              '${(service.progress * 100).round()}%',
                              style: const TextStyle(
                                color: AppTheme.primaryGradientEnd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Recent Files (placeholder)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTipCard(
                      icon: Icons.videocam,
                      title: 'Vertical Videos',
                      description: 'Best for 9:16 aspect ratio (Shorts, Reels, TikTok)',
                    ),
                    const SizedBox(height: 8),
                    _buildTipCard(
                      icon: Icons.timer,
                      title: 'Under 60 seconds',
                      description: 'Optimized for short-form content',
                    ),
                    const SizedBox(height: 8),
                    _buildTipCard(
                      icon: Icons.wifi_off,
                      title: 'Works Offline',
                      description: 'Download model for on-device transcription',
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

  Widget _buildUploadPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_a_photo_outlined,
              size: 40,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tap to upload video',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'MP4, MOV, WebM',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _selectedVideo!.path.split('/').last,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primaryGradientStart),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TranscriptionService>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transcription Mode',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _ModeChip(
                label: 'Auto',
                icon: Icons.autorenew,
                selected: service.mode == TranscriptionMode.auto,
                onTap: () => service.setMode(TranscriptionMode.auto),
              ),
              _ModeChip(
                label: 'On-Device',
                icon: Icons.phone_android,
                selected: service.mode == TranscriptionMode.local,
                onTap: () => service.setMode(TranscriptionMode.local),
              ),
              _ModeChip(
                label: 'Cloud',
                icon: Icons.cloud,
                selected: service.mode == TranscriptionMode.cloud,
                onTap: () => service.setMode(TranscriptionMode.cloud),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
        backgroundColor: selected
            ? AppTheme.primaryGradientStart
            : AppTheme.surfaceLight,
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
