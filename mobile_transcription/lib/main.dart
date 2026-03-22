import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/transcription_service.dart';
import 'ui/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize transcription service
  final transcriptionService = TranscriptionService();
  await transcriptionService.initialize();
  
  runApp(ViralCaptionApp(transcriptionService: transcriptionService));
}

class ViralCaptionApp extends StatelessWidget {
  final TranscriptionService transcriptionService;
  
  const ViralCaptionApp({
    super.key,
    required this.transcriptionService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TranscriptionService>.value(value: transcriptionService),
      ],
      child: MaterialApp(
        title: 'ViralCaption AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
