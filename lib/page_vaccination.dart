import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'pages_dashboard.dart';
import 'voice_mixin.dart';

// ══════════════════════════════════════════════════════════
//  VACCINATION PAGE — 5 Sub-tabs
//  1. बालक लसीकरण        (Child Vaccination)
//  2. गर्भवती लसीकरण      (Pregnant TT Vaccination)
//  3. VHND कार्यक्रम       (VHND Program)
//  4. UWIN नोंद           (UWIN Record)
//  5. अपेक्षित लाभार्थी    (Expected Beneficiaries)
// ══════════════════════════════════════════════════════════

// ── Local translation helper (3 languages) ──────────────
String _vt(String k) {
  const m = <String, Map<String, String>>{
    'childVacc':    {'en': 'Child Vaccination',       'hi': 'बालक टीकाकरण',        'mr': 'बालक लसीकरण'},
    'pregVacc':     {'en': 'Pregnant Vaccination',    'hi': 'गर्भवती टीकाकरण',     'mr': 'गर्भवती लसीकरण'},
    'vhnd':         {'en': 'VHND Program',            'hi': 'VHND कार्यक्रम',       'mr': 'VHND कार्यक्रम'},
    'uwin':         {'en': 'UWIN Record',             'hi': 'UWIN नोंद',            'mr': 'UWIN नोंद'},
    'expected':     {'en': 'Expected Beneficiaries',  'hi': 'अपेक्षित लाभार्थी',    'mr': 'अपेक्षित लाभार्थी'},
    'childName':    {'en': 'Child Name',              'hi': 'बच्चे का नाम',          'mr': 'मुलाचे नाव'},
    'dob':          {'en': 'Date of Birth',           'hi': 'जन्म तिथि',             'mr': 'जन्म तारीख'},
    'fatherName':   {'en': "Father's Name",           'hi': 'पिता का नाम',           'mr': 'वडिलांचे नाव'},
    'village':      {'en': 'Village / Area',          'hi': 'गांव / क्षेत्र',        'mr': 'गाव / क्षेत्र'},
    'weight':       {'en': 'Weight (kg)',             'hi': 'वजन (kg)',              'mr': 'वजन (kg)'},
    'vaccGiven':    {'en': 'Vaccine Given',           'hi': 'दिया गया टीका',         'mr': 'दिलेली लस'},
    'nextVacc':     {'en': 'Next Vaccine',            'hi': 'अगला टीका',             'mr': 'पुढील लस'},
    'nextDate':     {'en': 'Next Vaccine Date',       'hi': 'अगली टीका तिथि',        'mr': 'पुढील लस तारीख'},
    'uwinId':       {'en': 'UWIN ID',                 'hi': 'UWIN आईडी',             'mr': 'UWIN आयडी'},
    'aadhar':       {'en': 'Aadhar Number',           'hi': 'आधार नंबर',             'mr': 'आधार क्रमांक'},
    'sendWA':       {'en': 'Send WhatsApp',           'hi': 'WhatsApp भेजें',        'mr': 'WhatsApp पाठवा'},
    'ttDose':       {'en': 'TT Dose Given',           'hi': 'दिया गया TT डोज़',      'mr': 'दिलेला TT डोस'},
    'nextDose':     {'en': 'Next TT Dose',            'hi': 'अगला TT डोज़',          'mr': 'पुढील TT डोस'},
    'anc':          {'en': 'ANC Visit No.',           'hi': 'ANC विजिट नं.',         'mr': 'ANC भेट क्र.'},
    'edd':          {'en': 'Expected Delivery Date',  'hi': 'प्रसव तिथि',            'mr': 'प्रसूती तारीख'},
    'vhndDate':     {'en': 'VHND Date',               'hi': 'VHND तिथि',             'mr': 'VHND तारीख'},
    'vhndPlace':    {'en': 'VHND Location',           'hi': 'VHND स्थान',            'mr': 'VHND ठिकाण'},
    'awc':          {'en': 'Anganwadi Centre',        'hi': 'आंगनवाड़ी केंद्र',       'mr': 'अंगणवाडी केंद्र'},
    'childrens':    {'en': 'Children Count',          'hi': 'बच्चों की संख्या',       'mr': 'मुलांची संख्या'},
    'pregCount':    {'en': 'Pregnant Count',          'hi': 'गर्भवती संख्या',         'mr': 'गर्भवती संख्या'},
    'vaccinesGiven':{'en': 'Vaccines Given',          'hi': 'दिए गए टीके',            'mr': 'दिलेल्या लसी'},
    'remarks':      {'en': 'Remarks',                 'hi': 'टिप्पणी',               'mr': 'शेरा'},
    'gender':       {'en': 'Gender',                  'hi': 'लिंग',                  'mr': 'लिंग'},
    'male':         {'en': 'Male / Boy',              'hi': 'पुरुष / लड़का',          'mr': 'पुरुष / मुलगा'},
    'female':       {'en': 'Female / Girl',           'hi': 'महिला / लड़की',          'mr': 'महिला / मुलगी'},
    'due':          {'en': 'Due',                     'hi': 'बकाया',                 'mr': 'बाकी'},
    'overdue':      {'en': 'Overdue',                 'hi': 'अतिदेय',                'mr': 'थकबाकी'},
    'done':         {'en': 'Done',                    'hi': 'पूर्ण',                 'mr': 'झाले'},
    'all':          {'en': 'All',                     'hi': 'सभी',                   'mr': 'सर्व'},
    'totalChild':   {'en': 'Total',                   'hi': 'कुल',                   'mr': 'एकूण'},
    'vaccinated':   {'en': 'Done',                    'hi': 'पूर्ण',                 'mr': 'झाले'},
    'pending':      {'en': 'Pending',                 'hi': 'बाकी',                  'mr': 'प्रलंबित'},
    'upcoming':     {'en': 'Upcoming',                'hi': 'आने वाला',              'mr': 'येणारे'},
    'synced':       {'en': 'Synced',                  'hi': 'अपलोड हुआ',             'mr': 'अपलोड झाले'},
    'upload':       {'en': 'Upload to UWIN Portal',  'hi': 'UWIN पोर्टल पर अपलोड', 'mr': 'UWIN पोर्टलवर अपलोड'},
    'addRecord':    {'en': '+ Add Record',            'hi': '+ रिकॉर्ड जोड़ें',       'mr': '+ नोंद जोडा'},
    'addSession':   {'en': '+ Add VHND Session',      'hi': '+ VHND सत्र जोड़ें',     'mr': '+ VHND सत्र जोडा'},
    'addChild':     {'en': '+ Add Child',             'hi': '+ बच्चा जोड़ें',         'mr': '+ मूल जोडा'},
    'addPreg':      {'en': '+ Add Pregnant',          'hi': '+ गर्भवती जोड़ें',       'mr': '+ गर्भवती जोडा'},
    'vaccination2': {'en': 'Vaccination',             'hi': 'टीकाकरण',               'mr': 'लसीकरण'},
  };
  final lang = langNotifier.value;
  return m[k]?[lang] ?? m[k]?['en'] ?? k;
}

// ── WhatsApp sender ──────────────────────────────────────
Future<void> _sendWA(BuildContext ctx, String phone, String msg) async {
  final url = 'https://wa.me/91$phone?text=${Uri.encodeComponent(msg)}';
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: msg));
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: const Text('Message copied! WhatsApp pe paste karein'),
          backgroundColor: const Color(0xFF25D366),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }
}

// WhatsApp message builders — tri-lingual
String _childWAMsg(Map<String, String> c) {
  final lang = langNotifier.value;
  if (lang == 'mr') {
    return '🏥 *NHM लसीकरण स्मरणपत्र*\n\n'
        'प्रिय ${c['mother']} जी,\n\n'
        '👶 मुलाचे नाव: ${c['name']}\n'
        '💉 पुढील लस: ${c['nextVacc']}\n'
        '📅 तारीख: ${c['nextDate']}\n'
        '📍 जवळचे आरोग्य केंद्र / अंगणवाडी\n\n'
        'वेळेत लसीकरण करा — मूल निरोगी राहील! 🙏\n'
        '📞 ASHA वर्करशी संपर्क करा';
  } else if (lang == 'hi') {
    return '🏥 *NHM टीकाकरण अनुस्मारक*\n\n'
        'प्रिय ${c['mother']} जी,\n\n'
        '👶 बच्चे का नाम: ${c['name']}\n'
        '💉 अगला टीका: ${c['nextVacc']}\n'
        '📅 तिथि: ${c['nextDate']}\n'
        '📍 नजदीकी स्वास्थ्य केंद्र / आंगनवाड़ी\n\n'
        'समय पर टीका लगवाएं — बच्चा स्वस्थ रहेगा! 🙏\n'
        '📞 ASHA वर्कर से संपर्क करें';
  }
  return '🏥 *NHM Vaccination Reminder*\n\n'
      'Dear ${c['mother']},\n\n'
      '👶 Child: ${c['name']}\n'
      '💉 Next Vaccine: ${c['nextVacc']}\n'
      '📅 Date: ${c['nextDate']}\n'
      '📍 Nearest Health Centre / Anganwadi\n\n'
      'Timely vaccination keeps your child healthy! 🙏\n'
      '📞 Contact your ASHA Worker';
}

String _pregWAMsg(Map<String, String> p) {
  final lang = langNotifier.value;
  if (lang == 'mr') {
    return '🏥 *NHM TT लस स्मरणपत्र*\n\n'
        'प्रिय ${p['name']} जी,\n\n'
        '💉 पुढील TT डोस: ${p['nextDose']}\n'
        '📅 तारीख: ${p['nextDate']}\n'
        '🤱 प्रसूती तारीख: ${p['edd']}\n\n'
        'वेळेत TT लस घ्या — माता व बाळ सुरक्षित! 🙏';
  } else if (lang == 'hi') {
    return '🏥 *NHM TT टीका अनुस्मारक*\n\n'
        'प्रिय ${p['name']} जी,\n\n'
        '💉 अगला TT डोज़: ${p['nextDose']}\n'
        '📅 तिथि: ${p['nextDate']}\n'
        '🤱 प्रसव तिथि: ${p['edd']}\n\n'
        'समय पर TT लगवाएं — माँ और बच्चा सुरक्षित! 🙏';
  }
  return '🏥 *NHM TT Vaccination Reminder*\n\n'
      'Dear ${p['name']},\n\n'
      '💉 Next TT Dose: ${p['nextDose']}\n'
      '📅 Date: ${p['nextDate']}\n'
      '🤱 EDD: ${p['edd']}\n\n'
      'Get TT vaccine on time — safe mother, safe baby! 🙏';
}

String _expectedWAMsg(Map<String, String> b) {
  final lang = langNotifier.value;
  if (lang == 'mr') {
    return '🏥 *लसीकरण सूचना*\n\nप्रिय ${b['mother']} जी,\n\n'
        '${b['name']} च्या लसीकरणाची वेळ आली आहे.\n'
        '💉 लस: ${b['vaccine']}\n📅 तारीख: ${b['dueDate']}\n\nकृपया वेळेत या! 🙏';
  } else if (lang == 'hi') {
    return '🏥 *टीकाकरण सूचना*\n\nप्रिय ${b['mother']} जी,\n\n'
        '${b['name']} के टीकाकरण का समय आ गया है।\n'
        '💉 टीका: ${b['vaccine']}\n📅 तिथि: ${b['dueDate']}\n\nकृपया समय पर आएं! 🙏';
  }
  return '🏥 *Vaccination Due Notice*\n\nDear ${b['mother']},\n\n'
      '${b['name']} vaccination is due.\n'
      '💉 Vaccine: ${b['vaccine']}\n📅 Date: ${b['dueDate']}\n\nPlease come on time! 🙏';
}

// ══════════════════════════════════════════════════════════
//  MAIN PAGE  — Bilkul Mahila jaisa layout
// ══════════════════════════════════════════════════════════
class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});
  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  int _sel = 0;
  final ScrollController _tabScrollCtrl = ScrollController();
  static const double _kTabWidth = 147.0;

  @override
  void dispose() {
    _tabScrollCtrl.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    setState(() => _sel = i);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_tabScrollCtrl.hasClients) return;
      final offset = (i * _kTabWidth) - 12.0;
      _tabScrollCtrl.animateTo(
        offset.clamp(0.0, _tabScrollCtrl.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  static const _tabs = [
    _VT(Icons.child_care_rounded,     'childVacc', Color(0xFF0891B2)),
    _VT(Icons.pregnant_woman_rounded, 'pregVacc',  Color(0xFFDB2777)),
    _VT(Icons.groups_rounded,         'vhnd',      Color(0xFF7C3AED)),
    _VT(Icons.qr_code_rounded,        'uwin',      Color(0xFF1D4ED8)),
    _VT(Icons.people_alt_rounded,     'expected',  Color(0xFFD97706)),
  ];

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
              colors: [kTeal, Color(0xFF004D40)],
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
              child: const Icon(Icons.vaccines_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_vt('vaccination2'),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white, decoration: TextDecoration.none)),
                const Text('लसीकरण / Immunization',
                    style: TextStyle(fontSize: 11, color: Colors.white70, decoration: TextDecoration.none)),
              ]),
            ),
            const MiniLangBar(),
          ]),
        ),

        // ── Pill-style Sub-tabs (Mahila jaisa) ──
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _tabScrollCtrl,
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
                          color: active
                              ? tab.color
                              : Colors.grey.shade300),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(tab.icon,
                          size: 15,
                          color: active ? Colors.white : tab.color),
                      const SizedBox(width: 6),
                      Text(_vt(tab.labelKey),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : tab.color, decoration: TextDecoration.none)),
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
      case 0: return const _ChildVaccTab();
      case 1: return const _PregVaccTab();
      case 2: return const _VhndTab();
      case 3: return const _UwinTab();
      case 4: return const _ExpectedTab();
      default: return const _ChildVaccTab();
    }
  }
}

// ── Tab descriptor ──
class _VT {
  final IconData icon;
  final String labelKey;
  final Color color;
  const _VT(this.icon, this.labelKey, this.color);
}

// ══════════════════════════════════════════════════════════
//  TAB 1 — CHILD VACCINATION  (बालक लसीकरण)
// ══════════════════════════════════════════════════════════
class _ChildVaccTab extends StatefulWidget {
  const _ChildVaccTab();
  @override State<_ChildVaccTab> createState() => _ChildVaccTabState();
}

class _ChildVaccTabState extends State<_ChildVaccTab> {
  final List<Map<String, String>> _list = [
    {'name':'Rahul Kumar',  'dob':'28 Aug 2024','mother':'Sunita Kumar','father':'Vijay Kumar', 'phone':'9800001111','village':'Wardha',  'weight':'6.2','vaccGiven':'OPV-0, BCG, Hep-B',      'nextVacc':'OPV-1, Penta-1',         'nextDate':'28 Oct 2024','gender':'male',  'status':'due',     'uwinId':'UW2024001'},
    {'name':'Sneha Patil',  'dob':'28 Feb 2024','mother':'Priya Patil', 'father':'Ajay Patil',  'phone':'9800002222','village':'Nagpur',  'weight':'8.5','vaccGiven':'OPV-0,1, BCG, Penta-1,2','nextVacc':'MMR',                     'nextDate':'28 Feb 2025','gender':'female','status':'overdue', 'uwinId':'UW2024002'},
    {'name':'Arjun Singh',  'dob':'28 Dec 2024','mother':'Meera Singh', 'father':'Ravi Singh',  'phone':'9800003333','village':'Hingna',  'weight':'4.1','vaccGiven':'OPV-0, Hep-B',            'nextVacc':'BCG, OPV-1, Penta-1',    'nextDate':'28 Jan 2025','gender':'male',  'status':'done',    'uwinId':'UW2024003'},
  ];

  final _sc = TextEditingController();
  String _q = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != 'all' && c['status'] != _filter) return false;
    if (_q.isEmpty) return true;
    final q = _q.toLowerCase();
    return c['name']!.toLowerCase().contains(q) ||
        c['mother']!.toLowerCase().contains(q) ||
        c['village']!.toLowerCase().contains(q) ||
        c['phone']!.contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      // Stats
      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          _StatPill('${_list.length}',                                         _vt('totalChild'),  kTeal),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']=='done').length}',       _vt('vaccinated'),  kGreen),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']!='done').length}',       _vt('pending'),     kOrange),
        ]),
      ),
      buildSearchBar(controller: _sc, hint: 'Search child, mother, village…', color: kTeal,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _filter, color: kTeal, count: list.length,
          chips: [
            {'label': _vt('all'),     'value': 'all'},
            {'label': _vt('due'),     'value': 'due'},
            {'label': _vt('overdue'), 'value': 'overdue'},
            {'label': _vt('done'),    'value': 'done'},
          ],
          onTap: (v) => setState(() => _filter = v)),
      Expanded(
        child: list.isEmpty ? emptyState(_q) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            if (i == list.length) return _AddBtn(_vt('addChild'), kTeal, () => _addDialog(ctx));
            final c = list[i];
            final col = c['status']=='overdue' ? kRed : c['status']=='due' ? kOrange : kGreen;
            return _ChildCard(data: c, statusColor: col,
                onWA: () => _sendWA(ctx, c['phone']!, _childWAMsg(c)));
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _ChildDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

// ── Child Card (Expandable — tap karo details dekhne ke liye) ─────────────
class _ChildCard extends StatefulWidget {
  final Map<String, String> data;
  final Color statusColor;
  final VoidCallback onWA;
  const _ChildCard({required this.data, required this.statusColor, required this.onWA});

  @override
  State<_ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<_ChildCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final statusColor = widget.statusColor;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: c['status'] == 'overdue' ? Border.all(color: kRed.withOpacity(0.3)) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Row 1: avatar + name + status + expand arrow ──
          Row(children: [
            CircleAvatar(
                backgroundColor: kTealLight,
                child: Icon(c['gender'] == 'female' ? Icons.girl_rounded : Icons.boy_rounded,
                    color: kTeal, size: 20)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
              Text('DOB: ${c['dob']}  •  ${c['village']}  •  ⚖️ ${c['weight']} kg',
                  style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            ])),
            buildTag(
                c['status'] == 'overdue' ? _vt('overdue') : c['status'] == 'due' ? _vt('due') : _vt('done'),
                statusColor),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.keyboard_arrow_down_rounded, color: kMuted, size: 20),
            ),
          ]),

          // ── Expandable Details ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 10),
              const Divider(height: 1, color: kBorder),
              const SizedBox(height: 8),
              // Details info box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(10)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _IR(Icons.vaccines_rounded,       '${_vt('vaccGiven')}: ${c['vaccGiven']}',  kTeal),
                  const SizedBox(height: 4),
                  _IR(Icons.upcoming_rounded,       '${_vt('nextVacc')}: ${c['nextVacc']}',    kOrange),
                  const SizedBox(height: 4),
                  _IR(Icons.calendar_today_rounded, '${_vt('nextDate')}: ${c['nextDate']}',    kBlue),
                  const SizedBox(height: 4),
                  _IR(Icons.person_outline,
                      '${td('motherName')}: ${c['mother']}  •  ${_vt('fatherName')}: ${c['father']}',
                      kMuted),
                  if ((c['uwinId'] ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _IR(Icons.qr_code_rounded, 'UWIN ID: ${c['uwinId']}', const Color(0xFF6A1B9A)),
                  ],
                ]),
              ),
              const SizedBox(height: 8),
              // WhatsApp button
              Row(children: [
                Expanded(child: _WABtn(widget.onWA)),
              ]),
            ]),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 2 — PREGNANT VACCINATION  (गर्भवती लसीकरण)
// ══════════════════════════════════════════════════════════
class _PregVaccTab extends StatefulWidget {
  const _PregVaccTab();
  @override State<_PregVaccTab> createState() => _PregVaccTabState();
}

class _PregVaccTabState extends State<_PregVaccTab> {
  static const _pk = Color(0xFFD81B60);
  static const _pkl = Color(0xFFFCE4EC);

  final List<Map<String, String>> _list = [
    {'name':'Kavita Sharma','phone':'9876500001','village':'Wardha','anc':'2','edd':'Mar 2025','ttDone':'TT-1 Done', 'nextDose':'TT-2',   'nextDate':'15 Feb 2025','status':'due'},
    {'name':'Priya Patil',  'phone':'9876500002','village':'Nagpur','anc':'1','edd':'May 2025','ttDone':'Not Done',  'nextDose':'TT-1',   'nextDate':'20 Jan 2025','status':'overdue'},
    {'name':'Asha Devi',    'phone':'9876500003','village':'Hingna','anc':'3','edd':'Jul 2025','ttDone':'TT-1,2 Done','nextDose':'Booster','nextDate':'After delivery','status':'done'},
  ];

  final _sc = TextEditingController();
  String _q = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((p) {
    if (_filter != 'all' && p['status'] != _filter) return false;
    if (_q.isEmpty) return true;
    return p['name']!.toLowerCase().contains(_q.toLowerCase()) ||
        p['village']!.toLowerCase().contains(_q.toLowerCase()) ||
        p['phone']!.contains(_q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      buildSearchBar(controller: _sc, hint: 'Search pregnant women…', color: _pk,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _filter, color: _pk, count: list.length,
          chips: [
            {'label': _vt('all'),     'value': 'all'},
            {'label': _vt('due'),     'value': 'due'},
            {'label': _vt('overdue'), 'value': 'overdue'},
            {'label': _vt('done'),    'value': 'done'},
          ],
          onTap: (v) => setState(() => _filter = v)),
      Expanded(
        child: list.isEmpty ? emptyState(_q) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            if (i == list.length) return _AddBtn(_vt('addPreg'), _pk, () => _addDialog(ctx));
            final p = list[i];
            final col = p['status']=='overdue' ? kRed : p['status']=='due' ? kOrange : kGreen;
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(backgroundColor: _pkl, child: const Icon(Icons.pregnant_woman_rounded, color: _pk, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('${p['village']}  •  EDD: ${p['edd']}  •  ANC: ${p['anc']}',
                        style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(p['status']=='overdue' ? _vt('overdue') : p['status']=='due' ? _vt('due') : _vt('done'), col),
                ]),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _IR(Icons.vaccines_rounded,       '${_vt('ttDose')}: ${p['ttDone']}',          _pk),
                      const SizedBox(height: 4),
                      _IR(Icons.upcoming_rounded,       '${_vt('nextDose')}: ${p['nextDose']}  •  ${p['nextDate']}', kOrange),
                    ])),
                const SizedBox(height: 8),
                _WABtn(() => _sendWA(ctx, p['phone']!, _pregWAMsg(p))),
              ]),
            );
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _PregDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 3 — VHND PROGRAM  (VHND लसीकरण कार्यक्रम)
// ══════════════════════════════════════════════════════════
class _VhndTab extends StatefulWidget {
  const _VhndTab();
  @override State<_VhndTab> createState() => _VhndTabState();
}

class _VhndTabState extends State<_VhndTab> {
  static const _kb = Color(0xFF1565C0);
  static const _kbl = Color(0xFFE3F2FD);

  final List<Map<String, String>> _sessions = [
    {'date':'15 Jan 2025','place':'Wardha Anganwadi','awc':'AWC-WD-01','children':'12','pregnant':'4','vaccines':'OPV, BCG, Penta','remarks':'All smooth','status':'done'},
    {'date':'15 Feb 2025','place':'Hingna PHC',      'awc':'AWC-HN-03','children':'0', 'pregnant':'0','vaccines':'',               'remarks':'',          'status':'upcoming'},
    {'date':'15 Mar 2025','place':'Nagpur Sub-Centre','awc':'AWC-NG-07','children':'0','pregnant':'0','vaccines':'',               'remarks':'',          'status':'upcoming'},
  ];

  @override
  Widget build(BuildContext context) {
    return Material(color: kBg, child: Column(children: [
      // Header summary
      Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _kbl, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Icon(Icons.calendar_month_rounded, color: _kb, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('VHND Schedule', style: TextStyle(fontWeight: FontWeight.w800, color: _kb, fontSize: 14, decoration: TextDecoration.none)),
            Text('${_sessions.where((s)=>s['status']=='done').length} done  •  '
                '${_sessions.where((s)=>s['status']=='upcoming').length} upcoming',
                style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
          ])),
          ElevatedButton.icon(
            onPressed: () => _addDialog(context),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add'),
            style: ElevatedButton.styleFrom(backgroundColor: _kb, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
          ),
        ]),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: _sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final s = _sessions[i];
            final done = s['status'] == 'done';
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: done ? kGreen.withOpacity(0.3) : _kb.withOpacity(0.2)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: done ? kGreenLight : _kbl, borderRadius: BorderRadius.circular(10)),
                      child: Icon(done ? Icons.check_circle_rounded : Icons.upcoming_rounded,
                          color: done ? kGreen : _kb, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s['place']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.none)),
                    Text('${s['date']}  •  ${s['awc']}', style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(done ? _vt('done') : _vt('upcoming'), done ? kGreen : _kb),
                ]),
                if (done) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, children: [
                    buildTag('👶 ${s['children']} children', kTeal),
                    buildTag('🤱 ${s['pregnant']} pregnant', const Color(0xFFD81B60)),
                    if ((s['vaccines'] ?? '').isNotEmpty) buildTag('💉 ${s['vaccines']}', kBlue),
                  ]),
                  if ((s['remarks'] ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(s['remarks']!, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ],
                ],
              ]),
            );
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _VhndDialog());
    if (r != null && mounted) setState(() => _sessions.insert(0, r));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 4 — UWIN RECORD  (UWIN नोंद)
// ══════════════════════════════════════════════════════════
class _UwinTab extends StatefulWidget {
  const _UwinTab();
  @override State<_UwinTab> createState() => _UwinTabState();
}

class _UwinTabState extends State<_UwinTab> {
  static const _kp = Color(0xFF6A1B9A);
  static const _kpl = Color(0xFFF3E8FF);

  final List<Map<String, String>> _records = [
    {'uwinId':'UW2024001','childName':'Rahul Kumar', 'dob':'28 Aug 2024','mother':'Sunita Kumar','aadhar':'1234 5678 9012','phone':'9800001111','village':'Wardha',  'vaccines':'OPV-0, BCG, Hep-B',     'synced':'yes'},
    {'uwinId':'UW2024002','childName':'Sneha Patil', 'dob':'28 Feb 2024','mother':'Priya Patil', 'aadhar':'',             'phone':'9800002222','village':'Nagpur',  'vaccines':'OPV-0,1,2, BCG, Penta-2','synced':'yes'},
    {'uwinId':'',         'childName':'Baby Deshmukh','dob':'01 Jan 2025','mother':'Rita Deshmukh','aadhar':'',           'phone':'9800004444','village':'Amravati','vaccines':'OPV-0',                   'synced':'no'},
  ];

  @override
  Widget build(BuildContext context) {
    return Material(color: kBg, child: Column(children: [
      Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _kpl, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Icon(Icons.qr_code_rounded, color: _kp, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('UWIN — Universal Immunization', style: TextStyle(fontWeight: FontWeight.w800, color: _kp, fontSize: 13, decoration: TextDecoration.none)),
            Text('${_records.where((r)=>r['synced']=='yes').length} synced  •  '
                '${_records.where((r)=>r['synced']=='no').length} pending upload',
                style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
          ])),
          ElevatedButton.icon(
            onPressed: () => _addDialog(context),
            icon: const Icon(Icons.add, size: 16), label: const Text('Add'),
            style: ElevatedButton.styleFrom(backgroundColor: _kp, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
          ),
        ]),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: _records.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final r = _records[i];
            final ok = r['synced'] == 'yes';
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: _kpl, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.qr_code_2_rounded, color: _kp, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r['childName']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('DOB: ${r['dob']}  •  ${r['village']}', style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(ok ? '✓ ${_vt('synced')}' : '⏳ Pending', ok ? kGreen : kOrange),
                ]),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if ((r['uwinId']??'').isNotEmpty) _IR(Icons.badge_rounded,       'UWIN ID: ${r['uwinId']}',      _kp),
                      if ((r['aadhar']??'').isNotEmpty) ...[const SizedBox(height:4), _IR(Icons.credit_card_rounded,  'Aadhar: ${r['aadhar']}',       kMuted)],
                      const SizedBox(height: 4),
                      _IR(Icons.vaccines_rounded,  'Vaccines: ${r['vaccines']}',   kTeal),
                      const SizedBox(height: 4),
                      _IR(Icons.person_outline,    '${td('motherName')}: ${r['mother']}', kMuted),
                    ])),
                if (!ok) ...[
                  const SizedBox(height: 8),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(
                    onPressed: () => setState(() => _records[i]['synced'] = 'yes'),
                    icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                    label: Text(_vt('upload')),
                    style: ElevatedButton.styleFrom(backgroundColor: _kp, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                  )),
                ],
              ]),
            );
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _UwinDialog());
    if (r != null && mounted) setState(() => _records.insert(0, r));
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 5 — EXPECTED BENEFICIARIES  (अपेक्षित लाभार्थी)
// ══════════════════════════════════════════════════════════
class _ExpectedTab extends StatefulWidget {
  const _ExpectedTab();
  @override State<_ExpectedTab> createState() => _ExpectedTabState();
}

class _ExpectedTabState extends State<_ExpectedTab> {
  static const _ko = Color(0xFFE65100);
  static const _kol = Color(0xFFFFF3E0);

  final List<Map<String, String>> _list = [
    {'name':'Baby of Sunita','mother':'Sunita Rao',  'phone':'9876511111','village':'Wardha',  'vaccine':'BCG, OPV-0, Hep-B','dueDate':'28 Feb 2025','status':'upcoming'},
    {'name':'Baby of Rekha', 'mother':'Rekha Shinde','phone':'9876522222','village':'Nagpur',  'vaccine':'BCG, OPV-0',       'dueDate':'05 Mar 2025','status':'upcoming'},
    {'name':'Priya Jadhav',  'mother':'Sita Jadhav', 'phone':'9876533333','village':'Amravati','vaccine':'OPV-1, Penta-1',   'dueDate':'10 Jan 2025','status':'overdue'},
  ];

  @override
  Widget build(BuildContext context) {
    return Material(color: kBg, child: Column(children: [
      Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _kol, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Icon(Icons.people_alt_rounded, color: _ko, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Expected Beneficiaries', style: TextStyle(fontWeight: FontWeight.w800, color: _ko, fontSize: 13, decoration: TextDecoration.none)),
            Text('${_list.where((l)=>l['status']=='upcoming').length} upcoming  •  '
                '${_list.where((l)=>l['status']=='overdue').length} overdue',
                style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
          ])),
        ]),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: _list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final b = _list[i];
            final late = b['status'] == 'overdue';
            final col = late ? kRed : _ko;
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: late ? Border.all(color: kRed.withOpacity(0.3)) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(backgroundColor: _kol, child: Icon(Icons.child_friendly_rounded, color: _ko, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(b['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                    Text('${td('motherName')}: ${b['mother']}  •  ${b['village']}',
                        style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  buildTag(late ? '⚠️ ${_vt('overdue')}' : '📅 ${_vt('upcoming')}', col),
                ]),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _IR(Icons.vaccines_rounded,       '${_vt('nextVacc')}: ${b['vaccine']}',  _ko),
                      const SizedBox(height: 4),
                      _IR(Icons.calendar_today_rounded, 'Due Date: ${b['dueDate']}',             kBlue),
                    ])),
                const SizedBox(height: 8),
                _WABtn(() => _sendWA(ctx, b['phone']!, _expectedWAMsg(b))),
              ]),
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  DIALOG 1 — CHILD VACCINATION FORM
// ══════════════════════════════════════════════════════════
class _ChildDialog extends StatefulWidget {
  const _ChildDialog({super.key});
  @override State<_ChildDialog> createState() => _ChildDialogState();
}

class _ChildDialogState extends State<_ChildDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC = TextEditingController(); final _dobC  = TextEditingController();
  final _momC  = TextEditingController(); final _dadC  = TextEditingController();
  final _phC   = TextEditingController(); final _vilC  = TextEditingController();
  final _wtC   = TextEditingController(); final _vaccC = TextEditingController();
  final _nvcC  = TextEditingController(); final _ndC   = TextEditingController();
  final _uwinC = TextEditingController(); final _aadC  = TextEditingController();
  String _gender = 'male';

  static const _quickVacc = ['BCG','OPV-0','Hep-B','OPV-1','Penta-1','PCV-1','RVV-1','OPV-2','Penta-2','MR-1','DPT Booster','TT'];

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nameC,_dobC,_momC,_dadC,_phC,_vilC,_wtC,_vaccC,_nvcC,_ndC,_uwinC,_aadC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name':_nameC.text.trim(),'dob':_dobC.text.trim(),'mother':_momC.text.trim(),
      'father':_dadC.text.trim(),'phone':_phC.text.trim(),'village':_vilC.text.trim(),
      'weight':_wtC.text.trim(),'vaccGiven':_vaccC.text.trim(),'nextVacc':_nvcC.text.trim(),
      'nextDate':_ndC.text.trim(),'uwinId':_uwinC.text.trim(),'aadhar':_aadC.text.trim(),
      'gender':_gender,'status':'due',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key: _fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          _DHeader(icon: Icons.child_care_rounded, color: kTeal, colorLight: kTealLight,
              title: _vt('childVacc'), ctx: context),
          const SizedBox(height: 12),
          buildLangBar(kTeal), const SizedBox(height: 8),
          buildListeningBanner(kTeal),

          // ── Child Info ──
          sectionLabel('👶 Child Info', kTeal),
          voiceField(fieldKey:'name', controller:_nameC, label:_vt('childName'),
              icon:Icons.child_care_rounded, color:kTeal,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'dob', controller:_dobC, label:_vt('dob'),
              icon:Icons.cake_outlined, color:kTeal,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          // Gender selector
          Row(children:[
            Text('${_vt('gender')}: ', style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:kMuted, decoration: TextDecoration.none)),
            const SizedBox(width:8),
            _Chip(_vt('male'),   _gender=='male',   kTeal,  ()=>setState(()=>_gender='male')),
            const SizedBox(width:6),
            _Chip(_vt('female'), _gender=='female', const Color(0xFFD81B60), ()=>setState(()=>_gender='female')),
          ]),
          const SizedBox(height:8),
          voiceField(fieldKey:'weight', controller:_wtC, label:_vt('weight'),
              icon:Icons.monitor_weight_outlined, color:kTeal, keyboard:TextInputType.number),

          // ── Parent Info ──
          const SizedBox(height:10),
          sectionLabel('👨‍👩‍👦 Parent Info', kTeal),
          voiceField(fieldKey:'mom', controller:_momC, label:td('motherName'),
              icon:Icons.person_outline, color:kTeal,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'dad', controller:_dadC, label:_vt('fatherName'),
              icon:Icons.person_outline, color:kTeal),
          const SizedBox(height:8),
          voiceField(fieldKey:'ph', controller:_phC, label:td('phone'),
              icon:Icons.phone_outlined, color:kTeal,
              keyboard:TextInputType.phone, maxLen:10,
              formatters:[FilteringTextInputFormatter.digitsOnly],
              validator:(v){
                if(v==null||v.trim().isEmpty) return 'Required';
                if(!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return '10-digit valid number';
                return null;
              }),
          const SizedBox(height:8),
          voiceField(fieldKey:'vil', controller:_vilC, label:_vt('village'),
              icon:Icons.location_on_outlined, color:kTeal),

          // ── Vaccine Info ──
          const SizedBox(height:10),
          sectionLabel('💉 Vaccine Details', kTeal),
          voiceField(fieldKey:'vacc', controller:_vaccC, label:_vt('vaccGiven'),
              icon:Icons.vaccines_rounded, color:kTeal,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:6),
          // Quick-tap vaccine chips
          Wrap(spacing:6, runSpacing:4,
            children: _quickVacc.map((v) => GestureDetector(
              onTap: () => setState((){
                final cur = _vaccC.text.trim();
                _vaccC.text = cur.isEmpty ? v : '$cur, $v';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal:8,vertical:4),
                decoration: BoxDecoration(color:kTealLight, borderRadius:BorderRadius.circular(12)),
                child: Text(v, style:const TextStyle(fontSize:10,color:kTeal,fontWeight:FontWeight.w700, decoration: TextDecoration.none)),
              ),
            )).toList(),
          ),
          const SizedBox(height:8),
          voiceField(fieldKey:'nvc', controller:_nvcC, label:_vt('nextVacc'),
              icon:Icons.upcoming_rounded, color:kTeal,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'nd', controller:_ndC, label:_vt('nextDate'),
              icon:Icons.calendar_today_rounded, color:kTeal,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),

          // ── UWIN / Aadhar ──
          const SizedBox(height:10),
          sectionLabel('🪪 UWIN & Identity', kTeal),
          voiceField(fieldKey:'uwin', controller:_uwinC, label:_vt('uwinId'),
              icon:Icons.qr_code_rounded, color:kTeal),
          const SizedBox(height:8),
          voiceField(fieldKey:'aad', controller:_aadC, label:_vt('aadhar'),
              icon:Icons.credit_card_rounded, color:kTeal,
              keyboard:TextInputType.number, maxLen:14,
              formatters:[FilteringTextInputFormatter.digitsOnly]),

          const SizedBox(height:14),
          buildMicHint(kTeal, kTealLight),
          const SizedBox(height:14),
          buildDialogButtons(ctx:context, color:kTeal, onSave:_save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  DIALOG 2 — PREGNANT TT FORM
// ══════════════════════════════════════════════════════════
class _PregDialog extends StatefulWidget {
  const _PregDialog({super.key});
  @override State<_PregDialog> createState() => _PregDialogState();
}

class _PregDialogState extends State<_PregDialog> with VoiceDialogMixin {
  static const _pk  = Color(0xFFD81B60);
  static const _pkl = Color(0xFFFCE4EC);
  final _fk   = GlobalKey<FormState>();
  final _nmC  = TextEditingController(); final _phC  = TextEditingController();
  final _vlC  = TextEditingController(); final _eddC = TextEditingController();
  final _ancC = TextEditingController(); final _ndC  = TextEditingController();
  final _rmC  = TextEditingController();
  String _tt = 'TT-1';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_nmC,_phC,_vlC,_eddC,_ancC,_ndC,_rmC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name':_nmC.text.trim(),'phone':_phC.text.trim(),'village':_vlC.text.trim(),
      'edd':_eddC.text.trim(),'anc':_ancC.text.trim(),
      'ttDone':'$_tt Done',
      'nextDose':_tt=='TT-1'?'TT-2':'Booster',
      'nextDate':_ndC.text.trim(),
      'status':'due',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key:_fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DHeader(icon:Icons.pregnant_woman_rounded, color:_pk, colorLight:_pkl,
              title:_vt('pregVacc'), ctx:context),
          const SizedBox(height:12),
          buildLangBar(_pk), const SizedBox(height:8),
          buildListeningBanner(_pk),

          sectionLabel('🤱 Pregnant Woman Info', _pk),
          voiceField(fieldKey:'nm', controller:_nmC, label:td('motherName'),
              icon:Icons.person_outline, color:_pk,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'ph', controller:_phC, label:td('phone'),
              icon:Icons.phone_outlined, color:_pk,
              keyboard:TextInputType.phone, maxLen:10,
              formatters:[FilteringTextInputFormatter.digitsOnly],
              validator:(v){
                if(v==null||v.trim().isEmpty) return 'Required';
                if(!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return 'Valid 10-digit number';
                return null;
              }),
          const SizedBox(height:8),
          voiceField(fieldKey:'vl', controller:_vlC, label:_vt('village'),
              icon:Icons.location_on_outlined, color:_pk),
          const SizedBox(height:8),
          voiceField(fieldKey:'edd', controller:_eddC, label:_vt('edd'),
              icon:Icons.calendar_month_rounded, color:_pk,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'anc', controller:_ancC, label:_vt('anc'),
              icon:Icons.assignment_outlined, color:_pk, keyboard:TextInputType.number),

          const SizedBox(height:10),
          sectionLabel('💉 TT Vaccination', _pk),
          Row(children:[
            Text('${_vt('ttDose')}: ', style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:kMuted, decoration: TextDecoration.none)),
            const SizedBox(width:8),
            _Chip('TT-1', _tt=='TT-1', _pk, ()=>setState(()=>_tt='TT-1')),
            const SizedBox(width:6),
            _Chip('TT-2', _tt=='TT-2', _pk, ()=>setState(()=>_tt='TT-2')),
          ]),
          const SizedBox(height:8),
          voiceField(fieldKey:'nd', controller:_ndC, label:'Next TT Date',
              icon:Icons.calendar_today_rounded, color:_pk,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'rm', controller:_rmC, label:_vt('remarks'),
              icon:Icons.notes_rounded, color:_pk),

          const SizedBox(height:14),
          buildMicHint(_pk, _pkl),
          const SizedBox(height:14),
          buildDialogButtons(ctx:context, color:_pk, onSave:_save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  DIALOG 3 — VHND SESSION FORM
// ══════════════════════════════════════════════════════════
class _VhndDialog extends StatefulWidget {
  const _VhndDialog({super.key});
  @override State<_VhndDialog> createState() => _VhndDialogState();
}

class _VhndDialogState extends State<_VhndDialog> with VoiceDialogMixin {
  static const _kb  = Color(0xFF1565C0);
  static const _kbl = Color(0xFFE3F2FD);
  final _fk  = GlobalKey<FormState>();
  final _dtC = TextEditingController(); final _plC = TextEditingController();
  final _awC = TextEditingController(); final _chC = TextEditingController();
  final _pgC = TextEditingController(); final _vxC = TextEditingController();
  final _rmC = TextEditingController();

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_dtC,_plC,_awC,_chC,_pgC,_vxC,_rmC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'date':_dtC.text.trim(),'place':_plC.text.trim(),'awc':_awC.text.trim(),
      'children':_chC.text.trim(),'pregnant':_pgC.text.trim(),'vaccines':_vxC.text.trim(),
      'remarks':_rmC.text.trim(),'status':'done',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key:_fk, child: Column(
          mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children:[
          _DHeader(icon:Icons.groups_rounded, color:_kb, colorLight:_kbl,
              title:_vt('vhnd'), ctx:context),
          const SizedBox(height:12),
          buildLangBar(_kb), const SizedBox(height:8),
          buildListeningBanner(_kb),

          sectionLabel('📋 VHND Session', _kb),
          voiceField(fieldKey:'dt', controller:_dtC, label:_vt('vhndDate'),
              icon:Icons.calendar_today_rounded, color:_kb,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'pl', controller:_plC, label:_vt('vhndPlace'),
              icon:Icons.location_on_outlined, color:_kb,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'aw', controller:_awC, label:_vt('awc'),
              icon:Icons.home_work_outlined, color:_kb),

          const SizedBox(height:10),
          sectionLabel('👥 Beneficiary Count', _kb),
          Row(children:[
            Expanded(child:voiceField(fieldKey:'ch', controller:_chC, label:_vt('childrens'),
                icon:Icons.child_care_rounded, color:_kb,
                keyboard:TextInputType.number, formatters:[FilteringTextInputFormatter.digitsOnly])),
            const SizedBox(width:10),
            Expanded(child:voiceField(fieldKey:'pg', controller:_pgC, label:_vt('pregCount'),
                icon:Icons.pregnant_woman_rounded, color:_kb,
                keyboard:TextInputType.number, formatters:[FilteringTextInputFormatter.digitsOnly])),
          ]),
          const SizedBox(height:8),
          voiceField(fieldKey:'vx', controller:_vxC, label:_vt('vaccinesGiven'),
              icon:Icons.vaccines_rounded, color:_kb),
          const SizedBox(height:8),
          voiceField(fieldKey:'rm', controller:_rmC, label:_vt('remarks'),
              icon:Icons.notes_rounded, color:_kb),

          const SizedBox(height:14),
          buildMicHint(_kb, _kbl),
          const SizedBox(height:14),
          buildDialogButtons(ctx:context, color:_kb, onSave:_save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  DIALOG 4 — UWIN RECORD FORM
// ══════════════════════════════════════════════════════════
class _UwinDialog extends StatefulWidget {
  const _UwinDialog({super.key});
  @override State<_UwinDialog> createState() => _UwinDialogState();
}

class _UwinDialogState extends State<_UwinDialog> with VoiceDialogMixin {
  static const _kp  = Color(0xFF6A1B9A);
  static const _kpl = Color(0xFFF3E8FF);
  final _fk  = GlobalKey<FormState>();
  final _uwC = TextEditingController(); final _nmC = TextEditingController();
  final _dbC = TextEditingController(); final _moC = TextEditingController();
  final _phC = TextEditingController(); final _adC = TextEditingController();
  final _vlC = TextEditingController(); final _vxC = TextEditingController();

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    for (final c in [_uwC,_nmC,_dbC,_moC,_phC,_adC,_vlC,_vxC]) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'uwinId':_uwC.text.trim(),'childName':_nmC.text.trim(),'dob':_dbC.text.trim(),
      'mother':_moC.text.trim(),'phone':_phC.text.trim(),'aadhar':_adC.text.trim(),
      'village':_vlC.text.trim(),'vaccines':_vxC.text.trim(),'synced':'no',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key:_fk, child: Column(
          mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children:[
          _DHeader(icon:Icons.qr_code_rounded, color:_kp, colorLight:_kpl,
              title:_vt('uwin'), ctx:context),
          const SizedBox(height:12),
          buildLangBar(_kp), const SizedBox(height:8),
          buildListeningBanner(_kp),

          sectionLabel('🪪 UWIN Record', _kp),
          voiceField(fieldKey:'uw', controller:_uwC, label:_vt('uwinId'),
              icon:Icons.qr_code_rounded, color:_kp),
          const SizedBox(height:8),
          voiceField(fieldKey:'nm', controller:_nmC, label:_vt('childName'),
              icon:Icons.child_care_rounded, color:_kp,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'db', controller:_dbC, label:_vt('dob'),
              icon:Icons.cake_outlined, color:_kp,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'mo', controller:_moC, label:td('motherName'),
              icon:Icons.person_outline, color:_kp,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),
          const SizedBox(height:8),
          voiceField(fieldKey:'ph', controller:_phC, label:td('phone'),
              icon:Icons.phone_outlined, color:_kp,
              keyboard:TextInputType.phone, maxLen:10,
              formatters:[FilteringTextInputFormatter.digitsOnly],
              validator:(v){
                if(v==null||v.trim().isEmpty) return 'Required';
                if(!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return 'Valid 10-digit';
                return null;
              }),
          const SizedBox(height:8),
          voiceField(fieldKey:'ad', controller:_adC, label:_vt('aadhar'),
              icon:Icons.credit_card_rounded, color:_kp,
              keyboard:TextInputType.number, maxLen:14,
              formatters:[FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height:8),
          voiceField(fieldKey:'vl', controller:_vlC, label:_vt('village'),
              icon:Icons.location_on_outlined, color:_kp),
          const SizedBox(height:8),
          voiceField(fieldKey:'vx', controller:_vxC, label:_vt('vaccinesGiven'),
              icon:Icons.vaccines_rounded, color:_kp,
              validator:(v)=>v==null||v.trim().isEmpty?'Required':null),

          const SizedBox(height:14),
          buildMicHint(_kp, _kpl),
          const SizedBox(height:14),
          buildDialogButtons(ctx:context, color:_kp, onSave:_save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPER WIDGETS
// ══════════════════════════════════════════════════════════

/// Info row with icon
class _IR extends StatelessWidget {
  final IconData icon; final String text; final Color color;
  const _IR(this.icon, this.text, this.color);
  @override
  Widget build(BuildContext context) => Row(children:[
    Icon(icon, size:13, color:color), const SizedBox(width:5),
    Expanded(child:Text(text, style:const TextStyle(fontSize:11.5, color:kText, decoration: TextDecoration.none))),
  ]);
}

/// Stat pill for summary bar
class _StatPill extends StatelessWidget {
  final String value, label; final Color color;
  const _StatPill(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical:8, horizontal:10),
      decoration: BoxDecoration(color:color.withOpacity(0.1), borderRadius:BorderRadius.circular(10)),
      child: Column(children:[
        Text(value, style:TextStyle(fontSize:18, fontWeight:FontWeight.w800, color:color, decoration: TextDecoration.none)),
        Text(label, style:const TextStyle(fontSize:9, color:kMuted, decoration: TextDecoration.none), textAlign:TextAlign.center),
      ]),
    ),
  );
}

/// Toggle chip (gender / TT dose)
class _Chip extends StatelessWidget {
  final String label; final bool selected; final Color color; final VoidCallback onTap;
  const _Chip(this.label, this.selected, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds:200),
      padding: const EdgeInsets.symmetric(horizontal:14, vertical:6),
      decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:color)),
      child: Text(label, style:TextStyle(fontSize:12, fontWeight:FontWeight.w600,
          color: selected ? Colors.white : color, decoration: TextDecoration.none)),
    ),
  );
}

/// WhatsApp button
class _WABtn extends StatelessWidget {
  final VoidCallback onTap;
  const _WABtn(this.onTap);
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.chat_rounded, size:15, color:Color(0xFF25D366)),
    label: Text(_vt('sendWA'), style:const TextStyle(fontSize:12, decoration: TextDecoration.none)),
    style: OutlinedButton.styleFrom(
        foregroundColor:const Color(0xFF25D366),
        side:const BorderSide(color:Color(0xFF25D366)),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
        padding:const EdgeInsets.symmetric(vertical:8, horizontal:12)),
  );
}

/// Add row button
class _AddBtn extends StatelessWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _AddBtn(this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical:13),
      decoration: BoxDecoration(border:Border.all(color:color,width:1.5),
          borderRadius:BorderRadius.circular(14), color:color.withOpacity(0.05)),
      child: Center(child:Text(label, style:TextStyle(color:color,fontWeight:FontWeight.w700,fontSize:13, decoration: TextDecoration.none))),
    ),
  );
}

/// Dialog header widget
class _DHeader extends StatelessWidget {
  final IconData icon; final Color color, colorLight;
  final String title; final BuildContext ctx;
  const _DHeader({required this.icon, required this.color, required this.colorLight, required this.title, required this.ctx});
  @override
  Widget build(BuildContext context) => Row(children:[
    Container(padding:const EdgeInsets.all(8),
        decoration:BoxDecoration(color:colorLight, borderRadius:BorderRadius.circular(10)),
        child:Icon(icon, color:color, size:20)),
    const SizedBox(width:10),
    Expanded(child:Text(title, style:const TextStyle(fontSize:15, fontWeight:FontWeight.w800, decoration: TextDecoration.none))),
    GestureDetector(onTap:()=>Navigator.pop(ctx), child:const Icon(Icons.close_rounded, color:Colors.grey)),
  ]);
}