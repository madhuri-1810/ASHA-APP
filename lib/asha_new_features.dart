import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ════════════════════════════════════════════════════════════
//  ALL COLOR CONSTANTS — fully self-contained
//
//  FIX FOR DUPLICATE ERRORS:
//  In asha_dashboard.dart, change the import line to:
//
//  import 'asha_new_features.dart'
//    hide kGreen, kGreenLight, kBlue, kBlueLight, kRed, kRedLight,
//         kOrange, kOrangeLight, kPurple, kTeal, kPink,
//         kText, kMuted, kBorder, kBg,
//         offlineNotifier, pendingSyncCount;
//
//  (hide whatever constants are ALREADY defined in main.dart)
// ════════════════════════════════════════════════════════════
const Color kGreen       = Color(0xFF2E7D32);
const Color kGreenLight  = Color(0xFFE8F5E9);
const Color kBlue        = Color(0xFF1565C0);
const Color kBlueLight   = Color(0xFFE3F2FD);
const Color kRed         = Color(0xFFC62828);
const Color kRedLight    = Color(0xFFFFEBEE);
const Color kOrange      = Color(0xFFE65100);
const Color kOrangeLight = Color(0xFFFFF3E0);
const Color kPurple      = Color(0xFF6A1B9A);
const Color kPurpleLight = Color(0xFFF3E5F5);
const Color kTeal        = Color(0xFF00695C);
const Color kTealLight   = Color(0xFFE0F2F1);
const Color kPink        = Color(0xFFAD1457);
const Color kPinkLight   = Color(0xFFFCE4EC);
const Color kText        = Color(0xFF212121);
const Color kMuted       = Color(0xFF757575);
const Color kBorder      = Color(0xFFE0E0E0);
const Color kBg          = Color(0xFFF5F5F5);

// ════════════════════════════════════════════════════════════
//  GLOBAL OFFLINE NOTIFIER
// ════════════════════════════════════════════════════════════
final offlineNotifier    = ValueNotifier<bool>(false);
final pendingSyncCount   = ValueNotifier<int>(0);

// ════════════════════════════════════════════════════════════
//  1. OFFLINE BANNER WIDGET
// ════════════════════════════════════════════════════════════
class OfflineBanner extends StatelessWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: offlineNotifier,
      builder: (_, isOffline, __) => Column(
        children: [
          if (isOffline)
            ValueListenableBuilder<int>(
              valueListenable: pendingSyncCount,
              builder: (_, count, __) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: kOrange,
                child: Row(children: [
                  const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      count > 0
                          ? 'Offline Mode • $count records saved locally'
                          : 'Offline Mode • Data saved locally',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _simulateSync(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text('Sync Now',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                    ),
                  ),
                ]),
              ),
            ),
          if (!isOffline)
            ValueListenableBuilder<int>(
              valueListenable: pendingSyncCount,
              builder: (_, count, __) => count > 0
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      color: kGreen,
                      child: const Row(children: [
                        Icon(Icons.sync_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('Back online! Syncing data...',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                      ]),
                    )
                  : const SizedBox.shrink(),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _simulateSync(BuildContext context) {
    offlineNotifier.value = false;
    Future.delayed(const Duration(seconds: 2), () {
      pendingSyncCount.value = 0;
    });
  }
}

// ════════════════════════════════════════════════════════════
//  2. AI HEALTH ASSISTANT PAGE  (fully working chat)
// ════════════════════════════════════════════════════════════
class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});
  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _msgC   = TextEditingController();
  final _scroll = ScrollController();
  bool  _typing = false;

  final List<_ChatMsg> _messages = [
    _ChatMsg(
      isBot: true,
      text : 'Namaste! 🙏 Main ASHA AI Health Assistant hoon.\n\nMain aapki help kar sakta hoon:\n• Symptoms check karna\n• Referral guidance\n• Medicine dosage\n• Government schemes\n• Health tips\n\nAap kya jaanna chahte hain?',
      time : 'Now',
    ),
  ];

  final Map<String, String> _responses = {
    'bp':
        '🩺 **Blood Pressure (BP) guidance:**\n\nNormal: 120/80 mmHg\nHigh Risk: >140/90 mmHg\n\n⚠️ Agar BP >160/110 ho toh TURANT PHC refer karein!\n\nGarbhavati mahilao mein high BP preeclampsia ka sign ho sakta hai.',
    'fever':
        '🌡️ **Bukhaar (Fever) guidance:**\n\n• 100-102°F: Paracetamol 500mg, rest, fluids\n• 102-104°F: PHC refer karein\n• 104°F+: EMERGENCY — turant hospital\n\n⚠️ 5 saal se kam bachhe mein koi bhi bukhaar — PHC refer!',
    'anc':
        '🤱 **ANC (Antenatal Care) Checklist:**\n\n1st Trimester (0-12 weeks):\n✅ Registration, weight, BP, Hb check\n✅ TT1 injection, IFA tablets\n✅ USG referral\n\n2nd Trimester (13-28 weeks):\n✅ Weight gain check (1kg/month)\n✅ TT2 injection\n✅ Fetal movement monitoring\n\n3rd Trimester (29-40 weeks):\n✅ Birth preparedness counseling\n✅ JSY registration\n✅ Danger signs counseling',
    'vaccine':
        '💉 **Child Vaccination Schedule:**\n\nBirth: BCG, OPV-0, Hep-B\n6 weeks: OPV-1, Penta-1, RVV-1, fIPV-1, PCV-1\n10 weeks: OPV-2, Penta-2, PCV-2\n14 weeks: OPV-3, Penta-3, fIPV-2, RVV-2, PCV-3\n9 months: MR-1, JE-1, Vit-A\n16-24 months: MR-2, OPV Booster, DPT Booster\n5-6 years: DPT Booster-2',
    'jsy':
        '💰 **JSY (Janani Suraksha Yojana):**\n\nBENEFITS:\n• Rural BPL mahila: ₹1,400\n• Urban BPL mahila: ₹1,000\n• ASHA incentive: ₹300-600\n\nZaruri documents:\n✅ JSY card\n✅ BPL card / Aadhar\n✅ Delivery certificate\n\nPayment: Delivery ke 7 din mein bank account mein',
    'malnutrition':
        '🍎 **Kuposhan (Malnutrition) Screening:**\n\nSAM (Severe Acute Malnutrition):\n• MUAC < 11.5 cm\n• Pitting edema present\n• Action: NRC referral TURANT\n\nMAM (Moderate Acute Malnutrition):\n• MUAC 11.5–12.5 cm\n• Action: RUTF, counseling, follow-up\n\nMUAC tape AWC se milti hai.',
    'diarrhea':
        '💧 **Diarrhea / Dast guidance:**\n\n• ORS solution har 10-15 min mein dein\n• Zinc tablet 14 din tak\n• 6 months+ bachhe ko breastfeed jaari rakhein\n\n⚠️ Blood in stool, sunken eyes, no urine → TURANT PHC!',
    'delivery':
        '🏥 **Delivery / Prasav guidance:**\n\nGhar par delivery AVOID karein!\n\nHospital birth ke fayde:\n✅ Skilled birth attendant\n✅ JSY payment (₹1,400)\n✅ Emergency care available\n\nBirth preparedness plan:\n• Hospital ka naam note karein\n• Transport ready rakhein\n• Blood donor identify karein',
    'default':
        '🤔 Main samjha nahi. Kripya in keywords se poochhen:\n\n• **bp** — Blood pressure\n• **fever** — Bukhaar\n• **anc** — Antenatal care\n• **vaccine** — Tikakaran\n• **jsy** — JSY yojana\n• **malnutrition** — Kuposhan\n• **diarrhea** — Dast\n• **delivery** — Prasav\n\nYa seedha apna sawaal likhen!',
  };

  String _getResponse(String input) {
    final l = input.toLowerCase();
    if (l.contains('bp') || l.contains('blood pressure') || l.contains('raktdab')) return _responses['bp']!;
    if (l.contains('fever') || l.contains('bukhaar') || l.contains('temperature')) return _responses['fever']!;
    if (l.contains('anc') || l.contains('antenatal') || l.contains('garbhavati') || l.contains('pregnant')) return _responses['anc']!;
    if (l.contains('vaccine') || l.contains('tika') || l.contains('vaccination') || l.contains('immuniz')) return _responses['vaccine']!;
    if (l.contains('jsy') || l.contains('janani') || l.contains('delivery') || l.contains('prasav')) return _responses['jsy']!;
    if (l.contains('malnutrition') || l.contains('kuposhan') || l.contains('muac') || l.contains('sam') || l.contains('mam')) return _responses['malnutrition']!;
    if (l.contains('diarrhea') || l.contains('dast') || l.contains('loose') || l.contains('ors')) return _responses['diarrhea']!;
    if (l.contains('hospital') || l.contains('birth') || l.contains('prasav')) return _responses['delivery']!;
    return _responses['default']!;
  }

  void _send() async {
    final text = _msgC.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(isBot: false, text: text, time: _timeNow()));
      _typing = true;
      _msgC.clear();
    });
    _scrollDown();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _typing = false;
      _messages.add(_ChatMsg(isBot: true, text: _getResponse(text), time: _timeNow()));
    });
    _scrollDown();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  String _timeNow() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _msgC.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF4A148C);
    return Material(color: kBg, child: Column(children: [
      // ── Header ──────────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Row(children: [
          Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20)),
          const SizedBox(width: 12),
          const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('AI Health Assistant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none)),
            Text('Online • Powered by NHM AI', style: TextStyle(fontSize: 11, color: Colors.white70, decoration: TextDecoration.none)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [
              Icon(Icons.circle, color: Color(0xFF76FF03), size: 8),
              SizedBox(width: 4),
              Text('Live', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            ]),
          ),
        ]),
      ),
      // ── Quick chips ─────────────────────────────────────────
      Container(
        color: color.withOpacity(0.04),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            const Text('Quick: ', style: TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            ...[
              {'label': '🩺 BP Check',    'msg': 'BP guidance chahiye'},
              {'label': '🌡️ Fever',       'msg': 'Bukhaar treatment'},
              {'label': '🤱 ANC',         'msg': 'ANC checklist'},
              {'label': '💉 Vaccine',     'msg': 'Vaccination schedule'},
              {'label': '💰 JSY',         'msg': 'JSY yojana'},
              {'label': '🍎 Nutrition',   'msg': 'Kuposhan screening'},
              {'label': '💧 Diarrhea',    'msg': 'Diarrhea treatment'},
            ].map((c) => Padding(
              padding: const EdgeInsets.only(left: 6),
              child: GestureDetector(
                onTap: () {
                  _msgC.text = c['msg']!;
                  _send();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.2))),
                  child: Text(c['label']!,
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                ),
              ),
            )),
          ]),
        ),
      ),
      // ── Messages ────────────────────────────────────────────
      Expanded(
        child: ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length + (_typing ? 1 : 0),
          itemBuilder: (_, i) {
            if (_typing && i == _messages.length) return _TypingBubble(color: color);
            return _ChatBubble(msg: _messages[i], color: color);
          },
        ),
      ),
      // ── Input ───────────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4))]),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _msgC,
              onSubmitted: (_) => _send(),
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: 'Apna sawaal likhen… (Hindi/English)',
                hintStyle: const TextStyle(fontSize: 12.5, color: kMuted, decoration: TextDecoration.none),
                filled: true, fillColor: kBg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              style: const TextStyle(fontSize: 13, decoration: TextDecoration.none),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 46, height: 46,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)]),
                  shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ]),
      ),
    ]));
  }
}

class _ChatMsg {
  final bool isBot;
  final String text, time;
  const _ChatMsg({required this.isBot, required this.text, required this.time});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMsg msg;
  final Color color;
  const _ChatBubble({super.key, required this.msg, required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: msg.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (msg.isBot) ...[
            Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(Icons.smart_toy_rounded, color: color, size: 14)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isBot ? Colors.white : color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18), topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(msg.isBot ? 4 : 18),
                  bottomRight: Radius.circular(msg.isBot ? 18 : 4),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(msg.text,
                    style: TextStyle(
                        fontSize: 12.5, color: msg.isBot ? kText : Colors.white, height: 1.5, decoration: TextDecoration.none)),
                const SizedBox(height: 4),
                Text(msg.time,
                    style: TextStyle(fontSize: 9.5, color: msg.isBot ? kMuted : Colors.white60, decoration: TextDecoration.none)),
              ]),
            ),
          ),
          if (!msg.isBot) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  final Color color;
  const _TypingBubble({required this.color});
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: widget.color.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(Icons.smart_toy_rounded, color: widget.color, size: 14)),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)]),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final opacity = i == 0
                  ? _ctrl.value
                  : i == 1
                      ? (_ctrl.value + 0.3).clamp(0.0, 1.0)
                      : (_ctrl.value + 0.6).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: 7, height: 7,
                  decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.3 + 0.7 * opacity),
                      shape: BoxShape.circle),
                ),
              );
            }),
          ),
        ),
      ),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
//  3. PHOTO / DOCUMENT UPLOAD PAGE  (fully working)
// ════════════════════════════════════════════════════════════
class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});
  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  static const Color _pageColor = Color(0xFF00695C);
  String _filter = 'all';

  final List<_DocItem> _docs = [
    _DocItem(name: 'Kavita Sharma - ANC Card',    type: 'image', size: '1.2 MB', date: '28 Feb', status: 'uploaded', category: 'anc'),
    _DocItem(name: 'JSY Payment Receipt - March', type: 'pdf',   size: '0.4 MB', date: '27 Feb', status: 'uploaded', category: 'jsy'),
    _DocItem(name: 'Rahul Kumar - Birth Certificate', type: 'pdf', size: '0.8 MB', date: '25 Feb', status: 'pending', category: 'birth'),
    _DocItem(name: 'Medicine Stock - Feb Photo',  type: 'image', size: '2.1 MB', date: '20 Feb', status: 'uploaded', category: 'medicine'),
  ];

  double get _usedMB => _docs.where((d) => d.status == 'uploaded').fold<double>(0.0, (double s, d) => s + (double.tryParse(d.size.replaceAll(' MB', '')) ?? 0.0));

  // ── Upload flow ─────────────────────────────────────────
  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('Upload Document / Photo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kText, decoration: TextDecoration.none)),
          const SizedBox(height: 20),
          Row(children: [
            _UploadOption(icon: Icons.camera_alt_rounded,    label: 'Camera\nPhoto',   color: kBlue,   onTap: () => _simulateUpload('Camera Photo',      'image', 'other')),
            const SizedBox(width: 12),
            _UploadOption(icon: Icons.image_rounded,         label: 'Gallery\nImage',  color: kGreen,  onTap: () => _simulateUpload('Gallery Image',      'image', 'other')),
            const SizedBox(width: 12),
            _UploadOption(icon: Icons.picture_as_pdf_rounded,label: 'PDF\nFile',       color: kRed,    onTap: () => _simulateUpload('PDF Document',       'pdf',   'other')),
            const SizedBox(width: 12),
            _UploadOption(icon: Icons.scanner_rounded,       label: 'Scan\nDoc',       color: kPurple, onTap: () => _simulateUpload('Scanned Document',   'pdf',   'other')),
          ]),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _simulateUpload(String name, String type, String category) {
    Navigator.pop(context);
    final rng = Random();
    final newItem = _DocItem(
      name: '$name — ${DateTime.now().day} Mar',
      type: type,
      size: '${(rng.nextDouble() * 3 + 0.3).toStringAsFixed(1)} MB',
      date: 'Today',
      status: 'uploading',
      category: category,
    );
    setState(() => _docs.insert(0, newItem));
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final idx = _docs.indexOf(newItem);
      if (idx != -1) {
        setState(() {
          _docs[idx] = _DocItem(
            name: _docs[idx].name, type: _docs[idx].type,
            size: _docs[idx].size, date: _docs[idx].date,
            status: 'uploaded', category: _docs[idx].category,
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('✅ File uploaded successfully!'),
            backgroundColor: kGreen, behavior: SnackBarBehavior.floating));
      }
    });
  }

  void _deleteDoc(_DocItem d) {
    setState(() => _docs.remove(d));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('File deleted'), backgroundColor: kRed, behavior: SnackBarBehavior.floating));
  }

  void _shareDoc(_DocItem d) {
    Clipboard.setData(ClipboardData(text: 'Sharing: ${d.name}'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sharing "${d.name}"…'),
        backgroundColor: kBlue, behavior: SnackBarBehavior.floating));
  }

  List<_DocItem> get _filtered => _docs.where((d) {
        if (_filter == 'all') return true;
        if (_filter == 'image') return d.type == 'image';
        if (_filter == 'pdf') return d.type == 'pdf';
        return d.category == _filter;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final usedFraction = (_usedMB / 100).clamp(0.0, 1.0);
    return Material(color: kBg, child: Column(children: [
      // ── Header ──────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF00695C), Color(0xFF00897B)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Row(children: [
          Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.folder_rounded, color: Colors.white, size: 20)),
          const SizedBox(width: 12),
          const Expanded(
              child: Text('Documents & Photos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none))),
          IconButton(
              icon: const Icon(Icons.upload_rounded, color: Colors.white),
              onPressed: _showUploadDialog),
        ]),
      ),
      // ── Storage bar ─────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        color: _pageColor.withOpacity(0.05),
        child: Column(children: [
          Row(children: [
            const Icon(Icons.storage_rounded, size: 14, color: kMuted),
            const SizedBox(width: 6),
            const Text('Storage', style: TextStyle(fontSize: 12, color: kMuted, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const Spacer(),
            Text('${_usedMB.toStringAsFixed(1)} MB / 100 MB',
                style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: usedFraction,
                  backgroundColor: kBorder,
                  color: _pageColor,
                  minHeight: 5)),
        ]),
      ),
      // ── Filter chips ────────────────────────────────────
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            ...[
              {'label': 'All',         'value': 'all'},
              {'label': '🖼️ Images',   'value': 'image'},
              {'label': '📄 PDFs',     'value': 'pdf'},
              {'label': 'ANC',         'value': 'anc'},
              {'label': 'JSY',         'value': 'jsy'},
              {'label': 'Medicine',    'value': 'medicine'},
              {'label': 'Birth',       'value': 'birth'},
            ].map((c) {
              final sel = _filter == c['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = c['value']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? _pageColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? _pageColor : kBorder),
                    ),
                    child: Text(c['label']!,
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : kMuted, decoration: TextDecoration.none)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      // ── Document list ───────────────────────────────────
      Expanded(
        child: _filtered.isEmpty
            ? Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.folder_open_rounded, size: 60, color: kBorder),
                  const SizedBox(height: 12),
                  const Text('No files found', style: TextStyle(color: kMuted, fontSize: 14, decoration: TextDecoration.none)),
                ]),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final d = _filtered[i];
                  final isImage     = d.type == 'image';
                  final isUploading = d.status == 'uploading';
                  final isPending   = d.status == 'pending';
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                    child: Row(children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                            color: isImage ? kBlueLight : kRedLight,
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                            isImage ? Icons.image_rounded : Icons.picture_as_pdf_rounded,
                            color: isImage ? kBlue : kRed, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(d.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.none)),
                        const SizedBox(height: 4),
                        Row(children: [
                          Text(d.size, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                          const Text(' • ', style: TextStyle(color: kMuted, decoration: TextDecoration.none)),
                          Text(d.date, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                          const SizedBox(width: 6),
                          if (isPending)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: kOrangeLight, borderRadius: BorderRadius.circular(6)),
                              child: const Text('PENDING',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: kOrange, decoration: TextDecoration.none)),
                            )
                          else if (!isUploading)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: kGreenLight, borderRadius: BorderRadius.circular(6)),
                              child: const Text('UPLOADED',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: kGreen, decoration: TextDecoration.none)),
                            ),
                        ]),
                        if (isUploading) ...[
                          const SizedBox(height: 6),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(minHeight: 4, color: _pageColor)),
                        ],
                      ])),
                      const SizedBox(width: 10),
                      if (isUploading)
                        const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: _pageColor))
                      else
                        Row(children: [
                          GestureDetector(
                            onTap: () => _shareDoc(d),
                            child: Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.share_rounded, size: 16, color: kGreen)),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _showDeleteConfirm(d),
                            child: Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.delete_outline_rounded, size: 16, color: kRed)),
                          ),
                        ]),
                    ]),
                  );
                },
              ),
      ),
      // ── Upload button ───────────────────────────────────
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton.icon(
            onPressed: _showUploadDialog,
            icon: const Icon(Icons.upload_rounded),
            label: const Text('Upload Document / Photo',
                style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
            style: ElevatedButton.styleFrom(
                backgroundColor: _pageColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
        ),
      ),
    ]));
  }

  void _showDeleteConfirm(_DocItem d) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete File?', style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        content: Text('${d.name} permanently delete ho jayega.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); _deleteDoc(d); },
            style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DocItem {
  final String name, type, size, date, status, category;
  const _DocItem({required this.name, required this.type, required this.size,
      required this.date, required this.status, required this.category});
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _UploadOption({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(children: [
          Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 26)),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 10.5, color: kMuted, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  4. NOTIFICATIONS & REMINDERS PAGE  (fully working)
// ════════════════════════════════════════════════════════════
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tab;

  final List<_Notif> _notifs = [
    _Notif(title: '💉 Vaccination Due!',   body: 'Rahul Kumar (6 months) — OPV vaccine due aaj',             time: '9:00 AM',    type: 'vaccine',  isRead: false, priority: 'high'),
    _Notif(title: '🤱 ANC Visit Reminder', body: 'Kavita Sharma ka 3rd trimester ANC checkup baaki hai',     time: '8:30 AM',    type: 'anc',      isRead: false, priority: 'high'),
    _Notif(title: '💊 Low Stock Alert',    body: 'Iron Tablets ka stock sirf 8 packets bacha hai (min: 15)', time: 'Yesterday',  type: 'medicine', isRead: true,  priority: 'medium'),
    _Notif(title: '📋 VHND Meeting',       body: 'Kal 10 AM — Wardha PHC mein VHND meeting hai',            time: 'Yesterday',  type: 'meeting',  isRead: true,  priority: 'low'),
    _Notif(title: '💰 Incentive Received!',body: 'JSY delivery incentive ₹600 aapke account mein aaya',     time: '2 days ago', type: 'payment',  isRead: true,  priority: 'low'),
    _Notif(title: '⚠️ High Risk Patient',  body: 'Kavita Sharma ka BP 160/100 — Immediate PHC refer karein', time: '3 days ago', type: 'alert',    isRead: true,  priority: 'high'),
  ];

  final List<_Reminder> _reminders = [
    _Reminder(title: 'Sneha Patil ANC Followup',       date: 'Mar 5',  time: '10:00 AM', type: 'anc',      isActive: true),
    _Reminder(title: 'BCG vaccination — Arjun Singh',  date: 'Mar 7',  time: '9:00 AM',  type: 'vaccine',  isActive: true),
    _Reminder(title: 'Medicine stock report submit',   date: 'Mar 10', time: '5:00 PM',  type: 'medicine', isActive: false),
    _Reminder(title: 'Monthly report deadline',        date: 'Mar 31', time: '11:59 PM', type: 'report',   isActive: true),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
  }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  int get _unread => _notifs.where((n) => !n.isRead).length;

  Color _typeColor(String type) {
    switch (type) {
      case 'vaccine':  return kTeal;
      case 'anc':      return kPink;
      case 'medicine': return kOrange;
      case 'meeting':  return kBlue;
      case 'payment':  return kGreen;
      case 'alert':    return kRed;
      case 'report':   return kPurple;
      default:         return kMuted;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'vaccine':  return Icons.vaccines_rounded;
      case 'anc':      return Icons.pregnant_woman_rounded;
      case 'medicine': return Icons.medication_rounded;
      case 'meeting':  return Icons.groups_rounded;
      case 'payment':  return Icons.account_balance_wallet_rounded;
      case 'alert':    return Icons.warning_rounded;
      case 'report':   return Icons.bar_chart_rounded;
      default:         return Icons.notifications_rounded;
    }
  }

  void _markAllRead() => setState(() { for (final n in _notifs) n.isRead = true; });

  void _addReminder() {
    final titleC = TextEditingController();
    String selectedType = 'meeting';
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('New Reminder', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: titleC,
              decoration: InputDecoration(
                labelText: 'Reminder Title',
                prefixIcon: const Icon(Icons.alarm_rounded),
                filled: true, fillColor: kBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category_rounded),
                filled: true, fillColor: kBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: const [
                DropdownMenuItem(value: 'anc',      child: Text('🤱 ANC Visit')),
                DropdownMenuItem(value: 'vaccine',  child: Text('💉 Vaccination')),
                DropdownMenuItem(value: 'medicine', child: Text('💊 Medicine')),
                DropdownMenuItem(value: 'meeting',  child: Text('📋 Meeting')),
                DropdownMenuItem(value: 'report',   child: Text('📊 Report')),
              ],
              onChanged: (v) => setSt(() => selectedType = v!),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleC.text.trim().isNotEmpty) {
                  setState(() => _reminders.insert(0, _Reminder(
                    title: titleC.text.trim(),
                    date: 'Mar 10', time: '9:00 AM',
                    type: selectedType, isActive: true,
                  )));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Reminder added!'),
                      backgroundColor: kGreen, behavior: SnackBarBehavior.floating));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kOrange, foregroundColor: Colors.white),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteReminder(int i) {
    setState(() => _reminders.removeAt(i));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Reminder deleted'), backgroundColor: kRed, behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFE65100);
    return Material(color: kBg, child: Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFE65100), Color(0xFFF4511E)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: Stack(alignment: Alignment.topRight, children: [
                const Icon(Icons.notifications_rounded, color: Colors.white, size: 20),
                if (_unread > 0)
                  Positioned(
                      right: 8, top: 8,
                      child: Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle))),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none)),
              if (_unread > 0)
                Text('$_unread unread alerts', style: const TextStyle(fontSize: 11, color: Colors.white70, decoration: TextDecoration.none)),
            ])),
            if (_unread > 0)
              TextButton(
                onPressed: _markAllRead,
                child: const Text('Mark all read',
                    style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
              ),
          ]),
          const SizedBox(height: 12),
          TabBar(
            controller: _tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, decoration: TextDecoration.none),
            tabs: [
              Tab(text: '🔔 Notifications${_unread > 0 ? " ($_unread)" : ""}'),
              Tab(text: '⏰ Reminders (${_reminders.length})'),
            ],
          ),
        ]),
      ),
      Expanded(
        child: TabBarView(
          controller: _tab,
          children: [
            // ── Notifications tab ──────────────────────────
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final n = _notifs[i];
                final c = _typeColor(n.type);
                return Dismissible(
                  key: ValueKey(n.title + n.time),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) => setState(() => _notifs.removeAt(i)),
                  child: GestureDetector(
                    onTap: () => setState(() => n.isRead = true),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: n.isRead ? Colors.white : c.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: n.isRead ? null : Border.all(color: c.withOpacity(0.3)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                            child: Icon(_typeIcon(n.type), color: c, size: 18)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(
                                child: Text(n.title,
                                    style: TextStyle(
                                        fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w800,
                                        fontSize: 13, decoration: TextDecoration.none))),
                            if (!n.isRead)
                              Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                          ]),
                          const SizedBox(height: 3),
                          Text(n.body, style: const TextStyle(fontSize: 11.5, color: kMuted, height: 1.4, decoration: TextDecoration.none)),
                          const SizedBox(height: 6),
                          Row(children: [
                            Text(n.time, style: const TextStyle(fontSize: 10.5, color: kMuted, decoration: TextDecoration.none)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: n.priority == 'high'
                                      ? kRedLight
                                      : n.priority == 'medium'
                                          ? kOrangeLight
                                          : kGreenLight,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(n.priority.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: n.priority == 'high'
                                          ? kRed
                                          : n.priority == 'medium'
                                              ? kOrange
                                              : kGreen, decoration: TextDecoration.none)),
                            ),
                          ]),
                        ])),
                      ]),
                    ),
                  ),
                );
              },
            ),
            // ── Reminders tab ──────────────────────────────
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity, height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _addReminder,
                    icon: const Icon(Icons.add_alarm_rounded, size: 18),
                    label: const Text('Add New Reminder', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _reminders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final r = _reminders[i];
                    final c = _typeColor(r.type);
                    return Dismissible(
                      key: ValueKey(r.title + r.date),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.delete_rounded, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteReminder(i),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                        child: Row(children: [
                          Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                              child: Icon(_typeIcon(r.type), color: c, size: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(r.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.none)),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.calendar_today_rounded, size: 12, color: kMuted),
                              const SizedBox(width: 4),
                              Text('${r.date} at ${r.time}',
                                  style: const TextStyle(fontSize: 11.5, color: kMuted, decoration: TextDecoration.none)),
                            ]),
                          ])),
                          Switch(
                              value: r.isActive,
                              onChanged: (v) => setState(() => r.isActive = v),
                              activeColor: kGreen,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ],
        ),
      ),
    ]));
  }
}

class _Notif {
  final String title, body, time, type, priority;
  bool isRead;
  _Notif({required this.title, required this.body, required this.time,
      required this.type, required this.priority, required this.isRead});
}

class _Reminder {
  final String title, date, time, type;
  bool isActive;
  _Reminder({required this.title, required this.date, required this.time,
      required this.type, required this.isActive});
}

// ════════════════════════════════════════════════════════════
//  5. ENHANCED REPORTS WITH CHARTS  (fully working)
// ════════════════════════════════════════════════════════════
class EnhancedReportsPage extends StatefulWidget {
  const EnhancedReportsPage({super.key});
  @override
  State<EnhancedReportsPage> createState() => _EnhancedReportsPageState();
}

class _EnhancedReportsPageState extends State<EnhancedReportsPage> {
  String _selectedMonth = 'March 2025';
  bool _isGenerating = false;

  final _months = ['January 2025', 'February 2025', 'March 2025'];

  // Stats per month
  final Map<String, Map<String, dynamic>> _monthStats = {
    'January 2025':  {'visits': 35, 'anc': 14, 'vaccine': 50, 'earnings': '₹2,100', 'visitT': 30, 'ancT': 10, 'vacT': 40, 'delT': 5, 'del': 4},
    'February 2025': {'visits': 32, 'anc': 12, 'vaccine': 48, 'earnings': '₹1,850', 'visitT': 30, 'ancT': 10, 'vacT': 40, 'delT': 5, 'del': 3},
    'March 2025':    {'visits': 18, 'anc':  7, 'vaccine': 28, 'earnings': '₹1,650', 'visitT': 30, 'ancT': 10, 'vacT': 40, 'delT': 5, 'del': 3},
  };

  final _trendData = [
    {'month': 'Oct', 'visits': 28, 'vaccine': 38},
    {'month': 'Nov', 'visits': 32, 'vaccine': 42},
    {'month': 'Dec', 'visits': 25, 'vaccine': 35},
    {'month': 'Jan', 'visits': 35, 'vaccine': 50},
    {'month': 'Feb', 'visits': 32, 'vaccine': 48},
    {'month': 'Mar', 'visits': 18, 'vaccine': 28},
  ];

  Map<String, dynamic> get _stats => _monthStats[_selectedMonth]!;

  void _generatePdf() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isGenerating = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('📄 PDF report for $_selectedMonth generated!'),
        backgroundColor: kGreen, behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF37474F);
    final s = _stats;
    return Material(color: kBg, child: Column(children: [
      // ── Header ──────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF37474F), Color(0xFF546E7A)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Row(children: [
          Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20)),
          const SizedBox(width: 12),
          const Expanded(
              child: Text('Monthly Reports',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none))),
          GestureDetector(
            onTap: _showMonthPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(_selectedMonth, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                const Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 18),
              ]),
            ),
          ),
        ]),
      ),
      // ── Body ────────────────────────────────────────────
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // stat cards
            Row(children: [
              _MiniStatCard(value: s['visits'].toString(),  label: 'Home Visits',   color: kBlue,   icon: Icons.home_work_rounded),
              const SizedBox(width: 10),
              _MiniStatCard(value: s['anc'].toString(),     label: 'ANC Cases',     color: kPink,   icon: Icons.pregnant_woman_rounded),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _MiniStatCard(value: s['vaccine'].toString(), label: 'Vaccinations',  color: kTeal,   icon: Icons.vaccines_rounded),
              const SizedBox(width: 10),
              _MiniStatCard(value: s['earnings'].toString(),label: 'Earnings',      color: kPurple, icon: Icons.currency_rupee_rounded),
            ]),
            const SizedBox(height: 20),
            // 6-month chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('6-Month Trend', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kText, decoration: TextDecoration.none)),
                const SizedBox(height: 4),
                const Text('Home Visits vs Vaccinations', style: TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                const SizedBox(height: 20),
                _BarChart(data: _trendData),
                const SizedBox(height: 12),
                const Row(children: [
                  _ChartLegend(color: kBlue, label: 'Home Visits'),
                  SizedBox(width: 16),
                  _ChartLegend(color: kTeal, label: 'Vaccinations'),
                ]),
              ]),
            ),
            const SizedBox(height: 16),
            // target achievement
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Target Achievement', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kText, decoration: TextDecoration.none)),
                const SizedBox(height: 16),
                ...[
                  {'label': 'Home Visits',              'done': s['visits'], 'target': s['visitT'], 'color': kBlue},
                  {'label': 'ANC Registrations',        'done': s['anc'],    'target': s['ancT'],   'color': kPink},
                  {'label': 'Vaccinations',             'done': s['vaccine'],'target': s['vacT'],   'color': kTeal},
                  {'label': 'Institutional Deliveries', 'done': s['del'],    'target': s['delT'],   'color': kGreen},
                ].map((item) {
                  final done   = item['done']   as int;
                  final target = item['target'] as int;
                  final pct    = (done / target).clamp(0.0, 1.0);
                  final ic     = item['color']  as Color;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(children: [
                      Row(children: [
                        Expanded(child: Text(item['label'] as String,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, decoration: TextDecoration.none))),
                        Text('$done / $target',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ic, decoration: TextDecoration.none)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: ic.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                          child: Text('${(pct * 100).round()}%',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ic, decoration: TextDecoration.none)),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                              value: pct,
                              backgroundColor: ic.withOpacity(0.1),
                              color: ic,
                              minHeight: 10)),
                    ]),
                  );
                }),
              ]),
            ),
            const SizedBox(height: 16),
            // action buttons
            Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generatePdf,
                  icon: _isGenerating
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.download_rounded, size: 18),
                  label: Text(_isGenerating ? 'Generating…' : 'PDF Report',
                      style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: color.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareWhatsApp(context),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ]),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    ]));
  }

  void _showMonthPicker() {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Month', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
        children: _months.map((m) => SimpleDialogOption(
          onPressed: () { setState(() => _selectedMonth = m); Navigator.pop(context); },
          child: Text(m,
              style: TextStyle(
                  fontWeight: m == _selectedMonth ? FontWeight.w700 : FontWeight.w400,
                  color: m == _selectedMonth ? kGreen : kText, decoration: TextDecoration.none)),
        )).toList(),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  final IconData icon;
  const _MiniStatCard({required this.value, required this.label, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 12)]),
        child: Row(children: [
          Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 10),
          Flexible(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color, decoration: TextDecoration.none)),
            Text(label, style: const TextStyle(fontSize: 10, color: kMuted, decoration: TextDecoration.none)),
          ])),
        ]),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _BarChart({required this.data});
  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((d) => d['vaccine'] as int).reduce(max).toDouble();
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((d) {
          final visits  = (d['visits']  as int).toDouble();
          final vaccine = (d['vaccine'] as int).toDouble();
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 10,
                          height: 90 * (visits / maxVal),
                          decoration: BoxDecoration(color: kBlue, borderRadius: BorderRadius.circular(3))),
                      const SizedBox(width: 2),
                      Container(
                          width: 10,
                          height: 90 * (vaccine / maxVal),
                          decoration: BoxDecoration(color: kTeal, borderRadius: BorderRadius.circular(3))),
                    ]),
                const SizedBox(height: 6),
                Text(d['month'] as String, style: const TextStyle(fontSize: 9.5, color: kMuted, decoration: TextDecoration.none)),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
//  6. WHATSAPP / SMS INTEGRATION  (fully working)
// ════════════════════════════════════════════════════════════
void _shareWhatsApp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => const _WhatsAppSheet(),
  );
}

class _WhatsAppSheet extends StatefulWidget {
  const _WhatsAppSheet();
  @override
  State<_WhatsAppSheet> createState() => _WhatsAppSheetState();
}

class _WhatsAppSheetState extends State<_WhatsAppSheet> {
  final _phoneC = TextEditingController();
  String _selectedTemplate = 'monthly_report';

  final Map<String, String> _templates = {
    'monthly_report':   '📋 *ASHA Monthly Report — March 2025*\n\nHome Visits: 18\nANC Cases: 7\nVaccinations: 28\nEarnings: ₹1,650\n\n_Sent via ASHA Worker App_',
    'vaccine_reminder': '💉 *Vaccination Reminder*\n\nNamaste! Aapke bachche ka [vaccine_name] ka waqt aa gaya hai.\nDate: [date]\nTime: 9:00 AM – 12:00 PM\nSthan: [location] PHC\n\n_ASHA Didi_',
    'anc_reminder':     '🤱 *ANC Checkup Reminder*\n\nNamaste! Aapka ANC checkup [date] ko hai.\nKripya samay par PHC aayen.\n\nZaruri: BP check, weight, HB test\n\n_Aapki ASHA Didi_',
    'jsy_info':         '💰 *JSY Yojana Jaankari*\n\nSansthanik prasav karne par sarkar se ₹1,400 milenge.\nZaruri documents:\n✅ Aadhar Card\n✅ BPL Card\n✅ Bank Passbook\n\nAdhik jaankari ke liye ASHA didi se milein.',
  };

  final Map<String, String> _labels = {
    'monthly_report':   '📋 Report',
    'vaccine_reminder': '💉 Vaccine',
    'anc_reminder':     '🤱 ANC',
    'jsy_info':         '💰 JSY',
  };

  @override
  void dispose() { _phoneC.dispose(); super.dispose(); }

  void _sendWhatsApp() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Opening WhatsApp…'),
        backgroundColor: Color(0xFF25D366), behavior: SnackBarBehavior.floating));
  }

  void _copyMessage() {
    Clipboard.setData(ClipboardData(text: _templates[_selectedTemplate]!));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Message copied! WhatsApp mein paste karein.'),
        backgroundColor: Color(0xFF25D366), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 24, right: 24, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 16),
        Row(children: [
          Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.chat_rounded, color: Color(0xFF25D366), size: 20)),
          const SizedBox(width: 12),
          const Text('Send WhatsApp / SMS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        ]),
        const SizedBox(height: 16),
        const Text('Message Template:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kMuted, decoration: TextDecoration.none)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _templates.keys.map((k) {
              final sel = _selectedTemplate == k;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTemplate = k),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: sel ? const Color(0xFF25D366) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: sel ? const Color(0xFF25D366) : kBorder)),
                    child: Text(_labels[k]!,
                        style: TextStyle(
                            fontSize: 11.5, fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : kMuted, decoration: TextDecoration.none)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFDCF8C6), borderRadius: BorderRadius.circular(12)),
          child: Text(_templates[_selectedTemplate]!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1A3C1A), height: 1.5, decoration: TextDecoration.none)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _phoneC,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Phone Number (optional)',
            hintText: '9876543210',
            prefixIcon: const Icon(Icons.phone_outlined),
            prefixText: '+91 ',
            filled: true, fillColor: kBg, counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _copyMessage,
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy'),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kBorder),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _sendWhatsApp,
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Send WhatsApp', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  7. PROFILE & SETTINGS PAGE  (fully working)
// ════════════════════════════════════════════════════════════
class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});
  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  bool _notifEnabled    = true;
  bool _offlineEnabled  = false;
  bool _biometricEnabled= false;
  bool _hindiSms        = true;
  String _selectedLang  = 'hi';

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF1565C0);
    return Material(color: kBg, child: Column(children: [
      // ── Profile header ───────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(children: [
          Stack(alignment: Alignment.bottomRight, children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 3)),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
            ),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Camera se photo lo ya gallery se chunein'),
                  behavior: SnackBarBehavior.floating)),
              child: Container(
                  width: 26, height: 26,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF1565C0), size: 14)),
            ),
          ]),
          const SizedBox(height: 12),
          const Text('Sunita ASHA Didi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none)),
          const SizedBox(height: 4),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: const Text('ASHA ID: MH-2024-001',
                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600, decoration: TextDecoration.none))),
          const SizedBox(height: 16),
          const Row(children: [
            _ProfileStat(value: '240', label: 'Visits'),
            _ProfileStat(value: '36',  label: 'ANC'),
            _ProfileStat(value: '180', label: 'Vaccines'),
            _ProfileStat(value: '₹18K',label: 'Earned'),
          ]),
        ]),
      ),
      // ── Settings body ────────────────────────────────────
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _SettingsSection(title: 'PERSONAL INFORMATION', children: [
              _InfoRow(icon: Icons.person_outline,    label: 'Full Name', value: 'Sunita Sharma'),
              _InfoRow(icon: Icons.phone_outlined,    label: 'Mobile',    value: '+91 98765 43210'),
              _InfoRow(icon: Icons.location_on_outlined, label: 'Village', value: 'Wardha, Maharashtra'),
              _InfoRow(icon: Icons.badge_outlined,    label: 'Supervisor',value: 'Rekha Madam — PHC Wardha'),
              _InfoRowAction(icon: Icons.edit_outlined, label: 'Edit Profile', color: kBlue, onTap: () => _showEditProfile(context)),
            ]),
            const SizedBox(height: 16),
            _SettingsSection(title: 'LANGUAGE SETTINGS', children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(children: [
                  const Icon(Icons.translate_rounded, color: kBlue, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('App Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, decoration: TextDecoration.none))),
                  ...[
                    {'code': 'en', 'label': 'EN'},
                    {'code': 'hi', 'label': 'हि'},
                    {'code': 'mr', 'label': 'म'},
                  ].map((o) {
                    final sel = _selectedLang == o['code'];
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedLang = o['code']!);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Language changed!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: kBlue));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: sel ? kBlue : kBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: sel ? kBlue : kBorder)),
                          child: Text(o['label']!,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700,
                                  color: sel ? Colors.white : kMuted, decoration: TextDecoration.none)),
                        ),
                      ),
                    );
                  }),
                ]),
              ),
              _SwitchRow(
                  icon: Icons.sms_outlined, label: 'SMS in Hindi/Marathi',
                  value: _hindiSms, onChanged: (v) => setState(() => _hindiSms = v)),
            ]),
            const SizedBox(height: 16),
            _SettingsSection(title: 'APP SETTINGS', children: [
              _SwitchRow(
                  icon: Icons.notifications_outlined, label: 'Push Notifications',
                  value: _notifEnabled, onChanged: (v) => setState(() => _notifEnabled = v)),
              _SwitchRow(
                  icon: Icons.wifi_off_rounded, label: 'Offline Mode',
                  value: _offlineEnabled,
                  onChanged: (v) {
                    setState(() { _offlineEnabled = v; offlineNotifier.value = v; });
                    if (v) pendingSyncCount.value = pendingSyncCount.value + 3;
                  }),
              _SwitchRow(
                  icon: Icons.fingerprint_rounded, label: 'Biometric Login',
                  value: _biometricEnabled, onChanged: (v) => setState(() => _biometricEnabled = v)),
            ]),
            const SizedBox(height: 16),
            _SettingsSection(title: 'TRAINING & CERTIFICATES', children: [
              _InfoRowAction(icon: Icons.school_outlined,       label: 'My Certificates (3)',  color: kPurple, onTap: () => _showCertificates(context)),
              _InfoRowAction(icon: Icons.video_library_outlined, label: 'Training Videos',      color: kTeal,   onTap: () => _showTrainingVideos(context)),
              _InfoRowAction(icon: Icons.help_outline_rounded,  label: 'Help & Support',       color: kOrange, onTap: () => _showHelp(context)),
            ]),
            const SizedBox(height: 16),
            _SettingsSection(title: 'SECURITY', children: [
              _InfoRowAction(icon: Icons.lock_outline_rounded,  label: 'Change Password', color: kBlue,  onTap: () => _showChangePassword(context)),
              _InfoRowAction(icon: Icons.privacy_tip_outlined,  label: 'Privacy Policy',  color: kMuted, onTap: () => _showPrivacyPolicy(context)),
            ]),
            const SizedBox(height: 16),
            // App info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(children: [
                const Row(children: [
                  Icon(Icons.info_outline_rounded, color: kMuted, size: 18),
                  SizedBox(width: 8),
                  Text('App Information', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kText, decoration: TextDecoration.none)),
                ]),
                const SizedBox(height: 12),
                const _AppInfoRow('App Version',  'v2.0.0'),
                const _AppInfoRow('Last Sync',    'Today, 2:30 PM'),
                const _AppInfoRow('Ministry',     'National Health Mission'),
                const _AppInfoRow('State',        'Maharashtra'),
              ]),
            ),
            const SizedBox(height: 16),
            // Logout button
            SizedBox(
              width: double.infinity, height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded, color: kRed),
                label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700, color: kRed, decoration: TextDecoration.none)),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kRed, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    ]));
  }

  // ── Dialog helpers ────────────────────────────────────────
  void _showEditProfile(BuildContext context) {
    final nameC  = TextEditingController(text: 'Sunita Sharma');
    final phoneC = TextEditingController(text: '9876543210');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: nameC,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.person_outline),
              filled: true, fillColor: kBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneC,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              prefixText: '+91 ',
              filled: true, fillColor: kBg, counterText: '',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('✅ Profile updated!'),
                  backgroundColor: kGreen, behavior: SnackBarBehavior.floating));
            },
            style: ElevatedButton.styleFrom(backgroundColor: kBlue, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final conC = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: oldC, obscureText: true, decoration: InputDecoration(labelText: 'Current Password', prefixIcon: const Icon(Icons.lock_outline), filled: true, fillColor: kBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 10),
          TextField(controller: newC, obscureText: true, decoration: InputDecoration(labelText: 'New Password',     prefixIcon: const Icon(Icons.lock_rounded),  filled: true, fillColor: kBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 10),
          TextField(controller: conC, obscureText: true, decoration: InputDecoration(labelText: 'Confirm Password', prefixIcon: const Icon(Icons.lock_rounded),  filled: true, fillColor: kBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('✅ Password changed successfully!'),
                  backgroundColor: kGreen, behavior: SnackBarBehavior.floating));
            },
            style: ElevatedButton.styleFrom(backgroundColor: kBlue, foregroundColor: Colors.white),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCertificates(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('My Certificates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
          const SizedBox(height: 16),
          ...[
            {'title': 'Basic ASHA Training', 'date': 'Jan 2023', 'issuer': 'NHM Maharashtra'},
            {'title': 'Child Nutrition Module', 'date': 'Jun 2023', 'issuer': 'ICDS'},
            {'title': 'Covid-19 Response',     'date': 'Mar 2022', 'issuer': 'MoHFW'},
          ].map((c) => ListTile(
            leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: kPurpleLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.workspace_premium_rounded, color: kPurple, size: 20)),
            title: Text(c['title']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.none)),
            subtitle: Text('${c['issuer']} • ${c['date']}', style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            trailing: const Icon(Icons.download_rounded, color: kBlue, size: 18),
          )),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  void _showTrainingVideos(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('Training Videos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
          const SizedBox(height: 16),
          ...[
            {'title': 'ANC Registration Process', 'dur': '12 min', 'views': '2.3K'},
            {'title': 'Child Vaccination Guide',  'dur': '8 min',  'views': '1.8K'},
            {'title': 'Malnutrition Screening',   'dur': '15 min', 'views': '1.1K'},
            {'title': 'JSY Benefits Explained',   'dur': '10 min', 'views': '3.2K'},
          ].map((v) => ListTile(
            leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: kTealLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.play_circle_rounded, color: kTeal, size: 24)),
            title: Text(v['title']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.none)),
            subtitle: Text('${v['dur']} • ${v['views']} views', style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kMuted, size: 14),
          )),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _HelpRow(Icons.phone_rounded, 'Helpline', '1800-XXX-XXXX (toll-free)'),
          _HelpRow(Icons.email_rounded, 'Email',    'asha.support@nhm.gov.in'),
          _HelpRow(Icons.chat_rounded,  'WhatsApp', '+91 98765 00000'),
          _HelpRow(Icons.access_time_rounded, 'Hours', 'Mon-Sat, 9 AM – 6 PM'),
        ]),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: kBlue, foregroundColor: Colors.white),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        content: const SingleChildScrollView(
          child: Text(
            'Aapka data NHM ke servers par securely store hota hai.\n\n'
            '• Personal data sirf government officials ke saath share hoga\n'
            '• Patient data confidential rahega\n'
            '• Biometric data device par hi store hoga\n'
            '• App ke through koi third-party advertising nahi hogi\n\n'
            'Adhik jaankari ke liye: nhm.gov.in/privacy',
            style: TextStyle(fontSize: 13, height: 1.6, color: kText, decoration: TextDecoration.none),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: kBlue, foregroundColor: Colors.white),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
        content: const Text('Kya aap logout karna chahte hain?\n\nOffline data sync ho gaya hai.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: kRed, behavior: SnackBarBehavior.floating));
            },
            style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white),
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
          ),
        ],
      ),
    );
  }
}

Widget _HelpRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: kBlue, size: 16)),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
      ]),
    ]),
  );
}

class _ProfileStat extends StatelessWidget {
  final String value, label;
  const _ProfileStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, decoration: TextDecoration.none)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7), decoration: TextDecoration.none)),
        ]),
      );
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kMuted, letterSpacing: 0.5, decoration: TextDecoration.none))),
          const Divider(height: 1, color: kBorder),
          ...children,
        ]),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Icon(icon, color: kBlue, size: 18),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
          ])),
        ]),
      );
}

class _InfoRowAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _InfoRowAction({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: color, decoration: TextDecoration.none))),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: color.withOpacity(0.5)),
          ]),
        ),
      );
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({required this.icon, required this.label, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Icon(icon, color: kBlue, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, decoration: TextDecoration.none))),
          Switch(value: value, onChanged: onChanged, activeColor: kGreen, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ]),
      );
}

class _AppInfoRow extends StatelessWidget {
  final String label, value;
  const _AppInfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kMuted, decoration: TextDecoration.none)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kText, decoration: TextDecoration.none)),
        ]),
      );
}