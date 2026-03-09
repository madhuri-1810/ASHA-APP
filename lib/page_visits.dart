import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'pages_dashboard.dart';
import 'voice_mixin.dart';

// ══════════════════════════════════════════════════════════
//  HOME VISITS PAGE  (Tab index: 1)
// ══════════════════════════════════════════════════════════
class HomeVisitsPage extends StatefulWidget {
  const HomeVisitsPage({super.key});
  @override
  State<HomeVisitsPage> createState() => _HomeVisitsPageState();
}

class _HomeVisitsPageState extends State<HomeVisitsPage> {
  final List<Map<String, String>> _visits = [
    {'name': 'Sunita Devi',  'village': 'Wardha',   'date': '28 Feb', 'status': 'completed', 'phone': '9876543210', 'age': '32', 'reason': 'ANC Follow-up',    'notes': 'BP normal'},
    {'name': 'Meena Bai',    'village': 'Hingna',   'date': '28 Feb', 'status': 'pending',   'phone': '9988776655', 'age': '27', 'reason': 'Child vaccination', 'notes': ''},
    {'name': 'Radha Tai',    'village': 'Nagpur',   'date': '27 Feb', 'status': 'completed', 'phone': '9123456780', 'age': '45', 'reason': 'General checkup',   'notes': 'Referred to PHC'},
    {'name': 'Savita Bai',   'village': 'Amravati', 'date': '26 Feb', 'status': 'pending',   'phone': '9765432100', 'age': '30', 'reason': 'Immunization',      'notes': ''},
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
      builder: (_) => const HomeVisitDialog(),
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
        PageHeader(
          title: td('homeVisits'),
          color: kBlue,
          icon: Icons.home_work_rounded,
          action: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _addVisit),
        ),
        buildSearchBar(
          controller: _searchC,
          hint: 'Search by name, village, phone…',
          color: kBlue,
          onChanged: () => setState(() => _query = _searchC.text.trim()),
        ),
        buildFilterChips(
          current: _filter,
          color: kBlue,
          count: filtered.length,
          chips: [
            {'label': 'All',       'value': 'all'},
            {'label': 'Pending',   'value': 'pending'},
            {'label': 'Completed', 'value': 'completed'},
          ],
          onTap: (v) => setState(() => _filter = v),
        ),
        Expanded(
          child: filtered.isEmpty
              ? emptyState(_query)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final v = filtered[i];
                    final done = v['status'] == 'completed';
                    final oi = _visits.indexOf(v);
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          CircleAvatar(
                              backgroundColor: kBlueLight,
                              child: Text(v['name']![0],
                                  style: const TextStyle(color: kBlue, fontWeight: FontWeight.w700))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(v['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              Text('${v['village']} • ${v['date']}',
                                  style: const TextStyle(fontSize: 12, color: kMuted)),
                            ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (oi >= 0) {
                                setState(() => _visits[oi]['status'] =
                                    done ? 'pending' : 'completed');
                              }
                            },
                            child: buildTag(
                                done ? td('completed') : td('pending'),
                                done ? kGreen : kOrange),
                          ),
                        ]),
                        if (v['phone']!.isNotEmpty || v['reason']!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Divider(height: 1, color: kBorder),
                          const SizedBox(height: 8),
                          Row(children: [
                            if (v['age']!.isNotEmpty) ...[
                              const Icon(Icons.cake_outlined, size: 13, color: kMuted),
                              const SizedBox(width: 4),
                              Text('${v['age']} yrs', style: const TextStyle(fontSize: 11, color: kMuted)),
                              const SizedBox(width: 12),
                            ],
                            if (v['phone']!.isNotEmpty) ...[
                              const Icon(Icons.phone_outlined, size: 13, color: kMuted),
                              const SizedBox(width: 4),
                              Text(v['phone']!, style: const TextStyle(fontSize: 11, color: kMuted)),
                            ],
                          ]),
                          if (v['reason']!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.info_outline_rounded, size: 13, color: kMuted),
                              const SizedBox(width: 4),
                              Expanded(child: Text(v['reason']!, style: const TextStyle(fontSize: 11, color: kMuted))),
                            ]),
                          ],
                          if (v['notes']!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(8)),
                              child: Text(v['notes']!, style: const TextStyle(fontSize: 11, color: kBlue)),
                            ),
                          ],
                        ],
                      ]),
                    );
                  },
                ),
        ),
      ]));
  }
}

// ══════════════════════════════════════════════════════════
//  HOME VISIT DIALOG (Voice Enabled)
// ══════════════════════════════════════════════════════════
class HomeVisitDialog extends StatefulWidget {
  const HomeVisitDialog({super.key});
  @override
  State<HomeVisitDialog> createState() => _HomeVisitDialogState();
}

class _HomeVisitDialogState extends State<HomeVisitDialog> with VoiceDialogMixin {
  final _fk       = GlobalKey<FormState>();
  final _nameC    = TextEditingController();
  final _ageC     = TextEditingController();
  final _phoneC   = TextEditingController();
  final _villageC = TextEditingController();
  final _reasonC  = TextEditingController();
  final _notesC   = TextEditingController();

  @override
  void initState() { super.initState(); initVoice(); }

  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _ageC.dispose(); _phoneC.dispose();
    _villageC.dispose(); _reasonC.dispose(); _notesC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name':    _nameC.text.trim(),
      'village': _villageC.text.trim(),
      'phone':   _phoneC.text.trim(),
      'age':     _ageC.text.trim(),
      'reason':  _reasonC.text.trim(),
      'notes':   _notesC.text.trim(),
      'date':    'Today',
      'status':  'pending',
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
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.home_work_rounded, color: kBlue, size: 20)),
                const SizedBox(width: 10),
                const Expanded(
                    child: Text('Add Home Visit',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2332)))),
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded, color: Colors.grey)),
              ]),
              const SizedBox(height: 16),

              buildLangBar(kBlue),
              const SizedBox(height: 10),
              buildListeningBanner(kBlue),

              sectionLabel('Patient Info', kBlue),
              voiceField(
                fieldKey: 'name', controller: _nameC,
                label: td('visitName'), icon: Icons.person_outline, color: kBlue,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name required';
                  if (v.trim().length < 3) return 'Min 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: voiceField(
                  fieldKey: 'age', controller: _ageC,
                  label: td('age'), icon: Icons.cake_outlined, color: kBlue,
                  keyboard: TextInputType.number, maxLen: 3,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Age required';
                    final a = int.tryParse(v.trim());
                    if (a == null || a < 1 || a > 120) return '1–120';
                    return null;
                  },
                )),
                const SizedBox(width: 10),
                Expanded(child: voiceField(
                  fieldKey: 'phone', controller: _phoneC,
                  label: td('visitPhone'), icon: Icons.phone_outlined, color: kBlue,
                  keyboard: TextInputType.phone, maxLen: 10,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Phone required';
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return '10 digits, 6–9';
                    return null;
                  },
                )),
              ]),
              const SizedBox(height: 10),
              voiceField(
                fieldKey: 'village', controller: _villageC,
                label: td('village'), icon: Icons.location_on_outlined, color: kBlue,
                validator: (v) { if (v == null || v.trim().isEmpty) return 'Village required'; return null; },
              ),
              const SizedBox(height: 14),

              sectionLabel('Visit Details', kBlue),
              voiceField(
                fieldKey: 'reason', controller: _reasonC,
                label: td('visitReason'), icon: Icons.help_outline, color: kBlue,
                validator: (v) { if (v == null || v.trim().isEmpty) return 'Reason required'; return null; },
              ),
              const SizedBox(height: 10),
              voiceField(
                fieldKey: 'notes', controller: _notesC,
                label: td('visitNotes'), icon: Icons.notes_rounded, color: kBlue,
              ),
              const SizedBox(height: 16),

              buildMicHint(kBlue, kBlueLight),
              const SizedBox(height: 16),
              buildDialogButtons(ctx: context, color: kBlue, onSave: _save),
            ]),
          ),
        ),
      ),
    );
  }
}