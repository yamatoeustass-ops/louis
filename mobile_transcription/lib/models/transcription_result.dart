import 'dart:convert';

/// Represents word-level transcription data
class WordData {
  final double start;
  final double end;
  final String text;
  
  WordData({
    required this.start,
    required this.end,
    required this.text,
  });
  
  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      text: json['text'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'text': text,
    };
  }
  
  double get duration => end - start;
}

/// Complete transcription result
class TranscriptionResult {
  final String filename;
  final String transcription;
  final List<WordData> words;
  final String? srtUrl;
  final String? jsonUrl;
  
  TranscriptionResult({
    required this.filename,
    required this.transcription,
    required this.words,
    this.srtUrl,
    this.jsonUrl,
  });
  
  factory TranscriptionResult.fromJson(Map<String, dynamic> json) {
    final wordsJson = json['words'] as List? ?? [];
    return TranscriptionResult(
      filename: json['filename'] as String? ?? 'unknown',
      transcription: json['transcription'] as String? ?? '',
      words: wordsJson.map((w) => WordData.fromJson(w as Map<String, dynamic>)).toList(),
      srtUrl: json['srt_url'] as String?,
      jsonUrl: json['json_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'transcription': transcription,
      'words': words.map((w) => w.toJson()).toList(),
      'srt_url': srtUrl,
      'json_url': jsonUrl,
    };
  }
  
  /// Export to SRT format
  String toSRT() {
    final sb = StringBuffer();
    int index = 1;
    
    // Group words into segments (simple approach - group by pauses)
    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      
      sb.writeln(index++);
      sb.writeln('${_formatSrtTime(word.start)} --> ${_formatSrtTime(word.end)}');
      sb.writeln(word.text);
      sb.writeln();
    }
    
    return sb.toString();
  }
  
  /// Export to JSON for caption editors
  String toJsonExport() {
    return jsonEncode(toJson());
  }
  
  /// Export to ASS format for advanced styling (Hormozi-style captions)
  String toASS() {
    final sb = StringBuffer();
    
    // ASS Header
    sb.writeln('[Script Info]');
    sb.writeln('Title: ViralCaption');
    sb.writeln('ScriptType: v4.00+');
    sb.writeln('PlayResX: 1080');
    sb.writeln('PlayResY: 1920');
    sb.writeln();
    sb.writeln('[V4+ Styles]');
    sb.writeln('Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding');
    sb.writeln('Style: Default,Arial,48,&H00FFFFFF,&H000000FF,&H00000000,&H80000000,-1,0,0,0,100,100,2,0,1,2,0,2,10,10,10,1');
    sb.writeln();
    sb.writeln('[Events]');
    sb.writeln('Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text');
    
    // Word-level captions with karaoke effect
    for (var word in words) {
      final startTime = _formatAssTime(word.start);
      final endTime = _formatAssTime(word.end);
      // \\k specifies karaoke timing in centiseconds
      final durationCs = ((word.end - word.start) * 100).round();
      sb.writeln('Dialogue: 0,$startTime,$endTime,Default,,0,0,0,,{\\k$durationCs}${word.text}');
    }
    
    return sb.toString();
  }
  
  String _formatSrtTime(double seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds.toInt() % 60;
    final millis = ((seconds * 1000) % 1000).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')},${millis.toString().padLeft(3, '0')}';
  }
  
  String _formatAssTime(double seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds.toInt() % 60;
    final centis = ((seconds * 100) % 100).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }
}
