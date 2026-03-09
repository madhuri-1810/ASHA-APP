import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'asha_dashboard.dart';

// ══════════════════════════════════════════════════════════
//  5. MEDICINE PAGE
// ══════════════════════════════════════════════════════════
class MedicinePage extends StatefulWidget {
  const MedicinePage({super.key});
  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final List<Map<String, dynamic>> _stock = [
    {'name':'ORS Packets','qty':45,'min':20,'batch':'B2024-01','expiry':'Dec 2025','supplier':'PHC Store'},
    {'name':'Iron Tablets','qty':8,'min':15,'batch':'B2024-02','expiry':'Jun 2025','supplier':'CHC Store'},
    {'name':'Paracetamol','qty':0,'min':10,'batch':'B2024-03','expiry':'Mar 2025','supplier':'PHC Store'},
    {'name':'Vitamin A','qty':30,'min':20,'batch':'B2024-04','expiry':'Aug 2025','supplier':'District Store'},
    {'name':'Chlorine Tablets','qty':5,'min':10,'batch':'B2024-05','expiry':'Apr 2025','supplier':'PHC Store'},
  ];
  final _searchC = TextEditingController();
  String _query = '', _filter = 'all';

  List<Map<String, dynamic>> get _filtered => _stock.where((m) {
        final qty = m['qty'] as int;
        final min = m['min'] as int;
        final status = qty == 0 ? 'out' : qty < min ? 'low' : 'ok';
        if (_filter != 'all' && status != _filter) return false;
        if (_query.isEmpty) return true;
        final q = _query.toLowerCase();
        return m['name'].toString().toLowerCase().contains(q) ||
            m['supplier'].toString().toLowerCase().contains(q);
      }).toList();

  void _addStock() {
    final fk = GlobalKey<FormState>();
    final nameC = TextEditingController(), qtyC = TextEditingController(),
        batchC = TextEditingController(), expiryC = TextEditingController(),
        supplierC = TextEditingController();
    showValidatedDialog(
      context: context, title: td('addMedicine'), color: kOrange,
      icon: Icons.medication_rounded, formKey: fk,
      onSave: () => setState(() => _stock.insert(0, {
            'name': nameC.text.trim(),
            'qty': int.tryParse(qtyC.text.trim()) ?? 0,
            'min': 10,
            'batch': batchC.text.trim(),
            'expiry': expiryC.text.trim(),
            'supplier': supplierC.text.trim(),
          })),
      fields: [
        sectionLabel('Medicine Details', kOrange),
        vField(controller: nameC, label: 'Medicine Name', icon: Icons.medication_rounded, color: kOrange,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Name required'; return null; }),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: vField(controller: qtyC, label: td('quantity'), icon: Icons.numbers_rounded, color: kOrange,
              keyboard: TextInputType.number, maxLen: 5,
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) { if (v == null || v.trim().isEmpty) return 'Quantity required'; return null; })),
          const SizedBox(width: 10),
          Expanded(child: vField(controller: batchC, label: td('batchNo'), icon: Icons.tag_rounded, color: kOrange,
              validator: (v) { if (v == null || v.trim().isEmpty) return 'Batch required'; return null; })),
        ]),
        const SizedBox(height: 10),
        vField(controller: expiryC, label: td('expiryDate'), icon: Icons.calendar_today_outlined, color: kOrange,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Expiry required'; return null; }),
        const SizedBox(height: 10),
        vField(controller: supplierC, label: td('supplier'), icon: Icons.store_outlined, color: kOrange,
            validator: (v) { if (v == null || v.trim().isEmpty) return 'Supplier required'; return null; }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Material(color: kBg, child: Column(children: [
        PageHeader(title: td('medicine'), color: kOrange, icon: Icons.medication_rounded,
            action: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _addStock)),
        buildSearchBar(controller: _searchC, hint: 'Search by medicine name, supplier…', color: kOrange,
            onChanged: () => setState(() => _query = _searchC.text.trim())),
        buildFilterChips(current: _filter, color: kOrange, count: filtered.length,
            chips: [{'label': 'All', 'value': 'all'}, {'label': 'In Stock', 'value': 'ok'}, {'label': 'Low', 'value': 'low'}, {'label': 'Out', 'value': 'out'}],
            onTap: (v) => setState(() => _filter = v)),
        Expanded(
          child: filtered.isEmpty
              ? emptyState(_query)
              : ListView.separated(
                  padding: const EdgeInsets.all(16), itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final m = filtered[i];
                    final qty = m['qty'] as int;
                    final min = m['min'] as int;
                    final Color color = qty == 0 ? kRed : qty < min ? kOrange : kGreen;
                    final String status = qty == 0 ? td('outOfStock') : qty < min ? td('lowStock') : td('inStock');
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                      child: Row(children: [
                        Container(width: 44, height: 44,
                            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.medication_rounded, color: color, size: 22)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(m['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, decoration: TextDecoration.none)),
                          const SizedBox(height: 4),
                          ClipRRect(borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                  value: qty == 0 ? 0 : (qty / (min * 2)).clamp(0.0, 1.0),
                                  backgroundColor: kBorder, color: color, minHeight: 5)),
                          const SizedBox(height: 4),
                          Text('${td('quantity')}: $qty', style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                        ])),
                        const SizedBox(width: 10),
                        buildTag(status, color),
                      ]),
                    );
                  },
                ),
        ),
      ])),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  9. EARNINGS PAGE
// ══════════════════════════════════════════════════════════
class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final incentives = [
      {'task': 'Institutional Delivery (JSY)', 'amount': '₹600', 'status': 'paid',    'date': '20 Feb'},
      {'task': 'ANC Registration',             'amount': '₹200', 'status': 'paid',    'date': '18 Feb'},
      {'task': 'Child Immunization',           'amount': '₹150', 'status': 'pending', 'date': '25 Feb'},
      {'task': 'Home Visit (5)',               'amount': '₹250', 'status': 'paid',    'date': '15 Feb'},
      {'task': 'VHND Meeting',                 'amount': '₹100', 'status': 'pending', 'date': '28 Feb'},
      {'task': 'Family Planning',              'amount': '₹500', 'status': 'paid',    'date': '10 Feb'},
    ];

    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, __, ___) => Material(color: kBg, child: Column(children: [
        PageHeader(title: td('earnings'), color: kPurple, icon: Icons.account_balance_wallet_rounded),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Summary Stats
            Row(children: [
              DStatCard(label: td('totalEarned'), value: '₹4,800', color: kGreen, icon: Icons.check_circle_rounded),
              const SizedBox(width: 10),
              DStatCard(label: td('pending2'), value: '₹250', color: kOrange, icon: Icons.pending_rounded),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              DStatCard(label: td('thisMonthEarn'), value: '₹1,650', color: kPurple, icon: Icons.calendar_today_rounded),
              const SizedBox(width: 10),
              DStatCard(label: 'Tasks Done', value: '6', color: kBlue, icon: Icons.task_alt_rounded),
            ]),
            const SizedBox(height: 20),

            // Incentive List
            ...incentives.map((inc) {
              final paid = inc['status'] == 'paid';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                child: Row(children: [
                  Container(width: 40, height: 40,
                      decoration: BoxDecoration(
                          color: paid ? kGreenLight : kOrangeLight,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(paid ? Icons.check_rounded : Icons.hourglass_empty_rounded,
                          color: paid ? kGreen : kOrange, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(inc['task']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, decoration: TextDecoration.none)),
                    Text(inc['date']!, style: const TextStyle(fontSize: 11, color: kMuted, decoration: TextDecoration.none)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(inc['amount']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: paid ? kGreen : kOrange, decoration: TextDecoration.none)),
                    buildTag(paid ? 'Paid' : td('pending2'), paid ? kGreen : kOrange),
                  ]),
                ]),
              );
            }),
          ]),
        )),
      ])),
    );
  }
}