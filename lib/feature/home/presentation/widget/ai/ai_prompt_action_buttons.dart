import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/search/model/search_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AiCameraButton extends StatelessWidget {
  const AiCameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _ActionIconButton(
      icon: Icons.camera_alt_outlined,
      onTap: () => Navigator.pushNamed(
        context,
        '/searchScreen',
        arguments: SearchModel(isImageDetect: true),
      ),
    );
  }
}

class AiMicButton extends StatefulWidget {
  const AiMicButton({super.key, required this.onResult});

  final ValueChanged<String> onResult;

  @override
  State<AiMicButton> createState() => _AiMicButtonState();
}

class _AiMicButtonState extends State<AiMicButton> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return;

    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
    );
    if (!available) return;

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          widget.onResult(result.recognizedWords);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ActionIconButton(
      icon: _isListening ? Icons.mic : Icons.mic_none_rounded,
      iconColor: _isListening ? AppColors.primaryGreen : null,
      onTap: _toggleListening,
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
