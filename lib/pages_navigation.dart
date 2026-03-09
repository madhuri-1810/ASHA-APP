import 'package:flutter/material.dart';
import 'main.dart';
import 'pages_dashboard.dart';
import 'pages_health.dart' hide VaccinationPage;
import 'pages_stock.dart';
import 'pages_info.dart';
import 'page_pregnant.dart';
import 'page_vaccination.dart';
import 'page_family_planning.dart';   // ← NEW
import 'daily_report_page.dart';
import 'asha_new_features.dart'
    hide
        kGreen, kGreenLight,
        kBlue, kBlueLight,
        kRed, kRedLight,
        kOrange, kOrangeLight,
        kPurple, kPurpleLight,
        kTeal, kTealLight,
        kPink, kPinkLight,
        kText, kMuted, kBorder, kBg,
        offlineNotifier, pendingSyncCount;

// ══════════════════════════════════════════════════════════
//  ASHA HOME PAGE  (entry point shell)
// ══════════════════════════════════════════════════════════
class AshaHomePage extends StatefulWidget {
  const AshaHomePage({super.key});
  @override
  State<AshaHomePage> createState() => _AshaHomePageState();
}

class _AshaHomePageState extends State<AshaHomePage> {
  int _tab = 0;
  Widget? _drawerPage; // drawer se aaya hua page

  late final List<Widget> _pages = [
    DashboardPage(),                    // 0  Home
    HomeVisitsPage(),                   // 1  Visits
    PregnantPage(),                     // 2  Mahila
    const VaccinationPage(),            // 3  Vaccine
    const FamilyPlanningPage(),         // 4  Family  ← NEW
    MedicinePage(),                     // 5  Dawai
    EnhancedReportsPage(),              // 6  Report
    SupervisorPage(),                   // 7  Alert
    SchemesPage(),                      // 8  Yojana
    EarningsPage(),                     // 9  Earn
    AiAssistantPage(),                  // 10 AI Help
    NotificationsPage(),                // 11 Alerts
    PhotoUploadPage(),                  // 12 Docs
    ProfileSettingsPage(),              // 13 Profile
    DailyReportPage(),                  // 14 Daily
  ];

  void _onDrawerNavigate(Widget page) {
    Navigator.pop(context); // drawer band karo
    setState(() { _drawerPage = page; });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: kBg,
        drawer: _AppDrawer(onNavigate: _onDrawerNavigate),
        body: OfflineBanner(
          child: _drawerPage != null
              ? Column(children: [
                  // Back bar jab drawer se aao
                  Container(
                    color: kGreen,
                    padding: EdgeInsets.fromLTRB(
                        8, MediaQuery.of(context).padding.top + 4, 8, 4),
                    child: Row(children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => setState(() => _drawerPage = null),
                      ),
                    ]),
                  ),
                  Expanded(child: _drawerPage!),
                ])
              : _pages[_tab],
        ),
        bottomNavigationBar: _drawerPage != null
            ? null
            : _BottomNav(selected: _tab, onTap: (i) => setState(() => _tab = i)),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BOTTOM NAVIGATION BAR
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
      {'icon': Icons.favorite_rounded,               'label': 'Family'},   // ← NEW
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
//  DRAWER
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
                  _DrawerItem(Icons.bar_chart_rounded,   td('reports'),     kBlue,   EnhancedReportsPage(),          onNavigate),
                  _DrawerItem(Icons.assignment_rounded,  td('dailyReport'), kBlue,   DailyReportPage(),              onNavigate),
                ]),
                _drawerSection('Vaccination', [
                  _DrawerItem(Icons.vaccines_rounded,    td('vaccination'), kTeal,   const VaccinationPage(),        onNavigate),
                ]),
                // ── Family Planning section ── NEW
                _drawerSection('Family Planning', [
                  _DrawerItem(Icons.favorite_rounded,             'कुटुंब नियोजन',      const Color(0xFFD946EF), const FamilyPlanningPage(),     onNavigate),
                ]),
                _drawerSection('Supervisor & Govt', [
                  _DrawerItem(Icons.supervisor_account_rounded, td('supervisor'), kOrange, SupervisorPage(), onNavigate),
                  _DrawerItem(Icons.policy_rounded,              td('schemes'),    kOrange, SchemesPage(),    onNavigate),
                ]),
                _drawerSection('Finance', [
                  _DrawerItem(Icons.account_balance_wallet_rounded, td('earnings'), kPurple, EarningsPage(), onNavigate),
                ]),
                _drawerSection('Tools & Settings', [
                  _DrawerItem(Icons.smart_toy_rounded,     td('aiAssistant'),   kTeal,  AiAssistantPage(),     onNavigate),
                  _DrawerItem(Icons.notifications_rounded, td('notifications'), kTeal,  NotificationsPage(),   onNavigate),
                  _DrawerItem(Icons.folder_open_rounded,   td('documents'),     kTeal,  PhotoUploadPage(),     onNavigate),
                  _DrawerItem(Icons.person_rounded,        td('profile'),       kMuted, ProfileSettingsPage(), onNavigate),
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
              const MiniLangBar(),
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
                fontSize: 9.5, fontWeight: FontWeight.w800,
                color: kMuted, letterSpacing: 1.2)),
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