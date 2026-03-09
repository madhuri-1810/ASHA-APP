import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'daily_report_page.dart';
import 'scheme_detail_page.dart';
import 'pages_health.dart' hide VaccinationPage;
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
import 'pages_stock.dart';
import 'pages_info.dart';
import 'pages_maternal.dart';
import 'page_vaccination.dart';
import 'page_child_health.dart';
import 'page_family_planning.dart';   // ← Family Planning

// ══════════════════════════════════════════════════════════
//  EXTRA COLORS
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
//  TRANSLATIONS
// ══════════════════════════════════════════════════════════
class TrD {
  static const _d = {
    'dashboard':     {'en': 'Dashboard',            'hi': 'डैशबोर्ड',            'mr': 'डॅशबोर्ड'},
    'welcome':       {'en': 'Welcome, ASHA Didi!',  'hi': 'स्वागत है, आशा दीदी!', 'mr': 'स्वागत, आशा दीदी!'},
    'ashaId':        {'en': 'ASHA ID: MH-2024-001', 'hi': 'आशा ID: MH-2024-001',  'mr': 'आशा ID: MH-2024-001'},
    'todaySummary':  {'en': "Today's Summary",      'hi': 'आज का सारांश',          'mr': 'आजचा सारांश'},
    'quickActions':  {'en': 'Quick Actions',        'hi': 'त्वरित कार्य',          'mr': 'जलद क्रिया'},
    'homeVisits':    {'en': 'Home Visits',          'hi': 'घर भेंट',               'mr': 'गृह भेट'},
    'addVisit':      {'en': 'Add Visit',            'hi': 'भेंट जोड़ें',            'mr': 'भेट जोडा'},
    'visitName':     {'en': 'Patient Name',         'hi': 'मरीज़ का नाम',           'mr': 'रुग्णाचे नाव'},
    'visitPhone':    {'en': 'Phone Number',         'hi': 'फ़ोन नंबर',              'mr': 'फोन नंबर'},
    'visitReason':   {'en': 'Visit Reason',         'hi': 'भेंट का कारण',           'mr': 'भेटीचे कारण'},
    'visitNotes':    {'en': 'Health Notes',         'hi': 'स्वास्थ्य नोट',          'mr': 'आरोग्य नोट'},
    'completed':     {'en': 'Completed',            'hi': 'पूर्ण',                  'mr': 'पूर्ण'},
    'pending':       {'en': 'Pending',              'hi': 'बाकी',                   'mr': 'बाकी'},
    'pregnantWomen': {'en': 'Pregnant Women',       'hi': 'गर्भवती महिला',          'mr': 'गर्भवती महिला'},
    'addMahila':     {'en': 'Add Mahila',           'hi': 'महिला जोड़ें',            'mr': 'महिला जोडा'},
    'trimester':     {'en': 'Trimester',            'hi': 'तिमाही',                 'mr': 'तिमाही'},
    'highRisk':      {'en': 'High Risk',            'hi': 'उच्च जोखिम',             'mr': 'उच्च धोका'},
    'normal':        {'en': 'Normal',               'hi': 'सामान्य',                'mr': 'सामान्य'},
    'husbandName':   {'en': 'Husband Name',         'hi': 'पति का नाम',              'mr': 'पतीचे नाव'},
    'bloodGroup':    {'en': 'Blood Group',          'hi': 'ब्लड ग्रुप',              'mr': 'रक्त गट'},
    'weightKg':      {'en': 'Weight (kg)',           'hi': 'वजन (kg)',               'mr': 'वजन (kg)'},
    'vaccination':   {'en': 'Child Vaccination',    'hi': 'बाल टीकाकरण',            'mr': 'बाल लसीकरण'},
    'vaccineNav':    {'en': 'Vaccine',              'hi': 'टीकाकरण',                'mr': 'लसीकरण'},
    'homeNav':       {'en': 'Home',                 'hi': 'होम',                    'mr': 'होम'},
    'addChild':      {'en': 'Add Child',            'hi': 'बच्चा जोड़ें',            'mr': 'मूल जोडा'},
    'nextVaccine':   {'en': 'Next Vaccine',         'hi': 'अगला टीका',              'mr': 'पुढील लस'},
    'upToDate':      {'en': 'Up to Date',           'hi': 'अप टू डेट',              'mr': 'अप टू डेट'},
    'overdue':       {'en': 'Overdue',              'hi': 'बाकी',                   'mr': 'उशीर'},
    'motherName':    {'en': "Mother's Name",        'hi': 'माँ का नाम',              'mr': 'आईचे नाव'},
    'fatherName':    {'en': "Father's Name",        'hi': 'पिता का नाम',             'mr': 'वडिलांचे नाव'},
    'birthDate':     {'en': 'Date of Birth',        'hi': 'जन्म तारीख',              'mr': 'जन्म तारीख'},
    'medicine':      {'en': 'Medicine Stock',       'hi': 'दवाई स्टॉक',              'mr': 'औषध साठा'},
    'addMedicine':   {'en': 'Add Stock',            'hi': 'स्टॉक जोड़ें',            'mr': 'साठा जोडा'},
    'inStock':       {'en': 'In Stock',             'hi': 'उपलब्ध',                 'mr': 'उपलब्ध'},
    'lowStock':      {'en': 'Low Stock',            'hi': 'कम स्टॉक',               'mr': 'कमी साठा'},
    'outOfStock':    {'en': 'Out of Stock',         'hi': 'खत्म',                   'mr': 'संपले'},
    'quantity':      {'en': 'Quantity',             'hi': 'मात्रा',                  'mr': 'प्रमाण'},
    'batchNo':       {'en': 'Batch No.',            'hi': 'बैच नंबर',                'mr': 'बॅच नंबर'},
    'expiryDate':    {'en': 'Expiry Date',          'hi': 'समाप्ति तारीख',           'mr': 'समाप्ती तारीख'},
    'supplier':      {'en': 'Supplier',             'hi': 'आपूर्तिकर्ता',            'mr': 'पुरवठादार'},
    'reports':       {'en': 'Monthly Report',       'hi': 'मासिक रिपोर्ट',           'mr': 'मासिक अहवाल'},
    'generate':      {'en': 'Generate',             'hi': 'बनाएं',                   'mr': 'तयार करा'},
    'thisMonth':     {'en': 'This Month',           'hi': 'इस महीने',               'mr': 'या महिन्यात'},
    'supervisor':    {'en': 'Supervisor Alert',     'hi': 'सुपरवाइज़र अलर्ट',       'mr': 'पर्यवेक्षक अलर्ट'},
    'sendMsg':       {'en': 'Send Message',         'hi': 'संदेश भेजें',             'mr': 'संदेश पाठवा'},
    'msgSent':       {'en': 'Message Sent!',        'hi': 'संदेश भेजा गया!',         'mr': 'संदेश पाठवला!'},
    'schemes':       {'en': 'Govt. Schemes',        'hi': 'सरकारी योजनाएं',          'mr': 'सरकारी योजना'},
    'earnings':      {'en': 'Incentive Tracker',    'hi': 'इनसेंटिव ट्रैकर',         'mr': 'इन्सेंटिव ट्रॅकर'},
    'totalEarned':   {'en': 'Total Earned',         'hi': 'कुल कमाई',               'mr': 'एकूण कमाई'},
    'pending2':      {'en': 'Pending Payment',      'hi': 'बाकी भुगतान',             'mr': 'बाकी देयक'},
    'thisMonthEarn': {'en': 'This Month',           'hi': 'इस महीने',               'mr': 'या महिन्यात'},
    'save':          {'en': 'Save',                 'hi': 'सेव करें',               'mr': 'सेव करा'},
    'cancel':        {'en': 'Cancel',               'hi': 'रद्द करें',               'mr': 'रद्द करा'},
    'name':          {'en': 'Name',                 'hi': 'नाम',                    'mr': 'नाव'},
    'age':           {'en': 'Age',                  'hi': 'उम्र',                   'mr': 'वय'},
    'village':       {'en': 'Village',              'hi': 'गांव',                   'mr': 'गाव'},
    'phone':         {'en': 'Phone',                'hi': 'फ़ोन',                    'mr': 'फोन'},
    'noData':        {'en': 'No data yet',          'hi': 'कोई डेटा नहीं',          'mr': 'डेटा नाही'},
    'health':        {'en': 'Health',               'hi': 'स्वास्थ्य',               'mr': 'आरोग्य'},
    'mahila':        {'en': 'Mahila',               'hi': 'महिला',                  'mr': 'महिला'},
    'balHealth':     {'en': 'Child Health',          'hi': 'बाल स्वास्थ्य',          'mr': 'बाल आरोग्य'},
    'newbornReg':    {'en': 'Newborn Reg.',          'hi': 'नवजात नोंद',              'mr': 'नवजात नोंद'},
    'birthReg':      {'en': 'Birth Reg.',            'hi': 'जन्म नोंद',               'mr': 'जन्म नोंद'},
    'hbnc':          {'en': 'HBNC Visit',            'hi': 'HBNC भेट',                'mr': 'HBNC भेट'},
    'childList':     {'en': '0-5 Yr Children',       'hi': '0-5 वर्ष बालक',          'mr': '0-5 वर्ष बालक'},
    'malnutrition':  {'en': 'Malnourished',          'hi': 'कुपोषित बालक',           'mr': 'कुपोषित बालक'},
    'illnessMgmt':   {'en': 'Illness Mgmt.',         'hi': 'आजार व्यवस्थापन',        'mr': 'आजार व्यवस्थापन'},
    'records':       {'en': 'Records',              'hi': 'रिकॉर्ड',                'mr': 'नोंदी'},
    'more':          {'en': 'More',                 'hi': 'अधिक',                   'mr': 'अधिक'},
    'profile':       {'en': 'Profile',              'hi': 'प्रोफ़ाइल',               'mr': 'प्रोफाइल'},
    'aiAssistant':   {'en': 'AI Assistant',         'hi': 'AI सहायक',               'mr': 'AI सहाय्यक'},
    'notifications': {'en': 'Notifications',        'hi': 'सूचनाएं',                'mr': 'सूचना'},
    'documents':     {'en': 'Documents',            'hi': 'दस्तावेज़',               'mr': 'दस्तावेज'},
    'dailyReport':   {'en': 'Daily Report',         'hi': 'दैनिक रिपोर्ट',          'mr': 'दैनिक अहवाल'},
    'whatsapp':      {'en': 'WhatsApp Reminders',   'hi': 'व्हाट्सएप रिमाइंडर',     'mr': 'व्हाट्सअॅप रिमाइंडर'},
    'familyPlan':   {'en': 'Family Planning',      'hi': 'परिवार नियोजन',           'mr': 'कुटुंब नियोजन'},
  };
  static String g(String k) {
    final lang = langNotifier.value;
    return _d[k]?[lang] ?? _d[k]?['en'] ?? k;
  }
}

String td(String k) => TrD.g(k);

// ══════════════════════════════════════════════════════════
//  ASHA HOME PAGE  — 5 Tabs + Drawer
// ══════════════════════════════════════════════════════════
class AshaHomePage extends StatefulWidget {
  const AshaHomePage({super.key});
  @override
  State<AshaHomePage> createState() => _AshaHomePageState();
}

class _AshaHomePageState extends State<AshaHomePage> {
  int _tab = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ── 5 Main tabs ──
  late final List<Widget> _mainPages = [
    _DashboardPage(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()),
    HomeVisitsPage(),
    _MahilaTab(),               // Mahila — pregnant + vaccination
    _VaccineTab(),              // Vaccine
    _MoreTab(onDrawerOpen: () => _scaffoldKey.currentState?.openDrawer()),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: kBg,
        drawer: _AppDrawer(
          onNavigate: (widget) => _openDrawerPage(context, widget),
        ),
        body: OfflineBanner(child: _mainPages[_tab]),
        bottomNavigationBar: _BottomNav(
          selected: _tab,
          onTap: (i) => setState(() => _tab = i),
        ),
      ),
    );
  }

  void _openDrawerPage(BuildContext context, Widget page) {
    Navigator.of(context).pop(); // close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BOTTOM NAV  — 6 tabs
// ══════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard_rounded,      'label': td('dashboard')},
      {'icon': Icons.home_work_rounded,      'label': td('homeNav')},
      {'icon': Icons.pregnant_woman_rounded, 'label': td('mahila')},
      {'icon': Icons.vaccines_rounded,       'label': td('vaccineNav')},
      {'icon': Icons.grid_view_rounded,      'label': td('more')},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
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
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 42,
                        height: 28,
                        decoration: BoxDecoration(
                          color: sel ? kGreenLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          items[i]['icon'] as IconData,
                          color: sel ? kGreen : kMuted,
                          size: sel ? 19 : 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                          color: sel ? kGreen : kMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
//  DRAWER — saari extra features
// ══════════════════════════════════════════════════════════
class _AppDrawer extends StatelessWidget {
  final void Function(Widget page) onNavigate;
  const _AppDrawer({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Profile Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kGreen, kGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              const Text('Sunita Devi',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 2),
              Text('MH-ASHA-2024-001',
                  style: TextStyle(fontSize: 11.5, color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 2),
              Text('Wardha Block, Nagpur',
                  style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
            ]),
          ),

          // ── Menu Items ──
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 8),
                _drawerSection('Reports & Records', [
                  _DrawerItem(Icons.bar_chart_rounded,   td('reports'),     kBlue,   EnhancedReportsPage(),       onNavigate),
                  _DrawerItem(Icons.assignment_rounded,  td('dailyReport'), kBlue,   DailyReportPage(),           onNavigate),
                ]),
                _drawerSection('Vaccination', [
                  _DrawerItem(Icons.vaccines_rounded,    td('vaccination'), kTeal,   const VaccinationPage(),     onNavigate),
                ]),
                _drawerSection('Child Health', [
                  _DrawerItem(Icons.child_care_rounded,  td('balHealth'),   kChildBlue, const ChildHealthPage(), onNavigate),
                ]),
                _drawerSection('Supervisor & Govt', [
                  _DrawerItem(Icons.supervisor_account_rounded, td('supervisor'), kOrange, SupervisorPage(), onNavigate),
                  _DrawerItem(Icons.policy_rounded,              td('schemes'),    kOrange, SchemesPage(),    onNavigate),
                ]),
                _drawerSection('Finance', [
                  _DrawerItem(Icons.account_balance_wallet_rounded, td('earnings'), kPurple, EarningsPage(), onNavigate),
                ]),
                _drawerSection('Family Planning', [
                  _DrawerItem(Icons.favorite_rounded, td('familyPlan'), const Color(0xFFD946EF), const FamilyPlanningPage(), onNavigate),
                ]),
                _drawerSection('Tools & Settings', [
                  _DrawerItem(Icons.smart_toy_rounded,       td('aiAssistant'),   kTeal,   AiAssistantPage(),      onNavigate),
                  _DrawerItem(Icons.notifications_rounded,   td('notifications'), kTeal,   NotificationsPage(),    onNavigate),
                  _DrawerItem(Icons.folder_open_rounded,     td('documents'),     kTeal,   PhotoUploadPage(),      onNavigate),
                  _DrawerItem(Icons.person_rounded,          td('profile'),       kMuted,  ProfileSettingsPage(),  onNavigate),
                ]),
                const SizedBox(height: 12),
              ]),
            ),
          ),

          // ── Footer ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kBorder)),
            ),
            child: Row(children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: kGreenLight, shape: BoxShape.circle),
                child: const Icon(Icons.local_hospital_rounded, color: kGreen, size: 14),
              ),
              const SizedBox(width: 10),
              const Text('NHM • Govt of India',
                  style: TextStyle(fontSize: 10.5, color: kMuted)),
              const Spacer(),
              MiniLangBar(),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _drawerSection(String title, List<Widget> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(title.toUpperCase(),
                style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: kMuted,
                    letterSpacing: 1.2)),
          ),
          ...items,
          const Divider(color: kBorder, height: 1, indent: 16, endIndent: 16),
        ],
      );
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget page;
  final void Function(Widget) onNavigate;
  const _DrawerItem(this.icon, this.label, this.color, this.page, this.onNavigate);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
      title: Text(label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kText)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: kMuted),
      onTap: () => onNavigate(page),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  MAHILA TAB  — Pregnant + Vaccination combined
// ══════════════════════════════════════════════════════════
// _MahilaTab now directly renders the full PregnantPage from pages_maternal.dart
// which has 8 sub-tabs: JSY, Pregnant List, ANC, Prenatal, Delivery, High Risk, MMVY, Postnatal
class _MahilaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const MaternalHealthPage();
}

// ══════════════════════════════════════════════════════════
//  VACCINE TAB — directly renders VaccinationPage
// ══════════════════════════════════════════════════════════
class _VaccineTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const VaccinationPage();
}

class _ChildHealthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const ChildHealthPage();
}

// Pregnant page without its own PageHeader (header handled by tab)
class _NoHeaderPregnantPage extends StatefulWidget {
  @override
  State<_NoHeaderPregnantPage> createState() => _NoHeaderPregnantPageState();
}

class _NoHeaderPregnantPageState extends State<_NoHeaderPregnantPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Kavita Sharma', 'trimester': '3rd', 'due': 'Mar 2025', 'risk': 'high',   'husband': 'Suresh Sharma', 'phone': '9876500001', 'blood': 'B+', 'weight': '68', 'lastCheckup': '20 Feb', 'village': 'Wardha'},
    {'name': 'Priya Patil',   'trimester': '2nd', 'due': 'May 2025', 'risk': 'normal', 'husband': 'Ajay Patil',   'phone': '9876500002', 'blood': 'O+', 'weight': '55', 'lastCheckup': '15 Feb', 'village': 'Nagpur'},
    {'name': 'Asha Devi',     'trimester': '1st', 'due': 'Jul 2025', 'risk': 'normal', 'husband': 'Ramesh Devi',  'phone': '9876500003', 'blood': 'A+', 'weight': '52', 'lastCheckup': '10 Feb', 'village': 'Hingna'},
  ];
  final _sc = TextEditingController();
  String _q = '', _f = 'all';

  List<Map<String, String>> get _filtered => _list.where((w) {
        if (_f != 'all' && w['risk'] != _f) return false;
        if (_q.isEmpty) return true;
        final q = _q.toLowerCase();
        return w['name']!.toLowerCase().contains(q) || w['village']!.toLowerCase().contains(q);
      }).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(children: [
      buildSearchBar(controller: _sc, hint: 'Search name, village…', color: kPink,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _f, color: kPink, count: filtered.length,
          chips: [
            {'label': 'All', 'value': 'all'},
            {'label': 'High Risk', 'value': 'high'},
            {'label': 'Normal', 'value': 'normal'},
          ],
          onTap: (v) => setState(() => _f = v)),
      Expanded(
        child: filtered.isEmpty
            ? emptyState(_q)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final w = filtered[i];
                  final isHigh = w['risk'] == 'high';
                  return _PregnantCard(w: w, isHigh: isHigh);
                }),
      ),
    ]);
  }
}

class _PregnantCard extends StatelessWidget {
  final Map<String, String> w;
  final bool isHigh;
  const _PregnantCard({required this.w, required this.isHigh});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isHigh ? Border.all(color: kRed.withOpacity(0.3)) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
                backgroundColor: kPinkLight,
                child: const Icon(Icons.pregnant_woman_rounded, color: kPink, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(w['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 4),
              Row(children: [
                buildTag('${w['trimester']} ${td('trimester')}', kPurple),
                const SizedBox(width: 6),
                buildTag(w['due']!, kTeal),
              ]),
            ])),
            buildTag(isHigh ? td('highRisk') : td('normal'), isHigh ? kRed : kGreen),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            if (w['phone']!.isNotEmpty) ...[
              const Icon(Icons.phone_outlined, size: 12, color: kMuted),
              const SizedBox(width: 4),
              Text(w['phone']!, style: const TextStyle(fontSize: 11, color: kMuted)),
              const SizedBox(width: 12),
            ],
            const Icon(Icons.water_drop_outlined, size: 12, color: kMuted),
            const SizedBox(width: 4),
            Text('Blood: ${w['blood']}', style: const TextStyle(fontSize: 11, color: kMuted)),
          ]),
        ]),
      );
}

// Vaccination page without own header
class _NoHeaderVaccinationPage extends StatefulWidget {
  @override
  State<_NoHeaderVaccinationPage> createState() => _NoHeaderVaccinationPageState();
}

class _NoHeaderVaccinationPageState extends State<_NoHeaderVaccinationPage> {
  final List<Map<String, String>> _list = [
    {'name': 'Rahul Kumar', 'age': '6 months',  'next': 'OPV', 'status': 'due',      'mother': 'Sunita Kumar', 'phone': '9800001111'},
    {'name': 'Sneha Patil', 'age': '12 months', 'next': 'MMR', 'status': 'overdue',  'mother': 'Priya Patil',  'phone': '9800002222'},
    {'name': 'Arjun Singh', 'age': '2 months',  'next': 'BCG', 'status': 'uptodate', 'mother': 'Meera Singh',  'phone': '9800003333'},
  ];
  final _sc = TextEditingController();
  String _q = '', _f = 'all';

  List<Map<String, String>> get _filtered => _list.where((c) {
        if (_f != 'all' && c['status'] != _f) return false;
        if (_q.isEmpty) return true;
        return c['name']!.toLowerCase().contains(_q.toLowerCase()) ||
            c['mother']!.toLowerCase().contains(_q.toLowerCase());
      }).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(children: [
      buildSearchBar(controller: _sc, hint: 'Search child, mother…', color: kTeal,
          onChanged: () => setState(() => _q = _sc.text.trim())),
      buildFilterChips(current: _f, color: kTeal, count: filtered.length,
          chips: [
            {'label': 'All', 'value': 'all'},
            {'label': 'Due', 'value': 'due'},
            {'label': 'Overdue', 'value': 'overdue'},
            {'label': 'Done', 'value': 'uptodate'},
          ],
          onTap: (v) => setState(() => _f = v)),
      Expanded(
        child: filtered.isEmpty
            ? emptyState(_q)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  final color = c['status'] == 'overdue' ? kRed : c['status'] == 'due' ? kOrange : kGreen;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                    child: Row(children: [
                      CircleAvatar(
                          backgroundColor: kTealLight,
                          child: const Icon(Icons.child_care_rounded, color: kTeal, size: 20)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        Text('${td('age')}: ${c['age']}',
                            style: const TextStyle(fontSize: 12, color: kMuted)),
                        const SizedBox(height: 4),
                        buildTag('${td('nextVaccine')}: ${c['next']}', kTeal),
                      ])),
                      buildTag(c['status']! == 'overdue' ? td('overdue') : c['status'] == 'due' ? td('nextVaccine') : td('upToDate'), color),
                    ]),
                  );
                }),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════
//  RECORDS TAB  — Medicine + Monthly Report
// ══════════════════════════════════════════════════════════
class _RecordsTab extends StatefulWidget {
  @override
  State<_RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<_RecordsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tc = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kOrange, kOrangeDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.folder_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(td('records'),
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white))),
            MiniLangBar(),
          ]),
          const SizedBox(height: 14),
          TabBar(
            controller: _tc,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            tabs: [
              Tab(icon: const Icon(Icons.medication_rounded, size: 15), text: td('medicine')),
              Tab(icon: const Icon(Icons.vaccines_rounded,   size: 15), text: td('vaccination')),
              Tab(icon: const Icon(Icons.bar_chart_rounded,  size: 15), text: td('reports')),
            ],
          ),
        ]),
      ),
      Expanded(
        child: TabBarView(
          controller: _tc,
          children: [
            MedicinePage(),
            const VaccinationPage(),
            EnhancedReportsPage(),
          ],
        ),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════
//  MORE TAB — grid of quick links
// ══════════════════════════════════════════════════════════
class _MoreTab extends StatelessWidget {
  final VoidCallback onDrawerOpen;
  const _MoreTab({required this.onDrawerOpen});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBlue, kBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(td('more'),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white))),
          MiniLangBar(),
        ]),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sectionLabel('Records', kOrange),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.medication_rounded,  td('medicine'),    kOrange,
                  () => _push(context, MedicinePage())),
              _MoreItem(Icons.vaccines_rounded,    td('vaccination'), kTeal,
                  () => _push(context, const VaccinationPage())),
              _MoreItem(Icons.bar_chart_rounded,   td('reports'),     const Color(0xFF5C6BC0),
                  () => _push(context, EnhancedReportsPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel('Supervisor & Govt', kBlue),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.supervisor_account_rounded, td('supervisor'), kOrange,
                  () => _push(context, SupervisorPage())),
              _MoreItem(Icons.policy_rounded, td('schemes'), kOrange,
                  () => _push(context, SchemesPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel(td('balHealth'), kChildBlue),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.child_friendly_rounded,    td('newbornReg'),   kChildBlue,   () => _push(context, const ChildHealthPage())),
              _MoreItem(Icons.article_outlined,          td('birthReg'),     kChildGreen,  () => _push(context, const ChildHealthPage())),
              _MoreItem(Icons.home_work_rounded,         td('hbnc'),         kChildTeal,   () => _push(context, const ChildHealthPage())),
              _MoreItem(Icons.people_alt_rounded,        td('childList'),    kChildIndigo, () => _push(context, const ChildHealthPage())),
              _MoreItem(Icons.monitor_weight_outlined,   td('malnutrition'), kChildOrange, () => _push(context, const ChildHealthPage())),
              _MoreItem(Icons.medical_services_outlined, td('illnessMgmt'),  kChildPurple, () => _push(context, const ChildHealthPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel('Records', kOrange),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.medication_rounded,  td('medicine'),    kOrange,
                  () => _push(context, MedicinePage())),
              _MoreItem(Icons.vaccines_rounded,    td('vaccination'), kTeal,
                  () => _push(context, const VaccinationPage())),
              _MoreItem(Icons.bar_chart_rounded,   td('reports'),     const Color(0xFF5C6BC0),
                  () => _push(context, EnhancedReportsPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel('Finance', kPurple),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.account_balance_wallet_rounded, td('earnings'), kPurple,
                  () => _push(context, EarningsPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel(td('familyPlan'), const Color(0xFFD946EF)),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.favorite_rounded,              td('familyPlan'),        const Color(0xFFD946EF),
                  () => _push(context, const FamilyPlanningPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel('Tools', kTeal),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.smart_toy_rounded, td('aiAssistant'), kTeal,
                  () => _push(context, AiAssistantPage())),
              _MoreItem(Icons.notifications_rounded, td('notifications'), kTeal,
                  () => _push(context, NotificationsPage())),
              _MoreItem(Icons.folder_open_rounded, td('documents'), kTeal,
                  () => _push(context, PhotoUploadPage())),
              _MoreItem(Icons.assignment_rounded, td('dailyReport'), const Color(0xFF37474F),
                  () => _push(context, DailyReportPage())),
            ]),
            const SizedBox(height: 16),
            sectionLabel('Account', kMuted),
            const SizedBox(height: 8),
            _MoreGrid(items: [
              _MoreItem(Icons.person_rounded, td('profile'), kMuted,
                  () => _push(context, ProfileSettingsPage())),
            ]),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    ]);
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _MoreGrid extends StatelessWidget {
  final List<_MoreItem> items;
  const _MoreGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.05,
      children: items,
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MoreItem(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  COMMON WIDGETS (used by all pages)
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
  final String? sub;
  final Color color;
  final IconData icon;
  const DStatCard({super.key, required this.label, required this.value,
      required this.color, required this.icon, this.sub});

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
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: kMuted)),
          if (sub != null) ...[
            const SizedBox(height: 3),
            Text(sub!, style: TextStyle(fontSize: 10, color: color.withOpacity(0.7), fontWeight: FontWeight.w600)),
          ],
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
        style: TextStyle(
            fontSize: 10.5, fontWeight: FontWeight.w600, color: color)));

Widget sectionLabel(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Row(children: [
      Container(
          width: 4, height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: color)),
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: color, width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
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
              child: Text(c['label']!,
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : kMuted)),
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
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      labelStyle: const TextStyle(fontSize: 12, color: kMuted),
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
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.red, width: 2)),
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
                  Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(icon, color: color, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color))),
                  GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                          width: 32, height: 32,
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
                      child: Text(td('cancel'),
                          style: const TextStyle(color: kMuted, fontWeight: FontWeight.w600)))),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          onSave();
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
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
      Text(
          query.isNotEmpty ? 'No results for "$query"' : 'No data found',
          style: const TextStyle(fontSize: 13, color: kMuted)),
    ]));

// ══════════════════════════════════════════════════════════
//  PROFESSIONAL DASHBOARD PAGE
// ══════════════════════════════════════════════════════════
class _DashboardPage extends StatefulWidget {
  final VoidCallback onMenuTap;
  const _DashboardPage({required this.onMenuTap});
  @override
  State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage> {
  // ── Real data — same lists jo pages mein use ho rahe hain ──
  final _visits = [
    {'name': 'Sunita Devi',  'village': 'Wardha',   'status': 'completed', 'reason': 'ANC Follow-up'},
    {'name': 'Meena Bai',    'village': 'Hingna',   'status': 'pending',   'reason': 'Child vaccination'},
    {'name': 'Radha Tai',    'village': 'Nagpur',   'status': 'completed', 'reason': 'General checkup'},
    {'name': 'Savita Bai',   'village': 'Amravati', 'status': 'pending',   'reason': 'Immunization'},
  ];

  final _pregnant = [
    {'name': 'Kavita Sharma', 'trimester': '3rd', 'risk': 'high',   'village': 'Wardha'},
    {'name': 'Priya Patil',   'trimester': '2nd', 'risk': 'normal', 'village': 'Nagpur'},
    {'name': 'Asha Devi',     'trimester': '1st', 'risk': 'normal', 'village': 'Hingna'},
  ];

  final _children = [
    {'name': 'Rahul Kumar', 'status': 'due'},
    {'name': 'Sneha Patil', 'status': 'overdue'},
    {'name': 'Arjun Singh', 'status': 'done'},
  ];

  final _stock = [
    {'name': 'ORS Packets',      'qty': 45, 'min': 20},
    {'name': 'Iron Tablets',     'qty': 8,  'min': 15},
    {'name': 'Paracetamol',      'qty': 0,  'min': 10},
    {'name': 'Vitamin A',        'qty': 30, 'min': 20},
    {'name': 'Chlorine Tablets', 'qty': 5,  'min': 10},
  ];

  // ── Computed counts ──
  int get totalVisits    => _visits.length;
  int get pendingVisits  => _visits.where((v) => v['status'] == 'pending').length;
  int get totalPregnant  => _pregnant.length;
  int get highRisk       => _pregnant.where((p) => p['risk'] == 'high').length;
  int get totalChildren  => _children.length;
  int get vaccDue        => _children.where((c) => c['status'] == 'due' || c['status'] == 'overdue').length;
  int get totalStock     => _stock.length;
  int get lowStock       => _stock.where((m) => (m['qty'] as int) < (m['min'] as int)).length;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildActivityBanner(),
              const SizedBox(height: 20),
              sectionLabel("Today's Overview", kGreen),
              const SizedBox(height: 10),
              _buildStatsGrid(),
              const SizedBox(height: 20),
              if (highRisk > 0) ...[
                _buildAlertBanner(),
                const SizedBox(height: 20),
              ],
              sectionLabel(td('quickActions'), kBlue),
              const SizedBox(height: 10),
              _buildQuickActions(context),
              const SizedBox(height: 24),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(
            onTap: widget.onMenuTap,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(td('welcome'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
              Text(td('ashaId'),
                  style: TextStyle(fontSize: 11.5, color: Colors.white.withOpacity(0.8))),
            ]),
          ),
          MiniLangBar(),
          const SizedBox(width: 10),
          // ── Notification button — ACTIVE ──
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => NotificationsPage())),
            child: Stack(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 20),
              ),
              if (highRisk > 0)
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                  ),
                ),
            ]),
          ),
          const SizedBox(width: 8),
          // ── Profile button — ACTIVE ──
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ProfileSettingsPage())),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25), shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.4))),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        // ── Summary pills — REAL DATA ──
        Row(children: [
          _WhitePill(value: '$totalVisits',   label: td('homeVisits'),    icon: Icons.home_work_rounded),
          const SizedBox(width: 8),
          _WhitePill(value: '$totalPregnant', label: td('pregnantWomen'), icon: Icons.pregnant_woman_rounded),
          const SizedBox(width: 8),
          _WhitePill(value: '$totalChildren', label: td('vaccination'),   icon: Icons.vaccines_rounded),
        ]),
      ]),
    );
  }

  Widget _buildActivityBanner() {
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${now.day} ${months[now.month-1]} ${now.year} • Wardha Block';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGreen.withOpacity(0.2)),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: kGreen.withOpacity(0.15), shape: BoxShape.circle),
          child: const Icon(Icons.today_rounded, color: kGreen, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Today is Active',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kGreen)),
          Text(dateStr, style: TextStyle(fontSize: 11, color: kGreen.withOpacity(0.8))),
        ])),
        buildTag('Online', kGreen),
      ]),
    );
  }

  Widget _buildStatsGrid() {
    return Column(children: [
      Row(children: [
        DStatCard(
          label: td('homeVisits'),
          value: '$totalVisits',
          sub: '$pendingVisits pending',
          color: kBlue, icon: Icons.home_work_rounded,
        ),
        const SizedBox(width: 10),
        DStatCard(
          label: td('pregnantWomen'),
          value: '$totalPregnant',
          sub: '$highRisk high risk',
          color: kPink, icon: Icons.pregnant_woman_rounded,
        ),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        DStatCard(
          label: td('vaccination'),
          value: '$totalChildren',
          sub: '$vaccDue due/overdue',
          color: kTeal, icon: Icons.vaccines_rounded,
        ),
        const SizedBox(width: 10),
        DStatCard(
          label: td('medicine'),
          value: '$totalStock',
          sub: '$lowStock low stock',
          color: kOrange, icon: Icons.medication_rounded,
        ),
      ]),
    ]);
  }

  Widget _buildAlertBanner() {
    final highRiskNames = _pregnant
        .where((p) => p['risk'] == 'high')
        .map((p) => '${p['name']} • ${p['trimester']} Trimester')
        .join(', ');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kRedLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kRed.withOpacity(0.25)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: kRed.withOpacity(0.12), shape: BoxShape.circle),
          child: const Icon(Icons.warning_rounded, color: kRed, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$highRisk High-Risk Case${highRisk > 1 ? 's' : ''} Need Attention',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: kRed)),
            Text(highRiskNames, style: const TextStyle(fontSize: 11, color: kMuted)),
          ]),
        ),
        const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: kRed),
      ]),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'title': td('homeVisits'),    'sub': '$pendingVisits pending visits',       'color': kBlue,   'bg': kBlueLight,   'icon': Icons.home_work_rounded},
      {'title': td('pregnantWomen'),'sub': '$highRisk high risk case${highRisk!=1?'s':''}', 'color': kPink,   'bg': kPinkLight,   'icon': Icons.pregnant_woman_rounded},
      {'title': td('vaccination'),   'sub': '$vaccDue due / overdue',              'color': kTeal,   'bg': kTealLight,   'icon': Icons.vaccines_rounded},
      {'title': td('medicine'),      'sub': '$lowStock low stock item${lowStock!=1?'s':''}','color': kOrange, 'bg': kOrangeLight, 'icon': Icons.medication_rounded},
      {'title': td('earnings'),      'sub': '₹2,400 this month',                  'color': kPurple, 'bg': kPurpleLight, 'icon': Icons.account_balance_wallet_rounded},
      {'title': td('dailyReport'),   'sub': 'Vivah • Janm • Mrityu',              'color': const Color(0xFF37474F), 'bg': const Color(0xFFECEFF1), 'icon': Icons.assignment_rounded},
    ];

    return Column(
      children: actions.map((a) {
        final color = a['color'] as Color;
        final bg    = a['bg']    as Color;
        final icon  = a['icon']  as IconData;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))]),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a['title'] as String,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
              const SizedBox(height: 1),
              Text(a['sub'] as String,
                  style: const TextStyle(fontSize: 11.5, color: kMuted)),
            ])),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color.withOpacity(0.5)),
          ]),
        );
      }).toList(),
    );
  }
}

// ── White Pill stat for header ──
class _WhitePill extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _WhitePill({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.25))),
          child: Column(children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            Text(label,
                style: TextStyle(fontSize: 8.5, color: Colors.white.withOpacity(0.8)),
                textAlign: TextAlign.center,
                maxLines: 2),
          ]),
        ),
      );
}