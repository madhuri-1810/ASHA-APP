// dashboard_page.dart — Drop-in replacement for DashboardPage
// Place this file as-is. DashboardPage reads navCallback from
// the nearest _AshaHomePageState through a simple InheritedWidget.

import 'package:flutter/material.dart';
import 'main.dart';
import 'pages_dashboard.dart'; // for td(), MiniLangBar(), DStatCard, sectionLabel, kPurple etc.

// ══════════════════════════════════════════════════════════
//  NAV CALLBACK INHERITED WIDGET
//  — Allows DashboardPage to push tabs without knowing parent
// ══════════════════════════════════════════════════════════
class NavController extends InheritedWidget {
  final ValueChanged<int> goto;
  const NavController({super.key, required this.goto, required super.child});
  static NavController? of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<NavController>();
  @override
  bool updateShouldNotify(NavController old) => goto != old.goto;
}

// ══════════════════════════════════════════════════════════
//  DASHBOARD PAGE  (public — replaces _DashboardPage)
// ══════════════════════════════════════════════════════════
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = NavController.of(context);
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _HeroHeader(nav: nav),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Stats Row 1 ──
              Row(children: [
                _ClickStat(label: td('homeVisits'),    value: '8',  color: kBlue,   icon: Icons.home_work_rounded,        tabIndex: 1, nav: nav),
                const SizedBox(width: 10),
                _ClickStat(label: td('pregnantWomen'), value: '12', color: kPink,   icon: Icons.pregnant_woman_rounded,   tabIndex: 2, nav: nav),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _ClickStat(label: td('vaccination'),   value: '24', color: kTeal,   icon: Icons.vaccines_rounded,         tabIndex: 3, nav: nav),
                const SizedBox(width: 10),
                _ClickStat(label: td('medicine'),      value: '18', color: kOrange, icon: Icons.medication_rounded,       tabIndex: 4, nav: nav),
              ]),
              const SizedBox(height: 22),

              // ── Alerts Banner ──
              _AlertBanner(nav: nav),
              const SizedBox(height: 22),

              // ── Quick Actions ──
              Row(children: [
                const Text('Quick Actions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kText)),
                const Spacer(),
                GestureDetector(
                  onTap: () => nav?.goto(0),
                  child: const Text('See all',
                      style: TextStyle(fontSize: 12, color: kGreen, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 12),

              // 2-column quick action grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.55,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ActionCard(icon: Icons.home_work_rounded,              title: td('homeVisits'),    subtitle: '8 today',           color: kBlue,                    tabIndex: 1, nav: nav),
                  _ActionCard(icon: Icons.pregnant_woman_rounded,         title: td('pregnantWomen'), subtitle: '2 high risk',        color: kPink,                    tabIndex: 2, nav: nav),
                  _ActionCard(icon: Icons.vaccines_rounded,               title: td('vaccination'),   subtitle: '3 due this week',   color: kTeal,                    tabIndex: 3, nav: nav),
                  _ActionCard(icon: Icons.medication_rounded,             title: td('medicine'),      subtitle: '2 low stock',       color: kOrange,                  tabIndex: 4, nav: nav),
                  _ActionCard(icon: Icons.bar_chart_rounded,              title: 'Reports',           subtitle: 'Monthly summary',   color: const Color(0xFF5C6BC0),  tabIndex: 5, nav: nav),
                  _ActionCard(icon: Icons.account_balance_wallet_rounded, title: 'Earnings',          subtitle: '₹2,400 this month', color: kPurple,                  tabIndex: 8, nav: nav),
                ],
              ),
              const SizedBox(height: 22),

              // ── Today's Activity Timeline ──
              const Text('Today\'s Activity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kText)),
              const SizedBox(height: 12),
              _Timeline(),
              const SizedBox(height: 28),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  HERO HEADER
// ══════════════════════════════════════════════════════════
class _HeroHeader extends StatelessWidget {
  final NavController? nav;
  const _HeroHeader({this.nav});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreen, kGreenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          // Profile tap → profile settings
          GestureDetector(
            onTap: () => nav?.goto(12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(td('welcome'),
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
              Text(td('ashaId'),
                  style: TextStyle(
                      fontSize: 11.5, color: Colors.white.withOpacity(0.8))),
            ]),
          ),
          MiniLangBar(),
          const SizedBox(width: 6),
          // Notification bell
          GestureDetector(
            onTap: () => nav?.goto(10),
            child: Stack(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 20),
        Text(td('todaySummary'),
            style: TextStyle(
                fontSize: 11.5,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(children: [
          _HeroStat('8',  td('homeVisits'),    tabIndex: 1, nav: nav),
          const SizedBox(width: 10),
          _HeroStat('3',  td('pregnantWomen'), tabIndex: 2, nav: nav),
          const SizedBox(width: 10),
          _HeroStat('5',  td('vaccination'),   tabIndex: 3, nav: nav),
        ]),
      ]),
    );
  }
}

// ── Tappable Hero stat ──
class _HeroStat extends StatelessWidget {
  final String value, label;
  final int tabIndex;
  final NavController? nav;
  const _HeroStat(this.value, this.label, {required this.tabIndex, this.nav});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: () => nav?.goto(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Column(children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.85)),
              textAlign: TextAlign.center,
              maxLines: 2),
        ]),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  CLICKABLE STAT CARD
// ══════════════════════════════════════════════════════════
class _ClickStat extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  final int tabIndex;
  final NavController? nav;
  const _ClickStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.tabIndex,
    this.nav,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: () => nav?.goto(tabIndex),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.14),
                blurRadius: 14,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 11, color: color.withOpacity(0.5)),
          ]),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: kMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  ALERT BANNER
// ══════════════════════════════════════════════════════════
class _AlertBanner extends StatelessWidget {
  final NavController? nav;
  const _AlertBanner({this.nav});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => nav?.goto(6),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFF8E1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFFFB74D).withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8F00).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.campaign_rounded,
              color: Color(0xFFFF8F00), size: 22),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Monthly Report Due',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE65100))),
            SizedBox(height: 2),
            Text('Submit June report by 30th — Tap to alert supervisor',
                style: TextStyle(fontSize: 11, color: Color(0xFFBF360C)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
        ),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 13, color: Color(0xFFFF8F00)),
      ]),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  ACTION CARD (grid item)
// ══════════════════════════════════════════════════════════
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final int tabIndex;
  final NavController? nav;
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.tabIndex,
    this.nav,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => nav?.goto(tabIndex),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const Spacer(),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_forward_rounded, color: color, size: 12),
          ),
        ]),
        const Spacer(),
        Text(title,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(subtitle,
            style: const TextStyle(fontSize: 10.5, color: kMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ]),
    ),
  );
}

// ══════════════════════════════════════════════════════════
//  TODAY'S ACTIVITY TIMELINE
// ══════════════════════════════════════════════════════════
class _Timeline extends StatelessWidget {
  const _Timeline();
  static const _events = [
    _Ev('9:00 AM', 'Home visit — Sunita Devi',       'Wardha',   kBlue,   Icons.home_work_rounded,         true),
    _Ev('10:30 AM','ANC checkup — Kavita Sharma',    'Nagpur',   kPink,   Icons.pregnant_woman_rounded,    true),
    _Ev('12:00 PM','Child vaccination — Rahul Kumar','Hingna',   kTeal,   Icons.vaccines_rounded,          true),
    _Ev('3:00 PM', 'Medicine stock update',           'PHC',     kOrange, Icons.medication_rounded,        false),
    _Ev('5:00 PM', 'Daily report submission',         'Pending', kGreen,  Icons.assignment_rounded,        false),
  ];
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(_events.length, (i) {
      final e = _events[i];
      final last = i == _events.length - 1;
      return IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: e.done ? e.color : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: e.color, width: 2),
                ),
                child: e.done
                    ? Icon(Icons.check_rounded, color: Colors.white, size: 7)
                    : null,
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 4),
                    color: kBorder,
                  ),
                ),
            ]),
          ),
          const SizedBox(width: 8),
          // Event card
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: last ? 0 : 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: e.done ? e.color.withOpacity(0.2) : kBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Row(children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: e.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(e.icon, color: e.color, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e.title,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: e.done ? kText : kMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text('${e.time} · ${e.place}',
                        style: const TextStyle(fontSize: 10.5, color: kMuted)),
                  ]),
                ),
                buildTag(e.done ? 'Done' : 'Pending', e.done ? kGreen : kOrange),
              ]),
            ),
          ),
        ]),
      );
    }),
  );
}

class _Ev {
  final String time, title, place;
  final Color color;
  final IconData icon;
  final bool done;
  const _Ev(this.time, this.title, this.place, this.color, this.icon, this.done);
}
