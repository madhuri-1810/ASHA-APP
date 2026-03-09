// page_child_health.dart — बाल आरोग्य (Child Health) — 8 sub-tabs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'asha_dashboard.dart';
import 'voice_mixin.dart';

// ══════════════════════════════════════════════════════════
//  COLORS
// ══════════════════════════════════════════════════════════
const kChildBlue    = Color(0xFF1565C0);
const kChildGreen   = Color(0xFF2E7D32);
const kChildOrange  = Color(0xFFE65100);
const kChildPurple  = Color(0xFF6A1B9A);
const kChildTeal    = Color(0xFF00695C);
const kChildRed     = Color(0xFFC62828);
const kChildAmber   = Color(0xFFF57F17);
const kChildIndigo  = Color(0xFF283593);

// ══════════════════════════════════════════════════════════
//  TRANSLATIONS
// ══════════════════════════════════════════════════════════
const Map<String, Map<String, String>> _ch = {
  'childHealth':     {'mr': 'बाल आरोग्य',              'hi': 'बाल स्वास्थ्य',           'en': 'Child Health'},
  'newbornReg':      {'mr': 'नवजात बालक नोंद',          'hi': 'नवजात शिशु नोंद',         'en': 'Newborn Registration'},
  'birthReg':        {'mr': 'जन्म नोंद',                'hi': 'जन्म पंजीकरण',            'en': 'Birth Registration'},
  'deathReg':        {'mr': 'बाल मृत्यू नोंद',           'hi': 'बाल मृत्यु नोंद',         'en': 'Child Death Record'},
  'hbnc':            {'mr': 'HBNC भेट',                 'hi': 'HBNC विजिट',              'en': 'HBNC Visit'},
  'childList':       {'mr': '0-5 वर्ष बालक यादी',       'hi': '0-5 वर्ष बच्चों की सूची', 'en': '0-5 Yr Children List'},
  'malnutrition':    {'mr': 'कुपोषित बालक माहिती',       'hi': 'कुपोषित बच्चों की जानकारी','en': 'Malnourished Children'},
  'weightRecord':    {'mr': 'बालकांचे वजन नोंद',         'hi': 'बच्चों का वजन नोंद',      'en': 'Child Weight Record'},
  'illnessMgmt':     {'mr': 'बालक आजार व्यवस्थापन',      'hi': 'बाल रोग प्रबंधन',         'en': 'Illness Management'},
  'childName':       {'mr': 'बालकाचे नाव',               'hi': 'बच्चे का नाम',            'en': 'Child Name'},
  'motherName':      {'mr': 'आईचे नाव',                  'hi': 'माँ का नाम',              'en': "Mother's Name"},
  'fatherName':      {'mr': 'वडिलांचे नाव',              'hi': 'पिता का नाम',             'en': "Father's Name"},
  'dob':             {'mr': 'जन्म तारीख',                'hi': 'जन्म तिथि',               'en': 'Date of Birth'},
  'phone':           {'mr': 'फोन',                      'hi': 'फ़ोन',                     'en': 'Phone'},
  'village':         {'mr': 'गाव',                      'hi': 'गांव',                    'en': 'Village'},
  'gender':          {'mr': 'लिंग',                     'hi': 'लिंग',                    'en': 'Gender'},
  'weight':          {'mr': 'वजन (किलो)',                'hi': 'वजन (किलो)',               'en': 'Weight (kg)'},
  'age':             {'mr': 'वय',                       'hi': 'उम्र',                    'en': 'Age'},
  'male':            {'mr': 'मुलगा',                    'hi': 'लड़का',                    'en': 'Boy'},
  'female':          {'mr': 'मुलगी',                    'hi': 'लड़की',                    'en': 'Girl'},
  'normal':          {'mr': 'सामान्य',                  'hi': 'सामान्य',                 'en': 'Normal'},
  'sam':             {'mr': 'SAM',                      'hi': 'SAM',                     'en': 'SAM'},
  'mam':             {'mr': 'MAM',                      'hi': 'MAM',                     'en': 'MAM'},
  'registered':      {'mr': 'नोंदणी झाली',              'hi': 'पंजीकृत',                 'en': 'Registered'},
  'pending':         {'mr': 'प्रलंबित',                 'hi': 'बाकी',                    'en': 'Pending'},
  'completed':       {'mr': 'पूर्ण',                    'hi': 'पूर्ण',                   'en': 'Completed'},
  'visitNo':         {'mr': 'भेट क्र.',                 'hi': 'विजिट नं.',               'en': 'Visit No.'},
  'visitDate':       {'mr': 'भेट तारीख',                'hi': 'विजिट तिथि',              'en': 'Visit Date'},
  'illness':         {'mr': 'आजार',                     'hi': 'बीमारी',                  'en': 'Illness'},
  'treatment':       {'mr': 'उपचार',                    'hi': 'उपचार',                   'en': 'Treatment'},
  'referred':        {'mr': 'संदर्भित',                 'hi': 'रेफर किया',               'en': 'Referred'},
  'certNo':          {'mr': 'प्रमाणपत्र क्र.',          'hi': 'प्रमाण पत्र नं.',         'en': 'Certificate No.'},
  'deathDate':       {'mr': 'मृत्यू तारीख',             'hi': 'मृत्यु तिथि',             'en': 'Death Date'},
  'deathCause':      {'mr': 'मृत्यूचे कारण',            'hi': 'मृत्यु कारण',             'en': 'Cause of Death'},
  'addRecord':       {'mr': '+ नोंद जोडा',              'hi': '+ रिकॉर्ड जोड़ें',        'en': '+ Add Record'},
  'sendWA':          {'mr': 'WhatsApp पाठवा',           'hi': 'WhatsApp भेजें',          'en': 'Send WhatsApp'},
  'search':          {'mr': 'शोधा...',                  'hi': 'खोजें...',                'en': 'Search...'},
  'total':           {'mr': 'एकूण',                     'hi': 'कुल',                     'en': 'Total'},
  'done':            {'mr': 'झाले',                     'hi': 'पूर्ण',                   'en': 'Done'},
  'due':             {'mr': 'बाकी',                     'hi': 'बाकी',                    'en': 'Due'},
  'all':             {'mr': 'सर्व',                     'hi': 'सभी',                     'en': 'All'},
};

String _t(String k) {
  final lang = langNotifier.value;
  return _ch[k]?[lang] ?? _ch[k]?['en'] ?? k;
}

// ══════════════════════════════════════════════════════════
//  SUB-TAB DESCRIPTOR
// ══════════════════════════════════════════════════════════
class _CT {
  final IconData icon;
  final String labelKey;
  final Color color;
  const _CT(this.icon, this.labelKey, this.color);
}

// ══════════════════════════════════════════════════════════
//  MAIN PAGE — bilkul Mahila jaisa
// ══════════════════════════════════════════════════════════
class ChildHealthPage extends StatefulWidget {
  const ChildHealthPage({super.key});
  @override
  State<ChildHealthPage> createState() => _ChildHealthPageState();
}

class _ChildHealthPageState extends State<ChildHealthPage> {
  int _sel = 0;
  final _scrollC = ScrollController();

  static const _tabs = [
    _CT(Icons.child_friendly_rounded,    'newbornReg',   kChildBlue),
    _CT(Icons.article_outlined,          'birthReg',     kChildGreen),
    _CT(Icons.heart_broken_outlined,     'deathReg',     kChildRed),
    _CT(Icons.home_work_rounded,         'hbnc',         kChildTeal),
    _CT(Icons.people_alt_rounded,        'childList',    kChildIndigo),
    _CT(Icons.monitor_weight_outlined,   'malnutrition', kChildOrange),
    _CT(Icons.scale_rounded,             'weightRecord', kChildAmber),
    _CT(Icons.medical_services_outlined, 'illnessMgmt',  kChildPurple),
  ];

  void _selectTab(int i) {
    setState(() => _sel = i);
    // Auto-scroll so selected tab is visible
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollC.hasClients) {
        final offset = (i * 130.0) - 60;
        _scrollC.animateTo(
          offset.clamp(0.0, _scrollC.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() { _scrollC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Container(color: kBg, child: Column(children: [
        // ── Gradient Header ──
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
              16, MediaQuery.of(context).padding.top + 16, 16, 14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kChildBlue, Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.child_care_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_t('childHealth'),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none,
                        color: Colors.white)),
                const Text('बाल आरोग्य / Child Health',
                    style: TextStyle(fontSize: 11, color: Colors.white70, decoration: TextDecoration.none)),
              ]),
            ),
            const MiniLangBar(),
          ]),
        ),

        // ── Pill Sub-tabs ──
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollC,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final active = _sel == i;
                return GestureDetector(
                  onTap: () => _selectTab(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? tab.color : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active ? tab.color : Colors.grey.shade300),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(tab.icon,
                          size: 15,
                          color: active ? Colors.white : tab.color),
                      const SizedBox(width: 6),
                      Text(_t(tab.labelKey),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                              color: active ? Colors.white : tab.color)),
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),

        // ── Tab Content ──
        Expanded(child: _page(_sel)),
      ])),
    );
  }

  Widget _page(int i) {
    switch (i) {
      case 0: return const _NewbornTab();
      case 1: return const _BirthRegTab();
      case 2: return const _DeathRegTab();
      case 3: return const _HbncTab();
      case 4: return const _ChildListTab();
      case 5: return const _MalnutritionTab();
      case 6: return const _WeightTab();
      case 7: return const _IllnessTab();
      default: return const _NewbornTab();
    }
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ══════════════════════════════════════════════════════════
Widget _statsBar(List<Map<String, dynamic>> stats) => Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: stats.map((s) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: (s['color'] as Color).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: [
              Text(s['value'].toString(),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: s['color'] as Color, decoration: TextDecoration.none)),
              const SizedBox(height: 2),
              Text(s['label'].toString(),
                  style: const TextStyle(fontSize: 9.5, color: kMuted, decoration: TextDecoration.none),
                  textAlign: TextAlign.center),
            ]),
          ),
        )).toList(),
      ),
    );

Widget _searchBar(TextEditingController c, Color color, VoidCallback onChange) =>
    Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Row(children: [
        Icon(Icons.search_rounded, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: c,
            onChanged: (_) => onChange(),
            style: const TextStyle(fontSize: 13, decoration: TextDecoration.none),
            decoration: InputDecoration(
              hintText: _t('search'),
              hintStyle: const TextStyle(color: kMuted, fontSize: 12, decoration: TextDecoration.none),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        if (c.text.isNotEmpty)
          GestureDetector(
            onTap: () { c.clear(); onChange(); },
            child: Icon(Icons.close_rounded, color: kMuted, size: 16),
          ),
      ]),
    );

Widget _filterBar(String cur, Color color, List<String> filters,
        int count, void Function(String) onTap) =>
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(children: [
        ...filters.map((f) => GestureDetector(
          onTap: () => onTap(f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: cur == f ? color : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cur == f ? color : Colors.grey.shade300),
            ),
            child: Text(f,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cur == f ? Colors.white : kMuted, decoration: TextDecoration.none)),
          ),
        )),
        const Spacer(),
        Text('$count records',
            style: const TextStyle(fontSize: 10.5, color: kMuted, decoration: TextDecoration.none)),
      ]),
    );

Widget _addBtn(Color color, String label, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(label),
          style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      ),
    );

// ══════════════════════════════════════════════════════════
//  TAB 1 — नवजात बालक नोंद (Newborn Registration)
// ══════════════════════════════════════════════════════════
class _NewbornTab extends StatefulWidget {
  const _NewbornTab();
  @override State<_NewbornTab> createState() => _NewbornTabState();
}

class _NewbornTabState extends State<_NewbornTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Rohan Sharma',   'mother': 'Kavita Sharma', 'father': 'Suresh Sharma', 'dob': '01 Mar 2025', 'gender': 'male',   'weight': '3.1', 'village': 'Wardha',  'phone': '9876500001', 'status': 'registered'},
    {'name': 'Ananya Patil',   'mother': 'Priya Patil',   'father': 'Ajay Patil',   'dob': '15 Feb 2025', 'gender': 'female', 'weight': '2.8', 'village': 'Nagpur',  'phone': '9876500002', 'status': 'pending'},
    {'name': 'Aryan Singh',    'mother': 'Meera Singh',   'father': 'Ravi Singh',   'dob': '10 Jan 2025', 'gender': 'male',   'weight': '3.4', 'village': 'Hingna',  'phone': '9876500003', 'status': 'registered'},
  ];
  final _sc = TextEditingController();
  String _q = '', _filter = _t('all');

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != _t('all') && c['status'] != _filter.toLowerCase() &&
        !(_filter == _t('registered') && c['status'] == 'registered') &&
        !(_filter == _t('pending') && c['status'] == 'pending')) return false;
    if (_q.isEmpty) return true;
    final q = _q.toLowerCase();
    return c['name']!.toLowerCase().contains(q) ||
        c['mother']!.toLowerCase().contains(q) ||
        c['village']!.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                              'label': _t('total'),     'color': kChildBlue},
        {'value': _list.where((c) => c['status']=='registered').length,     'label': _t('registered'),'color': kChildGreen},
        {'value': _list.where((c) => c['status']=='pending').length,        'label': _t('pending'),   'color': kChildOrange},
      ]),
      _searchBar(_sc, kChildBlue, () => setState(() => _q = _sc.text.trim())),
      _filterBar(_filter, kChildBlue,
          [_t('all'), _t('registered'), _t('pending')],
          list.length, (f) => setState(() => _filter = f)),
      Expanded(
        child: list.isEmpty
            ? _empty()
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: list.length,
                itemBuilder: (_, i) => _NewbornCard(item: list[i]),
              ),
      ),
      _addBtn(kChildBlue, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _NewbornDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

class _NewbornCard extends StatefulWidget {
  final Map<String, String> item;
  const _NewbornCard({required this.item});
  @override State<_NewbornCard> createState() => _NewbornCardState();
}

class _NewbornCardState extends State<_NewbornCard> {
  bool _exp = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.item;
    final isReg = c['status'] == 'registered';
    final color = isReg ? kChildGreen : kChildOrange;
    return GestureDetector(
      onTap: () => setState(() => _exp = !_exp),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isReg ? null : Border.all(color: kChildOrange.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: kChildBlue.withOpacity(0.1),
              child: Icon(
                  c['gender'] == 'male' ? Icons.boy_rounded : Icons.girl_rounded,
                  color: kChildBlue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
              Text('${_t('dob')}: ${c['dob']}  •  ${c['village']}',
                  style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            ])),
            buildTag(isReg ? _t('registered') : _t('pending'), color),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: _exp ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded, color: kMuted, size: 20),
            ),
          ]),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 10),
              const Divider(height: 1, color: kBorder),
              const SizedBox(height: 10),
              _detail(Icons.person_outline, '${_t('motherName')}: ${c['mother']}'),
              _detail(Icons.person_outline, '${_t('fatherName')}: ${c['father']}'),
              _detail(Icons.monitor_weight_outlined, '${_t('weight')}: ${c['weight']} kg'),
              _detail(Icons.phone_outlined, c['phone']!),
              const SizedBox(height: 8),
              _waBtn(c['phone']!, c['name']!),
            ]),
            crossFadeState: _exp ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ]),
      ),
    );
  }

  Widget _detail(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [
      Icon(icon, size: 13, color: kMuted),
      const SizedBox(width: 6),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, color: kText, decoration: TextDecoration.none))),
    ]),
  );

  Widget _waBtn(String phone, String name) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => launchUrl(Uri.parse('https://wa.me/91$phone')),
      icon: const Icon(Icons.message_rounded, size: 14),
      label: Text(_t('sendWA')),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 8)),
    ),
  );
}

// ── Dialog ──
class _NewbornDialog extends StatefulWidget {
  const _NewbornDialog();
  @override State<_NewbornDialog> createState() => _NewbornDialogState();
}

class _NewbornDialogState extends State<_NewbornDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _motherC = TextEditingController(),
      _fatherC = TextEditingController(), _phoneC = TextEditingController(),
      _villageC = TextEditingController(), _weightC = TextEditingController(),
      _dobC = TextEditingController();
  String _gender = 'male';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _motherC, _fatherC, _phoneC, _villageC, _weightC, _dobC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'mother': _motherC.text.trim(),
      'father': _fatherC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(), 'weight': _weightC.text.trim(),
      'dob': _dobC.text.trim(), 'gender': _gender, 'status': 'pending',
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('newbornReg'), Icons.child_friendly_rounded, kChildBlue, context),
        const SizedBox(height: 14),
        buildLangBar(kChildBlue),
        const SizedBox(height: 8),
        buildListeningBanner(kChildBlue),
        sectionLabel(_t('childName'), kChildBlue),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildBlue,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'dob', controller: _dobC, label: _t('dob'),
              icon: Icons.calendar_today_outlined, color: kChildBlue,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: _t('weight'),
              icon: Icons.monitor_weight_outlined, color: kChildBlue,
              keyboard: TextInputType.number,
              formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Gender
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildBlue.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.wc_rounded, color: kChildBlue, size: 16),
            const SizedBox(width: 8),
            Text(_t('gender'), style: TextStyle(color: kChildBlue, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['male', _t('male')], ['female', _t('female')]].map((g) =>
              GestureDetector(
                onTap: () => setState(() => _gender = g[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _gender == g[0] ? kChildBlue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gender == g[0] ? kChildBlue : Colors.grey.shade300),
                  ),
                  child: Text(g[1], style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: _gender == g[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'mother', controller: _motherC, label: _t('motherName'),
            icon: Icons.woman_rounded, color: kChildBlue,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'father', controller: _fatherC, label: _t('fatherName'),
            icon: Icons.man_rounded, color: kChildBlue,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _t('phone'),
              icon: Icons.phone_outlined, color: kChildBlue,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => !RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim()) ? '10 digits' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
              icon: Icons.location_on_outlined, color: kChildBlue,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 14),
        buildMicHint(kChildBlue, kChildBlue.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildBlue, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  TAB 2 — जन्म नोंद (Birth Registration)
// ══════════════════════════════════════════════════════════
class _BirthRegTab extends StatefulWidget {
  const _BirthRegTab();
  @override State<_BirthRegTab> createState() => _BirthRegTabState();
}

class _BirthRegTabState extends State<_BirthRegTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Rohan Sharma',  'dob': '01 Mar 2025', 'gender': 'male',   'father': 'Suresh Sharma', 'village': 'Wardha',  'certNo': 'BR-WD-2025-001', 'status': 'registered'},
    {'name': 'Ananya Patil',  'dob': '15 Feb 2025', 'gender': 'female', 'father': 'Ajay Patil',   'village': 'Nagpur',  'certNo': '',               'status': 'pending'},
  ];
  final _sc = TextEditingController();
  String _q = '', _filter = _t('all');

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != _t('all')) {
      if (_filter == _t('registered') && c['status'] != 'registered') return false;
      if (_filter == _t('pending') && c['status'] != 'pending') return false;
    }
    if (_q.isEmpty) return true;
    return c['name']!.toLowerCase().contains(_q.toLowerCase()) ||
        c['village']!.toLowerCase().contains(_q.toLowerCase());
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                             'label': _t('total'),      'color': kChildGreen},
        {'value': _list.where((c) => c['status']=='registered').length,    'label': _t('registered'), 'color': kChildBlue},
        {'value': _list.where((c) => c['status']=='pending').length,       'label': _t('pending'),    'color': kChildOrange},
      ]),
      _searchBar(_sc, kChildGreen, () => setState(() => _q = _sc.text.trim())),
      _filterBar(_filter, kChildGreen,
          [_t('all'), _t('registered'), _t('pending')],
          list.length, (f) => setState(() => _filter = f)),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            final isReg = c['status'] == 'registered';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: kChildGreen.withOpacity(0.1),
                  child: Icon(c['gender'] == 'male' ? Icons.boy_rounded : Icons.girl_rounded,
                      color: kChildGreen, size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                  Text('${c['dob']}  •  ${c['village']}',
                      style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  if (c['certNo']!.isNotEmpty)
                    Text('${_t('certNo')}: ${c['certNo']}',
                        style: const TextStyle(fontSize: 10.5, color: kChildGreen, decoration: TextDecoration.none)),
                ])),
                buildTag(isReg ? _t('registered') : _t('pending'),
                    isReg ? kChildGreen : kChildOrange),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildGreen, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _BirthRegDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 3 — बाल मृत्यू नोंद (Child Death Record)
// ══════════════════════════════════════════════════════════
class _DeathRegTab extends StatefulWidget {
  const _DeathRegTab();
  @override State<_DeathRegTab> createState() => _DeathRegTabState();
}

class _DeathRegTabState extends State<_DeathRegTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Baby Gaikwad', 'age': '2 months', 'gender': 'male', 'deathDate': '10 Jan 2025', 'cause': 'Pneumonia', 'village': 'Wardha', 'father': 'Raju Gaikwad', 'phone': '9876500011'},
  ];
  final _sc = TextEditingController();
  String _q = '';

  List<Map<String, String>> get _filtered => _q.isEmpty ? _list :
      _list.where((c) => c['name']!.toLowerCase().contains(_q.toLowerCase()) ||
          c['village']!.toLowerCase().contains(_q.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length, 'label': _t('total'),  'color': kChildRed},
        {'value': _list.where((c) => c['cause'] == 'Pneumonia').length, 'label': 'Pneumonia', 'color': kChildOrange},
        {'value': _list.where((c) => int.tryParse(c['age']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '99') != null && (c['age']?.contains('month') ?? false) && (int.tryParse(c['age']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0) <= 1).length, 'label': '≤1 month', 'color': kChildPurple},
      ]),
      _searchBar(_sc, kChildRed, () => setState(() => _q = _sc.text.trim())),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text('${list.length} records',
            style: const TextStyle(fontSize: 10.5, color: kMuted, decoration: TextDecoration.none)),
      ),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kChildRed.withOpacity(0.15)),
                  boxShadow: [BoxShadow(color: kChildRed.withOpacity(0.06), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(
                    backgroundColor: kChildRed.withOpacity(0.1),
                    child: const Icon(Icons.child_care_rounded, color: kChildRed, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('${c['age']}  •  ${c['village']}',
                        style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(_t('deathReg'), kChildRed),
                ]),
                const SizedBox(height: 8),
                const Divider(height: 1, color: kBorder),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 12, color: kMuted),
                  const SizedBox(width: 4),
                  Text('${_t('deathDate')}: ${c['deathDate']}',
                      style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  const SizedBox(width: 12),
                  const Icon(Icons.info_outline, size: 12, color: kMuted),
                  const SizedBox(width: 4),
                  Text(c['cause']!, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                ]),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildRed, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _DeathRegDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 4 — HBNC भेट
// ══════════════════════════════════════════════════════════
class _HbncTab extends StatefulWidget {
  const _HbncTab();
  @override State<_HbncTab> createState() => _HbncTabState();
}

class _HbncTabState extends State<_HbncTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Rohan Sharma',  'mother': 'Kavita Sharma', 'village': 'Wardha',  'visit': '3', 'lastVisit': '05 Mar 2025', 'nextVisit': '12 Mar 2025', 'status': 'completed', 'phone': '9876500001'},
    {'name': 'Ananya Patil',  'mother': 'Priya Patil',   'village': 'Nagpur',  'visit': '1', 'lastVisit': '16 Feb 2025', 'nextVisit': '01 Mar 2025', 'status': 'pending',   'phone': '9876500002'},
    {'name': 'Aryan Singh',   'mother': 'Meera Singh',   'village': 'Hingna',  'visit': '6', 'lastVisit': '20 Jan 2025', 'nextVisit': 'Complete',    'status': 'completed', 'phone': '9876500003'},
  ];
  final _sc = TextEditingController();
  String _q = '', _filter = _t('all');

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != _t('all')) {
      if (_filter == _t('completed') && c['status'] != 'completed') return false;
      if (_filter == _t('pending') && c['status'] != 'pending') return false;
    }
    if (_q.isEmpty) return true;
    return c['name']!.toLowerCase().contains(_q.toLowerCase()) ||
        c['mother']!.toLowerCase().contains(_q.toLowerCase());
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                              'label': _t('total'),     'color': kChildTeal},
        {'value': _list.where((c) => c['status']=='completed').length,      'label': _t('done'),      'color': kChildGreen},
        {'value': _list.where((c) => c['status']=='pending').length,        'label': _t('pending'),   'color': kChildOrange},
      ]),
      _searchBar(_sc, kChildTeal, () => setState(() => _q = _sc.text.trim())),
      _filterBar(_filter, kChildTeal,
          [_t('all'), _t('completed'), _t('pending')],
          list.length, (f) => setState(() => _filter = f)),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            final done = c['status'] == 'completed';
            final visits = int.tryParse(c['visit'] ?? '0') ?? 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(backgroundColor: kChildTeal.withOpacity(0.1),
                      child: const Icon(Icons.child_friendly_rounded, color: kChildTeal, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('${_t('motherName')}: ${c['mother']}  •  ${c['village']}',
                        style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(done ? _t('completed') : _t('pending'), done ? kChildGreen : kChildOrange),
                ]),
                const SizedBox(height: 10),
                // Visit progress bar
                Row(children: List.generate(7, (v) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    height: 6,
                    decoration: BoxDecoration(
                      color: v < visits ? kChildTeal : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ))),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${_t('visitNo')} $visits / 7',
                      style: const TextStyle(fontSize: 10.5, color: kChildTeal, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                  Text('${_t('visitDate')}: ${c['lastVisit']}',
                      style: const TextStyle(fontSize: 10.5, color: kMuted, decoration: TextDecoration.none)),
                ]),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildTeal, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _HbncDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 5 — 0-5 वर्ष बालक यादी
// ══════════════════════════════════════════════════════════
class _ChildListTab extends StatefulWidget {
  const _ChildListTab();
  @override State<_ChildListTab> createState() => _ChildListTabState();
}

class _ChildListTabState extends State<_ChildListTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Rahul Kumar',  'age': '6 months', 'gender': 'male',   'mother': 'Sunita Kumar',  'village': 'Wardha',  'weight': '6.2', 'phone': '9800001111', 'status': 'normal'},
    {'name': 'Sneha Patil',  'age': '1 year',   'gender': 'female', 'mother': 'Priya Patil',   'village': 'Nagpur',  'weight': '8.5', 'phone': '9800002222', 'status': 'normal'},
    {'name': 'Arjun Singh',  'age': '3 months', 'gender': 'male',   'mother': 'Meera Singh',   'village': 'Hingna',  'weight': '4.1', 'phone': '9800003333', 'status': 'mam'},
    {'name': 'Pooja Devi',   'age': '2 years',  'gender': 'female', 'mother': 'Kavita Devi',   'village': 'Wardha',  'weight': '9.8', 'phone': '9800004444', 'status': 'sam'},
    {'name': 'Vishal Rane',  'age': '4 years',  'gender': 'male',   'mother': 'Rekha Rane',    'village': 'Amravati','weight': '14.2','phone': '9800005555', 'status': 'normal'},
  ];
  final _sc = TextEditingController();
  String _q = '', _filter = _t('all');

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != _t('all') && c['status'] != _filter.toLowerCase() &&
        !(_filter == 'SAM' && c['status'] == 'sam') &&
        !(_filter == 'MAM' && c['status'] == 'mam') &&
        !(_filter == _t('normal') && c['status'] == 'normal')) return false;
    if (_q.isEmpty) return true;
    return c['name']!.toLowerCase().contains(_q.toLowerCase()) ||
        c['village']!.toLowerCase().contains(_q.toLowerCase());
  }).toList();

  Color _statusColor(String s) => s == 'sam' ? kChildRed : s == 'mam' ? kChildOrange : kChildGreen;
  String _statusLabel(String s) => s == 'sam' ? _t('sam') : s == 'mam' ? _t('mam') : _t('normal');

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                       'label': _t('total'),   'color': kChildIndigo},
        {'value': _list.where((c) => c['status']=='normal').length,   'label': _t('normal'),  'color': kChildGreen},
        {'value': _list.where((c) => c['status']=='mam').length,      'label': 'MAM',         'color': kChildOrange},
        {'value': _list.where((c) => c['status']=='sam').length,      'label': 'SAM',         'color': kChildRed},
      ]),
      _searchBar(_sc, kChildIndigo, () => setState(() => _q = _sc.text.trim())),
      _filterBar(_filter, kChildIndigo,
          [_t('all'), _t('normal'), 'MAM', 'SAM'],
          list.length, (f) => setState(() => _filter = f)),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            final color = _statusColor(c['status']!);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: c['status'] != 'normal' ? Border.all(color: color.withOpacity(0.3)) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: kChildIndigo.withOpacity(0.1),
                  child: Icon(c['gender'] == 'male' ? Icons.boy_rounded : Icons.girl_rounded,
                      color: kChildIndigo, size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                  Text('${c['age']}  •  ${c['village']}  •  ${c['weight']} kg',
                      style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  Text('${_t('motherName')}: ${c['mother']}',
                      style: const TextStyle(fontSize: 10.5, color: kMuted, decoration: TextDecoration.none)),
                ])),
                buildTag(_statusLabel(c['status']!), color),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildIndigo, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _ChildListDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 6 — कुपोषित बालक माहिती
// ══════════════════════════════════════════════════════════
class _MalnutritionTab extends StatefulWidget {
  const _MalnutritionTab();
  @override State<_MalnutritionTab> createState() => _MalnutritionTabState();
}

class _MalnutritionTabState extends State<_MalnutritionTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Arjun Singh', 'age': '3 months', 'weight': '4.1', 'mother': 'Meera Singh', 'village': 'Hingna',  'phone': '9800003333', 'grade': 'mam', 'referred': 'No',  'treatment': 'Poshana kit diya'},
    {'name': 'Pooja Devi',  'age': '2 years',  'weight': '9.8', 'mother': 'Kavita Devi', 'village': 'Wardha',  'phone': '9800004444', 'grade': 'sam', 'referred': 'Yes', 'treatment': 'PHC mein refer kiya'},
  ];
  final _sc = TextEditingController();
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final list = _q.isEmpty ? _list :
        _list.where((c) => c['name']!.toLowerCase().contains(_q.toLowerCase())).toList();
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                      'label': _t('total'), 'color': kChildOrange},
        {'value': _list.where((c) => c['grade']=='sam').length,      'label': 'SAM',       'color': kChildRed},
        {'value': _list.where((c) => c['grade']=='mam').length,      'label': 'MAM',       'color': kChildAmber},
        {'value': _list.where((c) => c['referred']=='Yes').length,   'label': 'Referred',  'color': kChildPurple},
      ]),
      _searchBar(_sc, kChildOrange, () => setState(() => _q = _sc.text.trim())),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            final isSam = c['grade'] == 'sam';
            final color = isSam ? kChildRed : kChildOrange;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.06), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(backgroundColor: color.withOpacity(0.1),
                      child: Icon(Icons.child_care_rounded, color: color, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('${c['age']}  •  ${c['weight']} kg  •  ${c['village']}',
                        style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(isSam ? 'SAM' : 'MAM', color),
                ]),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${_t('treatment')}: ${c['treatment']}',
                        style: const TextStyle(fontSize: 11.5, color: kText, decoration: TextDecoration.none)),
                    if (c['referred'] == 'Yes')
                      Text('✓ ${_t('referred')}',
                          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                  ]),
                ),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildOrange, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _MalnutritionDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 7 — बालकांचे वजन नोंद
// ══════════════════════════════════════════════════════════
class _WeightTab extends StatefulWidget {
  const _WeightTab();
  @override State<_WeightTab> createState() => _WeightTabState();
}

class _WeightTabState extends State<_WeightTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Rahul Kumar', 'age': '6 months', 'date': '01 Mar 2025', 'weight': '6.2', 'prev': '5.8', 'village': 'Wardha',  'status': 'normal'},
    {'name': 'Sneha Patil', 'age': '1 year',   'date': '01 Mar 2025', 'weight': '8.5', 'prev': '8.5', 'village': 'Nagpur',  'status': 'normal'},
    {'name': 'Arjun Singh', 'age': '3 months', 'date': '01 Mar 2025', 'weight': '4.1', 'prev': '4.4', 'village': 'Hingna',  'status': 'loss'},
    {'name': 'Pooja Devi',  'age': '2 years',  'date': '01 Mar 2025', 'weight': '9.8', 'prev': '9.4', 'village': 'Wardha',  'status': 'gain'},
  ];
  final _sc = TextEditingController();
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final list = _q.isEmpty ? _list :
        _list.where((c) => c['name']!.toLowerCase().contains(_q.toLowerCase())).toList();
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                    'label': _t('total'), 'color': kChildAmber},
        {'value': _list.where((c) => c['status']=='gain').length,  'label': 'Weight ↑',  'color': kChildGreen},
        {'value': _list.where((c) => c['status']=='loss').length,  'label': 'Weight ↓',  'color': kChildRed},
      ]),
      _searchBar(_sc, kChildAmber, () => setState(() => _q = _sc.text.trim())),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            final curr = double.tryParse(c['weight'] ?? '0') ?? 0;
            final prev = double.tryParse(c['prev'] ?? '0') ?? 0;
            final diff = curr - prev;
            final isGain = diff > 0;
            final isLoss = diff < 0;
            final color = isLoss ? kChildRed : isGain ? kChildGreen : kChildAmber;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.scale_rounded, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                  Text('${c['age']}  •  ${c['village']}  •  ${c['date']}',
                      style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${c['weight']} kg',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color, decoration: TextDecoration.none)),
                  Text('${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
                      style: TextStyle(fontSize: 10.5, color: color, decoration: TextDecoration.none)),
                ]),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildAmber, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _WeightDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 8 — बालक आजार व्यवस्थापन
// ══════════════════════════════════════════════════════════
class _IllnessTab extends StatefulWidget {
  const _IllnessTab();
  @override State<_IllnessTab> createState() => _IllnessTabState();
}

class _IllnessTabState extends State<_IllnessTab> {
  final List<Map<String, String>> _list = [
    {'name': 'Rahul Kumar', 'age': '6 months', 'illness': 'Fever & Cold',     'date': '28 Feb 2025', 'treatment': 'Paracetamol syrup', 'referred': 'No',  'village': 'Wardha',  'status': 'resolved', 'phone': '9800001111'},
    {'name': 'Pooja Devi',  'age': '2 years',  'illness': 'Diarrhea',          'date': '25 Feb 2025', 'treatment': 'ORS + Zinc',         'referred': 'No',  'village': 'Wardha',  'status': 'ongoing',  'phone': '9800004444'},
    {'name': 'Arjun Singh', 'age': '3 months', 'illness': 'Severe Pneumonia',  'date': '20 Feb 2025', 'treatment': 'Referred to PHC',    'referred': 'Yes', 'village': 'Hingna',  'status': 'referred', 'phone': '9800003333'},
  ];
  final _sc = TextEditingController();
  String _q = '', _filter = _t('all');

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != _t('all') && c['status'] != _filter.toLowerCase() &&
        !(_filter == _t('referred') && c['status'] == 'referred') &&
        !(_filter == _t('completed') && c['status'] == 'resolved')) return false;
    if (_q.isEmpty) return true;
    return c['name']!.toLowerCase().contains(_q.toLowerCase()) ||
        c['illness']!.toLowerCase().contains(_q.toLowerCase());
  }).toList();

  Color _stColor(String s) => s == 'referred' ? kChildPurple : s == 'resolved' ? kChildGreen : kChildOrange;

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      _statsBar([
        {'value': _list.length,                                       'label': _t('total'),     'color': kChildPurple},
        {'value': _list.where((c) => c['status']=='resolved').length, 'label': _t('completed'), 'color': kChildGreen},
        {'value': _list.where((c) => c['status']=='ongoing').length,  'label': 'Ongoing',       'color': kChildOrange},
        {'value': _list.where((c) => c['referred']=='Yes').length,    'label': 'Referred',      'color': kChildRed},
      ]),
      _searchBar(_sc, kChildPurple, () => setState(() => _q = _sc.text.trim())),
      _filterBar(_filter, kChildPurple,
          [_t('all'), _t('completed'), 'Ongoing', _t('referred')],
          list.length, (f) => setState(() => _filter = f)),
      Expanded(
        child: list.isEmpty ? _empty() : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final c = list[i];
            final color = _stColor(c['status']!);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(backgroundColor: color.withOpacity(0.1),
                      child: const Icon(Icons.medical_services_outlined, color: kChildPurple, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('${c['age']}  •  ${c['date']}',
                        style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(c['status']!, color),
                ]),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: kChildPurple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.sick_outlined, size: 13, color: kChildRed),
                      const SizedBox(width: 6),
                      Text('${_t('illness')}: ${c['illness']}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: kText, decoration: TextDecoration.none)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.healing_outlined, size: 13, color: kChildGreen),
                      const SizedBox(width: 6),
                      Expanded(child: Text('${_t('treatment')}: ${c['treatment']}',
                          style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none))),
                    ]),
                  ]),
                ),
              ]),
            );
          },
        ),
      ),
      _addBtn(kChildPurple, _t('addRecord'), () async {
        final r = await showDialog<Map<String, String>>(
          context: context,
          builder: (_) => const _IllnessDialog(),
        );
        if (r != null && mounted) setState(() => _list.insert(0, r));
      }),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════
Widget _empty() => Center(
  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
    const SizedBox(height: 12),
    Text('कोणताही डेटा नाही', style: TextStyle(color: Colors.grey.shade400, fontSize: 13, decoration: TextDecoration.none)),
  ]),
);

Widget _dialogHeader(String title, IconData icon, Color color, BuildContext context) =>
    Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kText, decoration: TextDecoration.none))),
      GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close_rounded, color: kMuted)),
    ]);

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 2: जन्म नोंद (Birth Registration)
// ══════════════════════════════════════════════════════════
class _BirthRegDialog extends StatefulWidget {
  const _BirthRegDialog();
  @override State<_BirthRegDialog> createState() => _BirthRegDialogState();
}

class _BirthRegDialogState extends State<_BirthRegDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _fatherC = TextEditingController(),
      _villageC = TextEditingController(), _certC = TextEditingController(),
      _dobC = TextEditingController();
  String _gender = 'male', _status = 'pending';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _fatherC, _villageC, _certC, _dobC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'father': _fatherC.text.trim(),
      'village': _villageC.text.trim(), 'certNo': _certC.text.trim(),
      'dob': _dobC.text.trim(), 'gender': _gender, 'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('birthReg'), Icons.article_outlined, kChildGreen, context),
        const SizedBox(height: 14),
        buildLangBar(kChildGreen),
        const SizedBox(height: 8),
        buildListeningBanner(kChildGreen),
        sectionLabel(_t('childName'), kChildGreen),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildGreen,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'dob', controller: _dobC, label: _t('dob'),
              icon: Icons.calendar_today_outlined, color: kChildGreen,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'certNo', controller: _certC, label: _t('certNo'),
              icon: Icons.tag_rounded, color: kChildGreen,
              validator: (v) => null)),
        ]),
        const SizedBox(height: 8),
        // Gender
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildGreen.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.wc_rounded, color: kChildGreen, size: 16),
            const SizedBox(width: 8),
            Text(_t('gender'), style: TextStyle(color: kChildGreen, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['male', _t('male')], ['female', _t('female')]].map((g) =>
              GestureDetector(
                onTap: () => setState(() => _gender = g[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _gender == g[0] ? kChildGreen : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gender == g[0] ? kChildGreen : Colors.grey.shade300),
                  ),
                  child: Text(g[1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: _gender == g[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'father', controller: _fatherC, label: _t('fatherName'),
            icon: Icons.man_rounded, color: kChildGreen,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
            icon: Icons.location_on_outlined, color: kChildGreen,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        // Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildGreen.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.assignment_turned_in_outlined, color: kChildGreen, size: 16),
            const SizedBox(width: 8),
            Text('Status', style: TextStyle(color: kChildGreen, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['registered', _t('registered')], ['pending', _t('pending')]].map((s) =>
              GestureDetector(
                onTap: () => setState(() => _status = s[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _status == s[0] ? kChildGreen : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _status == s[0] ? kChildGreen : Colors.grey.shade300),
                  ),
                  child: Text(s[1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: _status == s[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 14),
        buildMicHint(kChildGreen, kChildGreen.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildGreen, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 3: बाल मृत्यू नोंद (Child Death Record)
// ══════════════════════════════════════════════════════════
class _DeathRegDialog extends StatefulWidget {
  const _DeathRegDialog();
  @override State<_DeathRegDialog> createState() => _DeathRegDialogState();
}

class _DeathRegDialogState extends State<_DeathRegDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _fatherC = TextEditingController(),
      _villageC = TextEditingController(), _phoneC = TextEditingController(),
      _ageC = TextEditingController(), _causeC = TextEditingController(),
      _deathDateC = TextEditingController();
  String _gender = 'male';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _fatherC, _villageC, _phoneC, _ageC, _causeC, _deathDateC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'father': _fatherC.text.trim(),
      'village': _villageC.text.trim(), 'phone': _phoneC.text.trim(),
      'age': _ageC.text.trim(), 'cause': _causeC.text.trim(),
      'deathDate': _deathDateC.text.trim(), 'gender': _gender,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('deathReg'), Icons.heart_broken_outlined, kChildRed, context),
        const SizedBox(height: 14),
        buildLangBar(kChildRed),
        const SizedBox(height: 8),
        buildListeningBanner(kChildRed),
        sectionLabel(_t('childName'), kChildRed),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildRed,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'age', controller: _ageC, label: _t('age'),
              icon: Icons.cake_outlined, color: kChildRed,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'deathDate', controller: _deathDateC, label: _t('deathDate'),
              icon: Icons.calendar_today_outlined, color: kChildRed,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Gender
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildRed.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.wc_rounded, color: kChildRed, size: 16),
            const SizedBox(width: 8),
            Text(_t('gender'), style: TextStyle(color: kChildRed, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['male', _t('male')], ['female', _t('female')]].map((g) =>
              GestureDetector(
                onTap: () => setState(() => _gender = g[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _gender == g[0] ? kChildRed : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gender == g[0] ? kChildRed : Colors.grey.shade300),
                  ),
                  child: Text(g[1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: _gender == g[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'cause', controller: _causeC, label: _t('deathCause'),
            icon: Icons.info_outline, color: kChildRed,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'father', controller: _fatherC, label: _t('fatherName'),
            icon: Icons.man_rounded, color: kChildRed,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _t('phone'),
              icon: Icons.phone_outlined, color: kChildRed,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => !RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim()) ? '10 digits' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
              icon: Icons.location_on_outlined, color: kChildRed,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 14),
        buildMicHint(kChildRed, kChildRed.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildRed, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 4: HBNC भेट
// ══════════════════════════════════════════════════════════
class _HbncDialog extends StatefulWidget {
  const _HbncDialog();
  @override State<_HbncDialog> createState() => _HbncDialogState();
}

class _HbncDialogState extends State<_HbncDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _motherC = TextEditingController(),
      _villageC = TextEditingController(), _phoneC = TextEditingController(),
      _visitC = TextEditingController(), _lastVisitC = TextEditingController(),
      _nextVisitC = TextEditingController();
  String _status = 'pending';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _motherC, _villageC, _phoneC, _visitC, _lastVisitC, _nextVisitC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'mother': _motherC.text.trim(),
      'village': _villageC.text.trim(), 'phone': _phoneC.text.trim(),
      'visit': _visitC.text.trim().isEmpty ? '1' : _visitC.text.trim(),
      'lastVisit': _lastVisitC.text.trim(), 'nextVisit': _nextVisitC.text.trim(),
      'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('hbnc'), Icons.home_work_rounded, kChildTeal, context),
        const SizedBox(height: 14),
        buildLangBar(kChildTeal),
        const SizedBox(height: 8),
        buildListeningBanner(kChildTeal),
        sectionLabel(_t('childName'), kChildTeal),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_friendly_rounded, color: kChildTeal,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'mother', controller: _motherC, label: _t('motherName'),
            icon: Icons.woman_rounded, color: kChildTeal,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'lastVisit', controller: _lastVisitC, label: _t('visitDate'),
              icon: Icons.calendar_today_outlined, color: kChildTeal,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'visit', controller: _visitC, label: '${_t('visitNo')} (1-7)',
              icon: Icons.format_list_numbered_rounded, color: kChildTeal,
              keyboard: TextInputType.number, maxLen: 1,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => null)),
        ]),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'nextVisit', controller: _nextVisitC, label: 'Next Visit Date',
            icon: Icons.event_outlined, color: kChildTeal,
            validator: (v) => null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _t('phone'),
              icon: Icons.phone_outlined, color: kChildTeal,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => !RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim()) ? '10 digits' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
              icon: Icons.location_on_outlined, color: kChildTeal,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildTeal.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildTeal.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.check_circle_outline, color: kChildTeal, size: 16),
            const SizedBox(width: 8),
            Text('Status', style: TextStyle(color: kChildTeal, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['pending', _t('pending')], ['completed', _t('completed')]].map((s) =>
              GestureDetector(
                onTap: () => setState(() => _status = s[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _status == s[0] ? kChildTeal : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _status == s[0] ? kChildTeal : Colors.grey.shade300),
                  ),
                  child: Text(s[1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: _status == s[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 14),
        buildMicHint(kChildTeal, kChildTeal.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildTeal, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 5: 0-5 वर्ष बालक यादी
// ══════════════════════════════════════════════════════════
class _ChildListDialog extends StatefulWidget {
  const _ChildListDialog();
  @override State<_ChildListDialog> createState() => _ChildListDialogState();
}

class _ChildListDialogState extends State<_ChildListDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _motherC = TextEditingController(),
      _villageC = TextEditingController(), _phoneC = TextEditingController(),
      _ageC = TextEditingController(), _weightC = TextEditingController();
  String _gender = 'male', _status = 'normal';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _motherC, _villageC, _phoneC, _ageC, _weightC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'mother': _motherC.text.trim(),
      'village': _villageC.text.trim(), 'phone': _phoneC.text.trim(),
      'age': _ageC.text.trim(), 'weight': _weightC.text.trim(),
      'gender': _gender, 'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('childList'), Icons.people_alt_rounded, kChildIndigo, context),
        const SizedBox(height: 14),
        buildLangBar(kChildIndigo),
        const SizedBox(height: 8),
        buildListeningBanner(kChildIndigo),
        sectionLabel(_t('childName'), kChildIndigo),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildIndigo,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'age', controller: _ageC, label: _t('age'),
              icon: Icons.cake_outlined, color: kChildIndigo,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: _t('weight'),
              icon: Icons.monitor_weight_outlined, color: kChildIndigo,
              keyboard: TextInputType.number,
              formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Gender
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildIndigo.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildIndigo.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.wc_rounded, color: kChildIndigo, size: 16),
            const SizedBox(width: 8),
            Text(_t('gender'), style: TextStyle(color: kChildIndigo, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['male', _t('male')], ['female', _t('female')]].map((g) =>
              GestureDetector(
                onTap: () => setState(() => _gender = g[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _gender == g[0] ? kChildIndigo : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _gender == g[0] ? kChildIndigo : Colors.grey.shade300),
                  ),
                  child: Text(g[1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: _gender == g[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'mother', controller: _motherC, label: _t('motherName'),
            icon: Icons.woman_rounded, color: kChildIndigo,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _t('phone'),
              icon: Icons.phone_outlined, color: kChildIndigo,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => !RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim()) ? '10 digits' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
              icon: Icons.location_on_outlined, color: kChildIndigo,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Nutrition Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildIndigo.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildIndigo.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.monitor_weight_outlined, color: kChildIndigo, size: 16),
              const SizedBox(width: 8),
              Text('Nutrition Status', style: TextStyle(color: kChildIndigo, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              ...[['normal', _t('normal')], ['mam', 'MAM'], ['sam', 'SAM']].map((s) =>
                GestureDetector(
                  onTap: () => setState(() => _status = s[0]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _status == s[0] ? (s[0] == 'sam' ? kChildRed : s[0] == 'mam' ? kChildOrange : kChildGreen) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _status == s[0] ? (s[0] == 'sam' ? kChildRed : s[0] == 'mam' ? kChildOrange : kChildGreen) : Colors.grey.shade300),
                    ),
                    child: Text(s[1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: _status == s[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                  ),
                )),
            ]),
          ]),
        ),
        const SizedBox(height: 14),
        buildMicHint(kChildIndigo, kChildIndigo.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildIndigo, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 6: कुपोषित बालक माहिती
// ══════════════════════════════════════════════════════════
class _MalnutritionDialog extends StatefulWidget {
  const _MalnutritionDialog();
  @override State<_MalnutritionDialog> createState() => _MalnutritionDialogState();
}

class _MalnutritionDialogState extends State<_MalnutritionDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _motherC = TextEditingController(),
      _villageC = TextEditingController(), _phoneC = TextEditingController(),
      _ageC = TextEditingController(), _weightC = TextEditingController(),
      _treatmentC = TextEditingController();
  String _grade = 'mam', _referred = 'No';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _motherC, _villageC, _phoneC, _ageC, _weightC, _treatmentC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'mother': _motherC.text.trim(),
      'village': _villageC.text.trim(), 'phone': _phoneC.text.trim(),
      'age': _ageC.text.trim(), 'weight': _weightC.text.trim(),
      'treatment': _treatmentC.text.trim(), 'grade': _grade, 'referred': _referred,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('malnutrition'), Icons.monitor_weight_outlined, kChildOrange, context),
        const SizedBox(height: 14),
        buildLangBar(kChildOrange),
        const SizedBox(height: 8),
        buildListeningBanner(kChildOrange),
        sectionLabel(_t('childName'), kChildOrange),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildOrange,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'age', controller: _ageC, label: _t('age'),
              icon: Icons.cake_outlined, color: kChildOrange,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: _t('weight'),
              icon: Icons.monitor_weight_outlined, color: kChildOrange,
              keyboard: TextInputType.number,
              formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Grade: MAM / SAM
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildOrange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildOrange.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.warning_amber_rounded, color: kChildOrange, size: 16),
            const SizedBox(width: 8),
            Text('Grade', style: TextStyle(color: kChildOrange, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const SizedBox(width: 12),
            ...[['mam', 'MAM'], ['sam', 'SAM']].map((g) =>
              GestureDetector(
                onTap: () => setState(() => _grade = g[0]),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: _grade == g[0] ? (_grade == 'sam' ? kChildRed : kChildOrange) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _grade == g[0] ? (_grade == 'sam' ? kChildRed : kChildOrange) : Colors.grey.shade300),
                  ),
                  child: Text(g[1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: _grade == g[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                ),
              )),
          ]),
        ),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'treatment', controller: _treatmentC, label: _t('treatment'),
            icon: Icons.healing_outlined, color: kChildOrange,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'mother', controller: _motherC, label: _t('motherName'),
            icon: Icons.woman_rounded, color: kChildOrange,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _t('phone'),
              icon: Icons.phone_outlined, color: kChildOrange,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => !RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim()) ? '10 digits' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
              icon: Icons.location_on_outlined, color: kChildOrange,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Referred toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildOrange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildOrange.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.local_hospital_outlined, color: kChildOrange, size: 16),
            const SizedBox(width: 8),
            Text(_t('referred'), style: TextStyle(color: kChildOrange, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _referred = _referred == 'Yes' ? 'No' : 'Yes'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _referred == 'Yes' ? kChildGreen : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_referred == 'Yes' ? 'Yes ✓' : 'No',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: _referred == 'Yes' ? Colors.white : kMuted, decoration: TextDecoration.none)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        buildMicHint(kChildOrange, kChildOrange.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildOrange, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 7: बालकांचे वजन नोंद
// ══════════════════════════════════════════════════════════
class _WeightDialog extends StatefulWidget {
  const _WeightDialog();
  @override State<_WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<_WeightDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _villageC = TextEditingController(),
      _ageC = TextEditingController(), _weightC = TextEditingController(),
      _prevC = TextEditingController(), _dateC = TextEditingController();

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _villageC, _ageC, _weightC, _prevC, _dateC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final curr = double.tryParse(_weightC.text.trim()) ?? 0;
    final prev = double.tryParse(_prevC.text.trim()) ?? curr;
    final status = curr > prev ? 'gain' : curr < prev ? 'loss' : 'normal';
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'village': _villageC.text.trim(),
      'age': _ageC.text.trim(), 'weight': _weightC.text.trim(),
      'prev': _prevC.text.trim().isEmpty ? _weightC.text.trim() : _prevC.text.trim(),
      'date': _dateC.text.trim(), 'status': status,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('weightRecord'), Icons.scale_rounded, kChildAmber, context),
        const SizedBox(height: 14),
        buildLangBar(kChildAmber),
        const SizedBox(height: 8),
        buildListeningBanner(kChildAmber),
        sectionLabel(_t('childName'), kChildAmber),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildAmber,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'age', controller: _ageC, label: _t('age'),
              icon: Icons.cake_outlined, color: kChildAmber,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'date', controller: _dateC, label: _t('visitDate'),
              icon: Icons.calendar_today_outlined, color: kChildAmber,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: '${_t('weight')} (Current)',
              icon: Icons.scale_rounded, color: kChildAmber,
              keyboard: TextInputType.number,
              formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'prev', controller: _prevC, label: '${_t('weight')} (Previous)',
              icon: Icons.history_rounded, color: kChildAmber,
              keyboard: TextInputType.number,
              formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (v) => null)),
        ]),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
            icon: Icons.location_on_outlined, color: kChildAmber,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 14),
        buildMicHint(kChildAmber, kChildAmber.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildAmber, onSave: _save),
      ])),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG — TAB 8: बालक आजार व्यवस्थापन
// ══════════════════════════════════════════════════════════
class _IllnessDialog extends StatefulWidget {
  const _IllnessDialog();
  @override State<_IllnessDialog> createState() => _IllnessDialogState();
}

class _IllnessDialogState extends State<_IllnessDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(), _villageC = TextEditingController(),
      _ageC = TextEditingController(), _illnessC = TextEditingController(),
      _treatmentC = TextEditingController(), _dateC = TextEditingController(),
      _phoneC = TextEditingController();
  String _referred = 'No', _status = 'ongoing';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC, _villageC, _ageC, _illnessC, _treatmentC, _dateC, _phoneC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'village': _villageC.text.trim(),
      'age': _ageC.text.trim(), 'illness': _illnessC.text.trim(),
      'treatment': _treatmentC.text.trim(), 'date': _dateC.text.trim(),
      'phone': _phoneC.text.trim(), 'referred': _referred, 'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _fk, child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dialogHeader(_t('illnessMgmt'), Icons.medical_services_outlined, kChildPurple, context),
        const SizedBox(height: 14),
        buildLangBar(kChildPurple),
        const SizedBox(height: 8),
        buildListeningBanner(kChildPurple),
        sectionLabel(_t('childName'), kChildPurple),
        voiceField(fieldKey: 'name', controller: _nameC, label: _t('childName'),
            icon: Icons.child_care_rounded, color: kChildPurple,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'age', controller: _ageC, label: _t('age'),
              icon: Icons.cake_outlined, color: kChildPurple,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'date', controller: _dateC, label: _t('visitDate'),
              icon: Icons.calendar_today_outlined, color: kChildPurple,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'illness', controller: _illnessC, label: _t('illness'),
            icon: Icons.sick_outlined, color: kChildPurple,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        voiceField(fieldKey: 'treatment', controller: _treatmentC, label: _t('treatment'),
            icon: Icons.healing_outlined, color: kChildPurple,
            validator: (v) => v!.trim().isEmpty ? 'Required' : null),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _t('phone'),
              icon: Icons.phone_outlined, color: kChildPurple,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => !RegExp(r'^[6-9]\d{9}$').hasMatch(v!.trim()) ? '10 digits' : null)),
          const SizedBox(width: 10),
          Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _t('village'),
              icon: Icons.location_on_outlined, color: kChildPurple,
              validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
        ]),
        const SizedBox(height: 8),
        // Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildPurple.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.info_outline, color: kChildPurple, size: 16),
              const SizedBox(width: 8),
              Text('Status', style: TextStyle(color: kChildPurple, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              ...[['ongoing', 'Ongoing'], ['resolved', _t('completed')], ['referred', _t('referred')]].map((s) =>
                GestureDetector(
                  onTap: () => setState(() {
                    _status = s[0];
                    if (s[0] == 'referred') _referred = 'Yes';
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _status == s[0] ? kChildPurple : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _status == s[0] ? kChildPurple : Colors.grey.shade300),
                    ),
                    child: Text(s[1], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                        color: _status == s[0] ? Colors.white : kMuted, decoration: TextDecoration.none)),
                  ),
                )),
            ]),
          ]),
        ),
        const SizedBox(height: 8),
        // Referred toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: kChildPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kChildPurple.withOpacity(0.2))),
          child: Row(children: [
            Icon(Icons.local_hospital_outlined, color: kChildPurple, size: 16),
            const SizedBox(width: 8),
            Text(_t('referred'), style: TextStyle(color: kChildPurple, fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _referred = _referred == 'Yes' ? 'No' : 'Yes'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _referred == 'Yes' ? kChildGreen : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_referred == 'Yes' ? 'Yes ✓' : 'No',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: _referred == 'Yes' ? Colors.white : kMuted, decoration: TextDecoration.none)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        buildMicHint(kChildPurple, kChildPurple.withOpacity(0.07)),
        const SizedBox(height: 12),
        buildDialogButtons(ctx: context, color: kChildPurple, onSave: _save),
      ])),
    ),
  );
}