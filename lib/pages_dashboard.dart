import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'daily_report_page.dart';
import 'scheme_detail_page.dart';
import 'asha_new_features.dart'
    hide
        kGreen,
        kGreenLight,
        kBlue,
        kBlueLight,
        kRed,
        kRedLight,
        kOrange,
        kOrangeLight,
        kPurple,
        kPurpleLight,
        kTeal,
        kTealLight,
        kPink,
        kPinkLight,
        kText,
        kMuted,
        kBorder,
        kBg,
        offlineNotifier,
        pendingSyncCount;
import 'pages_health.dart';
import 'pages_stock.dart';
import 'pages_info.dart';
import 'pages_maternal.dart'; // ✅ NEW IMPORT — saare 8 sub-tabs yahan se aayenge

// ══════════════════════════════════════════════════════════
//  COLORS (dashboard-specific extra colors)
// ══════════════════════════════════════════════════════════
const kPurple      = Color(0xFF7B2FBE);
const kPurpleLight = Color(0xFFF3E8FF);
const kRed         = Color(0xFFE53935);
const kRedLight    = Color(0xFFFFEBEE);
const kTeal        = Color(0xFF00897B);
const kTealLight   = Color(0xFFE0F2F1);
const kPink        = Color(0xFFD81B60);
const kPinkLight   = Color(0xFFFCE4EC);

// ══════════════════════════════════════════════════════════
//  TRANSLATIONS (dashboard specific)
// ══════════════════════════════════════════════════════════
class TrD {
  static const _d = {
    'dashboard':     {'en':'Dashboard',           'hi':'डैशबोर्ड',           'mr':'डॅशबोर्ड'},
    'welcome':       {'en':'Welcome, ASHA Didi!', 'hi':'स्वागत है, आशा दीदी!','mr':'स्वागत, आशा दीदी!'},
    'ashaId':        {'en':'ASHA ID: MH-2024-001','hi':'आशा ID: MH-2024-001', 'mr':'आशा ID: MH-2024-001'},
    'todaySummary':  {'en':'Today\'s Summary',    'hi':'आज का सारांश',        'mr':'आजचा सारांश'},
    'quickActions':  {'en':'Quick Actions',       'hi':'त्वरित कार्य',       'mr':'जलद क्रिया'},
    'homeVisits':    {'en':'Home Visits',         'hi':'घर भेंट',             'mr':'गृह भेट'},
    'addVisit':      {'en':'Add Visit',           'hi':'भेंट जोड़ें',          'mr':'भेट जोडा'},
    'visitName':     {'en':'Patient Name',        'hi':'मरीज़ का नाम',        'mr':'रुग्णाचे नाव'},
    'visitPhone':    {'en':'Phone Number',        'hi':'फ़ोन नंबर',            'mr':'फोन नंबर'},
    'visitReason':   {'en':'Visit Reason',        'hi':'भेंट का कारण',        'mr':'भेटीचे कारण'},
    'visitNotes':    {'en':'Health Notes',        'hi':'स्वास्थ्य नोट',       'mr':'आरोग्य नोट'},
    'completed':     {'en':'Completed',           'hi':'पूर्ण',               'mr':'पूर्ण'},
    'pending':       {'en':'Pending',             'hi':'बाकी',                'mr':'बाकी'},
    'pregnantWomen': {'en':'Pregnant Women',      'hi':'गर्भवती महिला',       'mr':'गर्भवती महिला'},
    'addMahila':     {'en':'Add Mahila',          'hi':'महिला जोड़ें',         'mr':'महिला जोडा'},
    'trimester':     {'en':'Trimester',           'hi':'तिमाही',              'mr':'तिमाही'},
    'highRisk':      {'en':'High Risk',           'hi':'उच्च जोखिम',          'mr':'उच्च धोका'},
    'normal':        {'en':'Normal',              'hi':'सामान्य',             'mr':'सामान्य'},
    'husbandName':   {'en':'Husband Name',        'hi':'पति का नाम',           'mr':'पतीचे नाव'},
    'bloodGroup':    {'en':'Blood Group',         'hi':'ब्लड ग्रुप',           'mr':'रक्त गट'},
    'weightKg':      {'en':'Weight (kg)',         'hi':'वजन (kg)',              'mr':'वजन (kg)'},
    'vaccination':   {'en':'Child Vaccination',  'hi':'बाल टीकाकरण',         'mr':'बाल लसीकरण'},
    'addChild':      {'en':'Add Child',          'hi':'बच्चा जोड़ें',         'mr':'मूल जोडा'},
    'nextVaccine':   {'en':'Next Vaccine',       'hi':'अगला टीका',           'mr':'पुढील लस'},
    'upToDate':      {'en':'Up to Date',         'hi':'अप टू डेट',           'mr':'अप टू डेट'},
    'overdue':       {'en':'Overdue',            'hi':'बाकी',                'mr':'उशीर'},
    'motherName':    {'en':'Mother\'s Name',     'hi':'माँ का नाम',           'mr':'आईचे नाव'},
    'fatherName':    {'en':'Father\'s Name',     'hi':'पिता का नाम',          'mr':'वडिलांचे नाव'},
    'birthDate':     {'en':'Date of Birth',      'hi':'जन्म तारीख',           'mr':'जन्म तारीख'},
    'medicine':      {'en':'Medicine Stock',     'hi':'दवाई स्टॉक',          'mr':'औषध साठा'},
    'addMedicine':   {'en':'Add Stock',          'hi':'स्टॉक जोड़ें',         'mr':'साठा जोडा'},
    'inStock':       {'en':'In Stock',           'hi':'उपलब्ध',              'mr':'उपलब्ध'},
    'lowStock':      {'en':'Low Stock',          'hi':'कम स्टॉक',            'mr':'कमी साठा'},
    'outOfStock':    {'en':'Out of Stock',       'hi':'खत्म',                'mr':'संपले'},
    'quantity':      {'en':'Quantity',           'hi':'मात्रा',              'mr':'प्रमाण'},
    'batchNo':       {'en':'Batch No.',          'hi':'बैच नंबर',             'mr':'बॅच नंबर'},
    'expiryDate':    {'en':'Expiry Date',        'hi':'समाप्ति तारीख',        'mr':'समाप्ती तारीख'},
    'supplier':      {'en':'Supplier',           'hi':'आपूर्तिकर्ता',         'mr':'पुरवठादार'},
    'reports':       {'en':'Monthly Report',     'hi':'मासिक रिपोर्ट',       'mr':'मासिक अहवाल'},
    'generate':      {'en':'Generate',           'hi':'बनाएं',               'mr':'तयार करा'},
    'thisMonth':     {'en':'This Month',         'hi':'इस महीने',            'mr':'या महिन्यात'},
    'supervisor':    {'en':'Supervisor Alert',   'hi':'सुपरवाइज़र अलर्ट',    'mr':'पर्यवेक्षक अलर्ट'},
    'sendMsg':       {'en':'Send Message',       'hi':'संदेश भेजें',         'mr':'संदेश पाठवा'},
    'msgSent':       {'en':'Message Sent!',      'hi':'संदेश भेजा गया!',     'mr':'संदेश पाठवला!'},
    'schemes':       {'en':'Govt. Schemes',      'hi':'सरकारी योजनाएं',      'mr':'सरकारी योजना'},
    'earnings':      {'en':'Incentive Tracker',  'hi':'इनसेंटिव ट्रैकर',     'mr':'इन्सेंटिव ट्रॅकर'},
    'totalEarned':   {'en':'Total Earned',       'hi':'कुल कमाई',            'mr':'एकूण कमाई'},
    'pending2':      {'en':'Pending Payment',    'hi':'बाकी भुगतान',         'mr':'बाकी देयक'},
    'thisMonthEarn': {'en':'This Month',         'hi':'इस महीने',            'mr':'या महिन्यात'},
    'save':          {'en':'Save',               'hi':'सेव करें',            'mr':'सेव करा'},
    'cancel':        {'en':'Cancel',             'hi':'रद्द करें',           'mr':'रद्द करा'},
    'name':          {'en':'Name',               'hi':'नाम',                 'mr':'नाव'},
    'age':           {'en':'Age',                'hi':'उम्र',                'mr':'वय'},
    'village':       {'en':'Village',            'hi':'गांव',                'mr':'गाव'},
    'phone':         {'en':'Phone',              'hi':'फ़ोन',                 'mr':'फोन'},
    'noData':        {'en':'No data yet',        'hi':'कोई डेटा नहीं',       'mr':'डेटा नाही'},
  };
  static String g(String k) {
    final lang = langNotifier.value;
    return _d[k]?[lang] ?? _d[k]?['en'] ?? k;
  }
}

String td(String k) => TrD.g(k);

// ══════════════════════════════════════════════════════════
//  ASHA HOME PAGE
// ══════════════════════════════════════════════════════════
class AshaHomePage extends StatefulWidget {
  const AshaHomePage({super.key});
  @override
  State<AshaHomePage> createState() => _AshaHomePageState();
}

class _AshaHomePageState extends State<AshaHomePage> {
  int _tab = 0;

  // ✅ KEY CHANGE: index 2 ab pages_maternal.dart ka PregnantPage use karega
  // pages_health.dart mein jo purana PregnantPage tha woh simple list tha
  // pages_maternal.dart mein 8 sub-tabs wala naya PregnantPage hai
  late final List<Widget> _pages = const [
    _DashboardPage(),       // 0  - Home
    HomeVisitsPage(),       // 1  - pages_health.dart
    MaternalHealthPage(),   // 2  ✅ pages_maternal.dart (8 sub-tabs!)
    VaccinationPage(),      // 3  - pages_health.dart
    MedicinePage(),         // 4  - pages_stock.dart
    EnhancedReportsPage(),  // 5  - asha_new_features.dart
    SupervisorPage(),       // 6  - pages_info.dart
    SchemesPage(),          // 7  - pages_info.dart
    EarningsPage(),         // 8  - pages_stock.dart
    AiAssistantPage(),      // 9  - asha_new_features.dart
    NotificationsPage(),    // 10 - asha_new_features.dart
    PhotoUploadPage(),      // 11 - asha_new_features.dart
    ProfileSettingsPage(),  // 12 - asha_new_features.dart
    DailyReportPage(),      // 13 - daily_report_page.dart
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: kBg,
        body: OfflineBanner(child: _pages[_tab]),
        bottomNavigationBar:
            _BottomNav(selected: _tab, onTap: (i) => setState(() => _tab = i)),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BOTTOM NAVIGATION
// ══════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard_rounded,              'label': 'Home'},
      {'icon': Icons.home_work_rounded,              'label': 'Visits'},
      {'icon': Icons.pregnant_woman_rounded,         'label': 'Mahila'},
      {'icon': Icons.vaccines_rounded,               'label': 'Vaccine'},
      {'icon': Icons.medication_rounded,             'label': 'Dawai'},
      {'icon': Icons.bar_chart_rounded,              'label': 'Report'},
      {'icon': Icons.supervisor_account_rounded,     'label': 'Alert'},
      {'icon': Icons.policy_rounded,                 'label': 'Yojana'},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'Earn'},
      {'icon': Icons.smart_toy_rounded,              'label': 'AI Help'},
      {'icon': Icons.notifications_rounded,          'label': 'Alerts'},
      {'icon': Icons.folder_rounded,                 'label': 'Docs'},
      {'icon': Icons.person_rounded,                 'label': 'Profile'},
      {'icon': Icons.assignment_rounded,             'label': 'Daily'},
    ];
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4))]),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (_, i) {
              final sel = selected == i;
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  decoration: BoxDecoration(
                      color: sel ? kGreenLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i]['icon'] as IconData,
                          color: sel ? kGreen : kMuted,
                          size: sel ? 22 : 20),
                      const SizedBox(height: 2),
                      Text(items[i]['label'] as String,
                          style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                              color: sel ? kGreen : kMuted)),
                    ]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  COMMON WIDGETS
// ══════════════════════════════════════════════════════════
class PageHeader extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final Widget? action;
  const PageHeader({super.key, required this.title, required this.color,
      required this.icon, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Row(children: [
        Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Text(title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white))),
        MiniLangBar(),
        if (action != null) ...[const SizedBox(width: 8), action!],
      ]),
    );
  }
}

class MiniLangBar extends StatelessWidget {
  const MiniLangBar({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Row(
        children: [
          {'code': 'en', 'label': 'EN'},
          {'code': 'hi', 'label': 'हि'},
          {'code': 'mr', 'label': 'म'},
        ].map((o) {
          final sel = lang == o['code'];
          return GestureDetector(
            onTap: () => langNotifier.value = o['code']!,
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                  color: sel ? Colors.white : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(o['label']!,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: sel ? kGreen : Colors.white)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DStatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const DStatCard({super.key, required this.label, required this.value,
      required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18)),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: kMuted)),
        ]),
      ),
    );
  }
}

Widget buildTag(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
        color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
    child: Text(label,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)));

Widget sectionLabel(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Row(children: [
      Container(width: 4, height: 14,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
    ]));

Widget buildSearchBar({
  required TextEditingController controller,
  required String hint,
  required Color color,
  required VoidCallback onChanged,
}) {
  return Container(
    color: color.withOpacity(0.04),
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
    child: TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      style: const TextStyle(fontSize: 13, color: kText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: kMuted),
        prefixIcon: Icon(Icons.search_rounded, color: color, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () { controller.clear(); onChanged(); },
                child: const Icon(Icons.close_rounded, color: kMuted, size: 18))
            : null,
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: color, width: 1.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    ),
  );
}

Widget buildFilterChips({
  required String current,
  required List<Map<String, String>> chips,
  required Color color,
  required int count,
  required ValueChanged<String> onTap,
}) {
  return Container(
    color: color.withOpacity(0.04),
    padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
    child: Row(children: [
      ...chips.map((c) {
        final sel = current == c['value'];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onTap(c['value']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: sel ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? color : kBorder)),
              child: Text(c['label']!, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: sel ? Colors.white : kMuted)),
            ),
          ),
        );
      }),
      const Spacer(),
      Text('$count record${count == 1 ? '' : 's'}',
          style: const TextStyle(fontSize: 11, color: kMuted, fontWeight: FontWeight.w500)),
    ]),
  );
}

Widget vField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required Color color,
  String? Function(String?)? validator,
  TextInputType keyboard = TextInputType.text,
  List<TextInputFormatter>? formatters,
  int? maxLen,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboard,
    maxLength: maxLen,
    inputFormatters: formatters,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    style: const TextStyle(fontSize: 13, color: kText),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: color, size: 18),
      counterText: '',
      filled: true, fillColor: const Color(0xFFF8FAFC),
      labelStyle: const TextStyle(fontSize: 12, color: kMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: kBorder, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: BorderSide(color: color, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: Colors.red, width: 2)),
      errorStyle: const TextStyle(fontSize: 10.5),
      errorMaxLines: 2,
    ),
  );
}

Future<void> showValidatedDialog({
  required BuildContext context,
  required String title,
  required Color color,
  required IconData icon,
  required List<Widget> fields,
  required GlobalKey<FormState> formKey,
  required VoidCallback onSave,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Container(width: 42, height: 42,
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Icon(icon, color: color, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color))),
                  GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(width: 32, height: 32,
                          decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close_rounded, size: 16, color: kMuted))),
                ]),
                const SizedBox(height: 4),
                Divider(color: color.withOpacity(0.15), height: 24),
                ...fields,
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kBorder),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Text(td('cancel'), style: const TextStyle(color: kMuted, fontWeight: FontWeight.w600)))),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) { onSave(); Navigator.pop(ctx); }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: color, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.check_rounded, size: 18),
                        const SizedBox(width: 6),
                        Text(td('save'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      ]))),
                ]),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget emptyState(String query) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.search_off_rounded, size: 48, color: kMuted.withOpacity(0.4)),
      const SizedBox(height: 10),
      Text(query.isNotEmpty ? 'No results for "$query"' : 'No data found',
          style: const TextStyle(fontSize: 13, color: kMuted)),
    ]));

// ══════════════════════════════════════════════════════════
//  DASHBOARD PAGE
// ══════════════════════════════════════════════════════════
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [kGreen, kGreenDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(td('welcome'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(td('ashaId'), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                ])),
                MiniLangBar(),
                const SizedBox(width: 8),
                CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.white)),
              ]),
              const SizedBox(height: 20),
              Text(td('todaySummary'), style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(children: [
                _WhiteStat(value: '8', label: td('homeVisits')),
                const SizedBox(width: 10),
                _WhiteStat(value: '3', label: td('pregnantWomen')),
                const SizedBox(width: 10),
                _WhiteStat(value: '5', label: td('vaccination')),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 4),
              Row(children: [
                DStatCard(label: td('homeVisits'),    value: '8',  color: kBlue,   icon: Icons.home_work_rounded),
                const SizedBox(width: 10),
                DStatCard(label: td('pregnantWomen'), value: '12', color: kPink,   icon: Icons.pregnant_woman_rounded),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                DStatCard(label: td('vaccination'),   value: '24', color: kTeal,   icon: Icons.vaccines_rounded),
                const SizedBox(width: 10),
                DStatCard(label: td('medicine'),      value: '18', color: kOrange, icon: Icons.medication_rounded),
              ]),
              const SizedBox(height: 20),
              Text(td('quickActions'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kText)),
              const SizedBox(height: 12),
              _DSectionCard(title: td('homeVisits'),    subtitle: '8 visits today',     color: kBlue,   bgColor: kBlueLight,   icon: Icons.home_work_rounded),
              const SizedBox(height: 10),
              _DSectionCard(title: td('pregnantWomen'), subtitle: '2 high risk cases',  color: kPink,   bgColor: kPinkLight,   icon: Icons.pregnant_woman_rounded),
              const SizedBox(height: 10),
              _DSectionCard(title: td('vaccination'),   subtitle: '3 due this week',    color: kTeal,   bgColor: kTealLight,   icon: Icons.vaccines_rounded),
              const SizedBox(height: 10),
              _DSectionCard(title: td('medicine'),      subtitle: '2 low stock items',  color: kOrange, bgColor: kOrangeLight, icon: Icons.medication_rounded),
              const SizedBox(height: 10),
              _DSectionCard(title: td('earnings'),      subtitle: '₹2,400 this month',  color: kPurple, bgColor: kPurpleLight, icon: Icons.account_balance_wallet_rounded),
              const SizedBox(height: 10),
              _DSectionCard(title: 'Daily Report',      subtitle: 'Vivah • Janm • Mrityu records',
                  color: const Color(0xFF37474F), bgColor: const Color(0xFFECEFF1), icon: Icons.assignment_rounded),
              const SizedBox(height: 24),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _WhiteStat extends StatelessWidget {
  final String value, label;
  const _WhiteStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.8)), textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _DSectionCard extends StatelessWidget {
  final String title, subtitle;
  final Color color, bgColor;
  final IconData icon;
  const _DSectionCard({required this.title, required this.subtitle, required this.color, required this.bgColor, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 3))]),
    child: Row(children: [
      Container(width: 48, height: 48,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 24)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        Text(subtitle, style: const TextStyle(fontSize: 11.5, color: kMuted)),
      ])),
      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: kMuted),
    ]),
  );
}