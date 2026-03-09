// pages_maternal.dart — Complete file with 8 sub-tabs
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'asha_dashboard.dart';
import 'voice_mixin.dart';

// ══════════════════════════════════════════════════════════
//  TRANSLATIONS
// ══════════════════════════════════════════════════════════
const Map<String, Map<String, String>> _tr = {
  'maternalHealth':  {'mr':'मातृत्व आरोग्य सेवा',  'hi':'मातृ स्वास्थ्य सेवा',      'en':'Maternal Health'},
  'jsyBeneficiary':  {'mr':'JSY लाभार्थी माहिती',   'hi':'JSY लाभार्थी जानकारी',     'en':'JSY Beneficiaries'},
  'pregnantList':    {'mr':'गर्भवती महिला यादी',     'hi':'गर्भवती महिला सूची',       'en':'Pregnant Women List'},
  'ancRecord':       {'mr':'ANC नोंद',               'hi':'ANC रिकॉर्ड',              'en':'ANC Record'},
  'prenatalCheck':   {'mr':'प्रसूतीपूर्व तपासणी',   'hi':'प्रसव पूर्व जांच',         'en':'Prenatal Checkup'},
  'deliveryRecord':  {'mr':'प्रसूती नोंद',           'hi':'प्रसव रिकॉर्ड',            'en':'Delivery Record'},
  'highRiskMothers': {'mr':'उच्च जोखीम गर्भवती',    'hi':'उच्च जोखिम गर्भवती',      'en':'High Risk Mothers'},
  'mmvy':            {'mr':'मातृत्व वंदना योजना',     'hi':'मातृत्व वंदना योजना',      'en':'Matritva Vandana Yojana'},
  'postnatal':       {'mr':'प्रसूतीनंतरची माहिती',   'hi':'प्रसव के बाद की जानकारी', 'en':'Postnatal Info'},
  'name':            {'mr':'नाव',         'hi':'नाम',          'en':'Name'},
  'husbandName':     {'mr':'पतीचे नाव',   'hi':'पति का नाम',   'en':'Husband Name'},
  'phone':           {'mr':'फोन',         'hi':'फ़ोन',           'en':'Phone'},
  'village':         {'mr':'गाव',         'hi':'गांव',          'en':'Village'},
  'bloodGroup':      {'mr':'रक्त गट',     'hi':'रक्त समूह',    'en':'Blood Group'},
  'weightKg':        {'mr':'वजन (किलो)',  'hi':'वजन (किलो)',   'en':'Weight (kg)'},
  'trimester':       {'mr':'तिमाही',      'hi':'तिमाही',        'en':'Trimester'},
  'highRisk':        {'mr':'उच्च जोखीम', 'hi':'उच्च जोखिम',   'en':'High Risk'},
  'normal':          {'mr':'सामान्य',     'hi':'सामान्य',       'en':'Normal'},
  'save':            {'mr':'जतन करा',     'hi':'सहेजें',        'en':'Save'},
  'cancel':          {'mr':'रद्द करा',    'hi':'रद्द करें',     'en':'Cancel'},
  'jsyAmount':       {'mr':'JSY रक्कम',   'hi':'JSY राशि',      'en':'JSY Amount'},
  'bankAcc':         {'mr':'बँक खाते',    'hi':'बैंक खाता',     'en':'Bank Account'},
  'installment':     {'mr':'हप्ता',       'hi':'किस्त',         'en':'Installment'},
  'ancVisit':        {'mr':'ANC भेट',     'hi':'ANC विजिट',     'en':'ANC Visit'},
  'bp':              {'mr':'रक्तदाब',     'hi':'रक्तचाप',       'en':'Blood Pressure'},
  'hb':              {'mr':'हिमोग्लोबिन', 'hi':'हीमोग्लोबिन',  'en':'Hemoglobin'},
  'deliveryType':    {'mr':'प्रसूती प्रकार','hi':'प्रसव प्रकार','en':'Delivery Type'},
  'babyWeight':      {'mr':'बाळाचे वजन',  'hi':'शिशु का वजन',  'en':'Baby Weight'},
  'complications':   {'mr':'गुंतागुंत',   'hi':'जटिलताएं',      'en':'Complications'},
  'pncVisit':        {'mr':'PNC भेट',     'hi':'PNC विजिट',     'en':'PNC Visit'},
  'breastfeeding':   {'mr':'स्तनपान',     'hi':'स्तनपान',       'en':'Breastfeeding'},
  'riskFactor':      {'mr':'जोखीम कारण', 'hi':'जोखिम कारण',    'en':'Risk Factor'},
  'referredTo':      {'mr':'संदर्भित',    'hi':'रेफर किया',     'en':'Referred To'},
  'addRecord':       {'mr':'नोंद जोडा',   'hi':'रिकॉर्ड जोड़ें','en':'Add Record'},
  'vaccRecord':      {'mr':'लसीकरण नोंद', 'hi':'टीकाकरण रिकॉर्ड','en':'Vaccination Record'},
  'vaccGiven':       {'mr':'दिलेली लस',   'hi':'दिया गया टीका',  'en':'Vaccine Given'},
  'nextVacc':        {'mr':'पुढील लस',    'hi':'अगला टीका',       'en':'Next Vaccine'},
  'nextDate':        {'mr':'पुढील तारीख', 'hi':'अगली तारीख',      'en':'Next Date'},
  'ttDose':          {'mr':'TT डोस',      'hi':'TT डोज़',          'en':'TT Dose'},
  'anc':             {'mr':'ANC भेट',     'hi':'ANC विजिट',       'en':'ANC Visit No.'},
  'edd':             {'mr':'प्रसूती तारीख','hi':'प्रसव तिथि',     'en':'Expected Delivery'},
  'due':             {'mr':'बाकी',         'hi':'बाकी',            'en':'Due'},
  'overdue':         {'mr':'थकबाकी',      'hi':'अतिदेय',          'en':'Overdue'},
  'done2':           {'mr':'झाले',         'hi':'पूर्ण',           'en':'Done'},
};

String _t(String key) {
  final lang = langNotifier.value;
  return _tr[key]?[lang] ?? _tr[key]?['en'] ?? key;
}

// ══════════════════════════════════════════════════════════
//  VALIDATION HELPERS  ← centralised rules
// ══════════════════════════════════════════════════════════

/// Name: required, min 3 chars, letters + spaces + common Indian characters only
String? _validateName(String? v) {
  if (v == null || v.trim().isEmpty) return 'Name is required';
  final s = v.trim();
  if (s.length < 3) return 'Min 3 characters';
  if (s.length > 50) return 'Max 50 characters';
  // Allow Unicode letters (covers Hindi/Marathi), spaces, dots, hyphens
  if (!RegExp(r"^[\p{L}\s.\-']+$", unicode: true).hasMatch(s)) {
    return 'Only letters allowed (no numbers/symbols)';
  }
  return null;
}

/// Phone: required, exactly 10 digits, must start with 6-9
String? _validatePhone(String? v) {
  if (v == null || v.trim().isEmpty) return 'Phone is required';
  final s = v.trim().replaceAll(RegExp(r'\s+'), ''); // strip any spaces
  if (s.length != 10) return 'Must be exactly 10 digits';
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(s)) return 'Start with 6-9, digits only';
  return null;
}

// ══════════════════════════════════════════════════════════
//  COLORS
// ══════════════════════════════════════════════════════════
const kMatPink      = Color(0xFFE91E8C);
const kMatPinkLight = Color(0xFFFCE4F1);
const kMatPurple    = Color(0xFF7C3AED);
const kMatTeal      = Color(0xFF0891B2);
const kMatGreen     = Color(0xFF16A34A);
const kMatRed       = Color(0xFFDC2626);
const kMatOrange    = Color(0xFFD97706);
const kMatBlue      = Color(0xFF1D4ED8);
const kMatDeepPink  = Color(0xFFDB2777);

// ══════════════════════════════════════════════════════════
//  MAIN PREGNANT PAGE
// ══════════════════════════════════════════════════════════
class MaternalHealthPage extends StatefulWidget {
  const MaternalHealthPage({super.key});
  @override
  State<MaternalHealthPage> createState() => _PregnantPageState();
}

class _PregnantPageState extends State<MaternalHealthPage> {
  int _sel = 0;

  static const _tabs = [
    _ST(Icons.star_outline_rounded,            'jsyBeneficiary',  kMatOrange),
    _ST(Icons.pregnant_woman_rounded,          'pregnantList',    kMatPink),
    _ST(Icons.assignment_outlined,             'ancRecord',       kMatBlue),
    _ST(Icons.medical_services_outlined,       'prenatalCheck',   kMatTeal),
    _ST(Icons.local_hospital_outlined,         'deliveryRecord',  kMatPurple),
    _ST(Icons.warning_amber_rounded,           'highRiskMothers', kMatRed),
    _ST(Icons.account_balance_wallet_outlined, 'mmvy',            kMatGreen),
    _ST(Icons.favorite_border_rounded,         'postnatal',       kMatDeepPink),
    _ST(Icons.vaccines_rounded,                'vaccRecord',      kMatTeal),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Container(color: kBg, child: Column(children: [
        PageHeader(title: _t('maternalHealth'), color: kMatPink, icon: Icons.pregnant_woman_rounded),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final active = _sel == i;
                return GestureDetector(
                  onTap: () => setState(() => _sel = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? tab.color : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? tab.color : Colors.grey.shade300),
                    ),
                    child: Row(children: [
                      Icon(tab.icon, size: 15, color: active ? Colors.white : tab.color),
                      const SizedBox(width: 6),
                      Text(_t(tab.labelKey),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                              color: active ? Colors.white : tab.color, decoration: TextDecoration.none)),
                    ]),
                  ),
                );
              }),
            ),
          ),
        ),
        const Divider(height: 1, color: kBorder),
        Expanded(child: _page(_sel)),
      ])),
    );
  }

  Widget _page(int i) {
    switch (i) {
      case 0: return const JsyBeneficiaryPage();
      case 1: return const PregnantListPage();
      case 2: return const AncRecordPage();
      case 3: return const PrenatalCheckPage();
      case 4: return const DeliveryRecordPage();
      case 5: return const HighRiskMothersPage();
      case 6: return const MmvyPage();
      case 7: return const PostnatalPage();
      case 8: return const MaternalVaccinePage();
      default: return const PregnantListPage();
    }
  }
}

class _ST {
  final IconData icon;
  final String labelKey;
  final Color color;
  const _ST(this.icon, this.labelKey, this.color);
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════
Widget _subHdr(String title, Color color, IconData icon, VoidCallback onAdd) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withOpacity(0.05),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color, decoration: TextDecoration.none))),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.add, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(_t('addRecord'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
            ]),
          ),
        ),
      ]),
    );

Widget _card({
  required Color color, required IconData icon,
  required String name, required String village, required String phone,
  required String statusLabel, required Color statusColor,
  required List<Widget> details,
}) =>
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 11, color: kMuted),
              const SizedBox(width: 2),
              Text(village, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
            ]),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor, decoration: TextDecoration.none)),
          ),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: kBorder),
        const SizedBox(height: 8),
        Wrap(spacing: 12, runSpacing: 4, children: [
          if (phone.isNotEmpty) _det(Icons.phone_outlined, phone),
          ...details,
        ]),
      ]),
    );

Widget _det(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
  Icon(icon, size: 12, color: kMuted),
  const SizedBox(width: 3),
  Text(text, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
]);

Widget _dropField({
  required String label, required Color color,
  required String value, required List<String> items,
  required ValueChanged<String?> onChanged,
}) =>
    DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12, color: color, decoration: TextDecoration.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color.withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color)),
      ),
      style: const TextStyle(fontSize: 12, color: kText, decoration: TextDecoration.none),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12, decoration: TextDecoration.none)))).toList(),
      onChanged: onChanged,
    );

String _month(int m) => ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m];

Widget _dlgBtns(BuildContext ctx, Color color, VoidCallback onSave) => Row(children: [
  Expanded(child: OutlinedButton(
    onPressed: () => Navigator.pop(ctx),
    style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 13)),
    child: Text(_t('cancel'), style: const TextStyle(color: kMuted, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
  )),
  const SizedBox(width: 12),
  Expanded(flex: 2, child: ElevatedButton(
    onPressed: onSave,
    style: ElevatedButton.styleFrom(
        backgroundColor: color, foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 13)),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.check_rounded, size: 18),
      const SizedBox(width: 6),
      Text(_t('save'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, decoration: TextDecoration.none)),
    ]),
  )),
]);

Widget _dlgShell({
  required BuildContext context, required Color color, required Color lightColor,
  required IconData icon, required String title,
  required Widget form, required VoidCallback onSave,
}) =>
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: lightColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20)),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kText, decoration: TextDecoration.none))),
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, color: kMuted)),
            ]),
            const SizedBox(height: 16),
            form,
            const SizedBox(height: 16),
            _dlgBtns(context, color, onSave),
          ]),
        ),
      ),
    );

// ══════════════════════════════════════════════════════════
//  1. JSY BENEFICIARY
// ══════════════════════════════════════════════════════════
class JsyBeneficiaryPage extends StatefulWidget {
  const JsyBeneficiaryPage({super.key});
  @override State<JsyBeneficiaryPage> createState() => _JsyBeneficiaryPageState();
}
class _JsyBeneficiaryPageState extends State<JsyBeneficiaryPage> {
  final _list = <Map<String, String>>[
    {'name':'Kavita Sharma','village':'Wardha','phone':'9876500001','installment':'2nd','amount':'1400','bankAcc':'SBI...4521','status':'paid'},
    {'name':'Sunita Yadav', 'village':'Nagpur','phone':'9876500004','installment':'1st','amount':'1000','bankAcc':'BOB...7821','status':'pending'},
    {'name':'Rekha Bai',    'village':'Hingna','phone':'9876500005','installment':'3rd','amount':'2000','bankAcc':'PNB...3312','status':'paid'},
  ];
  final _sc = TextEditingController(); String _q = '';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _JsyDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('jsyBeneficiary'), kMatOrange, Icons.star_outline_rounded, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village…', color: kMatOrange, onChanged: () => setState(() => _q = _sc.text.trim())),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i]; final p = w['status'] == 'paid';
          return _card(color: kMatOrange, icon: Icons.star_outline_rounded, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: p ? 'Paid' : 'Pending', statusColor: p ? kMatGreen : kMatRed,
            details: [_det(Icons.receipt_long_outlined,'${_t('installment')}: ${w['installment']}'),_det(Icons.currency_rupee_rounded,'₹${w['amount']}'),_det(Icons.account_balance_outlined,w['bankAcc']!)]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  2. PREGNANT LIST
// ══════════════════════════════════════════════════════════
class PregnantListPage extends StatefulWidget {
  const PregnantListPage({super.key});
  @override State<PregnantListPage> createState() => _PregnantListPageState();
}
class _PregnantListPageState extends State<PregnantListPage> {
  final _list = <Map<String,String>>[
    {'name':'Kavita Sharma','trimester':'3rd','due':'Mar 2025','risk':'high',  'husband':'Suresh Sharma','phone':'9876500001','blood':'B+','weight':'68','village':'Wardha'},
    {'name':'Priya Patil',  'trimester':'2nd','due':'May 2025','risk':'normal','husband':'Ajay Patil',  'phone':'9876500002','blood':'O+','weight':'55','village':'Nagpur'},
    {'name':'Asha Devi',    'trimester':'1st','due':'Jul 2025','risk':'normal','husband':'Ramesh Devi', 'phone':'9876500003','blood':'A+','weight':'52','village':'Hingna'},
  ];
  final _sc = TextEditingController(); String _q = '', _fl = 'all';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_fl != 'all' && w['risk'] != _fl) return false;
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q) || w['phone']!.contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _PregnantDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('pregnantList'), kMatPink, Icons.pregnant_woman_rounded, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village, phone…', color: kMatPink, onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _fl, color: kMatPink, count: f.length,
        chips: [{'label':'All','value':'all'},{'label':'High Risk','value':'high'},{'label':'Normal','value':'normal'}],
        onTap: (v) => setState(() => _fl = v)),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i]; final h = w['risk'] == 'high';
          return _card(color: kMatPink, icon: Icons.pregnant_woman_rounded, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: h ? _t('highRisk') : _t('normal'), statusColor: h ? kMatRed : kMatGreen,
            details: [_det(Icons.calendar_today_outlined,'${w['trimester']} ${_t('trimester')}'),_det(Icons.schedule_outlined,w['due']!),_det(Icons.water_drop_outlined,'Blood: ${w['blood']}'),_det(Icons.monitor_weight_outlined,'${w['weight']} kg')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  3. ANC RECORD
// ══════════════════════════════════════════════════════════
class AncRecordPage extends StatefulWidget {
  const AncRecordPage({super.key});
  @override State<AncRecordPage> createState() => _AncRecordPageState();
}
class _AncRecordPageState extends State<AncRecordPage> {
  final _list = <Map<String,String>>[
    {'name':'Kavita Sharma','village':'Wardha','phone':'9876500001','visit':'3rd','date':'20 Feb 2025','bp':'120/80','hb':'10.5','weight':'68','remarks':'Normal'},
    {'name':'Priya Patil',  'village':'Nagpur','phone':'9876500002','visit':'2nd','date':'15 Feb 2025','bp':'110/70','hb':'11.2','weight':'55','remarks':'Good'},
  ];
  final _sc = TextEditingController(); String _q = '';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _AncDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('ancRecord'), kMatBlue, Icons.assignment_outlined, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village…', color: kMatBlue, onChanged: () => setState(() => _q = _sc.text.trim())),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i];
          return _card(color: kMatBlue, icon: Icons.assignment_outlined, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: '${w['visit']} ${_t('ancVisit')}', statusColor: kMatBlue,
            details: [_det(Icons.calendar_today_outlined,w['date']!),_det(Icons.favorite_outlined,'BP: ${w['bp']}'),_det(Icons.bloodtype_outlined,'Hb: ${w['hb']} g/dL'),_det(Icons.monitor_weight_outlined,'${w['weight']} kg')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  4. PRENATAL CHECKUP
// ══════════════════════════════════════════════════════════
class PrenatalCheckPage extends StatefulWidget {
  const PrenatalCheckPage({super.key});
  @override State<PrenatalCheckPage> createState() => _PrenatalCheckPageState();
}
class _PrenatalCheckPageState extends State<PrenatalCheckPage> {
  final _list = <Map<String,String>>[
    {'name':'Kavita Sharma','village':'Wardha','phone':'9876500001','date':'20 Feb 2025','bp':'130/85','hb':'9.8', 'weight':'70','urine':'Normal','tdi':'Given','ifa':'Yes','status':'high'},
    {'name':'Sunita Yadav', 'village':'Nagpur','phone':'9876500004','date':'18 Feb 2025','bp':'115/75','hb':'11.5','weight':'58','urine':'Normal','tdi':'Given','ifa':'Yes','status':'normal'},
  ];
  final _sc = TextEditingController(); String _q = '';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _PrenatalDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('prenatalCheck'), kMatTeal, Icons.medical_services_outlined, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village…', color: kMatTeal, onChanged: () => setState(() => _q = _sc.text.trim())),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i]; final h = w['status'] == 'high';
          return _card(color: kMatTeal, icon: Icons.medical_services_outlined, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: h ? _t('highRisk') : _t('normal'), statusColor: h ? kMatRed : kMatGreen,
            details: [_det(Icons.calendar_today_outlined,w['date']!),_det(Icons.favorite_outlined,'BP: ${w['bp']}'),_det(Icons.bloodtype_outlined,'Hb: ${w['hb']} g/dL'),_det(Icons.science_outlined,'Urine: ${w['urine']}'),_det(Icons.vaccines_outlined,'TDI: ${w['tdi']} | IFA: ${w['ifa']}')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  5. DELIVERY RECORD
// ══════════════════════════════════════════════════════════
class DeliveryRecordPage extends StatefulWidget {
  const DeliveryRecordPage({super.key});
  @override State<DeliveryRecordPage> createState() => _DeliveryRecordPageState();
}
class _DeliveryRecordPageState extends State<DeliveryRecordPage> {
  final _list = <Map<String,String>>[
    {'name':'Meena Thakur', 'village':'Wardha','phone':'9876500006','date':'10 Feb 2025','type':'Normal',   'place':'PHC Wardha',       'babyWeight':'3.1','gender':'Girl','complications':'None'},
    {'name':'Lata Wankhede','village':'Hingna', 'phone':'9876500007','date':'05 Feb 2025','type':'C-Section','place':'District Hospital','babyWeight':'2.8','gender':'Boy', 'complications':'Anemia'},
  ];
  final _sc = TextEditingController(); String _q = '';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _DeliveryDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('deliveryRecord'), kMatPurple, Icons.local_hospital_outlined, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village…', color: kMatPurple, onChanged: () => setState(() => _q = _sc.text.trim())),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i]; final cs = w['type'] == 'C-Section';
          return _card(color: kMatPurple, icon: Icons.local_hospital_outlined, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: w['type']!, statusColor: cs ? kMatOrange : kMatGreen,
            details: [_det(Icons.calendar_today_outlined,w['date']!),_det(Icons.place_outlined,w['place']!),_det(Icons.child_care_outlined,'${w['gender']} | ${w['babyWeight']} kg'),
              if (w['complications'] != 'None') _det(Icons.warning_amber_outlined,'Complication: ${w['complications']}')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  6. HIGH RISK MOTHERS
// ══════════════════════════════════════════════════════════
class HighRiskMothersPage extends StatefulWidget {
  const HighRiskMothersPage({super.key});
  @override State<HighRiskMothersPage> createState() => _HighRiskMothersPageState();
}
class _HighRiskMothersPageState extends State<HighRiskMothersPage> {
  final _list = <Map<String,String>>[
    {'name':'Kavita Sharma','village':'Wardha','phone':'9876500001','trimester':'3rd','riskFactor':'Hypertension', 'referredTo':'District Hospital','lastCheckup':'20 Feb','blood':'B+'},
    {'name':'Lata Wankhede','village':'Hingna','phone':'9876500007','trimester':'2nd','riskFactor':'Severe Anemia','referredTo':'PHC Wardha',       'lastCheckup':'15 Feb','blood':'O-'},
    {'name':'Suman Borse',  'village':'Umred', 'phone':'9876500008','trimester':'3rd','riskFactor':'Diabetes',     'referredTo':'CHC Umred',         'lastCheckup':'12 Feb','blood':'AB+'},
  ];
  final _sc = TextEditingController(); String _q = '';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['riskFactor']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _HighRiskDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('highRiskMothers'), kMatRed, Icons.warning_amber_rounded, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, risk factor…', color: kMatRed, onChanged: () => setState(() => _q = _sc.text.trim())),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i];
          return _card(color: kMatRed, icon: Icons.warning_amber_rounded, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: _t('highRisk'), statusColor: kMatRed,
            details: [_det(Icons.dangerous_outlined,'${_t('riskFactor')}: ${w['riskFactor']}'),_det(Icons.local_hospital_outlined,'${_t('referredTo')}: ${w['referredTo']}'),_det(Icons.calendar_today_outlined,'Last: ${w['lastCheckup']}'),_det(Icons.water_drop_outlined,'Blood: ${w['blood']}')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  7. MMVY
// ══════════════════════════════════════════════════════════
class MmvyPage extends StatefulWidget {
  const MmvyPage({super.key});
  @override State<MmvyPage> createState() => _MmvyPageState();
}
class _MmvyPageState extends State<MmvyPage> {
  final _list = <Map<String,String>>[
    {'name':'Kavita Sharma','village':'Wardha','phone':'9876500001','installment':'2nd','amount':'2000','bankAcc':'SBI...4521','status':'received','regDate':'01 Jan 2025'},
    {'name':'Asha Devi',    'village':'Hingna','phone':'9876500003','installment':'1st','amount':'1000','bankAcc':'BOB...9841','status':'pending', 'regDate':'10 Feb 2025'},
    {'name':'Rekha Bai',    'village':'Wardha','phone':'9876500005','installment':'3rd','amount':'2000','bankAcc':'PNB...3312','status':'received','regDate':'15 Dec 2024'},
  ];
  final _sc = TextEditingController(); String _q = '', _fl = 'all';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_fl != 'all' && w['status'] != _fl) return false;
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _MmvyDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('mmvy'), kMatGreen, Icons.account_balance_wallet_outlined, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village…', color: kMatGreen, onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _fl, color: kMatGreen, count: f.length,
        chips: [{'label':'All','value':'all'},{'label':'Received','value':'received'},{'label':'Pending','value':'pending'}],
        onTap: (v) => setState(() => _fl = v)),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i]; final rc = w['status'] == 'received';
          return _card(color: kMatGreen, icon: Icons.account_balance_wallet_outlined, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: rc ? 'Received' : 'Pending', statusColor: rc ? kMatGreen : kMatRed,
            details: [_det(Icons.receipt_long_outlined,'${_t('installment')}: ${w['installment']}'),_det(Icons.currency_rupee_rounded,'₹${w['amount']}'),_det(Icons.account_balance_outlined,w['bankAcc']!),_det(Icons.calendar_today_outlined,'Reg: ${w['regDate']}')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  8. POSTNATAL
// ══════════════════════════════════════════════════════════
class PostnatalPage extends StatefulWidget {
  const PostnatalPage({super.key});
  @override State<PostnatalPage> createState() => _PostnatalPageState();
}
class _PostnatalPageState extends State<PostnatalPage> {
  final _list = <Map<String,String>>[
    {'name':'Meena Thakur', 'village':'Wardha','phone':'9876500006','deliveryDate':'10 Feb 2025','pncVisit':'2nd','breastfeeding':'Yes','babyWeight':'3.2','motherWeight':'58','status':'good'},
    {'name':'Lata Wankhede','village':'Hingna','phone':'9876500007','deliveryDate':'05 Feb 2025','pncVisit':'1st','breastfeeding':'Yes','babyWeight':'2.9','motherWeight':'54','status':'monitoring'},
  ];
  final _sc = TextEditingController(); String _q = '';
  List<Map<String,String>> get _f => _list.where((w) {
    if (_q.isEmpty) return true; final q = _q.toLowerCase();
    return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
  }).toList();
  Future<void> _add() async {
    final r = await showDialog<Map<String,String>>(context: context, barrierDismissible: false, builder: (_) => const _PostnatalDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }
  @override Widget build(BuildContext context) {
    final f = _f;
    return Material(color: kBg, child: Column(children: [
      _subHdr(_t('postnatal'), kMatDeepPink, Icons.favorite_border_rounded, _add),
      buildSearchBar(controller: _sc, hint: 'Search by name, village…', color: kMatDeepPink, onChanged: () => setState(() => _q = _sc.text.trim())),
      Expanded(child: f.isEmpty ? emptyState(_q) : ListView.separated(
        padding: const EdgeInsets.all(16), itemCount: f.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final w = f[i]; final g = w['status'] == 'good';
          return _card(color: kMatDeepPink, icon: Icons.favorite_border_rounded, name: w['name']!, village: w['village']!, phone: w['phone']!,
            statusLabel: g ? 'Good' : 'Monitoring', statusColor: g ? kMatGreen : kMatOrange,
            details: [_det(Icons.calendar_today_outlined,'Delivery: ${w['deliveryDate']}'),_det(Icons.assignment_turned_in_outlined,'${_t('pncVisit')}: ${w['pncVisit']}'),_det(Icons.child_care_outlined,'Baby: ${w['babyWeight']} kg'),_det(Icons.favorite_outlined,'${_t('breastfeeding')}: ${w['breastfeeding']}'),_det(Icons.monitor_weight_outlined,'Mother: ${w['motherWeight']} kg')]);
        },
      )),
    ]));
  }
}

// ══════════════════════════════════════════════════════════
//  DIALOGS  — all use _validateName() and _validatePhone()
// ══════════════════════════════════════════════════════════

// ── 1. JSY Dialog ──
class _JsyDialog extends StatefulWidget {
  const _JsyDialog();
  @override State<_JsyDialog> createState() => _JsyDialogState();
}
class _JsyDialogState extends State<_JsyDialog> with VoiceDialogMixin {
  final _fk = GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_bankC=TextEditingController(),_amountC=TextEditingController();
  String _inst = '1st';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_bankC.dispose();_amountC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'bankAcc':_bankC.text.trim(),'amount':_amountC.text.trim(),'installment':_inst,'status':'pending'});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatOrange,lightColor:kMatOrange.withOpacity(0.1),icon:Icons.star_outline_rounded,title:'Add JSY Beneficiary',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatOrange),const SizedBox(height:10),buildListeningBanner(kMatOrange),
      sectionLabel('Beneficiary Info',kMatOrange),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatOrange,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatOrange,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatOrange,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('Payment Info',kMatOrange),
      voiceField(fieldKey:'bank',controller:_bankC,label:_t('bankAcc'),icon:Icons.account_balance_outlined,color:kMatOrange,validator:(v)=>v==null||v.trim().isEmpty?'Bank account required':null),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'amount',controller:_amountC,label:_t('jsyAmount'),icon:Icons.currency_rupee_rounded,color:kMatOrange,keyboard:TextInputType.number,formatters:[FilteringTextInputFormatter.digitsOnly],validator:(v)=>v==null||v.trim().isEmpty?'Amount required':null)),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:_t('installment'),color:kMatOrange,value:_inst,items:['1st','2nd','3rd'],onChanged:(v)=>setState(()=>_inst=v!))),
      ]),
      const SizedBox(height:14),buildMicHint(kMatOrange,kMatOrange.withOpacity(0.1)),
    ])));
}

// ── 2. Pregnant Dialog ──
class _PregnantDialog extends StatefulWidget {
  const _PregnantDialog();
  @override State<_PregnantDialog> createState() => _PregnantDialogState();
}
class _PregnantDialogState extends State<_PregnantDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_husbandC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_bloodC=TextEditingController(),_weightC=TextEditingController();
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_husbandC.dispose();_phoneC.dispose();_villageC.dispose();_bloodC.dispose();_weightC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    Navigator.pop(context,{'name':_nameC.text.trim(),'husband':_husbandC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'blood':_bloodC.text.trim().toUpperCase(),'weight':_weightC.text.trim(),'village':_villageC.text.trim(),'trimester':'1st','due':'TBD','risk':'normal','lastCheckup':'Today'});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatPink,lightColor:kMatPinkLight,icon:Icons.pregnant_woman_rounded,title:'Add Pregnant Woman',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatPink),const SizedBox(height:10),buildListeningBanner(kMatPink),
      sectionLabel("Mother's Info",kMatPink),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatPink,validator:_validateName),
      const SizedBox(height:10),
      voiceField(fieldKey:'husband',controller:_husbandC,label:_t('husbandName'),icon:Icons.person_outline,color:kMatPink,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatPink,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatPink,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('Health Info',kMatPink),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'blood',controller:_bloodC,label:_t('bloodGroup'),icon:Icons.water_drop_outlined,color:kMatPink,validator:(v){if(v==null||v.isEmpty)return'Required';if(!RegExp(r'^(A|B|AB|O)[+-]$',caseSensitive:false).hasMatch(v.trim()))return'e.g. A+, O-';return null;})),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'weight',controller:_weightC,label:_t('weightKg'),icon:Icons.monitor_weight_outlined,color:kMatPink,keyboard:TextInputType.number,maxLen:3,formatters:[FilteringTextInputFormatter.digitsOnly],validator:(v){if(v==null||v.isEmpty)return'Required';final w=int.tryParse(v);if(w==null||w<30||w>150)return'30–150 kg';return null;})),
      ]),
      const SizedBox(height:14),buildMicHint(kMatPink,kMatPinkLight),
    ])));
}

// ── 3. ANC Dialog ──
class _AncDialog extends StatefulWidget {
  const _AncDialog();
  @override State<_AncDialog> createState() => _AncDialogState();
}
class _AncDialogState extends State<_AncDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_bpC=TextEditingController(),_hbC=TextEditingController(),_weightC=TextEditingController(),_remarksC=TextEditingController();
  String _visit='1st';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_bpC.dispose();_hbC.dispose();_weightC.dispose();_remarksC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    final now=DateTime.now();
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'visit':_visit,'date':'${now.day} ${_month(now.month)} ${now.year}','bp':_bpC.text.trim(),'hb':_hbC.text.trim(),'weight':_weightC.text.trim(),'remarks':_remarksC.text.trim().isEmpty?'Normal':_remarksC.text.trim()});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatBlue,lightColor:kMatBlue.withOpacity(0.08),icon:Icons.assignment_outlined,title:'Add ANC Record',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatBlue),const SizedBox(height:10),buildListeningBanner(kMatBlue),
      sectionLabel('Patient Info',kMatBlue),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatBlue,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatBlue,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatBlue,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('ANC Details',kMatBlue),
      Row(children:[
        Expanded(child:_dropField(label:_t('ancVisit'),color:kMatBlue,value:_visit,items:['1st','2nd','3rd','4th'],onChanged:(v)=>setState(()=>_visit=v!))),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'bp',controller:_bpC,label:_t('bp'),icon:Icons.favorite_outlined,color:kMatBlue,validator:(v)=>v==null||v.trim().isEmpty?'BP required':null)),
      ]),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'hb',controller:_hbC,label:_t('hb'),icon:Icons.bloodtype_outlined,color:kMatBlue,keyboard:TextInputType.number,validator:(v)=>v==null||v.trim().isEmpty?'Hb required':null)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'weight',controller:_weightC,label:_t('weightKg'),icon:Icons.monitor_weight_outlined,color:kMatBlue,keyboard:TextInputType.number,formatters:[FilteringTextInputFormatter.digitsOnly],validator:(v)=>v==null||v.trim().isEmpty?'Weight required':null)),
      ]),
      const SizedBox(height:10),
      voiceField(fieldKey:'remarks',controller:_remarksC,label:'Remarks',icon:Icons.notes_outlined,color:kMatBlue),
      const SizedBox(height:14),buildMicHint(kMatBlue,kMatBlue.withOpacity(0.08)),
    ])));
}

// ── 4. Prenatal Dialog ──
class _PrenatalDialog extends StatefulWidget {
  const _PrenatalDialog();
  @override State<_PrenatalDialog> createState() => _PrenatalDialogState();
}
class _PrenatalDialogState extends State<_PrenatalDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_bpC=TextEditingController(),_hbC=TextEditingController(),_weightC=TextEditingController();
  String _urine='Normal',_tdi='Given',_ifa='Yes',_status='normal';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_bpC.dispose();_hbC.dispose();_weightC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    final now=DateTime.now();
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'date':'${now.day} ${_month(now.month)} ${now.year}','bp':_bpC.text.trim(),'hb':_hbC.text.trim(),'weight':_weightC.text.trim(),'urine':_urine,'tdi':_tdi,'ifa':_ifa,'status':_status});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatTeal,lightColor:kMatTeal.withOpacity(0.08),icon:Icons.medical_services_outlined,title:'Add Prenatal Checkup',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatTeal),const SizedBox(height:10),buildListeningBanner(kMatTeal),
      sectionLabel('Patient Info',kMatTeal),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatTeal,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatTeal,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatTeal,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('Checkup Details',kMatTeal),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'bp',controller:_bpC,label:_t('bp'),icon:Icons.favorite_outlined,color:kMatTeal,validator:(v)=>v==null||v.trim().isEmpty?'BP required':null)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'hb',controller:_hbC,label:_t('hb'),icon:Icons.bloodtype_outlined,color:kMatTeal,keyboard:TextInputType.number,validator:(v)=>v==null||v.trim().isEmpty?'Hb required':null)),
      ]),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'weight',controller:_weightC,label:_t('weightKg'),icon:Icons.monitor_weight_outlined,color:kMatTeal,keyboard:TextInputType.number,formatters:[FilteringTextInputFormatter.digitsOnly],validator:(v)=>v==null||v.trim().isEmpty?'Weight required':null)),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:'Urine Test',color:kMatTeal,value:_urine,items:['Normal','Protein+','Sugar+'],onChanged:(v)=>setState(()=>_urine=v!))),
      ]),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:_dropField(label:'TDI',color:kMatTeal,value:_tdi,items:['Given','Pending','Refused'],onChanged:(v)=>setState(()=>_tdi=v!))),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:'IFA',color:kMatTeal,value:_ifa,items:['Yes','No','Partially'],onChanged:(v)=>setState(()=>_ifa=v!))),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:'Risk',color:kMatTeal,value:_status,items:['normal','high'],onChanged:(v)=>setState(()=>_status=v!))),
      ]),
      const SizedBox(height:14),buildMicHint(kMatTeal,kMatTeal.withOpacity(0.08)),
    ])));
}

// ── 5. Delivery Dialog ──
class _DeliveryDialog extends StatefulWidget {
  const _DeliveryDialog();
  @override State<_DeliveryDialog> createState() => _DeliveryDialogState();
}
class _DeliveryDialogState extends State<_DeliveryDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_placeC=TextEditingController(),_babyWC=TextEditingController(),_compC=TextEditingController();
  String _type='Normal',_gender='Girl';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_placeC.dispose();_babyWC.dispose();_compC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    final now=DateTime.now();
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'place':_placeC.text.trim(),'date':'${now.day} ${_month(now.month)} ${now.year}','type':_type,'gender':_gender,'babyWeight':_babyWC.text.trim(),'complications':_compC.text.trim().isEmpty?'None':_compC.text.trim()});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatPurple,lightColor:kMatPurple.withOpacity(0.08),icon:Icons.local_hospital_outlined,title:'Add Delivery Record',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatPurple),const SizedBox(height:10),buildListeningBanner(kMatPurple),
      sectionLabel('Mother Info',kMatPurple),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatPurple,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatPurple,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatPurple,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('Delivery Details',kMatPurple),
      voiceField(fieldKey:'place',controller:_placeC,label:'Delivery Place',icon:Icons.place_outlined,color:kMatPurple,validator:(v)=>v==null||v.trim().isEmpty?'Place required':null),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:_dropField(label:_t('deliveryType'),color:kMatPurple,value:_type,items:['Normal','C-Section','Forceps','Vacuum'],onChanged:(v)=>setState(()=>_type=v!))),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:'Gender',color:kMatPurple,value:_gender,items:['Girl','Boy','Twins'],onChanged:(v)=>setState(()=>_gender=v!))),
      ]),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'babyW',controller:_babyWC,label:_t('babyWeight'),icon:Icons.child_care_outlined,color:kMatPurple,keyboard:TextInputType.number,validator:(v)=>v==null||v.trim().isEmpty?'Baby weight required':null)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'comp',controller:_compC,label:_t('complications'),icon:Icons.warning_amber_outlined,color:kMatPurple)),
      ]),
      const SizedBox(height:14),buildMicHint(kMatPurple,kMatPurple.withOpacity(0.08)),
    ])));
}

// ── 6. High Risk Dialog ──
class _HighRiskDialog extends StatefulWidget {
  const _HighRiskDialog();
  @override State<_HighRiskDialog> createState() => _HighRiskDialogState();
}
class _HighRiskDialogState extends State<_HighRiskDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_bloodC=TextEditingController(),_riskC=TextEditingController(),_refC=TextEditingController();
  String _tri='1st';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_bloodC.dispose();_riskC.dispose();_refC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    final now=DateTime.now();
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'blood':_bloodC.text.trim().toUpperCase(),'riskFactor':_riskC.text.trim(),'referredTo':_refC.text.trim(),'trimester':_tri,'lastCheckup':'${now.day} ${_month(now.month)}'});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatRed,lightColor:kMatRed.withOpacity(0.08),icon:Icons.warning_amber_rounded,title:'Add High Risk Mother',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatRed),const SizedBox(height:10),buildListeningBanner(kMatRed),
      sectionLabel('Mother Info',kMatRed),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatRed,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatRed,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatRed,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'blood',controller:_bloodC,label:_t('bloodGroup'),icon:Icons.water_drop_outlined,color:kMatRed,validator:(v)=>v==null||v.trim().isEmpty?'Blood group required':null)),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:_t('trimester'),color:kMatRed,value:_tri,items:['1st','2nd','3rd'],onChanged:(v)=>setState(()=>_tri=v!))),
      ]),
      const SizedBox(height:14),sectionLabel('Risk Details',kMatRed),
      voiceField(fieldKey:'risk',controller:_riskC,label:_t('riskFactor'),icon:Icons.dangerous_outlined,color:kMatRed,validator:(v)=>v==null||v.trim().isEmpty?'Risk factor required':null),
      const SizedBox(height:10),
      voiceField(fieldKey:'ref',controller:_refC,label:_t('referredTo'),icon:Icons.local_hospital_outlined,color:kMatRed,validator:(v)=>v==null||v.trim().isEmpty?'Referral required':null),
      const SizedBox(height:14),buildMicHint(kMatRed,kMatRed.withOpacity(0.08)),
    ])));
}

// ── 7. MMVY Dialog ──
class _MmvyDialog extends StatefulWidget {
  const _MmvyDialog();
  @override State<_MmvyDialog> createState() => _MmvyDialogState();
}
class _MmvyDialogState extends State<_MmvyDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_bankC=TextEditingController(),_amountC=TextEditingController();
  String _inst='1st',_status='pending';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_bankC.dispose();_amountC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    final now=DateTime.now();
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'bankAcc':_bankC.text.trim(),'amount':_amountC.text.trim(),'installment':_inst,'status':_status,'regDate':'${now.day} ${_month(now.month)} ${now.year}'});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatGreen,lightColor:kMatGreen.withOpacity(0.08),icon:Icons.account_balance_wallet_outlined,title:'Add MMVY Beneficiary',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatGreen),const SizedBox(height:10),buildListeningBanner(kMatGreen),
      sectionLabel('Beneficiary Info',kMatGreen),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatGreen,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatGreen,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatGreen,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('Payment Info',kMatGreen),
      voiceField(fieldKey:'bank',controller:_bankC,label:_t('bankAcc'),icon:Icons.account_balance_outlined,color:kMatGreen,validator:(v)=>v==null||v.trim().isEmpty?'Bank account required':null),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'amount',controller:_amountC,label:_t('jsyAmount'),icon:Icons.currency_rupee_rounded,color:kMatGreen,keyboard:TextInputType.number,formatters:[FilteringTextInputFormatter.digitsOnly],validator:(v)=>v==null||v.trim().isEmpty?'Amount required':null)),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:_t('installment'),color:kMatGreen,value:_inst,items:['1st','2nd','3rd'],onChanged:(v)=>setState(()=>_inst=v!))),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:'Status',color:kMatGreen,value:_status,items:['pending','received'],onChanged:(v)=>setState(()=>_status=v!))),
      ]),
      const SizedBox(height:14),buildMicHint(kMatGreen,kMatGreen.withOpacity(0.08)),
    ])));
}

// ── 8. Postnatal Dialog ──
class _PostnatalDialog extends StatefulWidget {
  const _PostnatalDialog();
  @override State<_PostnatalDialog> createState() => _PostnatalDialogState();
}
class _PostnatalDialogState extends State<_PostnatalDialog> with VoiceDialogMixin {
  final _fk=GlobalKey<FormState>();
  final _nameC=TextEditingController(),_phoneC=TextEditingController(),_villageC=TextEditingController(),_babyWC=TextEditingController(),_motherWC=TextEditingController();
  String _pnc='1st',_bf='Yes',_status='good';
  @override void initState(){super.initState();initVoice();}
  @override void dispose(){stopVoice();_nameC.dispose();_phoneC.dispose();_villageC.dispose();_babyWC.dispose();_motherWC.dispose();super.dispose();}
  void _save(){
    if(!_fk.currentState!.validate())return;
    final now=DateTime.now();
    Navigator.pop(context,{'name':_nameC.text.trim(),'phone':_phoneC.text.trim().replaceAll(RegExp(r'\s+'),''),'village':_villageC.text.trim(),'deliveryDate':'${now.day} ${_month(now.month)} ${now.year}','pncVisit':_pnc,'breastfeeding':_bf,'babyWeight':_babyWC.text.trim(),'motherWeight':_motherWC.text.trim(),'status':_status});
  }
  @override Widget build(BuildContext context)=>_dlgShell(context:context,color:kMatDeepPink,lightColor:const Color(0xFFFCE7F3),icon:Icons.favorite_border_rounded,title:'Add Postnatal Record',onSave:_save,
    form:Form(key:_fk,child:Column(children:[
      buildLangBar(kMatDeepPink),const SizedBox(height:10),buildListeningBanner(kMatDeepPink),
      sectionLabel('Mother Info',kMatDeepPink),
      voiceField(fieldKey:'name',controller:_nameC,label:_t('name'),icon:Icons.person_outline,color:kMatDeepPink,validator:_validateName),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'phone',controller:_phoneC,label:_t('phone'),icon:Icons.phone_outlined,color:kMatDeepPink,keyboard:TextInputType.phone,maxLen:10,formatters:[FilteringTextInputFormatter.digitsOnly],validator:_validatePhone)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'village',controller:_villageC,label:_t('village'),icon:Icons.location_on_outlined,color:kMatDeepPink,validator:(v)=>v==null||v.trim().isEmpty?'Village required':null)),
      ]),
      const SizedBox(height:14),sectionLabel('Postnatal Details',kMatDeepPink),
      Row(children:[
        Expanded(child:voiceField(fieldKey:'babyW',controller:_babyWC,label:_t('babyWeight'),icon:Icons.child_care_outlined,color:kMatDeepPink,keyboard:TextInputType.number,validator:(v)=>v==null||v.trim().isEmpty?'Baby weight required':null)),
        const SizedBox(width:10),
        Expanded(child:voiceField(fieldKey:'motherW',controller:_motherWC,label:'Mother Wt (kg)',icon:Icons.monitor_weight_outlined,color:kMatDeepPink,keyboard:TextInputType.number,formatters:[FilteringTextInputFormatter.digitsOnly],validator:(v)=>v==null||v.trim().isEmpty?'Weight required':null)),
      ]),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:_dropField(label:_t('pncVisit'),color:kMatDeepPink,value:_pnc,items:['1st','2nd','3rd'],onChanged:(v)=>setState(()=>_pnc=v!))),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:_t('breastfeeding'),color:kMatDeepPink,value:_bf,items:['Yes','No','Partial'],onChanged:(v)=>setState(()=>_bf=v!))),
        const SizedBox(width:10),
        Expanded(child:_dropField(label:'Status',color:kMatDeepPink,value:_status,items:['good','monitoring','referred'],onChanged:(v)=>setState(()=>_status=v!))),
      ]),
      const SizedBox(height:14),buildMicHint(kMatDeepPink,const Color(0xFFFCE7F3)),
    ])));
}
// ══════════════════════════════════════════════════════════
//  9. MATERNAL VACCINATION PAGE
//     Pregnant mahilaon ka TT vaccine record
// ══════════════════════════════════════════════════════════
class MaternalVaccinePage extends StatefulWidget {
  const MaternalVaccinePage({super.key});
  @override State<MaternalVaccinePage> createState() => _MaternalVaccinePageState();
}

class _MaternalVaccinePageState extends State<MaternalVaccinePage> {
  static const _color = kMatTeal;

  final _list = <Map<String, String>>[
    {
      'name': 'Kavita Sharma', 'phone': '9876500001', 'village': 'Wardha',
      'anc': '2', 'edd': 'Mar 2025',
      'ttDone': 'TT-1 Done', 'nextDose': 'TT-2',
      'nextDate': '15 Mar 2025', 'status': 'due',
    },
    {
      'name': 'Priya Patil', 'phone': '9876500002', 'village': 'Nagpur',
      'anc': '1', 'edd': 'May 2025',
      'ttDone': 'Not Done', 'nextDose': 'TT-1',
      'nextDate': '20 Jan 2025', 'status': 'overdue',
    },
    {
      'name': 'Asha Devi', 'phone': '9876500003', 'village': 'Hingna',
      'anc': '3', 'edd': 'Jul 2025',
      'ttDone': 'TT-1, TT-2 Done', 'nextDose': 'Booster',
      'nextDate': 'After delivery', 'status': 'done',
    },
  ];

  final _sc = TextEditingController();
  String _q = '', _fl = 'all';

  List<Map<String, String>> get _filtered => _list.where((p) {
        if (_fl != 'all' && p['status'] != _fl) return false;
        if (_q.isEmpty) return true;
        final q = _q.toLowerCase();
        return p['name']!.toLowerCase().contains(q) ||
            p['village']!.toLowerCase().contains(q) ||
            p['phone']!.contains(q);
      }).toList();

  Future<void> _add() async {
    final r = await showDialog<Map<String, String>>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _MaternalVaccineDialog());
    if (r != null && mounted) setState(() => _list.insert(0, r));
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Container(
      color: kBg,
      child: Column(children: [
        _subHdr(_t('vaccRecord'), _color, Icons.vaccines_rounded, _add),

        // Stats bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(children: [
            _statPill('${_list.length}',                                          'Total',   _color),
            const SizedBox(width: 8),
            _statPill('${_list.where((p) => p['status'] == 'done').length}',      'Done',    kMatGreen),
            const SizedBox(width: 8),
            _statPill('${_list.where((p) => p['status'] == 'due').length}',       'Due',     kMatOrange),
            const SizedBox(width: 8),
            _statPill('${_list.where((p) => p['status'] == 'overdue').length}',   'Overdue', kMatRed),
          ]),
        ),

        buildSearchBar(
          controller: _sc,
          hint: 'Search by name, village, phone…',
          color: _color,
          onChanged: () => setState(() => _q = _sc.text.trim()),
        ),
        buildFilterChips(
          current: _fl, color: _color, count: list.length,
          chips: [
            {'label': 'All',     'value': 'all'},
            {'label': 'Due',     'value': 'due'},
            {'label': 'Overdue', 'value': 'overdue'},
            {'label': 'Done',    'value': 'done'},
          ],
          onTap: (v) => setState(() => _fl = v),
        ),

        Expanded(
          child: list.isEmpty
              ? emptyState(_q)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _VaccCard(data: list[i]),
                ),
        ),
      ]),
    );
  }

  Widget _statPill(String value, String label, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800, color: color, decoration: TextDecoration.none)),
            Text(label,
                style: const TextStyle(fontSize: 9, color: kMuted, decoration: TextDecoration.none),
                textAlign: TextAlign.center),
          ]),
        ),
      );
}

// ── Expandable Vaccine Card ─────────────────────────────
class _VaccCard extends StatefulWidget {
  final Map<String, String> data;
  const _VaccCard({required this.data});
  @override State<_VaccCard> createState() => _VaccCardState();
}

class _VaccCardState extends State<_VaccCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.data;
    final Color col = p['status'] == 'overdue'
        ? kMatRed
        : p['status'] == 'due'
            ? kMatOrange
            : kMatGreen;
    final String statusLabel = p['status'] == 'overdue'
        ? _t('overdue')
        : p['status'] == 'due'
            ? _t('due')
            : _t('done2');

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: p['status'] == 'overdue'
              ? Border.all(color: kMatRed.withOpacity(0.35))
              : Border.all(color: kMatTeal.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header row ──
          Row(children: [
            CircleAvatar(
              backgroundColor: kMatTeal.withOpacity(0.12),
              child: const Icon(Icons.pregnant_woman_rounded,
                  color: kMatTeal, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['name']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 11, color: kMuted),
                  const SizedBox(width: 2),
                  Text(p['village']!,
                      style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  const SizedBox(width: 10),
                  const Icon(Icons.phone_outlined, size: 11, color: kMuted),
                  const SizedBox(width: 2),
                  Text(p['phone']!,
                      style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                ]),
              ]),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: col.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(statusLabel,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: col, decoration: TextDecoration.none)),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: kMuted, size: 20),
            ),
          ]),

          // ── Expandable details ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: kBorder),
                  const SizedBox(height: 8),

                  // Info grid
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kBg,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _vrow(Icons.vaccines_rounded,
                          '${_t('ttDose')}: ${p['ttDone']}', kMatTeal),
                      const SizedBox(height: 5),
                      _vrow(Icons.upcoming_rounded,
                          '${_t('nextVacc')}: ${p['nextDose']}', kMatOrange),
                      const SizedBox(height: 5),
                      _vrow(Icons.calendar_today_rounded,
                          '${_t('nextDate')}: ${p['nextDate']}', kMatBlue),
                      const SizedBox(height: 5),
                      _vrow(Icons.assignment_outlined,
                          '${_t('anc')}: ${p['anc']}', kMatPurple),
                      const SizedBox(height: 5),
                      _vrow(Icons.child_care_rounded,
                          '${_t('edd')}: ${p['edd']}', kMatPink),
                    ]),
                  ),
                  const SizedBox(height: 8),

                  // WhatsApp reminder button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final lang = langNotifier.value;
                        String msg;
                        if (lang == 'mr') {
                          msg = '🏥 *TT लस स्मरणपत्र*\n\nप्रिय ${p['name']} जी,\n\n'
                              '💉 पुढील TT डोस: ${p['nextDose']}\n'
                              '📅 तारीख: ${p['nextDate']}\n'
                              '🤱 प्रसूती तारीख: ${p['edd']}\n\n'
                              'वेळेत TT लस घ्या — माता व बाळ सुरक्षित! 🙏';
                        } else if (lang == 'hi') {
                          msg = '🏥 *TT टीका स्मरण*\n\nप्रिय ${p['name']} जी,\n\n'
                              '💉 अगला TT डोज़: ${p['nextDose']}\n'
                              '📅 तिथि: ${p['nextDate']}\n'
                              '🤱 प्रसव तिथि: ${p['edd']}\n\n'
                              'समय पर TT लगवाएं — माँ और बच्चा सुरक्षित! 🙏';
                        } else {
                          msg = '🏥 *TT Vaccination Reminder*\n\nDear ${p['name']},\n\n'
                              '💉 Next TT Dose: ${p['nextDose']}\n'
                              '📅 Date: ${p['nextDate']}\n'
                              '🤱 EDD: ${p['edd']}\n\n'
                              'Get TT vaccine on time — safe mother, safe baby! 🙏';
                        }
                        final url =
                            'https://wa.me/91${p['phone']}?text=${Uri.encodeComponent(msg)}';
                        try {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } catch (_) {
                          await Clipboard.setData(ClipboardData(text: msg));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Message copied! WhatsApp pe paste karein'),
                                backgroundColor: const Color(0xFF25D366),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.chat_rounded,
                          size: 15, color: Color(0xFF25D366)),
                      label: const Text('WhatsApp Reminder',
                          style: TextStyle(fontSize: 12, decoration: TextDecoration.none)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        side: const BorderSide(color: Color(0xFF25D366)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 9, horizontal: 12),
                      ),
                    ),
                  ),
                ]),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ]),
      ),
    );
  }

  Widget _vrow(IconData icon, String text, Color color) =>
      Row(children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 11.5, color: kText, decoration: TextDecoration.none))),
      ]);
}

// ── Maternal Vaccine Dialog (Voice Enabled) ─────────────
class _MaternalVaccineDialog extends StatefulWidget {
  const _MaternalVaccineDialog();
  @override State<_MaternalVaccineDialog> createState() => _MaternalVaccineDialogState();
}

class _MaternalVaccineDialogState extends State<_MaternalVaccineDialog>
    with VoiceDialogMixin {
  final _fk        = GlobalKey<FormState>();
  final _nameC     = TextEditingController();
  final _phoneC    = TextEditingController();
  final _villageC  = TextEditingController();
  final _nextDateC = TextEditingController();
  final _eddC      = TextEditingController();

  String _anc      = '1';
  String _ttDone   = 'Not Done';
  String _nextDose = 'TT-1';
  String _status   = 'due';

  @override void initState() { super.initState(); initVoice(); }
  @override void dispose() {
    stopVoice();
    _nameC.dispose(); _phoneC.dispose(); _villageC.dispose();
    _nextDateC.dispose(); _eddC.dispose();
    super.dispose();
  }

  void _save() {
    if (!_fk.currentState!.validate()) return;
    Navigator.pop(context, {
      'name':     _nameC.text.trim(),
      'phone':    _phoneC.text.trim(),
      'village':  _villageC.text.trim(),
      'anc':      _anc,
      'edd':      _eddC.text.trim(),
      'ttDone':   _ttDone,
      'nextDose': _nextDose,
      'nextDate': _nextDateC.text.trim(),
      'status':   _status,
    });
  }

  @override
  Widget build(BuildContext context) => _dlgShell(
    context: context,
    color: kMatTeal,
    lightColor: kMatTeal.withOpacity(0.10),
    icon: Icons.vaccines_rounded,
    title: 'Add Vaccination Record',
    onSave: _save,
    form: Form(
      key: _fk,
      child: Column(children: [
        buildLangBar(kMatTeal),
        const SizedBox(height: 10),
        buildListeningBanner(kMatTeal),

        sectionLabel("Mother's Info", kMatTeal),
        voiceField(
          fieldKey: 'name', controller: _nameC,
          label: _t('name'), icon: Icons.person_outline, color: kMatTeal,
          validator: _validateName,
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: voiceField(
            fieldKey: 'phone', controller: _phoneC,
            label: _t('phone'), icon: Icons.phone_outlined, color: kMatTeal,
            keyboard: TextInputType.phone, maxLen: 10,
            formatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _validatePhone,
          )),
          const SizedBox(width: 10),
          Expanded(child: voiceField(
            fieldKey: 'village', controller: _villageC,
            label: _t('village'), icon: Icons.location_on_outlined, color: kMatTeal,
            validator: (v) => v == null || v.trim().isEmpty ? 'Village required' : null,
          )),
        ]),
        const SizedBox(height: 14),

        sectionLabel('Vaccination Details', kMatTeal),
        Row(children: [
          Expanded(child: _dropField(
            label: _t('anc'), color: kMatTeal, value: _anc,
            items: ['1', '2', '3', '4'],
            onChanged: (v) => setState(() => _anc = v!),
          )),
          const SizedBox(width: 10),
          Expanded(child: _dropField(
            label: _t('ttDose'), color: kMatTeal, value: _ttDone,
            items: ['Not Done', 'TT-1 Done', 'TT-1,2 Done'],
            onChanged: (v) => setState(() => _ttDone = v!),
          )),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _dropField(
            label: _t('nextVacc'), color: kMatTeal, value: _nextDose,
            items: ['TT-1', 'TT-2', 'Booster'],
            onChanged: (v) => setState(() => _nextDose = v!),
          )),
          const SizedBox(width: 10),
          Expanded(child: _dropField(
            label: 'Status', color: kMatTeal, value: _status,
            items: ['due', 'overdue', 'done'],
            onChanged: (v) => setState(() => _status = v!),
          )),
        ]),
        const SizedBox(height: 10),
        voiceField(
          fieldKey: 'nextDate', controller: _nextDateC,
          label: _t('nextDate'), icon: Icons.calendar_today_rounded, color: kMatTeal,
          validator: (v) => v == null || v.trim().isEmpty ? 'Next date required' : null,
        ),
        const SizedBox(height: 10),
        voiceField(
          fieldKey: 'edd', controller: _eddC,
          label: _t('edd'), icon: Icons.child_care_rounded, color: kMatTeal,
          validator: (v) => v == null || v.trim().isEmpty ? 'EDD required' : null,
        ),
        const SizedBox(height: 14),
        buildMicHint(kMatTeal, kMatTeal.withOpacity(0.08)),
      ]),
    ),
  );
}