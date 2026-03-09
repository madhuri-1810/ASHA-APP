// whatsapp_reminders_feature.dart
//
// DO NAYE FEATURES:
// 1. WhatsApp Integration — Patient ko seedha message bhejo
// 2. Smart Reminders — ANC/Vaccine dates auto-set aur track karo
//
// pubspec.yaml mein add karo:
//   url_launcher: ^6.2.5
//
// AndroidManifest.xml mein add karo (android/app/src/main/AndroidManifest.xml):
//   <queries>
//     <intent>
//       <action android:name="android.intent.action.VIEW" />
//       <data android:scheme="https" />
//     </intent>
//   </queries>
//
// asha_dashboard.dart mein import karo aur _pages list mein add karo:
//   WhatsAppPage()     // index 13
//   SmartRemindersPage() // index 14
// Bottom nav mein bhi 2 items add karo:
//   {'icon': Icons.chat_rounded,  'label': 'WhatsApp'}
//   {'icon': Icons.alarm_rounded, 'label': 'Reminders'}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

// ═══════════════════════════════════════════════════════════
//  COLOR CONSTANTS
// ═══════════════════════════════════════════════════════════
const _kPink        = Color(0xFFD81B60);
const _kPinkLight   = Color(0xFFFCE4EC);
const _kTeal        = Color(0xFF00897B);
const _kTealLight   = Color(0xFFE0F2F1);
const _kRed         = Color(0xFFE53935);
const _kRedLight    = Color(0xFFFFEBEE);
const _kOrangeLight = Color(0xFFFFF0EA);
const _kPurple      = Color(0xFF7B2FBE);
const _kWA          = Color(0xFF25D366); // WhatsApp green
const _kWADark      = Color(0xFF128C7E);

// ═══════════════════════════════════════════════════════════
//  WHATSAPP SERVICE
//  url_launcher use karta hai — real app mein uncomment karo
// ═══════════════════════════════════════════════════════════
class WAService {
  /// WhatsApp pe seedha message bhejo
  static Future<void> sendMessage({
    required BuildContext context,
    required String phone,
    required String message,
  }) async {
    // PRODUCTION: url_launcher ke saath:
    // import 'package:url_launcher/url_launcher.dart';
    // final encoded = Uri.encodeComponent(message);
    // final url = 'https://wa.me/91$phone?text=$encoded';
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // }

    // DEMO: clipboard copy + snackbar
    await Clipboard.setData(ClipboardData(text: message));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Message copied! WhatsApp pe $phone ko bhejein',
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          ]),
          backgroundColor: _kWA,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════
//  MESSAGE TEMPLATES
// ═══════════════════════════════════════════════════════════
class WATemplates {
  static String ancReminder({
    required String name,
    required String date,
    required String trimester,
    required String ashaName,
  }) =>
      'Namaste *$name* ji!\n\n'
      'Aapka $trimester trimester ka ANC checkup *$date* ko hai.\n\n'
      'Kripya samay par PHC aayen.\n\n'
      '✅ BP check\n'
      '✅ Weight monitoring\n'
      '✅ HB test\n'
      '✅ IFA tablets lena na bhulen\n\n'
      'Koi bhi takleef ho toh turant contact karein.\n\n'
      '_Aapki ASHA Didi: $ashaName_\n'
      '_NHM Health Mission_';

  static String vaccineReminder({
    required String childName,
    required String motherName,
    required String vaccine,
    required String date,
    required String time,
    required String location,
    required String ashaName,
  }) =>
      'Namaste *$motherName* ji!\n\n'
      'Aapke bachche *$childName* ka *$vaccine* ka samay aa gaya hai.\n\n'
      'Date: *$date*\n'
      'Time: *$time*\n'
      'Sthan: *$location PHC*\n\n'
      'Tikakaran miss na karein — yeh bachche ki suraksha ke liye zaroori hai.\n\n'
      '_ASHA Didi: $ashaName_';

  static String jsyInfo({
    required String name,
    required String ashaName,
  }) =>
      'Namaste *$name* ji!\n\n'
      'Janani Suraksha Yojana ke tahat Sarkar se *Rs.1,400* milenge agar aap '
      'government hospital mein delivery karayen.\n\n'
      'Zaruri documents tayar rakhein:\n'
      '✅ Aadhar Card\n'
      '✅ BPL/Ration Card\n'
      '✅ Bank Passbook\n'
      '✅ MCP Card (ANC card)\n\n'
      'Main aapki help karungi registration mein.\n\n'
      '_Aapki ASHA Didi: $ashaName_';

  static String highRiskAlert({
    required String name,
    required String reason,
    required String ashaName,
  }) =>
      'Namaste *$name* ji!\n\n'
      'Aapki recent jaanch mein kuch concern mila: *$reason*\n\n'
      'Kripya *AAJ* PHC mein doctor se milein. Deri mat karein.\n\n'
      'Main aapko saath le ja sakti hoon.\n\n'
      '_ASHA Didi: $ashaName_\n'
      '_Helpline: 104_';

  static String generalFollowup({
    required String name,
    required String message,
    required String ashaName,
  }) =>
      'Namaste *$name* ji!\n\n'
      '$message\n\n'
      'Koi bhi sawaal ho toh mujhse directly baat karein.\n\n'
      '_Aapki ASHA Didi: $ashaName_\n'
      '_NHM Health Mission_';
}

// ═══════════════════════════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════════════════════════
class _Patient {
  final String name, phone, type, detail, village;
  const _Patient({
    required this.name,
    required this.phone,
    required this.type,
    required this.detail,
    required this.village,
  });
}

class _SentMsg {
  final String patientName, phone, template, time;
  const _SentMsg({
    required this.patientName,
    required this.phone,
    required this.template,
    required this.time,
  });
}

class _SmartReminder {
  final String id, title, subtitle, phone, type, priority, waTemplate;
  final DateTime dueDate;
  bool isActive;
  final bool isAutoGenerated;

  _SmartReminder({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.dueDate,
    required this.type,
    required this.priority,
    required this.isActive,
    required this.waTemplate,
    required this.isAutoGenerated,
  });
}

// ═══════════════════════════════════════════════════════════
//  WHATSAPP PAGE
// ═══════════════════════════════════════════════════════════
class WhatsAppPage extends StatefulWidget {
  const WhatsAppPage({super.key});
  @override
  State<WhatsAppPage> createState() => _WhatsAppPageState();
}

class _WhatsAppPageState extends State<WhatsAppPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final List<_Patient> _patients = [
    const _Patient(
        name: 'Kavita Sharma',
        phone: '9876500001',
        type: 'anc',
        detail: '3rd Trimester • High Risk',
        village: 'Wardha'),
    const _Patient(
        name: 'Priya Patil',
        phone: '9876500002',
        type: 'anc',
        detail: '2nd Trimester • Normal',
        village: 'Nagpur'),
    const _Patient(
        name: 'Sunita Kumar',
        phone: '9800001111',
        type: 'vaccine',
        detail: 'Rahul — OPV Due',
        village: 'Wardha'),
    const _Patient(
        name: 'Meera Singh',
        phone: '9800003333',
        type: 'vaccine',
        detail: 'Arjun — BCG Due',
        village: 'Hingna'),
    const _Patient(
        name: 'Radha Devi',
        phone: '9123456780',
        type: 'jsy',
        detail: 'JSY Registration Pending',
        village: 'Amravati'),
  ];

  final List<_SentMsg> _sentLog = [];
  final _customMsgC = TextEditingController();
  final _customPhoneC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    _customMsgC.dispose();
    _customPhoneC.dispose();
    super.dispose();
  }

  String _timeNow() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

  String _buildMessage(_Patient p, String tmpl) {
    switch (tmpl) {
      case 'anc':
        return WATemplates.ancReminder(
          name: p.name,
          date: '5 March 2026',
          trimester: p.detail.split('•')[0].trim(),
          ashaName: 'Sunita Didi',
        );
      case 'vaccine':
        final parts = p.detail.split('—');
        return WATemplates.vaccineReminder(
          childName: parts.isNotEmpty ? parts[0].trim() : p.name,
          motherName: p.name,
          vaccine: parts.length > 1 ? parts[1].trim() : 'vaccine',
          date: '7 March 2026',
          time: '9:00 AM - 12:00 PM',
          location: p.village,
          ashaName: 'Sunita Didi',
        );
      case 'jsy':
        return WATemplates.jsyInfo(name: p.name, ashaName: 'Sunita Didi');
      default:
        return WATemplates.generalFollowup(
          name: p.name,
          message: 'Aapka health follow-up reminder',
          ashaName: 'Sunita Didi',
        );
    }
  }

  Future<void> _sendToPatient(_Patient p, String tmpl) async {
    final msg = _buildMessage(p, tmpl);
    await WAService.sendMessage(context: context, phone: p.phone, message: msg);
    setState(() => _sentLog.insert(
        0,
        _SentMsg(
            patientName: p.name,
            phone: p.phone,
            template: tmpl,
            time: _timeNow())));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Header ──────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_kWADark, _kWA],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.chat_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WhatsApp Messaging',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    Text('Patient ko seedha message bhejo',
                        style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ]),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('${_sentLog.length} sent',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 12),
          TabBar(
            controller: _tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Patients'),
              Tab(text: 'Custom'),
              Tab(text: 'Sent Log'),
            ],
          ),
        ]),
      ),

      Expanded(
        child: TabBarView(controller: _tab, children: [
          // ── TAB 1: Patients ───────────────────────────
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _patients.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final p = _patients[i];
              final tc = p.type == 'anc'
                  ? _kPink
                  : p.type == 'vaccine'
                      ? _kTeal
                      : kGreen;
              final ic = p.type == 'anc'
                  ? Icons.pregnant_woman_rounded
                  : p.type == 'vaccine'
                      ? Icons.vaccines_rounded
                      : Icons.account_balance_wallet_rounded;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 8)
                  ],
                ),
                child: Column(children: [
                  Row(children: [
                    CircleAvatar(
                      backgroundColor: tc.withOpacity(0.12),
                      child: Icon(ic, color: tc, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13.5)),
                          Text('${p.village} • ${p.phone}',
                              style: const TextStyle(
                                  fontSize: 11, color: kMuted)),
                          const SizedBox(height: 4),
                          _WaTag(p.detail, tc),
                        ])),
                  ]),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: kBorder),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: _MsgBtn(
                        label: p.type == 'anc'
                            ? 'ANC Reminder'
                            : p.type == 'vaccine'
                                ? 'Vaccine Alert'
                                : 'JSY Info',
                        icon: Icons.send_rounded,
                        color: _kWA,
                        onTap: () => _sendToPatient(p, p.type),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MsgBtn(
                        label: 'High Risk Alert',
                        icon: Icons.warning_amber_rounded,
                        color: kOrange,
                        onTap: () async {
                          final msg = WATemplates.highRiskAlert(
                            name: p.name,
                            reason: 'BP reading is elevated',
                            ashaName: 'Sunita Didi',
                          );
                          await WAService.sendMessage(
                              context: context, phone: p.phone, message: msg);
                          setState(() => _sentLog.insert(
                              0,
                              _SentMsg(
                                  patientName: p.name,
                                  phone: p.phone,
                                  template: 'alert',
                                  time: _timeNow())));
                        },
                      ),
                    ),
                  ]),
                ]),
              );
            },
          ),

          // ── TAB 2: Custom Message ─────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHdr('Template Select Karein', _kWA),
                  const SizedBox(height: 10),
                  ...{
                    'anc': ['ANC Reminder', 'ANC checkup reminder'],
                    'vaccine': ['Vaccine Alert', 'Vaccination reminder'],
                    'jsy': ['JSY Info', 'JSY yojana ke baare mein'],
                    'followup': [
                      'Follow-up',
                      'General health follow-up'
                    ],
                  }.entries.map((e) => _TemplateCard(
                        title: e.value[0],
                        subtitle: e.value[1],
                        color: _kWA,
                        key: ValueKey(e.key),
                        onTap: () {
                          final preview = e.key == 'anc'
                              ? WATemplates.ancReminder(
                                  name: '[Patient Naam]',
                                  date: '5 March 2026',
                                  trimester: '2nd',
                                  ashaName: 'Sunita Didi')
                              : e.key == 'vaccine'
                                  ? WATemplates.vaccineReminder(
                                      childName: '[Bachche ka Naam]',
                                      motherName: '[Maa ka Naam]',
                                      vaccine: '[Vaccine]',
                                      date: '7 March 2026',
                                      time: '9:00 AM',
                                      location: '[Gaon]',
                                      ashaName: 'Sunita Didi')
                                  : e.key == 'jsy'
                                      ? WATemplates.jsyInfo(
                                          name: '[Patient Naam]',
                                          ashaName: 'Sunita Didi')
                                      : WATemplates.generalFollowup(
                                          name: '[Patient Naam]',
                                          message: '[Apna message yahan likhen]',
                                          ashaName: 'Sunita Didi');
                          setState(() => _customMsgC.text = preview);
                        },
                      )),
                  const SizedBox(height: 14),
                  _SectionHdr('Phone Number', _kWA),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _customPhoneC,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Patient ka phone number',
                      prefixIcon:
                          const Icon(Icons.phone_rounded, color: _kWA),
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kBorder)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: kBorder, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: _kWA, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionHdr('Message Preview', _kWA),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCF8C6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _customMsgC,
                      maxLines: 10,
                      style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.55,
                          color: Color(0xFF1A3C1A)),
                      decoration: const InputDecoration.collapsed(
                          hintText:
                              'Upar se template choose karein ya khud likhein...'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _customMsgC.text));
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message copied!'),
                                backgroundColor: _kWA,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text('Copy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _kWA,
                          side: const BorderSide(color: _kWA),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final phone = _customPhoneC.text.trim();
                          if (phone.length != 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('10 digit phone number daalen'),
                                backgroundColor: _kRed,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          await WAService.sendMessage(
                              context: context,
                              phone: phone,
                              message: _customMsgC.text);
                          setState(() => _sentLog.insert(
                              0,
                              _SentMsg(
                                  patientName: 'Custom',
                                  phone: phone,
                                  template: 'custom',
                                  time: _timeNow())));
                        },
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text('WhatsApp Bhejo',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kWA,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                ]),
          ),

          // ── TAB 3: Sent Log ───────────────────────────
          _sentLog.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.chat_bubble_outline_rounded,
                        size: 48, color: kMuted.withOpacity(0.3)),
                    const SizedBox(height: 12),
                    const Text('Abhi tak koi message nahi bheja',
                        style: TextStyle(color: kMuted, fontSize: 13)),
                  ]),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _sentLog.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final s = _sentLog[i];
                    final tc = s.template == 'anc'
                        ? _kPink
                        : s.template == 'vaccine'
                            ? _kTeal
                            : s.template == 'alert'
                                ? kOrange
                                : _kWA;
                    final lbl = {
                          'anc': 'ANC Reminder',
                          'vaccine': 'Vaccine Alert',
                          'jsy': 'JSY Info',
                          'alert': 'High Risk Alert',
                          'custom': 'Custom Message',
                        }[s.template] ??
                        s.template;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: _kWA.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.chat_rounded,
                              color: _kWA, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(s.patientName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              Text(s.phone,
                                  style: const TextStyle(
                                      fontSize: 11, color: kMuted)),
                              const SizedBox(height: 4),
                              _WaTag(lbl, tc),
                            ])),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                          Text(s.time,
                              style: const TextStyle(
                                  fontSize: 11, color: kMuted)),
                          const SizedBox(height: 4),
                          const Row(children: [
                            Icon(Icons.done_all_rounded,
                                color: _kWA, size: 14),
                            SizedBox(width: 3),
                            Text('Sent',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: _kWA,
                                    fontWeight: FontWeight.w600)),
                          ]),
                        ]),
                      ]),
                    );
                  },
                ),
        ]),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════
//  SMART REMINDERS PAGE
// ═══════════════════════════════════════════════════════════
class SmartRemindersPage extends StatefulWidget {
  const SmartRemindersPage({super.key});
  @override
  State<SmartRemindersPage> createState() => _SmartRemindersPageState();
}

class _SmartRemindersPageState extends State<SmartRemindersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  static const _color = Color(0xFF6A1B9A);

  final List<_SmartReminder> _reminders = [
    _SmartReminder(
      id: 'r1',
      title: 'Kavita Sharma — ANC Checkup',
      subtitle: '3rd Trimester • Wardha',
      phone: '9876500001',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      type: 'anc',
      priority: 'high',
      isActive: true,
      waTemplate: 'anc',
      isAutoGenerated: true,
    ),
    _SmartReminder(
      id: 'r2',
      title: 'Rahul Kumar — OPV Vaccine',
      subtitle: '6 months • Wardha',
      phone: '9800001111',
      dueDate: DateTime.now().add(const Duration(hours: 4)),
      type: 'vaccine',
      priority: 'high',
      isActive: true,
      waTemplate: 'vaccine',
      isAutoGenerated: true,
    ),
    _SmartReminder(
      id: 'r3',
      title: 'Sneha Patil — MMR Vaccine Overdue',
      subtitle: '12 months • Nagpur',
      phone: '9800002222',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      type: 'vaccine',
      priority: 'high',
      isActive: true,
      waTemplate: 'vaccine',
      isAutoGenerated: true,
    ),
    _SmartReminder(
      id: 'r4',
      title: 'Priya Patil — ANC 2nd Visit',
      subtitle: '2nd Trimester • Nagpur',
      phone: '9876500002',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      type: 'anc',
      priority: 'medium',
      isActive: true,
      waTemplate: 'anc',
      isAutoGenerated: true,
    ),
    _SmartReminder(
      id: 'r5',
      title: 'Radha Devi — JSY Registration',
      subtitle: 'JSY pending • Nagpur',
      phone: '9123456780',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      type: 'jsy',
      priority: 'medium',
      isActive: false,
      waTemplate: 'jsy',
      isAutoGenerated: false,
    ),
    _SmartReminder(
      id: 'r6',
      title: 'Monthly Report Submit',
      subtitle: 'PHC submission deadline',
      phone: '',
      dueDate: DateTime.now().add(const Duration(days: 25)),
      type: 'report',
      priority: 'low',
      isActive: true,
      waTemplate: '',
      isAutoGenerated: false,
    ),
  ];

  String _filter = 'all';
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _phoneC = TextEditingController();
  final _notesC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    _titleC.dispose();
    _phoneC.dispose();
    _notesC.dispose();
    super.dispose();
  }

  List<_SmartReminder> get _filtered {
    final list = _reminders.where((r) {
      if (_filter == 'overdue') {
        return r.dueDate.isBefore(DateTime.now()) && r.isActive;
      }
      if (_filter == 'today') {
        final now = DateTime.now();
        final d = r.dueDate;
        return d.year == now.year &&
            d.month == now.month &&
            d.day == now.day;
      }
      if (_filter == 'anc') return r.type == 'anc';
      if (_filter == 'vaccine') return r.type == 'vaccine';
      return true;
    }).toList();
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'anc':
        return _kPink;
      case 'vaccine':
        return _kTeal;
      case 'jsy':
        return kGreen;
      case 'report':
        return _kPurple;
      default:
        return kBlue;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'anc':
        return Icons.pregnant_woman_rounded;
      case 'vaccine':
        return Icons.vaccines_rounded;
      case 'jsy':
        return Icons.account_balance_wallet_rounded;
      case 'report':
        return Icons.bar_chart_rounded;
      default:
        return Icons.alarm_rounded;
    }
  }

  String _dueDateText(_SmartReminder r) {
    final diff = r.dueDate.difference(DateTime.now());
    if (diff.isNegative) {
      final d = diff.inDays.abs();
      return d == 0 ? 'Aaj overdue!' : '$d din overdue!';
    }
    if (diff.inHours < 1) return '${diff.inMinutes} min mein';
    if (diff.inDays == 0) {
      return 'Aaj ${r.dueDate.hour}:${r.dueDate.minute.toString().padLeft(2, '0')} baje';
    }
    if (diff.inDays == 1) return 'Kal';
    return '${diff.inDays} din mein';
  }

  Color _dueDateColor(_SmartReminder r) {
    final diff = r.dueDate.difference(DateTime.now());
    if (diff.isNegative) return _kRed;
    if (diff.inDays <= 1) return kOrange;
    return kGreen;
  }

  void _addReminder() {
    String selectedType = 'anc';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: _color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.add_alarm_rounded,
                              color: _color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('New Reminder Add Karein',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: _color)),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close_rounded,
                              color: kMuted),
                        ),
                      ]),
                      const Divider(height: 24, color: kBorder),

                      // Type selector
                      const Text('Type Select Karein:',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: kMuted)),
                      const SizedBox(height: 8),
                      Row(
                          children: ['anc', 'vaccine', 'jsy', 'report']
                              .map((t) {
                        final sel = selectedType == t;
                        const labels = {
                          'anc': 'ANC',
                          'vaccine': 'Vaccine',
                          'jsy': 'JSY',
                          'report': 'Report'
                        };
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setS(() => selectedType = t),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: sel ? _typeColor(t) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: sel ? _typeColor(t) : kBorder),
                              ),
                              child: Text(
                                labels[t]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        sel ? Colors.white : kMuted),
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                      const SizedBox(height: 14),

                      // Title field
                      TextFormField(
                        controller: _titleC,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Title zaroori hai'
                                : null,
                        style: const TextStyle(fontSize: 13, color: kText),
                        decoration: InputDecoration(
                          labelText: 'Reminder Title *',
                          prefixIcon: const Icon(
                              Icons.title_rounded,
                              color: _color,
                              size: 18),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          labelStyle:
                              const TextStyle(fontSize: 12, color: kMuted),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: kBorder, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: _color, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Phone field
                      TextFormField(
                        controller: _phoneC,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(fontSize: 13, color: kText),
                        decoration: InputDecoration(
                          labelText: 'Phone (WhatsApp ke liye)',
                          prefixIcon: const Icon(Icons.phone_outlined,
                              color: _color, size: 18),
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          labelStyle:
                              const TextStyle(fontSize: 12, color: kMuted),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: kBorder, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: _color, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Date picker
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365)),
                            builder: (_, child) => Theme(
                              data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                      primary: _color)),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setS(() => selectedDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(11),
                            border:
                                Border.all(color: kBorder, width: 1.5),
                          ),
                          child: Row(children: [
                            const Icon(Icons.calendar_today_rounded,
                                color: _color, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: const TextStyle(
                                    fontSize: 13, color: kText),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded,
                                color: kMuted),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Notes
                      TextFormField(
                        controller: _notesC,
                        style: const TextStyle(fontSize: 13, color: kText),
                        decoration: InputDecoration(
                          labelText: 'Notes (optional)',
                          prefixIcon: const Icon(Icons.notes_rounded,
                              color: _color, size: 18),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          labelStyle:
                              const TextStyle(fontSize: 12, color: kMuted),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: kBorder, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                  color: _color, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save button
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _reminders.add(
                                  _SmartReminder(
                                    id: 'r${DateTime.now().millisecondsSinceEpoch}',
                                    title: _titleC.text.trim(),
                                    subtitle: _notesC.text
                                            .trim()
                                            .isNotEmpty
                                        ? _notesC.text.trim()
                                        : 'Manual reminder',
                                    phone: _phoneC.text.trim(),
                                    dueDate: selectedDate,
                                    type: selectedType,
                                    priority: 'medium',
                                    isActive: true,
                                    waTemplate: selectedType,
                                    isAutoGenerated: false,
                                  ),
                                ));
                            _titleC.clear();
                            _phoneC.clear();
                            _notesC.clear();
                            Navigator.pop(ctx);
                          }
                        },
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Reminder Save Karein',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overdueCount = _reminders
        .where((r) => r.isActive && r.dueDate.isBefore(DateTime.now()))
        .length;
    final todayCount = _reminders.where((r) {
      final now = DateTime.now();
      final d = r.dueDate;
      return r.isActive &&
          d.year == now.year &&
          d.month == now.month &&
          d.day == now.day;
    }).length;

    return Column(children: [
      // ── Header ─────────────────────────────────────────
      Container(
        padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_color, _color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.alarm_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Smart Reminders',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    Text('ANC/Vaccine alerts auto-set hote hain',
                        style: TextStyle(
                            fontSize: 11, color: Colors.white70)),
                  ]),
            ),
            GestureDetector(
              onTap: _addReminder,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: const Row(children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Add',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // Stats
          Row(children: [
            _ReminderStat(count: overdueCount, label: 'Overdue', color: _kRed),
            _ReminderStat(count: todayCount, label: 'Aaj', color: kOrange),
            _ReminderStat(
                count:
                    _reminders.where((r) => r.isAutoGenerated).length,
                label: 'Auto-Set',
                color: Colors.white),
            _ReminderStat(
                count: _reminders.where((r) => r.isActive).length,
                label: 'Active',
                color: kGreen),
          ]),
          const SizedBox(height: 16),

          TabBar(
            controller: _tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Reminders'),
              Tab(text: 'Overview'),
            ],
          ),
        ]),
      ),

      Expanded(
        child: TabBarView(controller: _tab, children: [
          // ── TAB 1: Reminders List ─────────────────────
          Column(children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  ...[
                    {'v': 'all', 'l': 'Sab'},
                    {'v': 'overdue', 'l': 'Overdue'},
                    {'v': 'today', 'l': 'Aaj'},
                    {'v': 'anc', 'l': 'ANC'},
                    {'v': 'vaccine', 'l': 'Vaccine'},
                  ].map((c) {
                    final sel = _filter == c['v'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _filter = c['v']!),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: sel ? _color : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: sel ? _color : kBorder),
                          ),
                          child: Text(c['l']!,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: sel
                                      ? Colors.white
                                      : kMuted)),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text('Koi reminder nahi',
                          style:
                              TextStyle(color: kMuted, fontSize: 13)))
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final r = _filtered[i];
                        final tc = _typeColor(r.type);
                        final overdue =
                            r.dueDate.isBefore(DateTime.now());
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: overdue
                                ? Border.all(
                                    color: _kRed.withOpacity(0.3))
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.05),
                                  blurRadius: 8)
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: overdue
                                          ? _kRedLight
                                          : tc.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Icon(_typeIcon(r.type),
                                        color: overdue ? _kRed : tc,
                                        size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(r.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Text(r.subtitle,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: kMuted)),
                                    ]),
                                  ),
                                  Switch(
                                    value: r.isActive,
                                    onChanged: (v) => setState(
                                        () => r.isActive = v),
                                    activeColor: kGreen,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                  ),
                                ]),
                                const SizedBox(height: 10),
                                Row(children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _dueDateColor(r)
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Row(children: [
                                      Icon(
                                        overdue
                                            ? Icons.warning_rounded
                                            : Icons.schedule_rounded,
                                        size: 12,
                                        color: _dueDateColor(r),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(_dueDateText(r),
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight.w700,
                                              color:
                                                  _dueDateColor(r))),
                                    ]),
                                  ),
                                  if (r.isAutoGenerated) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 3),
                                      decoration: BoxDecoration(
                                        color:
                                            _color.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Row(children: [
                                        Icon(
                                            Icons.auto_awesome_rounded,
                                            size: 10,
                                            color: _color),
                                        const SizedBox(width: 3),
                                        Text('Auto',
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight.w600,
                                                color: _color)),
                                      ]),
                                    ),
                                  ],
                                  const Spacer(),
                                  if (r.phone.isNotEmpty)
                                    GestureDetector(
                                      onTap: () async {
                                        final msg = r.waTemplate == 'anc'
                                            ? WATemplates.ancReminder(
                                                name: r.title
                                                    .split('—')[0]
                                                    .trim(),
                                                date:
                                                    '${r.dueDate.day}/${r.dueDate.month}',
                                                trimester: 'Next',
                                                ashaName: 'Sunita Didi')
                                            : r.waTemplate == 'vaccine'
                                                ? WATemplates.vaccineReminder(
                                                    childName: r.title,
                                                    motherName: r.subtitle,
                                                    vaccine: 'vaccine',
                                                    date:
                                                        '${r.dueDate.day} March',
                                                    time: '9:00 AM',
                                                    location: 'PHC',
                                                    ashaName: 'Sunita Didi')
                                                : WATemplates.jsyInfo(
                                                    name: r.title,
                                                    ashaName:
                                                        'Sunita Didi');
                                        await WAService.sendMessage(
                                            context: context,
                                            phone: r.phone,
                                            message: msg);
                                      },
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _kWA.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color:
                                                  _kWA.withOpacity(0.3)),
                                        ),
                                        child: const Row(children: [
                                          Icon(Icons.chat_rounded,
                                              size: 13, color: _kWA),
                                          SizedBox(width: 4),
                                          Text('WhatsApp',
                                              style: TextStyle(
                                                  fontSize: 10.5,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: _kWA)),
                                        ]),
                                      ),
                                    ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => setState(
                                        () => _reminders.remove(r)),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: _kRedLight,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 14,
                                          color: _kRed),
                                    ),
                                  ),
                                ]),
                              ]),
                        );
                      },
                    ),
            ),
          ]),

          // ── TAB 2: Overview ────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    _OvCard(
                        value: '$overdueCount',
                        label: 'Overdue',
                        color: _kRed,
                        icon: Icons.warning_rounded),
                    const SizedBox(width: 10),
                    _OvCard(
                        value: '$todayCount',
                        label: 'Aaj',
                        color: kOrange,
                        icon: Icons.today_rounded),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _OvCard(
                        value: '${_reminders.where((r) => r.type == 'anc').length}',
                        label: 'ANC Total',
                        color: _kPink,
                        icon: Icons.pregnant_woman_rounded),
                    const SizedBox(width: 10),
                    _OvCard(
                        value:
                            '${_reminders.where((r) => r.type == 'vaccine').length}',
                        label: 'Vaccine Total',
                        color: _kTeal,
                        icon: Icons.vaccines_rounded),
                  ]),
                  const SizedBox(height: 20),
                  const Text('Upcoming Schedule',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: kText)),
                  const SizedBox(height: 12),
                  ..._reminders
                      .where((r) =>
                          r.isActive &&
                          !r.dueDate.isBefore(DateTime.now()))
                      .toList()
                    ..sort((a, b) =>
                        a.dueDate.compareTo(b.dueDate))
                    ..take(5).forEach((r) {
                        final tc = _typeColor(r.type);
                        // Inline the widget
                      }),
                  ..._reminders
                      .where((r) =>
                          r.isActive &&
                          !r.dueDate.isBefore(DateTime.now()))
                      .toList()
                      .asMap()
                      .entries
                      .take(5)
                      .map((e) {
                    final r = e.value;
                    final tc = _typeColor(r.type);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: tc, shape: BoxShape.circle)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(r.title,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600))),
                        Text(_dueDateText(r),
                            style: TextStyle(
                                fontSize: 11,
                                color: _dueDateColor(r),
                                fontWeight: FontWeight.w700)),
                      ]),
                    );
                  }),
                  const SizedBox(height: 24),
                ]),
          ),
        ]),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════
//  SMALL HELPER WIDGETS
// ═══════════════════════════════════════════════════════════
class _WaTag extends StatelessWidget {
  final String text;
  final Color color;
  const _WaTag(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6)),
        child: Text(text,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color)));
}

class _MsgBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MsgBtn(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.3))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ]),
        ),
      );
}

class _SectionHdr extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionHdr(this.text, this.color);
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ]);
}

class _TemplateCard extends StatelessWidget {
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _TemplateCard(
      {required this.title,
      required this.subtitle,
      required this.color,
      required this.onTap,
      super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03), blurRadius: 4)
            ],
          ),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color)),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 11, color: kMuted)),
                ])),
            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: color),
          ]),
        ),
      );
}

class _ReminderStat extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _ReminderStat(
      {required this.count,
      required this.label,
      required this.color});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text('$count',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color)),
          Text(label,
              style:
                  TextStyle(fontSize: 9.5, color: color.withOpacity(0.8))),
        ]),
      );
}

class _OvCard extends StatelessWidget {
  final String value, label;
  final Color color;
  final IconData icon;
  const _OvCard(
      {required this.value,
      required this.label,
      required this.color,
      required this.icon});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.12), blurRadius: 10)
            ],
          ),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: color)),
              Text(label,
                  style:
                      const TextStyle(fontSize: 10, color: kMuted)),
            ]),
          ]),
        ),
      );
}
