import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'main.dart';
import 'pages_dashboard.dart';

// ══════════════════════════════════════════════════════════
//  VOICE DIALOG MIXIN
//  — Har dialog mein voice support ke liye yeh mixin use karo
// ══════════════════════════════════════════════════════════
mixin VoiceDialogMixin<T extends StatefulWidget> on State<T> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool speechReady = false;
  String? listeningField;
  String selectedLang = 'hi-IN';

  final Map<String, String> langOptions = {
    'हिंदी': 'hi-IN',
    'English': 'en-IN',
    'मराठी': 'mr-IN',
  };

  Future<void> initVoice() async {
    final ok = await _speech.initialize(
      onError: (e) => debugPrint('Speech error: $e'),
      onStatus: (s) {
        if ((s == 'done' || s == 'notListening') && mounted) {
          setState(() => listeningField = null);
        }
      },
    );
    if (mounted) setState(() => speechReady = ok);
  }

  void stopVoice() => _speech.stop();

  Future<void> startListening(String fieldKey, TextEditingController ctrl) async {
    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) setState(() => listeningField = null);
      return;
    }
    if (mounted) setState(() => listeningField = fieldKey);
    await _speech.listen(
      localeId: selectedLang,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      onResult: (r) {
        if (mounted) setState(() {
          ctrl.text = r.recognizedWords;
          if (r.finalResult) listeningField = null;
        });
      },
    );
  }

  // ── Language selector bar ──
  Widget buildLangBar(Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(children: [
          Icon(Icons.mic_rounded, color: color, size: 15),
          const SizedBox(width: 6),
          Text('Voice:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(width: 8),
          ...langOptions.entries.map((e) {
            final sel = selectedLang == e.value;
            return GestureDetector(
              onTap: () => setState(() => selectedLang = e.value),
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: sel ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? color : Colors.grey.shade300),
                ),
                child: Text(e.key,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : Colors.grey[700])),
              ),
            );
          }),
        ]),
      );

  // ── Listening indicator banner ──
  Widget buildListeningBanner(Color color) => listeningField == null
      ? const SizedBox.shrink()
      : Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(children: [
            const Icon(Icons.graphic_eq_rounded, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Sun raha hoon... boliye 🎤',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600)),
            ),
            GestureDetector(
              onTap: () async {
                await _speech.stop();
                if (mounted) setState(() => listeningField = null);
              },
              child: const Icon(Icons.stop_circle_rounded, color: Colors.red, size: 18),
            ),
          ]),
        );

  // ── Voice-enabled TextFormField ──
  Widget voiceField({
    required String fieldKey,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    TextInputType keyboard = TextInputType.text,
    int? maxLen,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    final active = listeningField == fieldKey;
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLength: maxLen,
      inputFormatters: formatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        counterText: '',
        prefixIcon: Icon(icon, color: color, size: 17),
        suffixIcon: GestureDetector(
          onTap: () => startListening(fieldKey, controller),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: active ? Colors.red : color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
                active ? Icons.stop_rounded : Icons.mic_rounded,
                color: active ? Colors.white : color,
                size: 15),
          ),
        ),
        filled: true,
        fillColor: active ? Colors.red.shade50 : Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: active
                ? const BorderSide(color: Colors.red, width: 1.5)
                : BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  // ── Reusable mic hint banner ──
  Widget buildMicHint(Color color, Color bgColor) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(Icons.mic_rounded, color: color, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
                '🎤 Mic button dabao aur bol do — automatic fill hoga',
                style: TextStyle(fontSize: 11, color: color)),
          ),
        ]),
      );

  // ── Reusable Save/Cancel button row ──
  Widget buildDialogButtons({
    required BuildContext ctx,
    required Color color,
    required VoidCallback onSave,
  }) =>
      Row(children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13)),
              child: const Text('Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13)),
              child:
                  const Text('Save', style: TextStyle(fontWeight: FontWeight.w700))),
        ),
      ]);
}
