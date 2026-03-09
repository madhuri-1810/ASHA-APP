import 'package:flutter/material.dart';
import 'main.dart';
import 'pages_dashboard.dart';
import 'scheme_detail_page.dart';

// ══════════════════════════════════════════════════════════
//  SUPERVISOR ALERT PAGE  (Tab index: 6)
// ══════════════════════════════════════════════════════════
class SupervisorPage extends StatefulWidget {
  const SupervisorPage({super.key});
  @override
  State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {
  final _msgCtrl = TextEditingController();
  bool _sent = false;
  final List<Map<String, String>> _alerts = [
    {'title': 'Monthly Report Due',       'desc': 'Please submit your June report by 30th.',   'date': 'Jun 20'},
    {'title': 'Training on June 25',      'desc': 'Attend NHM training at PHC Wada, 10 AM.',   'date': 'Jun 18'},
    {'title': 'Medicine Replenishment',   'desc': 'Collect IFA and ORS from PHC by Friday.',   'date': 'Jun 17'},
  ];

  void _sendMsg() {
    if (_msgCtrl.text.trim().isEmpty) return;
    setState(() { _sent = true; _msgCtrl.clear(); });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _sent = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Scaffold(
        backgroundColor: kBg,
        body: Column(children: [
          PageHeader(title: td('supervisor'), color: kBlue, icon: Icons.supervisor_account_rounded),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Alerts from supervisor
                sectionLabel('Supervisor Alerts', kBlue),
                ..._alerts.map((a) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: kBlue.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))]),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: kBlueLight, shape: BoxShape.circle),
                      child: const Icon(Icons.notifications_rounded, color: kBlue, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kText)),
                      const SizedBox(height: 2),
                      Text(a['desc']!, style: const TextStyle(fontSize: 12, color: kMuted)),
                    ])),
                    Text(a['date']!, style: const TextStyle(fontSize: 10.5, color: kMuted)),
                  ]),
                )),
                const SizedBox(height: 16),
                // Send message to supervisor
                sectionLabel(td('sendMsg'), kGreen),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: kGreen.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 3))]),
                  child: Column(children: [
                    TextField(
                      controller: _msgCtrl,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 13, color: kText),
                      decoration: InputDecoration(
                        hintText: 'Type your message to supervisor…',
                        hintStyle: const TextStyle(fontSize: 12.5, color: kMuted),
                        filled: true, fillColor: kBg,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kGreen, width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_sent)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(12)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.check_circle_rounded, color: kGreen, size: 18),
                          const SizedBox(width: 8),
                          Text(td('msgSent'), style: const TextStyle(color: kGreen, fontWeight: FontWeight.w700)),
                        ]),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _sendMsg,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(td('sendMsg')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen, foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                  ]),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  GOVERNMENT SCHEMES PAGE  (Tab index: 7)
// ══════════════════════════════════════════════════════════
class SchemesPage extends StatefulWidget {
  const SchemesPage({super.key});
  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  List<SchemeDetail> get _filtered {
    if (_query.isEmpty) return allSchemes;
    final q = _query.toLowerCase();
    return allSchemes.where((s) =>
        s.name.toLowerCase().contains(q) ||
        s.shortDesc.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Scaffold(
        backgroundColor: kBg,
        body: Column(children: [
          PageHeader(title: td('schemes'), color: kPurple, icon: Icons.policy_rounded),
          buildSearchBar(
              controller: _searchCtrl,
              hint: 'Search schemes…',
              color: kPurple,
              onChanged: () => setState(() => _query = _searchCtrl.text.trim())),
          Expanded(
            child: list.isEmpty
                ? emptyState(_searchCtrl.text)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final s = list[i];
                      final c = s.color;
                      return GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SchemeDetailPage(scheme: s))),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(
                                  color: c.withOpacity(0.10),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3))]),
                          child: Row(children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                  color: c.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Icon(s.icon, color: c, size: 24)),
                            const SizedBox(width: 14),
                            Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(s.name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: c)),
                              const SizedBox(height: 2),
                              Text(s.shortDesc,
                                  style: const TextStyle(fontSize: 11.5, color: kMuted),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Row(children: [
                                buildTag(s.amount, c),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: kGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    const Icon(Icons.how_to_reg_rounded, size: 11, color: kGreen),
                                    const SizedBox(width: 3),
                                    const Text('Register', style: TextStyle(fontSize: 10, color: kGreen, fontWeight: FontWeight.w600)),
                                  ]),
                                ),
                              ]),
                            ])),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: kMuted),
                          ]),
                        ),
                      );
                    }),
          ),
        ]),
      ),
    );
  }
}