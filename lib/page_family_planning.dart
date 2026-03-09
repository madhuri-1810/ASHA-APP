import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'pages_dashboard.dart';
import 'voice_mixin.dart';

// ══════════════════════════════════════════════════════════
//  FAMILY PLANNING PAGE — 5 Sub-tabs
//  1. Eligible Couple Register   (पात्र जोडपे नोंद)
//  2. कुटुंब नियोजन सेवा         (FP Services)
//  3. FPLMIS माहिती              (FPLMIS Info)
//  4. दोन अपत्यांमधील अंतर        (Birth Spacing)
//  5. गर्भनिरोधक साधने नोंद       (Contraceptive Record)
// ══════════════════════════════════════════════════════════

// ── Local translation helper (3 languages) ──────────────
String _ft(String k) {
  const m = <String, Map<String, String>>{
    'eligibleCouple': {'en': 'Eligible Couple',      'hi': 'पात्र दंपती',         'mr': 'पात्र जोडपे'},
    'fpServices':     {'en': 'FP Services',          'hi': 'FP सेवाएं',           'mr': 'कुटुंब नियोजन सेवा'},
    'fplmis':         {'en': 'FPLMIS Info',          'hi': 'FPLMIS जानकारी',      'mr': 'FPLMIS माहिती'},
    'birthSpacing':   {'en': 'Birth Spacing',        'hi': 'जन्म अंतर',           'mr': 'दोन अपत्यांमधील अंतर'},
    'contraceptive':  {'en': 'Contraceptive Record', 'hi': 'गर्भनिरोधक रिकॉर्ड', 'mr': 'गर्भनिरोधक साधने नोंद'},
    'husbandName':    {'en': "Husband's Name",       'hi': 'पति का नाम',           'mr': 'पतीचे नाव'},
    'wifeName':       {'en': "Wife's Name",          'hi': 'पत्नी का नाम',         'mr': 'पत्नीचे नाव'},
    'age':            {'en': 'Age (Wife)',            'hi': 'उम्र (पत्नी)',          'mr': 'वय (पत्नी)'},
    'children':       {'en': 'No. of Children',      'hi': 'बच्चों की संख्या',      'mr': 'अपत्यांची संख्या'},
    'village':        {'en': 'Village / Area',       'hi': 'गांव / क्षेत्र',       'mr': 'गाव / क्षेत्र'},
    'phone':          {'en': 'Phone Number',         'hi': 'फोन नंबर',             'mr': 'फोन नंबर'},
    'method':         {'en': 'FP Method Adopted',   'hi': 'FP विधि',              'mr': 'स्वीकारलेली FP पद्धत'},
    'lastChild':      {'en': 'Last Child DOB',       'hi': 'अंतिम बच्चे का जन्म',  'mr': 'शेवटच्या अपत्याचा जन्म'},
    'nextDue':        {'en': 'Next Follow-up',       'hi': 'अगला फॉलो-अप',         'mr': 'पुढील फॉलो-अप'},
    'status':         {'en': 'Status',               'hi': 'स्थिति',               'mr': 'स्थिती'},
    'active':         {'en': 'Active',               'hi': 'सक्रिय',               'mr': 'सक्रिय'},
    'followup':       {'en': 'Follow-up',            'hi': 'फॉलो-अप',              'mr': 'फॉलो-अप'},
    'dropout':        {'en': 'Dropout',              'hi': 'ड्रॉपआउट',             'mr': 'बाहेर पडले'},
    'all':            {'en': 'All',                  'hi': 'सभी',                  'mr': 'सर्व'},
    'total':          {'en': 'Total',                'hi': 'कुल',                  'mr': 'एकूण'},
    'sendWA':         {'en': 'Send WhatsApp',        'hi': 'WhatsApp भेजें',       'mr': 'WhatsApp पाठवा'},
    'addCouple':      {'en': '+ Add Couple',         'hi': '+ दंपती जोड़ें',        'mr': '+ जोडपे जोडा'},
    'addService':     {'en': '+ Add FP Service',     'hi': '+ FP सेवा जोड़ें',     'mr': '+ FP सेवा जोडा'},
    'addFplmis':      {'en': '+ Add FPLMIS Entry',   'hi': '+ FPLMIS एंट्री जोड़ें','mr': '+ FPLMIS नोंद जोडा'},
    'addSpacing':     {'en': '+ Add Record',         'hi': '+ रिकॉर्ड जोड़ें',      'mr': '+ नोंद जोडा'},
    'addContra':      {'en': '+ Add Record',         'hi': '+ रिकॉर्ड जोड़ें',      'mr': '+ नोंद जोडा'},
    'fpTitle':        {'en': 'Family Planning',      'hi': 'परिवार नियोजन',        'mr': 'कुटुंब नियोजन'},
    'fpSubtitle':     {'en': 'Family Planning / कुटुंब नियोजन', 'hi': 'Family Planning / परिवार नियोजन', 'mr': 'Family Planning / कुटुंब नियोजन'},
    'spacing':        {'en': 'Spacing (months)',     'hi': 'अंतर (माह)',            'mr': 'अंतर (महिने)'},
    'ideal':          {'en': 'Ideal (24+ months)',   'hi': 'आदर्श (24+ माह)',       'mr': 'आदर्श (24+ महिने)'},
    'remarks':        {'en': 'Remarks',              'hi': 'टिप्पणी',              'mr': 'शेरा'},
    'contraDevice':   {'en': 'Contraceptive Type',  'hi': 'गर्भनिरोधक प्रकार',    'mr': 'गर्भनिरोधक प्रकार'},
    'givenDate':      {'en': 'Given Date',           'hi': 'दी गई तारीख',          'mr': 'दिलेली तारीख'},
    'nextVisit':      {'en': 'Next Visit Date',      'hi': 'अगली भेट तिथि',        'mr': 'पुढील भेट तारीख'},
    'aadhar':         {'en': 'Aadhar Number',        'hi': 'आधार नंबर',            'mr': 'आधार क्रमांक'},
    'fplmisId':       {'en': 'FPLMIS ID',            'hi': 'FPLMIS आईडी',          'mr': 'FPLMIS आयडी'},
    'accepted':       {'en': 'Accepted',             'hi': 'स्वीकार किया',         'mr': 'स्वीकारले'},
    'refused':        {'en': 'Refused',              'hi': 'मना किया',             'mr': 'नाकारले'},
  };
  final lang = langNotifier.value;
  return m[k]?[lang] ?? m[k]?['en'] ?? k;
}

// ── Accent colour for this page ──────────────────────────
const _kFP      = Color(0xFFD946EF); // Pink-Purple
const _kFPLight = Color(0xFFFCE7F3);
const _kFPDark  = Color(0xFF86198F);

// ── FP Method options (ASHA standard list) ───────────────
const _kFpMethods = [
  'Copper-T (IUD)',
  'Hormonal IUD (LNG-IUS)',
  'Oral Contraceptive Pills (OCP)',
  'Emergency Contraceptive Pills',
  'Injection (Antara - MPA)',
  'Condom (Male)',
  'Female Condom',
  'NSV (Vasectomy)',
  'Tubectomy (Female Sterilization)',
  'LAM (Lactational Amenorrhea)',
  'Natural Family Planning',
  'None / Refused',
];

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
          backgroundColor: _kFP,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    }
  }
}

// ── WhatsApp message builders ────────────────────────────
String _coupleWAMsg(Map<String, String> c) {
  final lang = langNotifier.value;
  if (lang == 'mr') {
    return '🏥 *NHM कुटुंब नियोजन स्मरणपत्र*\n\n'
        'प्रिय ${c['wifeName']} जी,\n\n'
        '👫 पती: ${c['husbandName']}\n'
        '📋 पद्धत: ${c['method']}\n'
        '📅 फॉलो-अप: ${c['nextDue']}\n\n'
        'कुटुंब नियोजनाशी संपर्क ठेवा! 🙏\n'
        '📞 ASHA वर्करशी संपर्क करा';
  } else if (lang == 'hi') {
    return '🏥 *NHM परिवार नियोजन अनुस्मारक*\n\n'
        'प्रिय ${c['wifeName']} जी,\n\n'
        '👫 पति: ${c['husbandName']}\n'
        '📋 विधि: ${c['method']}\n'
        '📅 फॉलो-अप: ${c['nextDue']}\n\n'
        'परिवार नियोजन जुड़े रहें! 🙏\n'
        '📞 ASHA वर्कर से संपर्क करें';
  }
  return '🏥 *NHM Family Planning Reminder*\n\n'
      'Dear ${c['wifeName']},\n\n'
      '👫 Husband: ${c['husbandName']}\n'
      '📋 Method: ${c['method']}\n'
      '📅 Follow-up: ${c['nextDue']}\n\n'
      'Stay connected with family planning services! 🙏\n'
      '📞 Contact your ASHA Worker';
}

String _spacingWAMsg(Map<String, String> c) {
  final lang = langNotifier.value;
  if (lang == 'mr') {
    return '🏥 *NHM जन्म अंतर सल्ला*\n\n'
        'प्रिय ${c['wifeName']} जी,\n\n'
        '📅 शेवटचे अपत्य: ${c['lastChild']}\n'
        '⏳ अंतर: ${c['spacing']} महिने\n\n'
        'दोन अपत्यांमध्ये किमान 3 वर्षे अंतर ठेवा! 🙏';
  } else if (lang == 'hi') {
    return '🏥 *NHM जन्म अंतर सलाह*\n\n'
        'प्रिय ${c['wifeName']} जी,\n\n'
        '📅 अंतिम बच्चा: ${c['lastChild']}\n'
        '⏳ अंतर: ${c['spacing']} माह\n\n'
        'दो बच्चों के बीच कम से कम 3 साल का अंतर रखें! 🙏';
  }
  return '🏥 *NHM Birth Spacing Advisory*\n\n'
      'Dear ${c['wifeName']},\n\n'
      '📅 Last Child: ${c['lastChild']}\n'
      '⏳ Spacing: ${c['spacing']} months\n\n'
      'Maintain at least 3 years gap between children! 🙏';
}

// ══════════════════════════════════════════════════════════
//  MAIN PAGE
// ══════════════════════════════════════════════════════════
class FamilyPlanningPage extends StatefulWidget {
  const FamilyPlanningPage({super.key});
  @override
  State<FamilyPlanningPage> createState() => _FamilyPlanningPageState();
}

class _FamilyPlanningPageState extends State<FamilyPlanningPage> {
  int _sel = 0;
  final ScrollController _tabScrollCtrl = ScrollController();

  // Tab width estimate: padding(14*2) + icon(15) + spacing(6) + text(~80) + margin(8) ≈ 137px
  static const double _kTabWidth = 137.0;

  @override
  void dispose() {
    _tabScrollCtrl.dispose();
    super.dispose();
  }

  void _selectTab(int i) {
    setState(() => _sel = i);
    // Auto-scroll so selected tab is fully visible
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
    _FPTab(Icons.people_alt_rounded,        'eligibleCouple', Color(0xFFD946EF)),
    _FPTab(Icons.medical_services_rounded,  'fpServices',     Color(0xFF0891B2)),
    _FPTab(Icons.bar_chart_rounded,         'fplmis',         Color(0xFF7C3AED)),
    _FPTab(Icons.calendar_month_rounded,    'birthSpacing',   Color(0xFF16A34A)),
    _FPTab(Icons.medication_liquid_rounded, 'contraceptive',  Color(0xFFD97706)),
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
              colors: [_kFP, _kFPDark],
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
              child: const Icon(Icons.favorite_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(_ft('fpTitle'),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        decoration: TextDecoration.none)),
                Text(_ft('fpSubtitle'),
                    style: const TextStyle(fontSize: 11, color: Colors.white70, decoration: TextDecoration.none)),
              ]),
            ),
            const MiniLangBar(),
          ]),
        ),

        // ── Pill-style Sub-tabs ──
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
                      Text(_ft(tab.labelKey),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : tab.color,
                              decoration: TextDecoration.none)),
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

  // Keep tab instances alive - prevents blank screen on tab switch
  final _tabWidgets = const [
    _EligibleCoupleTab(),
    _FpServicesTab(),
    _BirthSpacingTab(),
    _ContraceptiveTab(),
  ];

  Widget _page(int i) {
    switch (i) {
      case 0: return const _EligibleCoupleTab();
      case 1: return const _FpServicesTab();
      case 2: return const _FplmisTab();
      case 3: return const _BirthSpacingTab();
      case 4: return const _ContraceptiveTab();
      default: return const _EligibleCoupleTab();
    }
  }
}

// ── Tab descriptor ──
class _FPTab {
  final IconData icon;
  final String labelKey;
  final Color color;
  const _FPTab(this.icon, this.labelKey, this.color);
}

// ══════════════════════════════════════════════════════════
//  TAB 1 — ELIGIBLE COUPLE REGISTER  (पात्र जोडपे नोंद)
// ══════════════════════════════════════════════════════════
class _EligibleCoupleTab extends StatefulWidget {
  const _EligibleCoupleTab();
  @override State<_EligibleCoupleTab> createState() => _EligibleCoupleTabState();
}

class _EligibleCoupleTabState extends State<_EligibleCoupleTab> {
  final List<Map<String, String>> _list = [
    {'husbandName':'Ramesh Patil',  'wifeName':'Sunita Patil',  'age':'24','children':'1','village':'Wardha',  'phone':'9800001111','method':'Copper-T','lastChild':'10 Jan 2023','nextDue':'10 Jul 2025','status':'active',   'remarks':''},
    {'husbandName':'Vijay Kumar',   'wifeName':'Priya Kumar',   'age':'28','children':'2','village':'Nagpur',  'phone':'9800002222','method':'Sterilization','lastChild':'05 Mar 2022','nextDue':'—','status':'active',  'remarks':'Permanent'},
    {'husbandName':'Suresh Yadav',  'wifeName':'Anita Yadav',   'age':'22','children':'0','village':'Hingna',  'phone':'9800003333','method':'Condom','lastChild':'—','nextDue':'15 Aug 2025','status':'followup','remarks':'Newly married'},
    {'husbandName':'Anil Deshmukh', 'wifeName':'Kavita Deshmukh','age':'30','children':'3','village':'Wardha','phone':'9800004444','method':'None','lastChild':'20 Nov 2024','nextDue':'20 Feb 2025','status':'dropout', 'remarks':'Refused FP'},
  ];

  final _sc = TextEditingController();
  String _q = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != 'all' && c['status'] != _filter) return false;
    if (_q.isEmpty) return true;
    final q = _q.toLowerCase();
    return c['wifeName']!.toLowerCase().contains(q) ||
        c['husbandName']!.toLowerCase().contains(q) ||
        c['village']!.toLowerCase().contains(q) ||
        c['phone']!.contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      // ASHA Progress Banner
      Container(
        margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_kFP, Color(0xFF9333EA)]),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 26),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('कुटुंब नियोजन नोंद', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
            Text('Eligible Couples in your area: ${_list.length}  •  Active: ${_list.where((c)=>c['status']=='active').length}',
                style: const TextStyle(fontSize: 10.5, color: Colors.white70)),
          ])),
        ]),
      ),
      const SizedBox(height: 6),
      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          _StatPill('${_list.length}',                                           _ft('total'),    _kFP),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']=='active').length}',      _ft('active'),   kGreen),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']=='followup').length}',    _ft('followup'), kOrange),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']=='dropout').length}',     _ft('dropout'),  kRed),
        ]),
      ),
      buildSearchBar(controller: _sc, hint: 'Search wife, husband, village…', color: _kFP,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _filter, color: _kFP, count: list.length,
          chips: [
            {'label': _ft('all'),      'value': 'all'},
            {'label': _ft('active'),   'value': 'active'},
            {'label': _ft('followup'), 'value': 'followup'},
            {'label': _ft('dropout'),  'value': 'dropout'},
          ],
          onTap: (v) => setState(() => _filter = v)),
      // Fixed Add Button at top
      Builder(builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: _AddBtn(_ft('addCouple'), _kFP, () => _addDialog(ctx)),
      )),
      const SizedBox(height: 8),
      Expanded(
        child: list.isEmpty ? emptyState(_q) : ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final c = list[i];
            final col = c['status']=='dropout' ? kRed : c['status']=='followup' ? kOrange : kGreen;
            return _CoupleCard(data: c, statusColor: col,
                onWA: () => _sendWA(ctx, c['phone']!, _coupleWAMsg(c)));
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _CoupleDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

// ── Couple Card ───────────────────────────────────────────
class _CoupleCard extends StatefulWidget {
  final Map<String, String> data;
  final Color statusColor;
  final VoidCallback onWA;
  const _CoupleCard({required this.data, required this.statusColor, required this.onWA});
  @override State<_CoupleCard> createState() => _CoupleCardState();
}

class _CoupleCardState extends State<_CoupleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final sc = widget.statusColor;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sc.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: _kFPLight, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.people_alt_rounded, color: _kFP, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['wifeName']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
              Text('👫 ${c['husbandName']}  •  🏘 ${c['village']}',
                  style: const TextStyle(fontSize: 11, color: kMuted)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(_ft(c['status']!), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: sc))),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 4, children: [
            _IR(Icons.medication_liquid_rounded, c['method']!, _kFP),
            _IR(Icons.child_care_rounded, '${c['children']} children', kGreen),
          ]),
          const SizedBox(height: 4),
          _IR(Icons.calendar_today_rounded, '${_ft('nextDue')}: ${c['nextDue']}', kOrange),
          if (_expanded) ...[
            const SizedBox(height: 10),
            const Divider(color: kBorder),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: _IR(Icons.phone_rounded, c['phone']!, kGreen)),
              Expanded(child: _IR(Icons.person_rounded, _ft('age') + ': ${c['age']}', _kFP)),
            ]),
            const SizedBox(height: 5),
            _IR(Icons.child_friendly_rounded, '${_ft('lastChild')}: ${c['lastChild']}', kOrange),
            if (c['remarks']!.isNotEmpty) ...[
              const SizedBox(height: 5),
              _IR(Icons.notes_rounded, c['remarks']!, kMuted),
            ],
            const SizedBox(height: 10),
            _WABtn(widget.onWA),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: kMuted, size: 18),
          ]),
        ]),
      ),
    );
  }
}

// ── Add Couple Dialog ─────────────────────────────────────
class _CoupleDialog extends StatefulWidget {
  const _CoupleDialog();
  @override State<_CoupleDialog> createState() => _CoupleDialogState();
}

class _CoupleDialogState extends State<_CoupleDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _hC = TextEditingController(); // husband
  final _wC = TextEditingController(); // wife
  final _agC = TextEditingController();
  final _chC = TextEditingController();
  final _vlC = TextEditingController();
  final _phC = TextEditingController();
  final _mtC = TextEditingController();
  final _lcC = TextEditingController();
  final _ndC = TextEditingController();
  final _adC = TextEditingController(); // aadhar
  String _risk = 'normal';

  void _save() {
    if (!(_fk.currentState?.validate() ?? false)) return;
    Navigator.pop(context, {
      'husbandName': _hC.text.trim(), 'wifeName': _wC.text.trim(),
      'age': _agC.text.trim(), 'children': _chC.text.trim(),
      'village': _vlC.text.trim(), 'phone': _phC.text.trim(),
      'method': _mtC.text.trim(), 'lastChild': _lcC.text.trim(),
      'nextDue': _ndC.text.trim(), 'status': 'active', 'remarks': '',
      'aadhar': _adC.text.trim(), 'risk': _risk,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key: _fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DHeader(icon: Icons.people_alt_rounded, color: _kFP, colorLight: _kFPLight,
              title: _ft('eligibleCouple'), ctx: context),
          const SizedBox(height: 12),
          buildLangBar(_kFP), const SizedBox(height: 8),
          buildListeningBanner(_kFP),

          sectionLabel('👫 ${_ft('eligibleCouple')}', _kFP),
          voiceField(fieldKey: 'wn', controller: _wC, label: _ft('wifeName'),
              icon: Icons.person_outline, color: _kFP,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'hn', controller: _hC, label: _ft('husbandName'),
              icon: Icons.person_outline, color: _kFP,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ag', controller: _agC, label: _ft('age'),
              icon: Icons.cake_rounded, color: _kFP,
              keyboard: TextInputType.number, maxLen: 2,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ch', controller: _chC, label: _ft('children'),
              icon: Icons.child_care_rounded, color: _kFP,
              keyboard: TextInputType.number, maxLen: 1,
              formatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ph', controller: _phC, label: _ft('phone'),
              icon: Icons.phone_outlined, color: _kFP,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return 'Valid 10-digit';
                return null;
              }),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'vl', controller: _vlC, label: _ft('village'),
              icon: Icons.location_on_outlined, color: _kFP),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ad', controller: _adC, label: 'Aadhar Number (Optional)',
              icon: Icons.credit_card_rounded, color: _kFP,
              keyboard: TextInputType.number, maxLen: 14,
              formatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 10),
          // Risk Category Toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Risk Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kText)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => _risk = 'normal'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _risk == 'normal' ? kGreen : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kGreen),
                    ),
                    child: Center(child: Text('Normal',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                            color: _risk == 'normal' ? Colors.white : kGreen))),
                  ),
                )),
                const SizedBox(width: 8),
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => _risk = 'high'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _risk == 'high' ? kRed : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kRed),
                    ),
                    child: Center(child: Text('High Risk',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                            color: _risk == 'high' ? Colors.white : kRed))),
                  ),
                )),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          // FP Method Dropdown
          DropdownButtonFormField<String>(
            value: _mtC.text.isEmpty ? null : _mtC.text,
            decoration: InputDecoration(
              labelText: _ft('method'),
              prefixIcon: const Icon(Icons.medication_liquid_rounded, size: 18, color: _kFP),
              filled: true, fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kFP, width: 1.5)),
            ),
            hint: Text('Select FP Method', style: TextStyle(fontSize: 12, color: kMuted)),
            items: _kFpMethods.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) { if (v != null) setState(() => _mtC.text = v); },
            validator: (v) => v == null || v.isEmpty ? 'Select a method' : null,
          ),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'lc', controller: _lcC, label: _ft('lastChild'),
              icon: Icons.child_friendly_rounded, color: _kFP),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'nd', controller: _ndC, label: _ft('nextDue'),
              icon: Icons.event_rounded, color: _kFP),

          const SizedBox(height: 14),
          buildMicHint(_kFP, _kFPLight),
          const SizedBox(height: 14),
          buildDialogButtons(ctx: context, color: _kFP, onSave: _save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 2 — FP SERVICES  (कुटुंब नियोजन सेवा)
// ══════════════════════════════════════════════════════════
const _kS = Color(0xFF0891B2);
const _kSL = Color(0xFFE0F2FE);

class _FpServicesTab extends StatefulWidget {
  const _FpServicesTab();
  @override State<_FpServicesTab> createState() => _FpServicesTabState();
}

class _FpServicesTabState extends State<_FpServicesTab> {
  final List<Map<String, String>> _list = [
    {'wifeName':'Sunita Patil',  'phone':'9800001111','village':'Wardha', 'method':'Copper-T IUD','givenDate':'10 Jan 2025','nextVisit':'10 Jul 2025','status':'active'},
    {'wifeName':'Meera Singh',   'phone':'9800002222','village':'Nagpur', 'method':'Oral Pills',  'givenDate':'05 Feb 2025','nextVisit':'05 Mar 2025','status':'followup'},
    {'wifeName':'Rekha Gupta',   'phone':'9800003333','village':'Hingna', 'method':'Injection',   'givenDate':'20 Mar 2025','nextVisit':'20 Jun 2025','status':'active'},
    {'wifeName':'Lata Deshmukh', 'phone':'9800004444','village':'Wardha', 'method':'NSV (Vasect.)','givenDate':'01 Jan 2024','nextVisit':'—','status':'active'},
  ];

  final _sc = TextEditingController();
  String _q = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != 'all' && c['status'] != _filter) return false;
    if (_q.isEmpty) return true;
    final q = _q.toLowerCase();
    return c['wifeName']!.toLowerCase().contains(q) ||
        c['village']!.toLowerCase().contains(q) ||
        c['method']!.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          _StatPill('${_list.length}',                                         _ft('total'),    _kS),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']=='active').length}',    _ft('active'),   kGreen),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['status']=='followup').length}',  _ft('followup'), kOrange),
        ]),
      ),
      buildSearchBar(controller: _sc, hint: 'Search name, method, village…', color: _kS,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _filter, color: _kS, count: list.length,
          chips: [
            {'label': _ft('all'),      'value': 'all'},
            {'label': _ft('active'),   'value': 'active'},
            {'label': _ft('followup'), 'value': 'followup'},
          ],
          onTap: (v) => setState(() => _filter = v)),
      Builder(builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: _AddBtn(_ft('addService'), _kS, () => _addDialog(ctx)),
      )),
      const SizedBox(height: 8),
      Expanded(
        child: list.isEmpty ? emptyState(_q) : ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final c = list[i];
            return _ServiceCard(data: c);
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _ServiceDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

class _ServiceCard extends StatefulWidget {
  final Map<String, String> data;
  const _ServiceCard({required this.data});
  @override State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final sc = c['status'] == 'followup' ? kOrange : kGreen;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sc.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: _kSL, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.medical_services_rounded, color: _kS, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['wifeName']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
              Text('💊 ${c['method']}  •  🏘 ${c['village']}',
                  style: const TextStyle(fontSize: 11, color: kMuted)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(_ft(c['status']!), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: sc))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _IR(Icons.event_rounded, '${_ft('givenDate')}: ${c['givenDate']}', _kS),
            const SizedBox(width: 12),
            _IR(Icons.event_available_rounded, '${_ft('nextVisit')}: ${c['nextVisit']}', kOrange),
          ]),
          if (_expanded) ...[
            const SizedBox(height: 8),
            const Divider(color: kBorder),
            _IR(Icons.phone_rounded, c['phone']!, kGreen),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: kMuted, size: 18),
          ]),
        ]),
      ),
    );
  }
}

class _ServiceDialog extends StatefulWidget {
  const _ServiceDialog();
  @override State<_ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<_ServiceDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _wC = TextEditingController();
  final _phC = TextEditingController();
  final _vlC = TextEditingController();
  final _mtC = TextEditingController();
  final _gdC = TextEditingController();
  final _nvC = TextEditingController();

  void _save() {
    if (!(_fk.currentState?.validate() ?? false)) return;
    Navigator.pop(context, {
      'wifeName': _wC.text.trim(), 'phone': _phC.text.trim(),
      'village': _vlC.text.trim(), 'method': _mtC.text.trim(),
      'givenDate': _gdC.text.trim(), 'nextVisit': _nvC.text.trim(),
      'status': 'active',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key: _fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DHeader(icon: Icons.medical_services_rounded, color: _kS, colorLight: _kSL,
              title: _ft('fpServices'), ctx: context),
          const SizedBox(height: 12),
          buildLangBar(_kS), const SizedBox(height: 8),
          buildListeningBanner(_kS),
          sectionLabel('💊 ${_ft('fpServices')}', _kS),
          voiceField(fieldKey: 'wn', controller: _wC, label: _ft('wifeName'),
              icon: Icons.person_outline, color: _kS,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ph', controller: _phC, label: _ft('phone'),
              icon: Icons.phone_outlined, color: _kS,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return 'Valid 10-digit';
                return null;
              }),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'vl', controller: _vlC, label: _ft('village'),
              icon: Icons.location_on_outlined, color: _kS),
          const SizedBox(height: 8),
          // FP Method Dropdown
          DropdownButtonFormField<String>(
            value: _mtC.text.isEmpty ? null : _mtC.text,
            decoration: InputDecoration(
              labelText: _ft('method'),
              prefixIcon: const Icon(Icons.medication_liquid_rounded, size: 18, color: _kS),
              filled: true, fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kS, width: 1.5)),
            ),
            hint: Text('Select FP Method', style: TextStyle(fontSize: 12, color: kMuted)),
            items: _kFpMethods.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) { if (v != null) setState(() => _mtC.text = v); },
            validator: (v) => v == null || v.isEmpty ? 'Select a method' : null,
          ),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'gd', controller: _gdC, label: _ft('givenDate'),
              icon: Icons.event_rounded, color: _kS),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'nv', controller: _nvC, label: _ft('nextVisit'),
              icon: Icons.event_available_rounded, color: _kS),
          const SizedBox(height: 14),
          buildMicHint(_kS, _kSL),
          const SizedBox(height: 14),
          buildDialogButtons(ctx: context, color: _kS, onSave: _save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 3 — FPLMIS INFO  (FPLMIS माहिती)
// ══════════════════════════════════════════════════════════
const _kFL  = Color(0xFF7C3AED);
const _kFLL = Color(0xFFF5F3FF);

class _FplmisTab extends StatefulWidget {
  const _FplmisTab();
  @override State<_FplmisTab> createState() => _FplmisTabState();
}

class _FplmisTabState extends State<_FplmisTab> {
  final List<Map<String, String>> _list = [
    {'fplmisId':'FP2025001','wifeName':'Sunita Patil', 'aadhar':'1234 5678 9012','method':'IUD','givenDate':'Jan 2025','village':'Wardha','phone':'9800001111','synced':'yes'},
    {'fplmisId':'FP2025002','wifeName':'Priya Kumar',  'aadhar':'2345 6789 0123','method':'Sterilization','givenDate':'Dec 2024','village':'Nagpur','phone':'9800002222','synced':'yes'},
    {'fplmisId':'FP2025003','wifeName':'Anita Yadav',  'aadhar':'3456 7890 1234','method':'Pills','givenDate':'Feb 2025','village':'Hingna','phone':'9800003333','synced':'no'},
  ];

  @override
  Widget build(BuildContext context) {
    return Material(color: kBg, child: Column(children: [
      // Summary banner
      Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [_kFL, _kFL.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('FPLMIS Portal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
            Text('Total: ${_list.length}  •  Synced: ${_list.where((c)=>c['synced']=='yes').length}  •  Pending: ${_list.where((c)=>c['synced']=='no').length}',
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Text('Sync', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ]),
      ),
      Builder(builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: _AddBtn(_ft('addFplmis'), _kFL, () => _addDialog(ctx)),
      )),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: _list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final c = _list[i];
            return _FplmisCard(data: c);
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _FplmisDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

class _FplmisCard extends StatefulWidget {
  final Map<String, String> data;
  const _FplmisCard({required this.data});
  @override State<_FplmisCard> createState() => _FplmisCardState();
}

class _FplmisCardState extends State<_FplmisCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final synced = c['synced'] == 'yes';
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: (synced ? kGreen : kOrange).withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: _kFLL, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.bar_chart_rounded, color: _kFL, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['wifeName']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
              Text('🪪 ${c['fplmisId']}  •  💊 ${c['method']}',
                  style: const TextStyle(fontSize: 11, color: kMuted)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (synced ? kGreen : kOrange).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8)),
              child: Text(synced ? '✓ Synced' : '⚡ Pending',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: synced ? kGreen : kOrange))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _IR(Icons.credit_card_rounded, c['aadhar']!, _kFL),
            const SizedBox(width: 12),
            _IR(Icons.event_rounded, c['givenDate']!, kMuted),
          ]),
          if (_expanded) ...[
            const SizedBox(height: 8),
            const Divider(color: kBorder),
            _IR(Icons.phone_rounded, c['phone']!, kGreen),
            const SizedBox(height: 5),
            _IR(Icons.location_on_rounded, c['village']!, kMuted),
            const SizedBox(height: 10),
            if (!synced)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_rounded, size: 16),
                  label: const Text('Upload to FPLMIS Portal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kFL, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: kMuted, size: 18),
          ]),
        ]),
      ),
    );
  }
}

class _FplmisDialog extends StatefulWidget {
  const _FplmisDialog();
  @override State<_FplmisDialog> createState() => _FplmisDialogState();
}

class _FplmisDialogState extends State<_FplmisDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _idC = TextEditingController();
  final _wC  = TextEditingController();
  final _adC = TextEditingController();
  final _mtC = TextEditingController();
  final _gdC = TextEditingController();
  final _vlC = TextEditingController();
  final _phC = TextEditingController();

  void _save() {
    if (!(_fk.currentState?.validate() ?? false)) return;
    Navigator.pop(context, {
      'fplmisId': _idC.text.trim(), 'wifeName': _wC.text.trim(),
      'aadhar': _adC.text.trim(), 'method': _mtC.text.trim(),
      'givenDate': _gdC.text.trim(), 'village': _vlC.text.trim(),
      'phone': _phC.text.trim(), 'synced': 'no',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key: _fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DHeader(icon: Icons.bar_chart_rounded, color: _kFL, colorLight: _kFLL,
              title: _ft('fplmis'), ctx: context),
          const SizedBox(height: 12),
          buildLangBar(_kFL), const SizedBox(height: 8),
          buildListeningBanner(_kFL),
          sectionLabel('📊 ${_ft('fplmis')}', _kFL),
          voiceField(fieldKey: 'id', controller: _idC, label: _ft('fplmisId'),
              icon: Icons.badge_rounded, color: _kFL),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'wn', controller: _wC, label: _ft('wifeName'),
              icon: Icons.person_outline, color: _kFL,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ad', controller: _adC, label: _ft('aadhar'),
              icon: Icons.credit_card_rounded, color: _kFL,
              keyboard: TextInputType.number, maxLen: 14,
              formatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _mtC.text.isEmpty ? null : _mtC.text,
            decoration: InputDecoration(
              labelText: _ft('method'),
              prefixIcon: const Icon(Icons.medication_liquid_rounded, size: 18, color: _kFL),
              filled: true, fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kFL, width: 1.5)),
            ),
            hint: Text('Select FP Method', style: TextStyle(fontSize: 12, color: kMuted)),
            items: _kFpMethods.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) { if (v != null) setState(() => _mtC.text = v); },
            validator: (v) => v == null || v.isEmpty ? 'Select a method' : null,
          ),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'gd', controller: _gdC, label: _ft('givenDate'),
              icon: Icons.event_rounded, color: _kFL),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'vl', controller: _vlC, label: _ft('village'),
              icon: Icons.location_on_outlined, color: _kFL),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ph', controller: _phC, label: _ft('phone'),
              icon: Icons.phone_outlined, color: _kFL,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 14),
          buildMicHint(_kFL, _kFLL),
          const SizedBox(height: 14),
          buildDialogButtons(ctx: context, color: _kFL, onSave: _save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 4 — BIRTH SPACING  (दोन अपत्यांमधील अंतर)
// ══════════════════════════════════════════════════════════
const _kBS  = Color(0xFF16A34A);
const _kBSL = Color(0xFFDCFCE7);

class _BirthSpacingTab extends StatefulWidget {
  const _BirthSpacingTab();
  @override State<_BirthSpacingTab> createState() => _BirthSpacingTabState();
}

class _BirthSpacingTabState extends State<_BirthSpacingTab> {
  final List<Map<String, String>> _list = [
    {'wifeName':'Sunita Patil',   'phone':'9800001111','village':'Wardha', 'lastChild':'Jan 2023','spacing':'26','status':'ideal',    'remarks':'Spacing ok'},
    {'wifeName':'Priya Kumar',    'phone':'9800002222','village':'Nagpur', 'lastChild':'Dec 2024','spacing':'12','status':'followup', 'remarks':'Counsel needed'},
    {'wifeName':'Anita Yadav',    'phone':'9800003333','village':'Hingna', 'lastChild':'Oct 2024','spacing':'8', 'status':'followup', 'remarks':'Too soon'},
    {'wifeName':'Rekha Deshmukh', 'phone':'9800004444','village':'Wardha', 'lastChild':'Aug 2022','spacing':'30','status':'ideal',    'remarks':''},
  ];

  final _sc = TextEditingController();
  String _q = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != 'all' && c['status'] != _filter) return false;
    if (_q.isEmpty) return true;
    final q = _q.toLowerCase();
    return c['wifeName']!.toLowerCase().contains(q) ||
        c['village']!.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          _StatPill('${_list.length}',                                          _ft('total'),    _kBS),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c)=>c['status']=='ideal').length}',        _ft('ideal'),    kGreen),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c)=>c['status']=='followup').length}',     _ft('followup'), kOrange),
        ]),
      ),
      buildSearchBar(controller: _sc, hint: 'Search name, village…', color: _kBS,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _filter, color: _kBS, count: list.length,
          chips: [
            {'label': _ft('all'),      'value': 'all'},
            {'label': _ft('ideal'),    'value': 'ideal'},
            {'label': _ft('followup'), 'value': 'followup'},
          ],
          onTap: (v) => setState(() => _filter = v)),
      Builder(builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: _AddBtn(_ft('addSpacing'), _kBS, () => _addDialog(ctx)),
      )),
      const SizedBox(height: 8),
      Expanded(
        child: list.isEmpty ? emptyState(_q) : ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final c = list[i];
            final months = int.tryParse(c['spacing'] ?? '0') ?? 0;
            final col = months >= 24 ? kGreen : months >= 18 ? kOrange : kRed;
            return _SpacingCard(data: c, statusColor: col,
                onWA: () => _sendWA(ctx, c['phone']!, _spacingWAMsg(c)));
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _SpacingDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

class _SpacingCard extends StatefulWidget {
  final Map<String, String> data;
  final Color statusColor;
  final VoidCallback onWA;
  const _SpacingCard({required this.data, required this.statusColor, required this.onWA});
  @override State<_SpacingCard> createState() => _SpacingCardState();
}

class _SpacingCardState extends State<_SpacingCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final sc = widget.statusColor;
    final months = int.tryParse(c['spacing'] ?? '0') ?? 0;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sc.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: _kBSL, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.calendar_month_rounded, color: _kBS, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['wifeName']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
              Text('🏘 ${c['village']}  •  📅 ${c['lastChild']}',
                  style: const TextStyle(fontSize: 11, color: kMuted)),
            ])),
            // Spacing circle indicator
            Container(width: 46, height: 46,
              decoration: BoxDecoration(color: sc.withOpacity(0.12), shape: BoxShape.circle,
                  border: Border.all(color: sc, width: 2)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$months', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: sc)),
                Text('mo', style: TextStyle(fontSize: 8, color: sc)),
              ])),
          ]),
          const SizedBox(height: 8),
          // Progress bar for spacing
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (months / 36).clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(sc),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(months >= 24 ? '✅ ${_ft('ideal')}' : '⚠️ ${_ft('followup')} — Counsel for spacing',
              style: TextStyle(fontSize: 10, color: sc, fontWeight: FontWeight.w600)),
          if (_expanded) ...[
            const SizedBox(height: 8),
            const Divider(color: kBorder),
            _IR(Icons.phone_rounded, c['phone']!, kGreen),
            if (c['remarks']!.isNotEmpty) ...[
              const SizedBox(height: 5),
              _IR(Icons.notes_rounded, c['remarks']!, kMuted),
            ],
            const SizedBox(height: 10),
            _WABtn(widget.onWA),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: kMuted, size: 18),
          ]),
        ]),
      ),
    );
  }
}

class _SpacingDialog extends StatefulWidget {
  const _SpacingDialog();
  @override State<_SpacingDialog> createState() => _SpacingDialogState();
}

class _SpacingDialogState extends State<_SpacingDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _wC  = TextEditingController();
  final _phC = TextEditingController();
  final _vlC = TextEditingController();
  final _lcC = TextEditingController();
  final _spC = TextEditingController();
  final _rmC = TextEditingController();

  void _save() {
    if (!(_fk.currentState?.validate() ?? false)) return;
    final months = int.tryParse(_spC.text.trim()) ?? 0;
    Navigator.pop(context, {
      'wifeName': _wC.text.trim(), 'phone': _phC.text.trim(),
      'village': _vlC.text.trim(), 'lastChild': _lcC.text.trim(),
      'spacing': _spC.text.trim(), 'remarks': _rmC.text.trim(),
      'status': months >= 24 ? 'ideal' : 'followup',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key: _fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DHeader(icon: Icons.calendar_month_rounded, color: _kBS, colorLight: _kBSL,
              title: _ft('birthSpacing'), ctx: context),
          const SizedBox(height: 12),
          buildLangBar(_kBS), const SizedBox(height: 8),
          buildListeningBanner(_kBS),
          sectionLabel('📅 ${_ft('birthSpacing')}', _kBS),
          voiceField(fieldKey: 'wn', controller: _wC, label: _ft('wifeName'),
              icon: Icons.person_outline, color: _kBS,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ph', controller: _phC, label: _ft('phone'),
              icon: Icons.phone_outlined, color: _kBS,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'vl', controller: _vlC, label: _ft('village'),
              icon: Icons.location_on_outlined, color: _kBS),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'lc', controller: _lcC, label: _ft('lastChild'),
              icon: Icons.child_friendly_rounded, color: _kBS),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'sp', controller: _spC, label: _ft('spacing'),
              icon: Icons.timelapse_rounded, color: _kBS,
              keyboard: TextInputType.number, maxLen: 2,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'rm', controller: _rmC, label: _ft('remarks'),
              icon: Icons.notes_rounded, color: _kBS),
          const SizedBox(height: 14),
          buildMicHint(_kBS, _kBSL),
          const SizedBox(height: 14),
          buildDialogButtons(ctx: context, color: _kBS, onSave: _save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB 5 — CONTRACEPTIVE RECORD  (गर्भनिरोधक साधने नोंद)
// ══════════════════════════════════════════════════════════
const _kC  = Color(0xFFD97706);
const _kCL = Color(0xFFFEF3C7);

class _ContraceptiveTab extends StatefulWidget {
  const _ContraceptiveTab();
  @override State<_ContraceptiveTab> createState() => _ContraceptiveTabState();
}

class _ContraceptiveTabState extends State<_ContraceptiveTab> {
  final List<Map<String, String>> _list = [
    {'wifeName':'Sunita Patil',  'phone':'9800001111','village':'Wardha', 'contraDevice':'Copper-T (IUD)',   'givenDate':'10 Jan 2025','nextVisit':'10 Jul 2025','status':'active',  'accepted':'yes'},
    {'wifeName':'Meera Singh',   'phone':'9800002222','village':'Nagpur', 'contraDevice':'Oral Contraceptive Pills','givenDate':'05 Feb 2025','nextVisit':'05 Mar 2025','status':'active','accepted':'yes'},
    {'wifeName':'Lata Deshmukh', 'phone':'9800004444','village':'Wardha', 'contraDevice':'Condom (Male)',    'givenDate':'15 Jan 2025','nextVisit':'15 Feb 2025','status':'followup','accepted':'yes'},
    {'wifeName':'Rita Sharma',   'phone':'9800005555','village':'Hingna', 'contraDevice':'None',             'givenDate':'—','nextVisit':'—','status':'followup','accepted':'no'},
  ];

  final _sc = TextEditingController();
  String _q = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
    if (_filter != 'all' && c['status'] != _filter) return false;
    if (_q.isEmpty) return true;
    final q = _q.toLowerCase();
    return c['wifeName']!.toLowerCase().contains(q) ||
        c['village']!.toLowerCase().contains(q) ||
        c['contraDevice']!.toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Material(color: kBg, child: Column(children: [
      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          _StatPill('${_list.length}',                                            _ft('total'),    _kC),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['accepted']=='yes').length}',        _ft('accepted'), kGreen),
          const SizedBox(width: 8),
          _StatPill('${_list.where((c) => c['accepted']=='no').length}',         _ft('refused'),  kRed),
        ]),
      ),
      buildSearchBar(controller: _sc, hint: 'Search name, device, village…', color: _kC,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _filter, color: _kC, count: list.length,
          chips: [
            {'label': _ft('all'),      'value': 'all'},
            {'label': _ft('active'),   'value': 'active'},
            {'label': _ft('followup'), 'value': 'followup'},
          ],
          onTap: (v) => setState(() => _filter = v)),
      Builder(builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: _AddBtn(_ft('addContra'), _kC, () => _addDialog(ctx)),
      )),
      const SizedBox(height: 8),
      Expanded(
        child: list.isEmpty ? emptyState(_q) : ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final c = list[i];
            return _ContraCard(data: c);
          },
        ),
      ),
    ]));
  }

  Future<void> _addDialog(BuildContext ctx) async {
    final r = await showDialog<Map<String,String>>(context: ctx, barrierDismissible: false, builder: (_) => const _ContraDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
}

class _ContraCard extends StatefulWidget {
  final Map<String, String> data;
  const _ContraCard({required this.data});
  @override State<_ContraCard> createState() => _ContraCardState();
}

class _ContraCardState extends State<_ContraCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final accepted = c['accepted'] == 'yes';
    final sc = c['status'] == 'followup' ? kOrange : kGreen;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sc.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: _kCL, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.medication_liquid_rounded, color: _kC, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['wifeName']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
              Text('💊 ${c['contraDevice']}  •  🏘 ${c['village']}',
                  style: const TextStyle(fontSize: 11, color: kMuted)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (accepted ? kGreen : kRed).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8)),
              child: Text(accepted ? '✓ ${_ft('accepted')}' : '✗ ${_ft('refused')}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      color: accepted ? kGreen : kRed))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            _IR(Icons.event_rounded, '${_ft('givenDate')}: ${c['givenDate']}', _kC),
            const SizedBox(width: 12),
            _IR(Icons.event_available_rounded, '${_ft('nextVisit')}: ${c['nextVisit']}', kOrange),
          ]),
          if (_expanded) ...[
            const SizedBox(height: 8),
            const Divider(color: kBorder),
            _IR(Icons.phone_rounded, c['phone']!, kGreen),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                color: kMuted, size: 18),
          ]),
        ]),
      ),
    );
  }
}

class _ContraDialog extends StatefulWidget {
  const _ContraDialog();
  @override State<_ContraDialog> createState() => _ContraDialogState();
}

class _ContraDialogState extends State<_ContraDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _wC  = TextEditingController();
  final _phC = TextEditingController();
  final _vlC = TextEditingController();
  final _cdC = TextEditingController();
  final _gdC = TextEditingController();
  final _nvC = TextEditingController();
  bool _accepted = true;

  void _save() {
    if (!(_fk.currentState?.validate() ?? false)) return;
    Navigator.pop(context, {
      'wifeName': _wC.text.trim(), 'phone': _phC.text.trim(),
      'village': _vlC.text.trim(), 'contraDevice': _cdC.text.trim(),
      'givenDate': _gdC.text.trim(), 'nextVisit': _nvC.text.trim(),
      'status': 'active', 'accepted': _accepted ? 'yes' : 'no',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12),
      content: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(18), child: Form(key: _fk, child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _DHeader(icon: Icons.medication_liquid_rounded, color: _kC, colorLight: _kCL,
              title: _ft('contraceptive'), ctx: context),
          const SizedBox(height: 12),
          buildLangBar(_kC), const SizedBox(height: 8),
          buildListeningBanner(_kC),
          sectionLabel('💊 ${_ft('contraceptive')}', _kC),
          voiceField(fieldKey: 'wn', controller: _wC, label: _ft('wifeName'),
              icon: Icons.person_outline, color: _kC,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'ph', controller: _phC, label: _ft('phone'),
              icon: Icons.phone_outlined, color: _kC,
              keyboard: TextInputType.phone, maxLen: 10,
              formatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'vl', controller: _vlC, label: _ft('village'),
              icon: Icons.location_on_outlined, color: _kC),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _cdC.text.isEmpty ? null : _cdC.text,
            decoration: InputDecoration(
              labelText: _ft('contraDevice'),
              prefixIcon: const Icon(Icons.medication_liquid_rounded, size: 18, color: _kC),
              filled: true, fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _kC, width: 1.5)),
            ),
            hint: Text('Select Contraceptive', style: TextStyle(fontSize: 12, color: kMuted)),
            items: _kFpMethods.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) { if (v != null) setState(() => _cdC.text = v); },
            validator: (v) => v == null || v.isEmpty ? 'Select a device' : null,
          ),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'gd', controller: _gdC, label: _ft('givenDate'),
              icon: Icons.event_rounded, color: _kC),
          const SizedBox(height: 8),
          voiceField(fieldKey: 'nv', controller: _nvC, label: _ft('nextVisit'),
              icon: Icons.event_available_rounded, color: _kC),
          const SizedBox(height: 12),
          // Accepted toggle
          Row(children: [
            Text(_ft('accepted'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kText)),
            const SizedBox(width: 12),
            _Chip(_ft('accepted'), _accepted,   kGreen,  () => setState(() => _accepted = true)),
            const SizedBox(width: 8),
            _Chip(_ft('refused'),  !_accepted,  kRed,    () => setState(() => _accepted = false)),
          ]),
          const SizedBox(height: 14),
          buildMicHint(_kC, _kCL),
          const SizedBox(height: 14),
          buildDialogButtons(ctx: context, color: _kC, onSave: _save),
        ]))),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPER WIDGETS  (same as vaccination page)
// ══════════════════════════════════════════════════════════

class _IR extends StatelessWidget {
  final IconData icon; final String text; final Color color;
  const _IR(this.icon, this.text, this.color);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 13, color: color), const SizedBox(width: 5),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 11.5, color: kText))),
  ]);
}

class _StatPill extends StatelessWidget {
  final String value, label; final Color color;
  const _StatPill(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 9, color: kMuted), textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label; final bool selected; final Color color; final VoidCallback onTap;
  const _Chip(this.label, this.selected, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: selected ? Colors.white : color)),
    ),
  );
}

class _WABtn extends StatelessWidget {
  final VoidCallback onTap;
  const _WABtn(this.onTap);
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.chat_rounded, size: 15, color: Color(0xFF25D366)),
    label: Text(_ft('sendWA'), style: const TextStyle(fontSize: 12)),
    style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF25D366),
        side: const BorderSide(color: Color(0xFF25D366)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
  );
}

class _AddBtn extends StatelessWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _AddBtn(this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 13),
      ),
    ),
  );
}

class _DHeader extends StatelessWidget {
  final IconData icon; final Color color, colorLight;
  final String title; final BuildContext ctx;
  const _DHeader({required this.icon, required this.color, required this.colorLight, required this.title, required this.ctx});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: colorLight, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20)),
    const SizedBox(width: 10),
    Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800))),
    GestureDetector(onTap: () => Navigator.pop(ctx), child: const Icon(Icons.close_rounded, color: Colors.grey)),
  ]);
}