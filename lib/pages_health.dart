import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'main.dart';
import 'asha_dashboard.dart';

// ══════════════════════════════════════════════════════════
//  SHARED VOICE DIALOG BASE
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
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : Colors.grey[700])),
              ),
            );
          }),
        ]),
      );

  // ── Listening indicator ──
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
            Expanded(child: Text('Sun raha hoon... boliye 🎤',
                style: TextStyle(fontSize: 11, color: Colors.red.shade700, fontWeight: FontWeight.w600))),
            GestureDetector(
              onTap: () async { await _speech.stop(); if (mounted) setState(() => listeningField = null); },
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
            child: Icon(active ? Icons.stop_rounded : Icons.mic_rounded,
                color: active ? Colors.white : color, size: 15),
          ),
        ),
        filled: true,
        fillColor: active ? Colors.red.shade50 : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: active ? const BorderSide(color: Colors.red, width: 1.5) : BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  2. HOME VISITS PAGE
// ══════════════════════════════════════════════════════════
class HomeVisitsPage extends StatefulWidget {
  const HomeVisitsPage({super.key});
  @override
  State<HomeVisitsPage> createState() => _HomeVisitsPageState();
}

class _HomeVisitsPageState extends State<HomeVisitsPage> {
  final List<Map<String, String>> _visits = [
    {'name':'Sunita Devi','village':'Wardha','date':'28 Feb','status':'completed','phone':'9876543210','age':'32','reason':'ANC Follow-up','notes':'BP normal'},
    {'name':'Meena Bai','village':'Hingna','date':'28 Feb','status':'pending','phone':'9988776655','age':'27','reason':'Child vaccination','notes':''},
    {'name':'Radha Tai','village':'Nagpur','date':'27 Feb','status':'completed','phone':'9123456780','age':'45','reason':'General checkup','notes':'Referred to PHC'},
    {'name':'Savita Bai','village':'Amravati','date':'26 Feb','status':'pending','phone':'9765432100','age':'30','reason':'Immunization','notes':''},
  ];
  final _searchC = TextEditingController();
  String _query = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _visits.where((v) {
        if (_filter != 'all' && v['status'] != _filter) return false;
        if (_query.isEmpty) return true;
        final q = _query.toLowerCase();
        return v['name']!.toLowerCase().contains(q) ||
            v['village']!.toLowerCase().contains(q) ||
            v['phone']!.contains(q) ||
            v['reason']!.toLowerCase().contains(q);
      }).toList();

  Future<void> _addVisit() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _HomeVisitDialog(),
    );
    if (result != null && mounted) {
      setState(() => _visits.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Container(color: kBg, child: Column(children: [
        PageHeader(title: td('homeVisits'), color: kBlue, icon: Icons.home_work_rounded,
            action: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _addVisit)),
        buildSearchBar(controller: _searchC, hint: 'Search by name, village, phone…', color: kBlue,
            onChanged: () => setState(() => _query = _searchC.text.trim())),
        buildFilterChips(current: _filter, color: kBlue, count: filtered.length,
            chips: [{'label': 'All', 'value': 'all'}, {'label': 'Pending', 'value': 'pending'}, {'label': 'Completed', 'value': 'completed'}],
            onTap: (v) => setState(() => _filter = v)),
        Expanded(
          child: filtered.isEmpty
              ? emptyState(_query)
              : ListView.separated(
                  padding: const EdgeInsets.all(16), itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final v = filtered[i];
                    final done = v['status'] == 'completed';
                    final oi = _visits.indexOf(v);
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          CircleAvatar(backgroundColor: kBlueLight,
                              child: Text(v['name']![0], style: const TextStyle(color: kBlue, fontWeight: FontWeight.w700))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(v['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('${v['village']} • ${v['date']}', style: const TextStyle(fontSize: 12, color: kMuted)),
                          ])),
                          GestureDetector(
                            onTap: () { if (oi >= 0) setState(() => _visits[oi]['status'] = done ? 'pending' : 'completed'); },
                            child: buildTag(done ? td('completed') : td('pending'), done ? kGreen : kOrange)),
                        ]),
                        if (v['phone']!.isNotEmpty || v['reason']!.isNotEmpty) ...[
                          const SizedBox(height: 10), const Divider(height: 1, color: kBorder), const SizedBox(height: 8),
                          Row(children: [
                            if (v['age']!.isNotEmpty) ...[const Icon(Icons.cake_outlined, size: 13, color: kMuted), const SizedBox(width: 4), Text('${v['age']} yrs', style: const TextStyle(fontSize: 11, color: kMuted)), const SizedBox(width: 12)],
                            if (v['phone']!.isNotEmpty) ...[const Icon(Icons.phone_outlined, size: 13, color: kMuted), const SizedBox(width: 4), Text(v['phone']!, style: const TextStyle(fontSize: 11, color: kMuted))],
                          ]),
                          if (v['reason']!.isNotEmpty) ...[const SizedBox(height: 4),
                            Row(children: [const Icon(Icons.info_outline_rounded, size: 13, color: kMuted), const SizedBox(width: 4),
                              Expanded(child: Text(v['reason']!, style: const TextStyle(fontSize: 11, color: kMuted)))])],
                          if (v['notes']!.isNotEmpty) ...[const SizedBox(height: 4),
                            Container(width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(8)),
                              child: Text(v['notes']!, style: const TextStyle(fontSize: 11, color: kBlue)))],
                        ],
                      ]),
                    );
                  },
                ),
        ),
      ])),
    );
  }
}

// ── Home Visit Dialog (Voice Enabled) ──
class _HomeVisitDialog extends StatefulWidget {
  const _HomeVisitDialog();
  @override
  State<_HomeVisitDialog> createState() => _HomeVisitDialogState();
}

class _HomeVisitDialogState extends State<_HomeVisitDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _ageC = TextEditingController();
  final _phoneC = TextEditingController();
  final _villageC = TextEditingController();
  final _reasonC = TextEditingController();
  final _notesC = TextEditingController();

  @override
  void initState() { super.initState(); initVoice(); }

  @override
  void dispose() { stopVoice(); _nameC.dispose(); _ageC.dispose(); _phoneC.dispose(); _villageC.dispose(); _reasonC.dispose(); _notesC.dispose(); super.dispose(); }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'village': _villageC.text.trim(),
      'phone': _phoneC.text.trim(), 'age': _ageC.text.trim(),
      'reason': _reasonC.text.trim(), 'notes': _notesC.text.trim(),
      'date': 'Today', 'status': 'pending',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _fk,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Row(children: [
                Container(padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.home_work_rounded, color: kBlue, size: 20)),
                const SizedBox(width: 10),
                const Expanded(child: Text('Add Home Visit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2332)))),
                GestureDetector(onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded, color: Colors.grey)),
              ]),
              const SizedBox(height: 16),

              // Lang bar + Listening banner
              buildLangBar(kBlue),
              const SizedBox(height: 10),
              buildListeningBanner(kBlue),

              // Fields
              sectionLabel('Patient Info', kBlue),
              voiceField(fieldKey: 'name', controller: _nameC, label: td('visitName'),
                  icon: Icons.person_outline, color: kBlue,
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Name required'; if (v.trim().length < 3) return 'Min 3 characters'; return null; }),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: voiceField(fieldKey: 'age', controller: _ageC, label: td('age'),
                    icon: Icons.cake_outlined, color: kBlue,
                    keyboard: TextInputType.number, maxLen: 3,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) { if (v == null || v.trim().isEmpty) return 'Age required'; final a = int.tryParse(v.trim()); if (a == null || a < 1 || a > 120) return '1-120'; return null; })),
                const SizedBox(width: 10),
                Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: td('visitPhone'),
                    icon: Icons.phone_outlined, color: kBlue,
                    keyboard: TextInputType.phone, maxLen: 10,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) { if (v == null || v.trim().isEmpty) return 'Phone required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return '10 digits, 6-9'; return null; })),
              ]),
              const SizedBox(height: 10),
              voiceField(fieldKey: 'village', controller: _villageC, label: td('village'),
                  icon: Icons.location_on_outlined, color: kBlue,
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Village required'; return null; }),
              const SizedBox(height: 14),

              sectionLabel('Visit Details', kBlue),
              voiceField(fieldKey: 'reason', controller: _reasonC, label: td('visitReason'),
                  icon: Icons.help_outline, color: kBlue,
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Reason required'; return null; }),
              const SizedBox(height: 10),
              voiceField(fieldKey: 'notes', controller: _notesC, label: td('visitNotes'),
                  icon: Icons.notes_rounded, color: kBlue),
              const SizedBox(height: 16),

              // Info hint
              Container(padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(10)),
                  child: const Row(children: [
                    Icon(Icons.mic_rounded, color: kBlue, size: 14),
                    SizedBox(width: 6),
                    Expanded(child: Text('🎤 Mic button dabao aur bol do — automatic fill hoga',
                        style: TextStyle(fontSize: 11, color: kBlue))),
                  ])),
              const SizedBox(height: 16),

              // Buttons
              Row(children: [
                Expanded(child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(foregroundColor: kBlue, side: const BorderSide(color: kBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13)),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(backgroundColor: kBlue, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13)),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700)))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  NOTE: PregnantPage has been moved to pages_maternal.dart
//  which contains the full 8-sub-tab implementation.
// ══════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════
//  4. VACCINATION PAGE
// ══════════════════════════════════════════════════════════
class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});
  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  final List<Map<String, String>> _list = [
    {'name':'Rahul Kumar','age':'6 months','next':'OPV','status':'due','mother':'Sunita Kumar','phone':'9800001111','dob':'28 Aug 2024'},
    {'name':'Sneha Patil','age':'12 months','next':'MMR','status':'overdue','mother':'Priya Patil','phone':'9800002222','dob':'28 Feb 2024'},
    {'name':'Arjun Singh','age':'2 months','next':'BCG','status':'uptodate','mother':'Meera Singh','phone':'9800003333','dob':'28 Dec 2024'},
  ];
  final _searchC = TextEditingController();
  String _query = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
        if (_filter != 'all' && c['status'] != _filter) return false;
        if (_query.isEmpty) return true;
        final q = _query.toLowerCase();
        return c['name']!.toLowerCase().contains(q) ||
            c['mother']!.toLowerCase().contains(q) ||
            c['phone']!.contains(q);
      }).toList();

  Future<void> _addChild() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _VaccinationDialog(),
    );
    if (result != null && mounted) {
      setState(() => _list.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Container(color: kBg, child: Column(children: [
        PageHeader(title: td('vaccination'), color: kTeal, icon: Icons.vaccines_rounded,
            action: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _addChild)),
        buildSearchBar(controller: _searchC, hint: 'Search by child name, mother, phone…', color: kTeal,
            onChanged: () => setState(() => _query = _searchC.text.trim())),
        buildFilterChips(current: _filter, color: kTeal, count: filtered.length,
            chips: [{'label': 'All', 'value': 'all'}, {'label': 'Due', 'value': 'due'}, {'label': 'Overdue', 'value': 'overdue'}, {'label': 'Done', 'value': 'uptodate'}],
            onTap: (v) => setState(() => _filter = v)),
        Expanded(
          child: filtered.isEmpty
              ? emptyState(_query)
              : ListView.separated(
                  padding: const EdgeInsets.all(16), itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final color = c['status'] == 'overdue' ? kRed : c['status'] == 'due' ? kOrange : kGreen;
                    final label = c['status'] == 'overdue' ? td('overdue') : c['status'] == 'due' ? td('nextVaccine') : td('upToDate');
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                      child: Row(children: [
                        CircleAvatar(backgroundColor: kTealLight,
                            child: const Icon(Icons.child_care_rounded, color: kTeal, size: 20)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text('${td('age')}: ${c['age']}', style: const TextStyle(fontSize: 12, color: kMuted)),
                          const SizedBox(height: 4),
                          buildTag('${td('nextVaccine')}: ${c['next']}', kTeal),
                        ])),
                        buildTag(label, color),
                      ]),
                    );
                  },
                ),
        ),
      ])),
    );
  }
}

// ── Vaccination Dialog (Voice Enabled) ──
class _VaccinationDialog extends StatefulWidget {
  const _VaccinationDialog();
  @override
  State<_VaccinationDialog> createState() => _VaccinationDialogState();
}

class _VaccinationDialogState extends State<_VaccinationDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _dobC = TextEditingController();
  final _motherC = TextEditingController();
  final _phoneC = TextEditingController();

  @override
  void initState() { super.initState(); initVoice(); }

  @override
  void dispose() { stopVoice(); _nameC.dispose(); _dobC.dispose(); _motherC.dispose(); _phoneC.dispose(); super.dispose(); }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'mother': _motherC.text.trim(),
      'phone': _phoneC.text.trim(), 'dob': _dobC.text.trim(),
      'age': 'Newborn', 'next': 'BCG', 'status': 'due',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _fk,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: kTealLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.child_care_rounded, color: kTeal, size: 20)),
                const SizedBox(width: 10),
                const Expanded(child: Text('Add Child', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2332)))),
                GestureDetector(onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded, color: Colors.grey)),
              ]),
              const SizedBox(height: 16),

              buildLangBar(kTeal),
              const SizedBox(height: 10),
              buildListeningBanner(kTeal),

              sectionLabel('Child Info', kTeal),
              voiceField(fieldKey: 'name', controller: _nameC, label: td('name'),
                  icon: Icons.child_care_rounded, color: kTeal,
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Name required'; return null; }),
              const SizedBox(height: 10),
              voiceField(fieldKey: 'dob', controller: _dobC, label: td('birthDate'),
                  icon: Icons.cake_outlined, color: kTeal,
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'DOB required'; return null; }),
              const SizedBox(height: 14),

              sectionLabel('Parent Info', kTeal),
              voiceField(fieldKey: 'mother', controller: _motherC, label: td('motherName'),
                  icon: Icons.person_outline, color: kTeal,
                  validator: (v) { if (v == null || v.trim().isEmpty) return "Mother's name required"; return null; }),
              const SizedBox(height: 10),
              voiceField(fieldKey: 'phone', controller: _phoneC, label: td('phone'),
                  icon: Icons.phone_outlined, color: kTeal,
                  keyboard: TextInputType.phone, maxLen: 10,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Phone required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return '10 digits, 6-9'; return null; }),
              const SizedBox(height: 16),

              Container(padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: kTealLight, borderRadius: BorderRadius.circular(10)),
                  child: const Row(children: [
                    Icon(Icons.mic_rounded, color: kTeal, size: 14),
                    SizedBox(width: 6),
                    Expanded(child: Text('🎤 Mic button dabao aur bol do — automatic fill hoga',
                        style: TextStyle(fontSize: 11, color: kTeal))),
                  ])),
              const SizedBox(height: 16),

              Row(children: [
                Expanded(child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(foregroundColor: kTeal, side: const BorderSide(color: kTeal),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13)),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(backgroundColor: kTeal, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13)),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700)))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}