import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'main.dart';
import 'asha_dashboard.dart';

// ══════════════════════════════════════════════════════════
//  LANGUAGE SUPPORT — English | हिंदी | मराठी
// ══════════════════════════════════════════════════════════

/// Global language notifier — listen anywhere in the widget tree
final ValueNotifier<String> appLocale = ValueNotifier('en'); // 'en' | 'hi' | 'mr'

class L {
  static String get currentLocale => appLocale.value;

  // ── STT language codes ──────────────────────────────────
  static String get sttLocale {
    switch (currentLocale) {
      case 'hi': return 'hi-IN';
      case 'mr': return 'mr-IN';
      default:   return 'en-IN';
    }
  }

  // ── Translation map ─────────────────────────────────────
  static const Map<String, Map<String, String>> _t = {
    // Page / header
    'daily_report':         {'en': 'Daily Report',             'hi': 'दैनिक रिपोर्ट',       'mr': 'दैनिक अहवाल'},
    'village_records':      {'en': 'Village Registration Records', 'hi': 'ग्राम पंजीकरण अभिलेख', 'mr': 'गाव नोंदणी नोंदी'},
    // Tabs
    'vivah':                {'en': 'Marriage', 'hi': 'विवाह',  'mr': 'विवाह'},
    'janm':                 {'en': 'Birth',    'hi': 'जन्म',   'mr': 'जन्म'},
    'mrityu':               {'en': 'Death',    'hi': 'मृत्यु', 'mr': 'मृत्यू'},
    // Marriage form
    'new_marriage_reg':     {'en': 'New Marriage Registration','hi': 'नई विवाह पंजीकरण',   'mr': 'नवीन विवाह नोंदणी'},
    'husband_details':      {'en': '👨 Husband Details',       'hi': '👨 पति का विवरण',     'mr': '👨 नवऱ्याचा तपशील'},
    'wife_details':         {'en': '👩 Wife Details',          'hi': '👩 पत्नी का विवरण',   'mr': '👩 नवरीचा तपशील'},
    'marriage_details':     {'en': '💒 Marriage Details',      'hi': '💒 विवाह विवरण',       'mr': '💒 विवाह तपशील'},
    'husband_name':         {'en': 'Husband Full Name',        'hi': 'पति का पूरा नाम',     'mr': 'नवऱ्याचे पूर्ण नाव'},
    'husband_age':          {'en': 'Husband Age',              'hi': 'पति की आयु',          'mr': 'नवऱ्याचे वय'},
    'husband_father':       {'en': "Husband's Father Name",    'hi': 'पति के पिता का नाम', 'mr': 'नवऱ्याच्या वडिलांचे नाव'},
    'husband_village':      {'en': 'Husband Village/Area',     'hi': 'पति का गाँव/क्षेत्र','mr': 'नवऱ्याचे गाव/क्षेत्र'},
    'wife_name':            {'en': 'Wife Full Name',           'hi': 'पत्नी का पूरा नाम',  'mr': 'नवरीचे पूर्ण नाव'},
    'wife_age':             {'en': 'Wife Age',                 'hi': 'पत्नी की आयु',       'mr': 'नवरीचे वय'},
    'wife_father':          {'en': "Wife's Father Name",       'hi': 'पत्नी के पिता का नाम','mr': 'नवरीच्या वडिलांचे नाव'},
    'wife_village':         {'en': 'Wife Village/Area',        'hi': 'पत्नी का गाँव/क्षेत्र','mr': 'नवरीचे गाव/क्षेत्र'},
    'marriage_date':        {'en': 'Marriage Date (DD-MM-YYYY)','hi': 'विवाह तिथि (DD-MM-YYYY)','mr': 'विवाह तारीख (DD-MM-YYYY)'},
    'marriage_place':       {'en': 'Marriage Place',           'hi': 'विवाह स्थान',         'mr': 'विवाहाचे ठिकाण'},
    'marriage_type':        {'en': 'Marriage Type / Dharm',    'hi': 'विवाह का प्रकार / धर्म','mr': 'विवाहाचा प्रकार / धर्म'},
    // Birth form
    'new_birth_reg':        {'en': 'New Baby Birth Registration','hi': 'नई जन्म पंजीकरण',   'mr': 'नवीन जन्म नोंदणी'},
    'baby_details':         {'en': '👶 Baby Details',          'hi': '👶 बच्चे का विवरण',  'mr': '👶 बाळाचा तपशील'},
    'mother_details':       {'en': '👩 Mother Details',        'hi': '👩 माँ का विवरण',    'mr': '👩 आईचा तपशील'},
    'baby_name':            {'en': 'Baby Name',                'hi': 'बच्चे का नाम',       'mr': 'बाळाचे नाव'},
    'gender':               {'en': 'Gender',                   'hi': 'लिंग',               'mr': 'लिंग'},
    'dob':                  {'en': 'Date of Birth (DD-MM-YYYY)','hi': 'जन्म तिथि (DD-MM-YYYY)','mr': 'जन्म तारीख (DD-MM-YYYY)'},
    'time_of_birth':        {'en': 'Time of Birth (HH:MM AM/PM)','hi': 'जन्म समय (HH:MM AM/PM)','mr': 'जन्म वेळ (HH:MM AM/PM)'},
    'weight':               {'en': 'Weight at Birth (kg)',     'hi': 'जन्म के समय वजन (kg)','mr': 'जन्माचे वजन (kg)'},
    'birth_type':           {'en': 'Birth Type',               'hi': 'जन्म का प्रकार',     'mr': 'जन्माचा प्रकार'},
    'birth_place':          {'en': 'Birth Place',              'hi': 'जन्म स्थान',         'mr': 'जन्माचे ठिकाण'},
    'phc_hospital':         {'en': 'PHC / Hospital Name',      'hi': 'PHC / अस्पताल का नाम','mr': 'PHC / रुग्णालयाचे नाव'},
    'mother_name':          {'en': "Mother's Full Name",       'hi': 'माँ का पूरा नाम',    'mr': 'आईचे पूर्ण नाव'},
    'mother_age':           {'en': "Mother's Age",             'hi': 'माँ की आयु',         'mr': 'आईचे वय'},
    'father_name':          {'en': "Father's Full Name",       'hi': 'पिता का पूरा नाम',   'mr': 'वडिलांचे पूर्ण नाव'},
    'father_age':           {'en': "Father's Age",             'hi': 'पिता की आयु',        'mr': 'वडिलांचे वय'},
    'village':              {'en': 'Village / Area',           'hi': 'गाँव / क्षेत्र',     'mr': 'गाव / क्षेत्र'},
    // Death form
    'death_reg':            {'en': 'Death Registration',       'hi': 'मृत्यु पंजीकरण',     'mr': 'मृत्यू नोंदणी'},
    'deceased_details':     {'en': '👤 Deceased Person Details','hi': '👤 मृत व्यक्ति का विवरण','mr': '👤 मृत व्यक्तीचा तपशील'},
    'death_details':        {'en': '📅 Death Details',         'hi': '📅 मृत्यु विवरण',    'mr': '📅 मृत्यू तपशील'},
    'hospital_details':     {'en': '🏥 Hospital / Referral Details','hi': '🏥 अस्पताल / रेफरल विवरण','mr': '🏥 रुग्णालय / रेफरल तपशील'},
    'deceased_name':        {'en': 'Full Name of Deceased',    'hi': 'मृत व्यक्ति का पूरा नाम','mr': 'मृत व्यक्तीचे पूर्ण नाव'},
    'age_at_death':         {'en': 'Age at Death',             'hi': 'मृत्यु के समय आयु',  'mr': 'मृत्यूच्या वेळी वय'},
    'relative_name':        {'en': 'Father / Husband Name',    'hi': 'पिता / पति का नाम',  'mr': 'वडील / पतीचे नाव'},
    'district':             {'en': 'District',                 'hi': 'जिला',               'mr': 'जिल्हा'},
    'date_of_death':        {'en': 'Date of Death (DD-MM-YYYY)','hi': 'मृत्यु तिथि (DD-MM-YYYY)','mr': 'मृत्यू तारीख (DD-MM-YYYY)'},
    'time_of_death':        {'en': 'Time of Death (HH:MM AM/PM)','hi': 'मृत्यु का समय (HH:MM AM/PM)','mr': 'मृत्यूची वेळ (HH:MM AM/PM)'},
    'place_of_death':       {'en': 'Place of Death',           'hi': 'मृत्यु का स्थान',    'mr': 'मृत्यूचे ठिकाण'},
    'death_reason':         {'en': 'Death Reason / Disease Name','hi': 'मृत्यु का कारण / रोग','mr': 'मृत्यूचे कारण / आजार'},
    'type_of_death':        {'en': 'Type of Death',            'hi': 'मृत्यु का प्रकार',   'mr': 'मृत्यूचा प्रकार'},
    'referred':             {'en': 'Referred to Hospital?',    'hi': 'अस्पताल रेफर किया?', 'mr': 'रुग्णालयात रेफर केले?'},
    'hospital_name':        {'en': 'Hospital Name (if referred)','hi': 'अस्पताल का नाम (यदि रेफर)', 'mr': 'रुग्णालयाचे नाव (रेफर असल्यास)'},
    // Common
    'remarks':              {'en': 'Remarks (optional)',       'hi': 'टिप्पणी (वैकल्पिक)', 'mr': 'शेरा (पर्यायी)'},
    'save_record':          {'en': 'Save Record',              'hi': 'रिकॉर्ड सहेजें',     'mr': 'नोंद जतन करा'},
    'cancel':               {'en': 'Cancel',                   'hi': 'रद्द करें',           'mr': 'रद्द करा'},
    'search_name_village':  {'en': 'Search by name or village…','hi': 'नाम या गाँव से खोजें…','mr': 'नाव किंवा गावाने शोधा…'},
    'search_baby_mother':   {'en': 'Search by baby or mother name…','hi': 'बच्चे या माँ के नाम से खोजें…','mr': 'बाळ किंवा आईच्या नावाने शोधा…'},
    'add_vivah':            {'en': 'Add New Marriage',         'hi': 'नया विवाह जोड़ें',    'mr': 'नवीन विवाह जोडा'},
    'add_janm':             {'en': 'Add New Birth',            'hi': 'नया जन्म जोड़ें',     'mr': 'नवीन जन्म जोडा'},
    'add_mrityu':           {'en': 'Add Death Record',         'hi': 'मृत्यु रिकॉर्ड जोड़ें','mr': 'मृत्यू नोंद जोडा'},
    'record_deleted':       {'en': 'Record deleted',           'hi': 'रिकॉर्ड हटाया गया',  'mr': 'नोंद हटवली'},
    'delete_record':        {'en': 'Delete Record?',           'hi': 'रिकॉर्ड हटाएँ?',      'mr': 'नोंद हटवायची?'},
    'delete_confirm':       {'en': 'This record will be permanently deleted.',
                             'hi': 'यह रिकॉर्ड स्थायी रूप से हटा दिया जाएगा।',
                             'mr': 'ही नोंद कायमची हटवली जाईल।'},
    'delete':               {'en': 'Delete',                   'hi': 'हटाएँ',               'mr': 'हटवा'},
    'name_required':        {'en': 'Name required',            'hi': 'नाम आवश्यक है',       'mr': 'नाव आवश्यक आहे'},
    'age_required':         {'en': 'Age required',             'hi': 'आयु आवश्यक है',       'mr': 'वय आवश्यक आहे'},
    'date_required':        {'en': 'Date required',            'hi': 'तिथि आवश्यक है',      'mr': 'तारीख आवश्यक आहे'},
    'place_required':       {'en': 'Place required',           'hi': 'स्थान आवश्यक है',     'mr': 'ठिकाण आवश्यक आहे'},
    'village_required':     {'en': 'Village required',         'hi': 'गाँव आवश्यक है',      'mr': 'गाव आवश्यक आहे'},
    'weight_required':      {'en': 'Weight required',          'hi': 'वजन आवश्यक है',       'mr': 'वजन आवश्यक आहे'},
    'reason_required':      {'en': 'Reason required',          'hi': 'कारण आवश्यक है',      'mr': 'कारण आवश्यक आहे'},
    'export_msg_vivah':     {'en': '📊 Saved! Export: ASHA_Daily_Report.xlsx → 💍 Marriages',
                             'hi': '📊 सहेजा! निर्यात: ASHA_Daily_Report.xlsx → 💍 विवाह',
                             'mr': '📊 जतन! निर्यात: ASHA_Daily_Report.xlsx → 💍 विवाह'},
    'export_msg_birth':     {'en': '📊 Saved! Export: ASHA_Daily_Report.xlsx → 👶 Births',
                             'hi': '📊 सहेजा! निर्यात: ASHA_Daily_Report.xlsx → 👶 जन्म',
                             'mr': '📊 जतन! निर्यात: ASHA_Daily_Report.xlsx → 👶 जन्म'},
    'export_msg_death':     {'en': '📊 Saved! Export: ASHA_Daily_Report.xlsx → 💀 Deaths',
                             'hi': '📊 सहेजा! निर्यात: ASHA_Daily_Report.xlsx → 💀 मृत्यु',
                             'mr': '📊 जतन! निर्यात: ASHA_Daily_Report.xlsx → 💀 मृत्यू'},
    'voice_listening':      {'en': '🎤 Listening…',            'hi': '🎤 सुन रहा हूँ…',      'mr': '🎤 ऐकतोय…'},
    'voice_tap':            {'en': 'Tap mic to speak',         'hi': 'माइक दबाएं',          'mr': 'मायक्रोफोन दाबा'},
  };

  static String tr(String key) =>
      _t[key]?[currentLocale] ?? _t[key]?['en'] ?? key;
}

// ══════════════════════════════════════════════════════════
//  LANGUAGE SWITCHER BAR (replaces MiniLangBar)
// ══════════════════════════════════════════════════════════
class MiniLangBar extends StatelessWidget {
  const MiniLangBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLocale,
      builder: (_, loc, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangBtn('EN', 'en', loc),
          const SizedBox(width: 4),
          _LangBtn('हि', 'hi', loc),
          const SizedBox(width: 4),
          _LangBtn('म', 'mr', loc),
        ],
      ),
    );
  }
}

class _LangBtn extends StatelessWidget {
  final String label, code, current;
  const _LangBtn(this.label, this.code, this.current);

  @override
  Widget build(BuildContext context) {
    final active = current == code;
    return GestureDetector(
      onTap: () => appLocale.value = code,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: active ? Colors.white : Colors.white30, width: 1.2),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: active ? const Color(0xFF37474F) : Colors.white70, decoration: TextDecoration.none)),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  VOICE INPUT FIELD WIDGET
// ══════════════════════════════════════════════════════════
class VoiceField extends StatefulWidget {
  final TextEditingController controller;
  final String labelKey;           // key into L._t
  final IconData icon;
  final Color color;
  final TextInputType keyboard;
  final List<TextInputFormatter>? formatters;
  final int? maxLen;
  final String? Function(String?)? validator;

  const VoiceField({
    super.key,
    required this.controller,
    required this.labelKey,
    required this.icon,
    required this.color,
    this.keyboard = TextInputType.text,
    this.formatters,
    this.maxLen,
    this.validator,
  });

  @override
  State<VoiceField> createState() => _VoiceFieldState();
}

class _VoiceFieldState extends State<VoiceField>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _liveText = ''; // ← real-time interim text
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _pulse = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
        lowerBound: 0.8,
        upperBound: 1.2)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleListen() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
        _liveText = '';
      });
      return;
    }
    final available = await _speech.initialize(
      onError: (e) => setState(() {
        _isListening = false;
        _liveText = '';
      }),
      onStatus: (s) {
        if (s == 'done' || s == 'notListening') {
          setState(() {
            _isListening = false;
            _liveText = '';
          });
        }
      },
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        localeId: L.sttLocale,
        partialResults: true,          // ← yeh line real-time text ke liye
        onResult: (r) {
          setState(() {
            // Har partial result field mein dikhao
            widget.controller.text = r.recognizedWords;
            // Cursor end pe rakho
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length),
            );
            _liveText = r.recognizedWords;
            if (r.finalResult) {
              _isListening = false;
              _liveText = '';
            }
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Microphone not available'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLocale,
      builder: (_, __, ___) => TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboard,
        inputFormatters: widget.formatters,
        maxLength: widget.maxLen,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontSize: 13, color: kText, decoration: TextDecoration.none),
        decoration: InputDecoration(
          labelText: L.tr(widget.labelKey),
          labelStyle: const TextStyle(fontSize: 12, color: kMuted, decoration: TextDecoration.none),
          prefixIcon: Icon(widget.icon, color: widget.color, size: 18),
          suffixIcon: GestureDetector(
            onTap: _toggleListen,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, child) => Transform.scale(
                scale: _isListening ? _pulse.value : 1.0,
                child: child,
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isListening
                      ? Colors.red.withOpacity(0.15)
                      : widget.color.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: _isListening ? Colors.red : widget.color,
                  size: 18,
                ),
              ),
            ),
          ),
          filled: true,
          fillColor: _isListening
              ? Colors.red.withOpacity(0.04)
              : const Color(0xFFF8FAFC),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide(
                  color: _isListening ? Colors.red : kBorder, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide(color: widget.color, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Colors.red, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Colors.red, width: 2)),
          helperText: _isListening ? L.tr('voice_listening') : null,
          helperStyle: const TextStyle(
              fontSize: 10, color: Colors.red, fontWeight: FontWeight.w600, decoration: TextDecoration.none),
          counterText: '',
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  DAILY REPORT PAGE — Main Entry
// ══════════════════════════════════════════════════════════
class DailyReportPage extends StatefulWidget {
  const DailyReportPage({super.key});
  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
    // Rebuild when language changes
    appLocale.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    appLocale.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: kBg, child: Column(children: [
      // ── Header ─────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF37474F), Color(0xFF546E7A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(children: [
          Row(children: [
            Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle),
                child: const Icon(Icons.assignment_rounded,
                    color: Colors.white, size: 22)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(L.tr('daily_report'),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white, decoration: TextDecoration.none)),
                  Text(L.tr('village_records'),
                      style: const TextStyle(
                          fontSize: 11, color: Colors.white70, decoration: TextDecoration.none)),
                ])),
            const MiniLangBar(),
          ]),
          const SizedBox(height: 12),
          _SummaryBar(),
          const SizedBox(height: 12),
          TabBar(
            controller: _tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, decoration: TextDecoration.none),
            tabs: [
              Tab(icon: const Icon(Icons.favorite_rounded, size: 16), text: L.tr('vivah')),
              Tab(icon: const Icon(Icons.child_care_rounded, size: 16), text: L.tr('janm')),
              Tab(icon: const Icon(Icons.sentiment_very_dissatisfied_rounded, size: 16), text: L.tr('mrityu')),
            ],
          ),
        ]),
      ),
      // ── Tab Views ──────────────────────────────────────
      Expanded(
        child: TabBarView(
          controller: _tab,
          children: const [
            MarriagePage(),
            BirthPage(),
            DeathPage(),
          ],
        ),
      ),
    ]));
  }
}

// ── Summary counts bar ───────────────────────────────────
class _SummaryBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _SumChip('💍', MarriageStore.records.length.toString(), L.tr('vivah'), const Color(0xFF1565C0)),
      const SizedBox(width: 8),
      _SumChip('👶', BirthStore.records.length.toString(),    L.tr('janm'),  const Color(0xFF1A9E5C)),
      const SizedBox(width: 8),
      _SumChip('🕯️', DeathStore.records.length.toString(),   L.tr('mrityu'),const Color(0xFFC62828)),
    ]);
  }
}

class _SumChip extends StatelessWidget {
  final String emoji, count, label;
  final Color color;
  const _SumChip(this.emoji, this.count, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text('$emoji $count',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white, decoration: TextDecoration.none)),
            Text(label,
                style: const TextStyle(fontSize: 9, color: Colors.white70, decoration: TextDecoration.none)),
          ]),
        ),
      );
}

// ══════════════════════════════════════════════════════════
//  DATA STORES (in-memory)
// ══════════════════════════════════════════════════════════
class MarriageStore {
  static final List<Map<String, dynamic>> records = [
    {
      'srNo': 1, 'regDate': '01-Mar-2025',
      'husbandName': 'Ramesh Sharma', 'husbandAge': 28,
      'husbandFather': 'Suresh Sharma', 'husbandVillage': 'Wardha',
      'wifeName': 'Sunita Patil', 'wifeAge': 24,
      'wifeFather': 'Vinod Patil', 'wifeVillage': 'Hingna',
      'marriageDate': '28-Feb-2025', 'marriagePlace': 'Wardha Temple',
      'marriageType': 'Hindu', 'ashaId': 'MH-ASHA-001', 'remarks': '',
    }
  ];
}

class BirthStore {
  static final List<Map<String, dynamic>> records = [
    {
      'srNo': 1, 'regDate': '01-Mar-2025',
      'babyName': 'Arjun Kumar', 'gender': 'Male',
      'dob': '28-Feb-2025', 'timeOfBirth': '10:30 AM',
      'birthPlace': 'PHC Wardha', 'birthType': 'Institutional',
      'weight': 3.2, 'motherName': 'Kavita Kumar', 'motherAge': 26,
      'fatherName': 'Ramesh Kumar', 'fatherAge': 30,
      'village': 'Wardha', 'hospital': 'PHC Wardha',
      'ashaId': 'MH-ASHA-001', 'remarks': '',
    }
  ];
}

class DeathStore {
  static final List<Map<String, dynamic>> records = [
    {
      'srNo': 1, 'regDate': '01-Mar-2025',
      'name': 'Ramkrishna Patil', 'age': 72, 'gender': 'Male',
      'relativeName': 'Ganpat Patil', 'village': 'Hingna',
      'district': 'Wardha', 'dateOfDeath': '28-Feb-2025',
      'timeOfDeath': '3:15 AM', 'placeOfDeath': 'Home',
      'deathReason': 'Cardiac Arrest', 'typeOfDeath': 'Natural',
      'referred': 'Yes', 'hospitalName': 'District Hospital Wardha',
      'ashaId': 'MH-ASHA-001', 'remarks': '',
    }
  ];
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════
const _kMarriage = Color(0xFF1565C0);
const _kBirth    = Color(0xFF1A9E5C);
const _kDeath    = Color(0xFFC62828);

Widget _fieldGap() => const SizedBox(height: 10);

Widget _sectionHead(String title, Color color) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Row(children: [
      Container(width: 4, height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(title,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: color, decoration: TextDecoration.none)),
    ]));

Widget _dropField({
  required String label,
  required String? value,
  required List<String> items,
  required Color color,
  required IconData icon,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12, color: kMuted, decoration: TextDecoration.none),
      prefixIcon: Icon(icon, color: color, size: 18),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: kBorder, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: color, width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    ),
    style: const TextStyle(fontSize: 13, color: kText, decoration: TextDecoration.none),
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onChanged,
    validator: (v) => v == null ? 'Please select $label' : null,
    autovalidateMode: AutovalidateMode.onUserInteraction,
  );
}

void _showExportSnack(BuildContext context, String msgKey) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(L.tr(msgKey)),
      backgroundColor: const Color(0xFF37474F),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating));
}

// ══════════════════════════════════════════════════════════
//  1. MARRIAGE PAGE
// ══════════════════════════════════════════════════════════
class MarriagePage extends StatefulWidget {
  const MarriagePage({super.key});
  @override
  State<MarriagePage> createState() => _MarriagePageState();
}

class _MarriagePageState extends State<MarriagePage> {
  final _searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    appLocale.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchC.dispose();
    appLocale.removeListener(() => setState(() {}));
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _searchC.text.toLowerCase();
    return MarriageStore.records.where((r) =>
        q.isEmpty ||
        r['husbandName'].toString().toLowerCase().contains(q) ||
        r['wifeName'].toString().toLowerCase().contains(q) ||
        r['husbandVillage'].toString().toLowerCase().contains(q)).toList();
  }

  void _addRecord() {
    final fk = GlobalKey<FormState>();
    final hNameC   = TextEditingController();
    final hAgeC    = TextEditingController();
    final hFatherC = TextEditingController();
    final hVillC   = TextEditingController();
    final wNameC   = TextEditingController();
    final wAgeC    = TextEditingController();
    final wFatherC = TextEditingController();
    final wVillC   = TextEditingController();
    final mDateC   = TextEditingController();
    final mPlaceC  = TextEditingController();
    final remarksC = TextEditingController();
    String? mType  = 'Hindu';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: fk,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  // Title
                  _DialogHeader(
                      title: L.tr('new_marriage_reg'),
                      icon: Icons.favorite_rounded,
                      color: _kMarriage,
                      onClose: () => Navigator.pop(ctx)),
                  Divider(color: _kMarriage.withOpacity(0.2), height: 20),

                  _sectionHead(L.tr('husband_details'), _kMarriage),
                  VoiceField(controller: hNameC,   labelKey: 'husband_name',   icon: Icons.person_outline,          color: _kMarriage, validator: (v) => v!.trim().length < 2 ? L.tr('name_required') : null),
                  _fieldGap(),
                  VoiceField(controller: hAgeC,    labelKey: 'husband_age',    icon: Icons.cake_outlined,           color: _kMarriage, keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly], maxLen: 3, validator: (v) => v!.trim().isEmpty ? L.tr('age_required') : null),
                  _fieldGap(),
                  VoiceField(controller: hFatherC, labelKey: 'husband_father', icon: Icons.family_restroom_rounded, color: _kMarriage),
                  _fieldGap(),
                  VoiceField(controller: hVillC,   labelKey: 'husband_village',icon: Icons.location_on_outlined,    color: _kMarriage, validator: (v) => v!.trim().isEmpty ? L.tr('village_required') : null),

                  _sectionHead(L.tr('wife_details'), _kMarriage),
                  VoiceField(controller: wNameC,   labelKey: 'wife_name',      icon: Icons.person_outline,          color: _kMarriage, validator: (v) => v!.trim().length < 2 ? L.tr('name_required') : null),
                  _fieldGap(),
                  VoiceField(controller: wAgeC,    labelKey: 'wife_age',       icon: Icons.cake_outlined,           color: _kMarriage, keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly], maxLen: 3, validator: (v) => v!.trim().isEmpty ? L.tr('age_required') : null),
                  _fieldGap(),
                  VoiceField(controller: wFatherC, labelKey: 'wife_father',    icon: Icons.family_restroom_rounded, color: _kMarriage),
                  _fieldGap(),
                  VoiceField(controller: wVillC,   labelKey: 'wife_village',   icon: Icons.location_on_outlined,    color: _kMarriage, validator: (v) => v!.trim().isEmpty ? L.tr('village_required') : null),

                  _sectionHead(L.tr('marriage_details'), _kMarriage),
                  VoiceField(controller: mDateC,   labelKey: 'marriage_date',  icon: Icons.calendar_today_rounded,  color: _kMarriage, validator: (v) => v!.trim().isEmpty ? L.tr('date_required') : null),
                  _fieldGap(),
                  VoiceField(controller: mPlaceC,  labelKey: 'marriage_place', icon: Icons.place_rounded,           color: _kMarriage, validator: (v) => v!.trim().isEmpty ? L.tr('place_required') : null),
                  _fieldGap(),
                  _dropField(
                    label: L.tr('marriage_type'),
                    value: mType,
                    items: ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Buddhist', 'Other'],
                    color: _kMarriage,
                    icon: Icons.church_rounded,
                    onChanged: (v) => setSt(() => mType = v),
                  ),
                  _fieldGap(),
                  VoiceField(controller: remarksC, labelKey: 'remarks',        icon: Icons.note_outlined,           color: _kMarriage),

                  const SizedBox(height: 20),
                  _DialogButtons(
                    color: _kMarriage,
                    onSave: () {
                      if (fk.currentState!.validate()) {
                        setState(() {
                          MarriageStore.records.insert(0, {
                            'srNo': MarriageStore.records.length + 1,
                            'regDate': _todayStr(),
                            'husbandName': hNameC.text.trim(),
                            'husbandAge': int.tryParse(hAgeC.text) ?? 0,
                            'husbandFather': hFatherC.text.trim(),
                            'husbandVillage': hVillC.text.trim(),
                            'wifeName': wNameC.text.trim(),
                            'wifeAge': int.tryParse(wAgeC.text) ?? 0,
                            'wifeFather': wFatherC.text.trim(),
                            'wifeVillage': wVillC.text.trim(),
                            'marriageDate': mDateC.text.trim(),
                            'marriagePlace': mPlaceC.text.trim(),
                            'marriageType': mType ?? 'Hindu',
                            'ashaId': 'MH-ASHA-001',
                            'remarks': remarksC.text.trim(),
                          });
                        });
                        Navigator.pop(ctx);
                        _showExportSnack(context, 'export_msg_vivah');
                      }
                    },
                    onCancel: () => Navigator.pop(ctx),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _delete(Map<String, dynamic> r) {
    setState(() => MarriageStore.records.remove(r));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L.tr('record_deleted')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      buildSearchBar(
          controller: _searchC,
          hint: L.tr('search_name_village'),
          color: _kMarriage,
          onChanged: () => setState(() {})),
      buildFilterChips(
        current: 'all',
        chips: [{'label': 'All', 'value': 'all'}],
        color: _kMarriage,
        count: list.length,
        onTap: (_) {},
      ),
      Expanded(
        child: list.isEmpty
            ? emptyState(_searchC.text)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final r = list[i];
                  return _RecordCard(
                    color: _kMarriage,
                    icon: Icons.favorite_rounded,
                    title: '${r['husbandName']} 💍 ${r['wifeName']}',
                    subtitle1: '📍 ${r['husbandVillage']} × ${r['wifeVillage']}',
                    subtitle2: '📅 ${r['marriageDate']} • ${r['marriageType']}',
                    subtitle3: '📝 Reg: ${r['regDate']}',
                    onDelete: () => _delete(r),
                  );
                }),
      ),
      _AddButton(
          label: L.tr('add_vivah'),
          color: _kMarriage,
          onTap: _addRecord),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  2. BIRTH PAGE
// ══════════════════════════════════════════════════════════
class BirthPage extends StatefulWidget {
  const BirthPage({super.key});
  @override
  State<BirthPage> createState() => _BirthPageState();
}

class _BirthPageState extends State<BirthPage> {
  final _searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    appLocale.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchC.dispose();
    appLocale.removeListener(() => setState(() {}));
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _searchC.text.toLowerCase();
    return BirthStore.records.where((r) =>
        q.isEmpty ||
        r['babyName'].toString().toLowerCase().contains(q) ||
        r['motherName'].toString().toLowerCase().contains(q) ||
        r['village'].toString().toLowerCase().contains(q)).toList();
  }

  void _addRecord() {
    final fk       = GlobalKey<FormState>();
    final babyC    = TextEditingController();
    final dobC     = TextEditingController();
    final timeC    = TextEditingController();
    final placeC   = TextEditingController();
    final weightC  = TextEditingController();
    final motherC  = TextEditingController();
    final mAgeC    = TextEditingController();
    final fatherC  = TextEditingController();
    final fAgeC    = TextEditingController();
    final villC    = TextEditingController();
    final hospC    = TextEditingController();
    final remarkC  = TextEditingController();
    String? gender = 'Male';
    String? bType  = 'Institutional';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: fk,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  _DialogHeader(
                      title: L.tr('new_birth_reg'),
                      icon: Icons.child_care_rounded,
                      color: _kBirth,
                      onClose: () => Navigator.pop(ctx)),
                  Divider(color: _kBirth.withOpacity(0.2), height: 20),

                  _sectionHead(L.tr('baby_details'), _kBirth),
                  VoiceField(controller: babyC,   labelKey: 'baby_name',    icon: Icons.child_care_rounded,          color: _kBirth, validator: (v) => v!.trim().length < 2 ? L.tr('name_required') : null),
                  _fieldGap(),
                  _dropField(label: L.tr('gender'), value: gender,
                      items: ['Male', 'Female', 'Other'], color: _kBirth,
                      icon: Icons.wc_rounded,
                      onChanged: (v) => setSt(() => gender = v)),
                  _fieldGap(),
                  VoiceField(controller: dobC,    labelKey: 'dob',          icon: Icons.calendar_today_rounded,      color: _kBirth, validator: (v) => v!.trim().isEmpty ? L.tr('date_required') : null),
                  _fieldGap(),
                  VoiceField(controller: timeC,   labelKey: 'time_of_birth',icon: Icons.access_time_rounded,         color: _kBirth),
                  _fieldGap(),
                  VoiceField(controller: weightC, labelKey: 'weight',       icon: Icons.monitor_weight_outlined,     color: _kBirth, keyboard: TextInputType.number, validator: (v) => v!.trim().isEmpty ? L.tr('weight_required') : null),
                  _fieldGap(),
                  _dropField(label: L.tr('birth_type'), value: bType,
                      items: ['Institutional', 'Home Birth', 'Emergency', 'Caesarean'],
                      color: _kBirth, icon: Icons.local_hospital_rounded,
                      onChanged: (v) => setSt(() => bType = v)),
                  _fieldGap(),
                  VoiceField(controller: placeC,  labelKey: 'birth_place',  icon: Icons.place_rounded,               color: _kBirth, validator: (v) => v!.trim().isEmpty ? L.tr('place_required') : null),
                  _fieldGap(),
                  VoiceField(controller: hospC,   labelKey: 'phc_hospital', icon: Icons.local_hospital_outlined,     color: _kBirth),

                  _sectionHead(L.tr('mother_details'), _kBirth),
                  VoiceField(controller: motherC, labelKey: 'mother_name',  icon: Icons.person_outline,              color: _kBirth, validator: (v) => v!.trim().length < 2 ? L.tr('name_required') : null),
                  _fieldGap(),
                  VoiceField(controller: mAgeC,   labelKey: 'mother_age',   icon: Icons.cake_outlined,               color: _kBirth, keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly], maxLen: 2),
                  _fieldGap(),
                  VoiceField(controller: fatherC, labelKey: 'father_name',  icon: Icons.person_2_outlined,           color: _kBirth, validator: (v) => v!.trim().length < 2 ? L.tr('name_required') : null),
                  _fieldGap(),
                  VoiceField(controller: fAgeC,   labelKey: 'father_age',   icon: Icons.cake_outlined,               color: _kBirth, keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly], maxLen: 2),
                  _fieldGap(),
                  VoiceField(controller: villC,   labelKey: 'village',      icon: Icons.location_on_outlined,        color: _kBirth, validator: (v) => v!.trim().isEmpty ? L.tr('village_required') : null),
                  _fieldGap(),
                  VoiceField(controller: remarkC, labelKey: 'remarks',      icon: Icons.note_outlined,               color: _kBirth),

                  const SizedBox(height: 20),
                  _DialogButtons(
                    color: _kBirth,
                    onSave: () {
                      if (fk.currentState!.validate()) {
                        setState(() {
                          BirthStore.records.insert(0, {
                            'srNo': BirthStore.records.length + 1,
                            'regDate': _todayStr(),
                            'babyName': babyC.text.trim(),
                            'gender': gender ?? 'Male',
                            'dob': dobC.text.trim(),
                            'timeOfBirth': timeC.text.trim(),
                            'birthPlace': placeC.text.trim(),
                            'birthType': bType ?? 'Institutional',
                            'weight': double.tryParse(weightC.text) ?? 0.0,
                            'motherName': motherC.text.trim(),
                            'motherAge': int.tryParse(mAgeC.text) ?? 0,
                            'fatherName': fatherC.text.trim(),
                            'fatherAge': int.tryParse(fAgeC.text) ?? 0,
                            'village': villC.text.trim(),
                            'hospital': hospC.text.trim(),
                            'ashaId': 'MH-ASHA-001',
                            'remarks': remarkC.text.trim(),
                          });
                        });
                        Navigator.pop(ctx);
                        _showExportSnack(context, 'export_msg_birth');
                      }
                    },
                    onCancel: () => Navigator.pop(ctx),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _delete(Map<String, dynamic> r) {
    setState(() => BirthStore.records.remove(r));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L.tr('record_deleted')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      buildSearchBar(
          controller: _searchC,
          hint: L.tr('search_baby_mother'),
          color: _kBirth,
          onChanged: () => setState(() {})),
      buildFilterChips(
        current: 'all',
        chips: [{'label': 'All', 'value': 'all'}],
        color: _kBirth,
        count: list.length,
        onTap: (_) {},
      ),
      Expanded(
        child: list.isEmpty
            ? emptyState(_searchC.text)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final r = list[i];
                  final gIcon = r['gender'] == 'Male'
                      ? '👦'
                      : r['gender'] == 'Female'
                          ? '👧'
                          : '🧒';
                  return _RecordCard(
                    color: _kBirth,
                    icon: Icons.child_care_rounded,
                    title: '$gIcon ${r['babyName']} — ${r['gender']}',
                    subtitle1: '👩 ${r['motherName']} × 👨 ${r['fatherName']}',
                    subtitle2: '📅 ${r['dob']} ${r['timeOfBirth']} • ⚖️ ${r['weight']} kg',
                    subtitle3: '🏥 ${r['birthType']} • 📍 ${r['village']}',
                    onDelete: () => _delete(r),
                  );
                }),
      ),
      _AddButton(label: L.tr('add_janm'), color: _kBirth, onTap: _addRecord),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  3. DEATH PAGE
// ══════════════════════════════════════════════════════════
class DeathPage extends StatefulWidget {
  const DeathPage({super.key});
  @override
  State<DeathPage> createState() => _DeathPageState();
}

class _DeathPageState extends State<DeathPage> {
  final _searchC = TextEditingController();
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    appLocale.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchC.dispose();
    appLocale.removeListener(() => setState(() {}));
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _searchC.text.toLowerCase();
    return DeathStore.records.where((r) {
      final matchQ = q.isEmpty ||
          r['name'].toString().toLowerCase().contains(q) ||
          r['village'].toString().toLowerCase().contains(q) ||
          r['deathReason'].toString().toLowerCase().contains(q);
      final matchF = _filter == 'all' || r['typeOfDeath'] == _filter;
      return matchQ && matchF;
    }).toList();
  }

  void _addRecord() {
    final fk       = GlobalKey<FormState>();
    final nameC    = TextEditingController();
    final ageC     = TextEditingController();
    final relC     = TextEditingController();
    final villC    = TextEditingController();
    final distC    = TextEditingController();
    final dodC     = TextEditingController();
    final todC     = TextEditingController();
    final placeC   = TextEditingController();
    final reasonC  = TextEditingController();
    final hospC    = TextEditingController();
    final remarkC  = TextEditingController();
    String? gender    = 'Male';
    String? deathType = 'Natural';
    String? referred  = 'No';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: fk,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  _DialogHeader(
                      title: L.tr('death_reg'),
                      icon: Icons.sentiment_very_dissatisfied_rounded,
                      color: _kDeath,
                      onClose: () => Navigator.pop(ctx)),
                  Divider(color: _kDeath.withOpacity(0.2), height: 20),

                  _sectionHead(L.tr('deceased_details'), _kDeath),
                  VoiceField(controller: nameC,   labelKey: 'deceased_name', icon: Icons.person_outline,          color: _kDeath, validator: (v) => v!.trim().length < 2 ? L.tr('name_required') : null),
                  _fieldGap(),
                  VoiceField(controller: ageC,    labelKey: 'age_at_death',  icon: Icons.cake_outlined,           color: _kDeath, keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly], maxLen: 3, validator: (v) => v!.trim().isEmpty ? L.tr('age_required') : null),
                  _fieldGap(),
                  _dropField(label: L.tr('gender'), value: gender,
                      items: ['Male', 'Female', 'Other'], color: _kDeath,
                      icon: Icons.wc_rounded,
                      onChanged: (v) => setSt(() => gender = v)),
                  _fieldGap(),
                  VoiceField(controller: relC,    labelKey: 'relative_name', icon: Icons.family_restroom_rounded, color: _kDeath),
                  _fieldGap(),
                  VoiceField(controller: villC,   labelKey: 'village',       icon: Icons.location_on_outlined,   color: _kDeath, validator: (v) => v!.trim().isEmpty ? L.tr('village_required') : null),
                  _fieldGap(),
                  VoiceField(controller: distC,   labelKey: 'district',      icon: Icons.map_outlined,           color: _kDeath),

                  _sectionHead(L.tr('death_details'), _kDeath),
                  VoiceField(controller: dodC,    labelKey: 'date_of_death', icon: Icons.calendar_today_rounded, color: _kDeath, validator: (v) => v!.trim().isEmpty ? L.tr('date_required') : null),
                  _fieldGap(),
                  VoiceField(controller: todC,    labelKey: 'time_of_death', icon: Icons.access_time_rounded,    color: _kDeath),
                  _fieldGap(),
                  _dropField(
                      label: L.tr('place_of_death'),
                      value: placeC.text.isEmpty ? 'Home' : null,
                      items: ['Home', 'Hospital', 'PHC', 'On the Way', 'Other'],
                      color: _kDeath, icon: Icons.place_rounded,
                      onChanged: (v) => placeC.text = v ?? 'Home'),
                  _fieldGap(),
                  VoiceField(controller: reasonC, labelKey: 'death_reason',  icon: Icons.medical_information_outlined, color: _kDeath, validator: (v) => v!.trim().isEmpty ? L.tr('reason_required') : null),
                  _fieldGap(),
                  _dropField(
                      label: L.tr('type_of_death'),
                      value: deathType,
                      items: [
                        'Natural', 'Accident', 'Illness / Disease',
                        'Maternal Death', 'Child Death (< 5 yrs)',
                        'Neonatal Death (< 28 days)', 'Suicide', 'Unknown',
                      ],
                      color: _kDeath, icon: Icons.category_outlined,
                      onChanged: (v) => setSt(() => deathType = v)),

                  _sectionHead(L.tr('hospital_details'), _kDeath),
                  _dropField(
                      label: L.tr('referred'),
                      value: referred,
                      items: ['No', 'Yes'], color: _kDeath,
                      icon: Icons.local_hospital_outlined,
                      onChanged: (v) => setSt(() => referred = v)),
                  _fieldGap(),
                  VoiceField(controller: hospC,   labelKey: 'hospital_name', icon: Icons.local_hospital_rounded, color: _kDeath),
                  _fieldGap(),
                  VoiceField(controller: remarkC, labelKey: 'remarks',       icon: Icons.note_outlined,          color: _kDeath),

                  const SizedBox(height: 20),
                  _DialogButtons(
                    color: _kDeath,
                    onSave: () {
                      if (fk.currentState!.validate()) {
                        setState(() {
                          DeathStore.records.insert(0, {
                            'srNo': DeathStore.records.length + 1,
                            'regDate': _todayStr(),
                            'name': nameC.text.trim(),
                            'age': int.tryParse(ageC.text) ?? 0,
                            'gender': gender ?? 'Male',
                            'relativeName': relC.text.trim(),
                            'village': villC.text.trim(),
                            'district': distC.text.trim(),
                            'dateOfDeath': dodC.text.trim(),
                            'timeOfDeath': todC.text.trim(),
                            'placeOfDeath': placeC.text.isEmpty ? 'Home' : placeC.text.trim(),
                            'deathReason': reasonC.text.trim(),
                            'typeOfDeath': deathType ?? 'Natural',
                            'referred': referred ?? 'No',
                            'hospitalName': hospC.text.trim(),
                            'ashaId': 'MH-ASHA-001',
                            'remarks': remarkC.text.trim(),
                          });
                        });
                        Navigator.pop(ctx);
                        _showExportSnack(context, 'export_msg_death');
                      }
                    },
                    onCancel: () => Navigator.pop(ctx),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _delete(Map<String, dynamic> r) {
    setState(() => DeathStore.records.remove(r));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(L.tr('record_deleted')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'Natural':                          return const Color(0xFF1A9E5C);
      case 'Accident':                         return const Color(0xFFFF6B2B);
      case 'Maternal Death':                   return const Color(0xFFD81B60);
      case 'Child Death (< 5 yrs)':
      case 'Neonatal Death (< 28 days)':       return const Color(0xFF7B2FBE);
      default:                                 return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      buildSearchBar(
          controller: _searchC,
          hint: L.tr('search_name_village'),
          color: _kDeath,
          onChanged: () => setState(() {})),
      buildFilterChips(
        current: _filter,
        chips: [
          {'label': 'All',       'value': 'all'},
          {'label': '🌿 Natural', 'value': 'Natural'},
          {'label': '🚗 Accident','value': 'Accident'},
          {'label': '🤒 Illness', 'value': 'Illness / Disease'},
          {'label': '👩 Maternal','value': 'Maternal Death'},
        ],
        color: _kDeath,
        count: list.length,
        onTap: (v) => setState(() => _filter = v),
      ),
      Expanded(
        child: list.isEmpty
            ? emptyState(_searchC.text)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final r = list[i];
                  final tc = _typeColor(r['typeOfDeath'].toString());
                  return _RecordCard(
                    color: _kDeath,
                    icon: Icons.person_off_rounded,
                    title: '${r['name']} — Age ${r['age']} (${r['gender']})',
                    subtitle1: '📍 ${r['village']}${r['district'].toString().isNotEmpty ? ', ${r['district']}' : ''}',
                    subtitle2: '📅 ${r['dateOfDeath']}  🕐 ${r['timeOfDeath']}  📌 ${r['placeOfDeath']}',
                    subtitle3: '🔴 ${r['deathReason']}',
                    badge: r['typeOfDeath'].toString(),
                    badgeColor: tc,
                    onDelete: () => _delete(r),
                  );
                }),
      ),
      _AddButton(label: L.tr('add_mrityu'), color: _kDeath, onTap: _addRecord),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED UI WIDGETS
// ══════════════════════════════════════════════════════════

/// Reusable dialog title row with colored icon, title, close button
class _DialogHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onClose;
  const _DialogHeader(
      {required this.title,
      required this.icon,
      required this.color,
      required this.onClose});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color, decoration: TextDecoration.none))),
        GestureDetector(
            onTap: onClose,
            child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.close_rounded,
                    size: 15, color: kMuted))),
      ]);
}

class _RecordCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title, subtitle1, subtitle2, subtitle3;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onDelete;

  const _RecordCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    this.badge,
    this.badgeColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.08), blurRadius: 8)
          ]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13.5, decoration: TextDecoration.none)),
            const SizedBox(height: 3),
            Text(subtitle1,
                style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            const SizedBox(height: 2),
            Text(subtitle2,
                style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            const SizedBox(height: 2),
            Text(subtitle3,
                style: TextStyle(
                    fontSize: 11.5,
                    color: color,
                    fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            if (badge != null) ...[
              const SizedBox(height: 5),
              buildTag(badge!, badgeColor ?? color),
            ],
          ]),
        ),
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(L.tr('delete_record'),
                  style: const TextStyle(fontWeight: FontWeight.w800, decoration: TextDecoration.none)),
              content: Text(L.tr('delete_confirm')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(L.tr('cancel'))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                    child: Text(L.tr('delete'))),
              ],
            ),
          ),
          child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Colors.red)),
        ),
      ]),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _AddButton(
      {required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.add_rounded),
            label: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.none)),
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
          ),
        ),
      );
}

class _DialogButtons extends StatelessWidget {
  final Color color;
  final VoidCallback onSave, onCancel;
  const _DialogButtons(
      {required this.color,
      required this.onSave,
      required this.onCancel});
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kBorder),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: Text(L.tr('cancel'),
                    style: const TextStyle(
                        color: kMuted, fontWeight: FontWeight.w600, decoration: TextDecoration.none)))),
        const SizedBox(width: 12),
        Expanded(
            flex: 2,
            child: ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text(L.tr('save_record'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14)))),
      ]);
}

// ══════════════════════════════════════════════════════════
//  UTILS
// ══════════════════════════════════════════════════════════
String _todayStr() {
  final n = DateTime.now();
  return '${n.day.toString().padLeft(2, '0')}-'
      '${n.month.toString().padLeft(2, '0')}-'
      '${n.year}';
}