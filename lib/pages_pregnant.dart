import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'pages_dashboard.dart';
import 'voice_mixin.dart';

// ══════════════════════════════════════════════════════════
//  TRANSLATION MAP  (Marathi / Hindi / English)
// ══════════════════════════════════════════════════════════
const Map<String, Map<String, String>> _maternalTrans = {
  'maternalHealth':  {'mr': 'मातृत्व आरोग्य सेवा', 'hi': 'मातृ स्वास्थ्य सेवा',      'en': 'Maternal Health'},
  'jsyBeneficiary':  {'mr': 'JSY लाभार्थी माहिती',  'hi': 'JSY लाभार्थी जानकारी',     'en': 'JSY Beneficiaries'},
  'pregnantList':    {'mr': 'गर्भवती महिला यादी',    'hi': 'गर्भवती महिला सूची',       'en': 'Pregnant Women List'},
  'ancRecord':       {'mr': 'ANC नोंद',              'hi': 'ANC रिकॉर्ड',              'en': 'ANC Record'},
  'prenatalCheck':   {'mr': 'प्रसूतीपूर्व तपासणी',  'hi': 'प्रसव पूर्व जांच',         'en': 'Prenatal Checkup'},
  'deliveryRecord':  {'mr': 'प्रसूती नोंद',          'hi': 'प्रसव रिकॉर्ड',            'en': 'Delivery Record'},
  'highRiskMothers': {'mr': 'उच्च जोखीम गर्भवती',   'hi': 'उच्च जोखिम गर्भवती',      'en': 'High Risk Mothers'},
  'mmvy':            {'mr': 'मातृत्व वंदना योजना',   'hi': 'मातृत्व वंदना योजना',      'en': 'Matritva Vandana Yojana'},
  'postnatal':       {'mr': 'प्रसूतीनंतरची माहिती',  'hi': 'प्रसव के बाद की जानकारी', 'en': 'Postnatal Info'},
  'name':            {'mr': 'नाव',                   'hi': 'नाम',                      'en': 'Name'},
  'husbandName':     {'mr': 'पतीचे नाव',             'hi': 'पति का नाम',               'en': 'Husband Name'},
  'phone':           {'mr': 'फोन',                   'hi': 'फ़ोन',                     'en': 'Phone'},
  'village':         {'mr': 'गाव',                   'hi': 'गांव',                     'en': 'Village'},
  'bloodGroup':      {'mr': 'रक्त गट',               'hi': 'रक्त समूह',                'en': 'Blood Group'},
  'weightKg':        {'mr': 'वजन (किलो)',             'hi': 'वजन (किलो)',               'en': 'Weight (kg)'},
  'trimester':       {'mr': 'तिमाही',                'hi': 'तिमाही',                   'en': 'Trimester'},
  'dueDate':         {'mr': 'अपेक्षित तारीख',         'hi': 'नियत तारीख',               'en': 'Due Date'},
  'highRisk':        {'mr': 'उच्च जोखीम',            'hi': 'उच्च जोखिम',               'en': 'High Risk'},
  'normal':          {'mr': 'सामान्य',               'hi': 'सामान्य',                  'en': 'Normal'},
  'save':            {'mr': 'जतन करा',               'hi': 'सहेजें',                   'en': 'Save'},
  'cancel':          {'mr': 'रद्द करा',              'hi': 'रद्द करें',                'en': 'Cancel'},
  'jsyAmount':       {'mr': 'JSY रक्कम',             'hi': 'JSY राशि',                 'en': 'JSY Amount'},
  'bankAcc':         {'mr': 'बँक खाते',              'hi': 'बैंक खाता',                'en': 'Bank Account'},
  'installment':     {'mr': 'हप्ता',                 'hi': 'किस्त',                    'en': 'Installment'},
  'ancVisit':        {'mr': 'ANC भेट',               'hi': 'ANC विजिट',                'en': 'ANC Visit'},
  'bp':              {'mr': 'रक्तदाब',               'hi': 'रक्तचाप',                  'en': 'Blood Pressure'},
  'hb':              {'mr': 'हिमोग्लोबिन',           'hi': 'हीमोग्लोबिन',              'en': 'Hemoglobin'},
  'deliveryType':    {'mr': 'प्रसूती प्रकार',        'hi': 'प्रसव प्रकार',             'en': 'Delivery Type'},
  'babyWeight':      {'mr': 'बाळाचे वजन',            'hi': 'शिशु का वजन',              'en': 'Baby Weight'},
  'complications':   {'mr': 'गुंतागुंत',             'hi': 'जटिलताएं',                 'en': 'Complications'},
  'pncVisit':        {'mr': 'PNC भेट',               'hi': 'PNC विजिट',                'en': 'PNC Visit'},
  'breastfeeding':   {'mr': 'स्तनपान',               'hi': 'स्तनपान',                  'en': 'Breastfeeding'},
  'riskFactor':      {'mr': 'जोखीम कारण',            'hi': 'जोखिम कारण',               'en': 'Risk Factor'},
  'referredTo':      {'mr': 'संदर्भित',              'hi': 'रेफर किया',                'en': 'Referred To'},
  'mvvyStatus':      {'mr': 'MVY स्थिती',            'hi': 'MVY स्थिति',               'en': 'MVVY Status'},
  'addRecord':       {'mr': 'नोंद जोडा',             'hi': 'रिकॉर्ड जोड़ें',           'en': 'Add Record'},
  'search':          {'mr': 'शोधा',                  'hi': 'खोजें',                    'en': 'Search'},
};

String _mt(String key) {
  final lang = langNotifier.value;
  return _maternalTrans[key]?[lang] ?? _maternalTrans[key]?['en'] ?? key;
}

// ══════════════════════════════════════════════════════════
//  COLOR CONSTANTS
// ══════════════════════════════════════════════════════════
const kMatPink      = Color(0xFFE91E8C);
const kMatPinkLight = Color(0xFFFCE4F1);
const kMatPurple    = Color(0xFF7C3AED);
const kMatTeal      = Color(0xFF0891B2);
const kMatGreen     = Color(0xFF16A34A);
const kMatRed       = Color(0xFFDC2626);
const kMatOrange    = Color(0xFFD97706);
const kMatBlue      = Color(0xFF1D4ED8);

// ══════════════════════════════════════════════════════════
//  MAIN PREGNANT PAGE  (Tab index: 2)
// ══════════════════════════════════════════════════════════
class PregnantPage extends StatefulWidget {
  const PregnantPage({super.key});
  @override
  State<PregnantPage> createState() => _PregnantPageState();
}

class _PregnantPageState extends State<PregnantPage> {
  int _selectedSubTab = 0;

  final List<_SubTabItem> _subTabs = [
    _SubTabItem(icon: Icons.star_outline_rounded,       labelKey: 'jsyBeneficiary',  color: kMatOrange),
    _SubTabItem(icon: Icons.pregnant_woman_rounded,      labelKey: 'pregnantList',    color: kMatPink),
    _SubTabItem(icon: Icons.assignment_outlined,         labelKey: 'ancRecord',       color: kMatBlue),
    _SubTabItem(icon: Icons.medical_services_outlined,   labelKey: 'prenatalCheck',   color: kMatTeal),
    _SubTabItem(icon: Icons.local_hospital_outlined,     labelKey: 'deliveryRecord',  color: kMatPurple),
    _SubTabItem(icon: Icons.warning_amber_rounded,       labelKey: 'highRiskMothers', color: kMatRed),
    _SubTabItem(icon: Icons.account_balance_wallet_outlined, labelKey: 'mmvy',        color: kMatGreen),
    _SubTabItem(icon: Icons.favorite_border_rounded,     labelKey: 'postnatal',       color: Color(0xFFDB2777)),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Container(color: kBg, child: Column(children: [
        // ── Main Header ──
        PageHeader(
          title: _mt('maternalHealth'),
          color: kMatPink,
          icon: Icons.pregnant_woman_rounded,
        ),

        // ── Sub-tab horizontal scroll ──
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(_subTabs.length, (i) {
                final tab = _subTabs[i];
                final active = _selectedSubTab == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSubTab = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? tab.color : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? tab.color : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(children: [
                      Icon(tab.icon,
                          size: 15,
                          color: active ? Colors.white : tab.color),
                      const SizedBox(width: 6),
                      Text(
                        _mt(tab.labelKey),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : tab.color,
                        ),
                      ),
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
        const Divider(height: 1, color: kBorder),

        // ── Sub-page content ──
        Expanded(child: _buildSubPage(_selectedSubTab)),
      ]));
    );
  }

  Widget _buildSubPage(int index) {
    switch (index) {
      case 0: return const JsyBeneficiaryPage();
      case 1: return const PregnantListPage();
      case 2: return const AncRecordPage();
      case 3: return const PrenatalCheckPage();
      case 4: return const DeliveryRecordPage();
      case 5: return const HighRiskMothersPage();
      case 6: return const MmvyPage();
      case 7: return const PostnatalPage();
      default: return const PregnantListPage();
    }
  }
}

class _SubTabItem {
  final IconData icon;
  final String labelKey;
  final Color color;
  const _SubTabItem({required this.icon, required this.labelKey, required this.color});
}

// ══════════════════════════════════════════════════════════
//  1.  JSY BENEFICIARY PAGE
// ══════════════════════════════════════════════════════════
class JsyBeneficiaryPage extends StatefulWidget {
  const JsyBeneficiaryPage({super.key});
  @override
  State<JsyBeneficiaryPage> createState() => _JsyBeneficiaryPageState();
}

class _JsyBeneficiaryPageState extends State<JsyBeneficiaryPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma',  'village': 'Wardha',  'phone': '9876500001', 'installment': '2nd', 'amount': '1400', 'bankAcc': 'SBI...4521', 'status': 'paid'},
    {'name': 'Sunita Yadav',   'village': 'Nagpur',  'phone': '9876500004', 'installment': '1st', 'amount': '1000', 'bankAcc': 'BOB...7821', 'status': 'pending'},
    {'name': 'Rekha Bai',      'village': 'Hingna',  'phone': '9876500005', 'installment': '3rd', 'amount': '2000', 'bankAcc': 'PNB...3312', 'status': 'paid'},
  ];

  final _searchC = TextEditingController();
  String _query = '';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const JsyDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('jsyBeneficiary'), kMatOrange, Icons.star_outline_rounded, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village…', color: kMatOrange,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            final isPaid = w['status'] == 'paid';
            return _card(
              color: kMatOrange,
              icon: Icons.star_outline_rounded,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: isPaid ? 'Paid' : 'Pending',
              statusColor: isPaid ? kMatGreen : kMatRed,
              details: [
                _detail(Icons.receipt_long_outlined, '${_mt('installment')}: ${w['installment']}'),
                _detail(Icons.currency_rupee_rounded, '₹${w['amount']}'),
                _detail(Icons.account_balance_outlined, w['bankAcc']!),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  2.  PREGNANT LIST PAGE  (original, enhanced)
// ══════════════════════════════════════════════════════════
class PregnantListPage extends StatefulWidget {
  const PregnantListPage({super.key});
  @override
  State<PregnantListPage> createState() => _PregnantListPageState();
}

class _PregnantListPageState extends State<PregnantListPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma', 'trimester': '3rd', 'due': 'Mar 2025', 'risk': 'high',   'husband': 'Suresh Sharma', 'phone': '9876500001', 'blood': 'B+', 'weight': '68', 'lastCheckup': '20 Feb', 'village': 'Wardha'},
    {'name': 'Priya Patil',   'trimester': '2nd', 'due': 'May 2025', 'risk': 'normal', 'husband': 'Ajay Patil',   'phone': '9876500002', 'blood': 'O+', 'weight': '55', 'lastCheckup': '15 Feb', 'village': 'Nagpur'},
    {'name': 'Asha Devi',     'trimester': '1st', 'due': 'Jul 2025', 'risk': 'normal', 'husband': 'Ramesh Devi',  'phone': '9876500003', 'blood': 'A+', 'weight': '52', 'lastCheckup': '10 Feb', 'village': 'Hingna'},
  ];

  final _searchC = TextEditingController();
  String _query = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_filter != 'all' && w['risk'] != _filter) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) ||
        w['village']!.toLowerCase().contains(q) ||
        w['phone']!.contains(q) ||
        w['husband']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const PregnantDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('pregnantList'), kMatPink, Icons.pregnant_woman_rounded, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village, phone…', color: kMatPink,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      buildFilterChips(
        current: _filter, color: kMatPink, count: filtered.length,
        chips: [
          {'label': 'All',       'value': 'all'},
          {'label': 'High Risk', 'value': 'high'},
          {'label': 'Normal',    'value': 'normal'},
        ],
        onTap: (v) => setState(() => _filter = v),
      ),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            final isHigh = w['risk'] == 'high';
            return _card(
              color: kMatPink,
              icon: Icons.pregnant_woman_rounded,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: isHigh ? _mt('highRisk') : _mt('normal'),
              statusColor: isHigh ? kMatRed : kMatGreen,
              details: [
                _detail(Icons.calendar_today_outlined, '${w['trimester']} ${_mt('trimester')}'),
                _detail(Icons.schedule_outlined, w['due']!),
                _detail(Icons.water_drop_outlined, 'Blood: ${w['blood']}'),
                _detail(Icons.monitor_weight_outlined, '${w['weight']} kg'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  3.  ANC RECORD PAGE
// ══════════════════════════════════════════════════════════
class AncRecordPage extends StatefulWidget {
  const AncRecordPage({super.key});
  @override
  State<AncRecordPage> createState() => _AncRecordPageState();
}

class _AncRecordPageState extends State<AncRecordPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma', 'village': 'Wardha',  'phone': '9876500001', 'visit': '3rd', 'date': '20 Feb 2025', 'bp': '120/80', 'hb': '10.5', 'weight': '68', 'remarks': 'Normal'},
    {'name': 'Priya Patil',   'village': 'Nagpur',  'phone': '9876500002', 'visit': '2nd', 'date': '15 Feb 2025', 'bp': '110/70', 'hb': '11.2', 'weight': '55', 'remarks': 'Good'},
  ];

  final _searchC = TextEditingController();
  String _query = '';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const AncDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('ancRecord'), kMatBlue, Icons.assignment_outlined, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village…', color: kMatBlue,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            return _card(
              color: kMatBlue,
              icon: Icons.assignment_outlined,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: '${w['visit']} ${_mt('ancVisit')}',
              statusColor: kMatBlue,
              details: [
                _detail(Icons.calendar_today_outlined, w['date']!),
                _detail(Icons.favorite_outlined, 'BP: ${w['bp']}'),
                _detail(Icons.bloodtype_outlined, 'Hb: ${w['hb']} g/dL'),
                _detail(Icons.monitor_weight_outlined, '${w['weight']} kg'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  4.  PRENATAL CHECKUP PAGE
// ══════════════════════════════════════════════════════════
class PrenatalCheckPage extends StatefulWidget {
  const PrenatalCheckPage({super.key});
  @override
  State<PrenatalCheckPage> createState() => _PrenatalCheckPageState();
}

class _PrenatalCheckPageState extends State<PrenatalCheckPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma',  'village': 'Wardha', 'phone': '9876500001', 'date': '20 Feb 2025', 'bp': '130/85', 'hb': '9.8',  'weight': '70', 'urine': 'Normal', 'tdi': 'Given', 'ifa': 'Yes', 'status': 'high'},
    {'name': 'Sunita Yadav',   'village': 'Nagpur', 'phone': '9876500004', 'date': '18 Feb 2025', 'bp': '115/75', 'hb': '11.5', 'weight': '58', 'urine': 'Normal', 'tdi': 'Given', 'ifa': 'Yes', 'status': 'normal'},
  ];

  final _searchC = TextEditingController();
  String _query = '';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const PrenatalDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('prenatalCheck'), kMatTeal, Icons.medical_services_outlined, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village…', color: kMatTeal,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            final isHigh = w['status'] == 'high';
            return _card(
              color: kMatTeal,
              icon: Icons.medical_services_outlined,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: isHigh ? _mt('highRisk') : _mt('normal'),
              statusColor: isHigh ? kMatRed : kMatGreen,
              details: [
                _detail(Icons.calendar_today_outlined, w['date']!),
                _detail(Icons.favorite_outlined, 'BP: ${w['bp']}'),
                _detail(Icons.bloodtype_outlined, 'Hb: ${w['hb']} g/dL'),
                _detail(Icons.science_outlined, 'Urine: ${w['urine']}'),
                _detail(Icons.vaccines_outlined, 'TDI: ${w['tdi']} | IFA: ${w['ifa']}'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  5.  DELIVERY RECORD PAGE
// ══════════════════════════════════════════════════════════
class DeliveryRecordPage extends StatefulWidget {
  const DeliveryRecordPage({super.key});
  @override
  State<DeliveryRecordPage> createState() => _DeliveryRecordPageState();
}

class _DeliveryRecordPageState extends State<DeliveryRecordPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Meena Thakur',   'village': 'Wardha',  'phone': '9876500006', 'date': '10 Feb 2025', 'type': 'Normal',    'place': 'PHC Wardha',     'babyWeight': '3.1', 'gender': 'Girl', 'complications': 'None'},
    {'name': 'Lata Wankhede',  'village': 'Hingna',  'phone': '9876500007', 'date': '05 Feb 2025', 'type': 'C-Section', 'place': 'District Hospital', 'babyWeight': '2.8', 'gender': 'Boy',  'complications': 'Anemia'},
  ];

  final _searchC = TextEditingController();
  String _query = '';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const DeliveryDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('deliveryRecord'), kMatPurple, Icons.local_hospital_outlined, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village…', color: kMatPurple,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            final isCSection = w['type'] == 'C-Section';
            return _card(
              color: kMatPurple,
              icon: Icons.local_hospital_outlined,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: w['type']!,
              statusColor: isCSection ? kMatOrange : kMatGreen,
              details: [
                _detail(Icons.calendar_today_outlined, w['date']!),
                _detail(Icons.place_outlined, w['place']!),
                _detail(Icons.child_care_outlined, '${w['gender']} | ${w['babyWeight']} kg'),
                if (w['complications'] != 'None')
                  _detail(Icons.warning_amber_outlined, 'Complication: ${w['complications']}'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  6.  HIGH RISK MOTHERS PAGE
// ══════════════════════════════════════════════════════════
class HighRiskMothersPage extends StatefulWidget {
  const HighRiskMothersPage({super.key});
  @override
  State<HighRiskMothersPage> createState() => _HighRiskMothersPageState();
}

class _HighRiskMothersPageState extends State<HighRiskMothersPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma',  'village': 'Wardha',  'phone': '9876500001', 'trimester': '3rd', 'riskFactor': 'Hypertension', 'referredTo': 'District Hospital', 'lastCheckup': '20 Feb', 'blood': 'B+'},
    {'name': 'Lata Wankhede',  'village': 'Hingna',  'phone': '9876500007', 'trimester': '2nd', 'riskFactor': 'Severe Anemia', 'referredTo': 'PHC Wardha',        'lastCheckup': '15 Feb', 'blood': 'O-'},
    {'name': 'Suman Borse',    'village': 'Umred',   'phone': '9876500008', 'trimester': '3rd', 'riskFactor': 'Diabetes',       'referredTo': 'CHC Umred',         'lastCheckup': '12 Feb', 'blood': 'AB+'},
  ];

  final _searchC = TextEditingController();
  String _query = '';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) ||
        w['riskFactor']!.toLowerCase().contains(q) ||
        w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const HighRiskDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('highRiskMothers'), kMatRed, Icons.warning_amber_rounded, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, risk factor…', color: kMatRed,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            return _card(
              color: kMatRed,
              icon: Icons.warning_amber_rounded,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: _mt('highRisk'),
              statusColor: kMatRed,
              details: [
                _detail(Icons.dangerous_outlined, '${_mt('riskFactor')}: ${w['riskFactor']}'),
                _detail(Icons.local_hospital_outlined, '${_mt('referredTo')}: ${w['referredTo']}'),
                _detail(Icons.calendar_today_outlined, 'Last: ${w['lastCheckup']}'),
                _detail(Icons.water_drop_outlined, 'Blood: ${w['blood']}'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  7.  MMVY PAGE  (Matritva Vandana Yojana)
// ══════════════════════════════════════════════════════════
class MmvyPage extends StatefulWidget {
  const MmvyPage({super.key});
  @override
  State<MmvyPage> createState() => _MmvyPageState();
}

class _MmvyPageState extends State<MmvyPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma', 'village': 'Wardha',  'phone': '9876500001', 'installment': '2nd', 'amount': '2000', 'bankAcc': 'SBI...4521', 'status': 'received', 'regDate': '01 Jan 2025'},
    {'name': 'Asha Devi',     'village': 'Hingna',  'phone': '9876500003', 'installment': '1st', 'amount': '1000', 'bankAcc': 'BOB...9841', 'status': 'pending',  'regDate': '10 Feb 2025'},
    {'name': 'Rekha Bai',     'village': 'Wardha',  'phone': '9876500005', 'installment': '3rd', 'amount': '2000', 'bankAcc': 'PNB...3312', 'status': 'received', 'regDate': '15 Dec 2024'},
  ];

  final _searchC = TextEditingController();
  String _query = '', _filter = 'all';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_filter != 'all' && w['status'] != _filter) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const MmvyDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('mmvy'), kMatGreen, Icons.account_balance_wallet_outlined, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village…', color: kMatGreen,
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      buildFilterChips(
        current: _filter, color: kMatGreen, count: filtered.length,
        chips: [
          {'label': 'All',      'value': 'all'},
          {'label': 'Received', 'value': 'received'},
          {'label': 'Pending',  'value': 'pending'},
        ],
        onTap: (v) => setState(() => _filter = v),
      ),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            final isReceived = w['status'] == 'received';
            return _card(
              color: kMatGreen,
              icon: Icons.account_balance_wallet_outlined,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: isReceived ? 'Received' : 'Pending',
              statusColor: isReceived ? kMatGreen : kMatRed,
              details: [
                _detail(Icons.receipt_long_outlined, '${_mt('installment')}: ${w['installment']}'),
                _detail(Icons.currency_rupee_rounded, '₹${w['amount']}'),
                _detail(Icons.account_balance_outlined, w['bankAcc']!),
                _detail(Icons.calendar_today_outlined, 'Reg: ${w['regDate']}'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  8.  POSTNATAL PAGE
// ══════════════════════════════════════════════════════════
class PostnatalPage extends StatefulWidget {
  const PostnatalPage({super.key});
  @override
  State<PostnatalPage> createState() => _PostnatalPageState();
}

class _PostnatalPageState extends State<PostnatalPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Meena Thakur',  'village': 'Wardha', 'phone': '9876500006', 'deliveryDate': '10 Feb 2025', 'pncVisit': '2nd', 'breastfeeding': 'Yes', 'babyWeight': '3.2', 'motherWeight': '58', 'status': 'good'},
    {'name': 'Lata Wankhede', 'village': 'Hingna', 'phone': '9876500007', 'deliveryDate': '05 Feb 2025', 'pncVisit': '1st', 'breastfeeding': 'Yes', 'babyWeight': '2.9', 'motherWeight': '54', 'status': 'monitoring'},
  ];

  final _searchC = TextEditingController();
  String _query = '';

  List<Map<String, String>> get _filtered => _list.where((w) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final result = await showDialog<Map<String, String>>(
      context: context, barrierDismissible: false,
      builder: (_) => const PostnatalDialog(),
    );
    if (result != null && mounted) setState(() => _list.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(color: kBg, child: Column(children: [
      _subHeader(_mt('postnatal'), const Color(0xFFDB2777), Icons.favorite_border_rounded, onAdd: _add),
      buildSearchBar(controller: _searchC, hint: 'Search by name, village…', color: const Color(0xFFDB2777),
          onChanged: () => setState(() => _query = _searchC.text.trim())),
      Expanded(
        child: filtered.isEmpty ? emptyState(_query) : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final w = filtered[i];
            final isGood = w['status'] == 'good';
            return _card(
              color: const Color(0xFFDB2777),
              icon: Icons.favorite_border_rounded,
              name: w['name']!,
              village: w['village']!,
              phone: w['phone']!,
              statusLabel: isGood ? 'Good' : 'Monitoring',
              statusColor: isGood ? kMatGreen : kMatOrange,
              details: [
                _detail(Icons.calendar_today_outlined, 'Delivery: ${w['deliveryDate']}'),
                _detail(Icons.assignment_turned_in_outlined, '${_mt('pncVisit')}: ${w['pncVisit']}'),
                _detail(Icons.child_care_outlined, 'Baby: ${w['babyWeight']} kg'),
                _detail(Icons.favorite_outlined, '${_mt('breastfeeding')}: ${w['breastfeeding']}'),
                _detail(Icons.monitor_weight_outlined, 'Mother: ${w['motherWeight']} kg'),
              ],
            );
          },
        ),
      ),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════
Widget _subHeader(String title, Color color, IconData icon, {required VoidCallback onAdd}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    color: color.withOpacity(0.05),
    child: Row(children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color))),
      GestureDetector(
        onTap: onAdd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            const Icon(Icons.add, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(_mt('addRecord'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    ]),
  );
}

Widget _card({
  required Color color,
  required IconData icon,
  required String name,
  required String village,
  required String phone,
  required String statusLabel,
  required Color statusColor,
  required List<Widget> details,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.15)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 2),
          Row(children: [
            const Icon(Icons.location_on_outlined, size: 11, color: kMuted),
            const SizedBox(width: 2),
            Text(village, style: const TextStyle(fontSize: 11, color: kMuted)),
          ]),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(statusLabel,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
        ),
      ]),
      const SizedBox(height: 10),
      const Divider(height: 1, color: kBorder),
      const SizedBox(height: 8),
      Wrap(
        spacing: 12,
        runSpacing: 4,
        children: [
          if (phone.isNotEmpty)
            _detail(Icons.phone_outlined, phone),
          ...details,
        ],
      ),
    ]),
  );
}

Widget _detail(IconData icon, String text) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 12, color: kMuted),
    const SizedBox(width: 3),
    Text(text, style: const TextStyle(fontSize: 11, color: kMuted)),
  ]);
}

// ══════════════════════════════════════════════════════════
//  DIALOG: PREGNANT WOMAN  (Voice + Translator)
// ══════════════════════════════════════════════════════════
class PregnantDialog extends StatefulWidget {
  const PregnantDialog({super.key});
  @override
  State<PregnantDialog> createState() => _PregnantDialogState();
}

class _PregnantDialogState extends State<PregnantDialog> with VoiceDialogMixin {
  final _fk       = GlobalKey<FormState>();
  final _nameC    = TextEditingController();
  final _husbandC = TextEditingController();
  final _phoneC   = TextEditingController();
  final _villageC = TextEditingController();
  final _bloodC   = TextEditingController();
  final _weightC  = TextEditingController();

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _husbandC.dispose(); _phoneC.dispose();
    _villageC.dispose(); _bloodC.dispose(); _weightC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'husband': _husbandC.text.trim(),
      'phone': _phoneC.text.trim(), 'blood': _bloodC.text.trim().toUpperCase(),
      'weight': _weightC.text.trim(), 'village': _villageC.text.trim(),
      'trimester': '1st', 'due': 'TBD', 'risk': 'normal', 'lastCheckup': 'Today',
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatPink, lightColor: kMatPinkLight,
    icon: Icons.pregnant_woman_rounded, title: 'Add Pregnant Woman',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatPink),
      const SizedBox(height: 10),
      buildListeningBanner(kMatPink),
      sectionLabel("Mother's Info", kMatPink),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatPink,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Name required'; if (v.trim().length < 3) return 'Min 3 chars'; return null; }),
      const SizedBox(height: 10),
      voiceField(fieldKey: 'husband', controller: _husbandC, label: _mt('husbandName'), icon: Icons.person_outline, color: kMatPink,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatPink,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return '10 digits'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatPink,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Health Info', kMatPink),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'blood', controller: _bloodC, label: _mt('bloodGroup'), icon: Icons.water_drop_outlined, color: kMatPink,
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; if (!RegExp(r'^(A|B|AB|O)[+-]$', caseSensitive: false).hasMatch(v.trim())) return 'e.g. A+'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: _mt('weightKg'), icon: Icons.monitor_weight_outlined, color: kMatPink,
            keyboard: TextInputType.number, maxLen: 3, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; final w = int.tryParse(v); if (w == null || w < 30 || w > 150) return '30-150 kg'; return null; })),
      ]),
      const SizedBox(height: 14),
      buildMicHint(kMatPink, kMatPinkLight),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: JSY BENEFICIARY
// ══════════════════════════════════════════════════════════
class JsyDialog extends StatefulWidget {
  const JsyDialog({super.key});
  @override
  State<JsyDialog> createState() => _JsyDialogState();
}

class _JsyDialogState extends State<JsyDialog> with VoiceDialogMixin {
  final _fk          = GlobalKey<FormState>();
  final _nameC       = TextEditingController();
  final _phoneC      = TextEditingController();
  final _villageC    = TextEditingController();
  final _bankAccC    = TextEditingController();
  final _amountC     = TextEditingController();
  String _installment = '1st';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _bankAccC.dispose(); _amountC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(), 'bankAcc': _bankAccC.text.trim(),
      'amount': _amountC.text.trim(), 'installment': _installment, 'status': 'pending',
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatOrange, lightColor: kMatOrange.withOpacity(0.1),
    icon: Icons.star_outline_rounded, title: 'Add JSY Beneficiary',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatOrange),
      const SizedBox(height: 10),
      buildListeningBanner(kMatOrange),
      sectionLabel('Beneficiary Info', kMatOrange),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatOrange,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatOrange,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return '10 digits'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatOrange,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Payment Info', kMatOrange),
      voiceField(fieldKey: 'bankAcc', controller: _bankAccC, label: _mt('bankAcc'), icon: Icons.account_balance_outlined, color: kMatOrange,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'amount', controller: _amountC, label: _mt('jsyAmount'), icon: Icons.currency_rupee_rounded, color: kMatOrange,
            keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(
          label: _mt('installment'), color: kMatOrange,
          value: _installment, items: ['1st', '2nd', '3rd'],
          onChanged: (v) => setState(() => _installment = v!),
        )),
      ]),
      const SizedBox(height: 14),
      buildMicHint(kMatOrange, kMatOrange.withOpacity(0.1)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: ANC RECORD
// ══════════════════════════════════════════════════════════
class AncDialog extends StatefulWidget {
  const AncDialog({super.key});
  @override
  State<AncDialog> createState() => _AncDialogState();
}

class _AncDialogState extends State<AncDialog> with VoiceDialogMixin {
  final _fk       = GlobalKey<FormState>();
  final _nameC    = TextEditingController();
  final _phoneC   = TextEditingController();
  final _villageC = TextEditingController();
  final _bpC      = TextEditingController();
  final _hbC      = TextEditingController();
  final _weightC  = TextEditingController();
  final _remarksC = TextEditingController();
  String _visit = '1st';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _bpC.dispose(); _hbC.dispose(); _weightC.dispose(); _remarksC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(), 'visit': _visit,
      'date': '${now.day} ${_monthName(now.month)} ${now.year}',
      'bp': _bpC.text.trim(), 'hb': _hbC.text.trim(),
      'weight': _weightC.text.trim(), 'remarks': _remarksC.text.trim().isEmpty ? 'Normal' : _remarksC.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatBlue, lightColor: kMatBlue.withOpacity(0.08),
    icon: Icons.assignment_outlined, title: 'Add ANC Record',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatBlue),
      const SizedBox(height: 10),
      buildListeningBanner(kMatBlue),
      sectionLabel('Patient Info', kMatBlue),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatBlue,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatBlue,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatBlue,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('ANC Details', kMatBlue),
      Row(children: [
        Expanded(child: _dropdownField(
          label: _mt('ancVisit'), color: kMatBlue,
          value: _visit, items: ['1st', '2nd', '3rd', '4th'],
          onChanged: (v) => setState(() => _visit = v!),
        )),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'bp', controller: _bpC, label: _mt('bp'), icon: Icons.favorite_outlined, color: kMatBlue,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'hb', controller: _hbC, label: _mt('hb'), icon: Icons.bloodtype_outlined, color: kMatBlue,
            keyboard: TextInputType.number,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: _mt('weightKg'), icon: Icons.monitor_weight_outlined, color: kMatBlue,
            keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 10),
      voiceField(fieldKey: 'remarks', controller: _remarksC, label: 'Remarks', icon: Icons.notes_outlined, color: kMatBlue),
      const SizedBox(height: 14),
      buildMicHint(kMatBlue, kMatBlue.withOpacity(0.08)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: PRENATAL CHECKUP
// ══════════════════════════════════════════════════════════
class PrenatalDialog extends StatefulWidget {
  const PrenatalDialog({super.key});
  @override
  State<PrenatalDialog> createState() => _PrenatalDialogState();
}

class _PrenatalDialogState extends State<PrenatalDialog> with VoiceDialogMixin {
  final _fk       = GlobalKey<FormState>();
  final _nameC    = TextEditingController();
  final _phoneC   = TextEditingController();
  final _villageC = TextEditingController();
  final _bpC      = TextEditingController();
  final _hbC      = TextEditingController();
  final _weightC  = TextEditingController();
  String _urine = 'Normal', _tdi = 'Given', _ifa = 'Yes', _status = 'normal';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _bpC.dispose(); _hbC.dispose(); _weightC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(),
      'date': '${now.day} ${_monthName(now.month)} ${now.year}',
      'bp': _bpC.text.trim(), 'hb': _hbC.text.trim(), 'weight': _weightC.text.trim(),
      'urine': _urine, 'tdi': _tdi, 'ifa': _ifa, 'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatTeal, lightColor: kMatTeal.withOpacity(0.08),
    icon: Icons.medical_services_outlined, title: 'Add Prenatal Checkup',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatTeal),
      const SizedBox(height: 10),
      buildListeningBanner(kMatTeal),
      sectionLabel('Patient Info', kMatTeal),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatTeal,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatTeal,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatTeal,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Checkup Details', kMatTeal),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'bp', controller: _bpC, label: _mt('bp'), icon: Icons.favorite_outlined, color: kMatTeal,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'hb', controller: _hbC, label: _mt('hb'), icon: Icons.bloodtype_outlined, color: kMatTeal,
            keyboard: TextInputType.number,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'weight', controller: _weightC, label: _mt('weightKg'), icon: Icons.monitor_weight_outlined, color: kMatTeal,
            keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: 'Urine Test', color: kMatTeal, value: _urine,
            items: ['Normal', 'Protein+', 'Sugar+'], onChanged: (v) => setState(() => _urine = v!))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _dropdownField(label: 'TDI', color: kMatTeal, value: _tdi,
            items: ['Given', 'Pending', 'Refused'], onChanged: (v) => setState(() => _tdi = v!))),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: 'IFA Tablets', color: kMatTeal, value: _ifa,
            items: ['Yes', 'No', 'Partially'], onChanged: (v) => setState(() => _ifa = v!))),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: 'Risk', color: kMatTeal, value: _status,
            items: ['normal', 'high'], onChanged: (v) => setState(() => _status = v!))),
      ]),
      const SizedBox(height: 14),
      buildMicHint(kMatTeal, kMatTeal.withOpacity(0.08)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: DELIVERY RECORD
// ══════════════════════════════════════════════════════════
class DeliveryDialog extends StatefulWidget {
  const DeliveryDialog({super.key});
  @override
  State<DeliveryDialog> createState() => _DeliveryDialogState();
}

class _DeliveryDialogState extends State<DeliveryDialog> with VoiceDialogMixin {
  final _fk          = GlobalKey<FormState>();
  final _nameC       = TextEditingController();
  final _phoneC      = TextEditingController();
  final _villageC    = TextEditingController();
  final _placeC      = TextEditingController();
  final _babyWeightC = TextEditingController();
  final _compC       = TextEditingController();
  String _type = 'Normal', _gender = 'Girl';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _placeC.dispose(); _babyWeightC.dispose(); _compC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(), 'place': _placeC.text.trim(),
      'date': '${now.day} ${_monthName(now.month)} ${now.year}',
      'type': _type, 'gender': _gender,
      'babyWeight': _babyWeightC.text.trim(),
      'complications': _compC.text.trim().isEmpty ? 'None' : _compC.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatPurple, lightColor: kMatPurple.withOpacity(0.08),
    icon: Icons.local_hospital_outlined, title: 'Add Delivery Record',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatPurple),
      const SizedBox(height: 10),
      buildListeningBanner(kMatPurple),
      sectionLabel('Mother Info', kMatPurple),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatPurple,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatPurple,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatPurple,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Delivery Details', kMatPurple),
      voiceField(fieldKey: 'place', controller: _placeC, label: 'Delivery Place', icon: Icons.place_outlined, color: kMatPurple,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _dropdownField(label: _mt('deliveryType'), color: kMatPurple, value: _type,
            items: ['Normal', 'C-Section', 'Forceps', 'Vacuum'], onChanged: (v) => setState(() => _type = v!))),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: 'Gender', color: kMatPurple, value: _gender,
            items: ['Girl', 'Boy', 'Twins'], onChanged: (v) => setState(() => _gender = v!))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'babyWeight', controller: _babyWeightC, label: _mt('babyWeight'), icon: Icons.child_care_outlined, color: kMatPurple,
            keyboard: TextInputType.number,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'comp', controller: _compC, label: _mt('complications'), icon: Icons.warning_amber_outlined, color: kMatPurple)),
      ]),
      const SizedBox(height: 14),
      buildMicHint(kMatPurple, kMatPurple.withOpacity(0.08)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: HIGH RISK
// ══════════════════════════════════════════════════════════
class HighRiskDialog extends StatefulWidget {
  const HighRiskDialog({super.key});
  @override
  State<HighRiskDialog> createState() => _HighRiskDialogState();
}

class _HighRiskDialogState extends State<HighRiskDialog> with VoiceDialogMixin {
  final _fk          = GlobalKey<FormState>();
  final _nameC       = TextEditingController();
  final _phoneC      = TextEditingController();
  final _villageC    = TextEditingController();
  final _bloodC      = TextEditingController();
  final _riskFactorC = TextEditingController();
  final _referredC   = TextEditingController();
  String _trimester = '1st';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _bloodC.dispose(); _riskFactorC.dispose(); _referredC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(), 'blood': _bloodC.text.trim().toUpperCase(),
      'riskFactor': _riskFactorC.text.trim(), 'referredTo': _referredC.text.trim(),
      'trimester': _trimester, 'lastCheckup': '${now.day} ${_monthName(now.month)}',
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatRed, lightColor: kMatRed.withOpacity(0.08),
    icon: Icons.warning_amber_rounded, title: 'Add High Risk Mother',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatRed),
      const SizedBox(height: 10),
      buildListeningBanner(kMatRed),
      sectionLabel('Mother Info', kMatRed),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatRed,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatRed,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatRed,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'blood', controller: _bloodC, label: _mt('bloodGroup'), icon: Icons.water_drop_outlined, color: kMatRed,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: _mt('trimester'), color: kMatRed, value: _trimester,
            items: ['1st', '2nd', '3rd'], onChanged: (v) => setState(() => _trimester = v!))),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Risk Details', kMatRed),
      voiceField(fieldKey: 'riskFactor', controller: _riskFactorC, label: _mt('riskFactor'), icon: Icons.dangerous_outlined, color: kMatRed,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      voiceField(fieldKey: 'referred', controller: _referredC, label: _mt('referredTo'), icon: Icons.local_hospital_outlined, color: kMatRed,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 14),
      buildMicHint(kMatRed, kMatRed.withOpacity(0.08)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: MMVY
// ══════════════════════════════════════════════════════════
class MmvyDialog extends StatefulWidget {
  const MmvyDialog({super.key});
  @override
  State<MmvyDialog> createState() => _MmvyDialogState();
}

class _MmvyDialogState extends State<MmvyDialog> with VoiceDialogMixin {
  final _fk       = GlobalKey<FormState>();
  final _nameC    = TextEditingController();
  final _phoneC   = TextEditingController();
  final _villageC = TextEditingController();
  final _bankAccC = TextEditingController();
  final _amountC  = TextEditingController();
  String _installment = '1st', _status = 'pending';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _bankAccC.dispose(); _amountC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(), 'bankAcc': _bankAccC.text.trim(),
      'amount': _amountC.text.trim(), 'installment': _installment, 'status': _status,
      'regDate': '${now.day} ${_monthName(now.month)} ${now.year}',
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: kMatGreen, lightColor: kMatGreen.withOpacity(0.08),
    icon: Icons.account_balance_wallet_outlined, title: 'Add MVVY Beneficiary',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(kMatGreen),
      const SizedBox(height: 10),
      buildListeningBanner(kMatGreen),
      sectionLabel('Beneficiary Info', kMatGreen),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: kMatGreen,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: kMatGreen,
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: kMatGreen,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Payment Info', kMatGreen),
      voiceField(fieldKey: 'bankAcc', controller: _bankAccC, label: _mt('bankAcc'), icon: Icons.account_balance_outlined, color: kMatGreen,
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'amount', controller: _amountC, label: _mt('jsyAmount'), icon: Icons.currency_rupee_rounded, color: kMatGreen,
            keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: _mt('installment'), color: kMatGreen, value: _installment,
            items: ['1st', '2nd', '3rd'], onChanged: (v) => setState(() => _installment = v!))),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: 'Status', color: kMatGreen, value: _status,
            items: ['pending', 'received'], onChanged: (v) => setState(() => _status = v!))),
      ]),
      const SizedBox(height: 14),
      buildMicHint(kMatGreen, kMatGreen.withOpacity(0.08)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG: POSTNATAL
// ══════════════════════════════════════════════════════════
class PostnatalDialog extends StatefulWidget {
  const PostnatalDialog({super.key});
  @override
  State<PostnatalDialog> createState() => _PostnatalDialogState();
}

class _PostnatalDialogState extends State<PostnatalDialog> with VoiceDialogMixin {
  final _fk             = GlobalKey<FormState>();
  final _nameC          = TextEditingController();
  final _phoneC         = TextEditingController();
  final _villageC       = TextEditingController();
  final _babyWeightC    = TextEditingController();
  final _motherWeightC  = TextEditingController();
  String _pncVisit = '1st', _breastfeeding = 'Yes', _status = 'good';

  @override
  void initState() { super.initState(); initVoice(); }
  @override
  void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _babyWeightC.dispose(); _motherWeightC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.pop(context, {
      'name': _nameC.text.trim(), 'phone': _phoneC.text.trim(),
      'village': _villageC.text.trim(),
      'deliveryDate': '${now.day} ${_monthName(now.month)} ${now.year}',
      'pncVisit': _pncVisit, 'breastfeeding': _breastfeeding,
      'babyWeight': _babyWeightC.text.trim(), 'motherWeight': _motherWeightC.text.trim(),
      'status': _status,
    });
  }

  @override
  Widget build(BuildContext context) => _buildDialog(
    context: context, color: const Color(0xFFDB2777), lightColor: const Color(0xFFFCE7F3),
    icon: Icons.favorite_border_rounded, title: 'Add Postnatal Record',
    form: Form(key: _fk, child: Column(children: [
      buildLangBar(const Color(0xFFDB2777)),
      const SizedBox(height: 10),
      buildListeningBanner(const Color(0xFFDB2777)),
      sectionLabel('Mother Info', const Color(0xFFDB2777)),
      voiceField(fieldKey: 'name', controller: _nameC, label: _mt('name'), icon: Icons.person_outline, color: const Color(0xFFDB2777),
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; }),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'phone', controller: _phoneC, label: _mt('phone'), icon: Icons.phone_outlined, color: const Color(0xFFDB2777),
            keyboard: TextInputType.phone, maxLen: 10, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'village', controller: _villageC, label: _mt('village'), icon: Icons.location_on_outlined, color: const Color(0xFFDB2777),
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 14),
      sectionLabel('Postnatal Details', const Color(0xFFDB2777)),
      Row(children: [
        Expanded(child: voiceField(fieldKey: 'babyWeight', controller: _babyWeightC, label: _mt('babyWeight'), icon: Icons.child_care_outlined, color: const Color(0xFFDB2777),
            keyboard: TextInputType.number,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
        const SizedBox(width: 10),
        Expanded(child: voiceField(fieldKey: 'motherWeight', controller: _motherWeightC, label: 'Mother Wt (kg)', icon: Icons.monitor_weight_outlined, color: const Color(0xFFDB2777),
            keyboard: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; return null; })),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _dropdownField(label: _mt('pncVisit'), color: const Color(0xFFDB2777), value: _pncVisit,
            items: ['1st', '2nd', '3rd'], onChanged: (v) => setState(() => _pncVisit = v!))),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: _mt('breastfeeding'), color: const Color(0xFFDB2777), value: _breastfeeding,
            items: ['Yes', 'No', 'Partial'], onChanged: (v) => setState(() => _breastfeeding = v!))),
        const SizedBox(width: 10),
        Expanded(child: _dropdownField(label: 'Status', color: const Color(0xFFDB2777), value: _status,
            items: ['good', 'monitoring', 'referred'], onChanged: (v) => setState(() => _status = v!))),
      ]),
      const SizedBox(height: 14),
      buildMicHint(const Color(0xFFDB2777), const Color(0xFFFCE7F3)),
    ])),
    onSave: _save,
  );
}

// ══════════════════════════════════════════════════════════
//  SHARED DIALOG BUILDER
// ══════════════════════════════════════════════════════════
Widget _buildDialog({
  required BuildContext context,
  required Color color,
  required Color lightColor,
  required IconData icon,
  required String title,
  required Widget form,
  required VoidCallback onSave,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    insetPadding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: lightColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2332)))),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close_rounded, color: Colors.grey)),
          ]),
          const SizedBox(height: 16),
          form,
          const SizedBox(height: 16),
          _dialogButtons(ctx: context, color: color, onSave: onSave),
        ]),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  DIALOG SAVE / CANCEL BUTTONS
// ══════════════════════════════════════════════════════════
Widget _dialogButtons({
  required BuildContext ctx,
  required Color color,
  required VoidCallback onSave,
}) {
  return Row(children: [
    Expanded(
      child: OutlinedButton(
        onPressed: () => Navigator.pop(ctx),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        child: Text(_mt('cancel'),
            style: const TextStyle(color: kMuted, fontWeight: FontWeight.w600)),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      flex: 2,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_rounded, size: 18),
          const SizedBox(width: 6),
          Text(_mt('save'),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ]),
      ),
    ),
  ]);
}

// ══════════════════════════════════════════════════════════
//  DROPDOWN FIELD HELPER
// ══════════════════════════════════════════════════════════
Widget _dropdownField({
  required String label,
  required Color color,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 12, color: color),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color.withOpacity(0.3))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color.withOpacity(0.3))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color)),
    ),
    style: const TextStyle(fontSize: 12, color: Color(0xFF1A2332)),
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
    onChanged: onChanged,
  );
}

// ══════════════════════════════════════════════════════════
//  UTILITY
// ══════════════════════════════════════════════════════════
String _monthName(int m) {
  const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[m];
}