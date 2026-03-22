import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transcription_service.dart';
import '../services/whisper_local_service.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _cloudUrlController = TextEditingController();
  bool _isDownloadingModel = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    final service = context.read<TranscriptionService>();
    _cloudUrlController.text = service.cloudBaseUrl ?? '';
  }

  @override
  void dispose() {
    _cloudUrlController.dispose();
    super.dispose();
  }

  Future<void> _downloadModel() async {
    setState(() {
      _isDownloadingModel = true;
    });

    try {
      final service = context.read<TranscriptionService>();
      await service.downloadModel('base');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Model downloaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingModel = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TranscriptionService>(
      builder: (context, service, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cloud Settings
              _buildSection(
                title: 'Cloud Transcription',
                children: [
                  TextField(
                    controller: _cloudUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Server URL',
                      hintText: 'http://192.168.1.100:8000',
                      prefixIcon: Icon(Icons.cloud),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      service.setCloudUrl(value);
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      service.setCloudUrl(_cloudUrlController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Server URL saved')),
                      );
                    },
                    child: const Text('Save Server URL'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Local Model Settings
              _buildSection(
                title: 'On-Device Model',
                children: [
                  Row(
                    children: [
                      Icon(
                        service.isModelDownloaded
                            ? Icons.check_circle
                            : Icons.download,
                        color: service.isModelDownloaded
                            ? Colors.green
                            : AppTheme.primaryGradientStart,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service.isModelDownloaded
                            ? 'Model downloaded (~140 MB)'
                            : 'No model downloaded',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!service.isModelDownloaded)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isDownloadingModel ? null : _downloadModel,
                        icon: _isDownloadingModel
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download),
                        label: Text(_isDownloadingModel
                            ? 'Downloading...'
                            : 'Download Base Model'),
                      ),
                    ),
                  if (service.isModelDownloaded)
                    Row(
                      children: [
                        const Icon(Icons.storage, size: 16),
                        const SizedBox(width: 8),
                        FutureBuilder<int>(
                          future: service
                              .downloadedModelSize()
                              .then((s) => s ~/ 1024 ~/ 1024),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Size: ${snapshot.data} MB',
                                style: const TextStyle(fontSize: 12),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Delete model logic
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Download the model for offline transcription. First download may take a few minutes.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Model Size Selection
              _buildSection(
                title: 'Model Size',
                children: [
                  const Text(
                    'Smaller models are faster but less accurate. Larger models need more storage.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _ModelSizeChip(
                        size: 'Tiny',
                        accuracy: '~50%',
                        size: '40 MB',
                        selected: false,
                        onTap: () {},
                      ),
                      _ModelSizeChip(
                        size: 'Base',
                        accuracy: '~70%',
                        size: '140 MB',
                        selected: true,
                        onTap: () {},
                      ),
                      _ModelSizeChip(
                        size: 'Small',
                        accuracy: '~85%',
                        size: '450 MB',
                        selected: false,
                        onTap: () {},
                      ),
                      _ModelSizeChip(
                        size: 'Medium',
                        accuracy: '~95%',
                        size: '1.5 GB',
                        selected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // About
              _buildSection(
                title: 'About',
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const ListTile(
                    leading: Icon(Icons.code),
                    title: Text('Powered by'),
                    subtitle: Text('Whisper AI + whisper.cpp'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGradientStart,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _ModelSizeChip extends StatelessWidget {
  final String size;
  final String accuracy;
  final String storage;
  final bool selected;
  final VoidCallback onTap;

  const _ModelSizeChip({
    required this.size,
    required this.accuracy,
    required this.storage,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryGradientStart
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFF4B5563),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              size,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              accuracy,
              style: TextStyle(
                fontSize: 10,
                color: selected ? Colors.black54 : const Color(0xFF9CA3AF),
              ),
            ),
            Text(
              storage,
              style: TextStyle(
                fontSize: 9,
                color: selected ? Colors.black54 : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for SettingsPanel used in HomeScreen
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                selected: context.watch<TranscriptionService>().mode ==
                    TranscriptionMode.auto,
                onTap: () =>
                    context.read<TranscriptionService>().setMode(TranscriptionMode.auto),
              ),
              _ModeChip(
                label: 'On-Device',
                icon: Icons.phone_android,
                selected: context.watch<TranscriptionService>().mode ==
                    TranscriptionMode.local,
                onTap: () =>
                    context.read<TranscriptionService>().setMode(TranscriptionMode.local),
              ),
              _ModeChip(
                label: 'Cloud',
                icon: Icons.cloud,
                selected: context.watch<TranscriptionService>().mode ==
                    TranscriptionMode.cloud,
                onTap: () =>
                    context.read<TranscriptionService>().setMode(TranscriptionMode.cloud),
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
