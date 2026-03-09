import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart' as ex;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'main.dart'; // langNotifier, colors

// ══════════════════════════════════════════════════════════
//  BENEFICIARY DATA MODEL
// ══════════════════════════════════════════════════════════
class BeneficiaryRecord {
  final String schemeName;
  final String beneficiaryName;
  final String mobileNumber;
  final String aadhaarNumber;
  final String village;
  final String district;
  final String ashaWorkerName;
  final String enrollmentDate;
  final String status;

  BeneficiaryRecord({
    required this.schemeName,
    required this.beneficiaryName,
    required this.mobileNumber,
    required this.aadhaarNumber,
    required this.village,
    required this.district,
    required this.ashaWorkerName,
    required this.enrollmentDate,
    this.status = 'Enrolled',
  });

  List<String> toExcelRow() => [
        schemeName, beneficiaryName, mobileNumber, aadhaarNumber,
        village, district, ashaWorkerName, enrollmentDate, status,
      ];
}

// ══════════════════════════════════════════════════════════
//  EXCEL EXPORT SERVICE  — Android/iOS compatible
// ══════════════════════════════════════════════════════════
class ExcelExportService {
  static final List<BeneficiaryRecord> _allRecords = [];

  static void addRecord(BeneficiaryRecord record) => _allRecords.add(record);
  static List<BeneficiaryRecord> get allRecords => List.unmodifiable(_allRecords);

  static Future<String> exportToExcel(String ashaWorkerName) async {
    final excel = ex.Excel.createExcel();
    final sheet = excel['ASHA Beneficiaries'];

    // ── Headers ──
    final headers = [
      'Scheme Name', 'Beneficiary Name', 'Mobile Number', 'Aadhaar Number',
      'Village', 'District', 'ASHA Worker Name', 'Enrollment Date', 'Status',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = ex.TextCellValue(headers[i]);
      cell.cellStyle = ex.CellStyle(
        bold: true,
        backgroundColorHex: ex.ExcelColor.fromHexString('#1A9E5C'),
        fontColorHex: ex.ExcelColor.fromHexString('#FFFFFF'),
      );
    }

    // ── Rows ──
    final workerRecords = ashaWorkerName == 'All'
        ? _allRecords
        : _allRecords.where((r) => r.ashaWorkerName == ashaWorkerName).toList();

    for (int rowIdx = 0; rowIdx < workerRecords.length; rowIdx++) {
      final rowData = workerRecords[rowIdx].toExcelRow();
      for (int colIdx = 0; colIdx < rowData.length; colIdx++) {
        sheet
            .cell(ex.CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: rowIdx + 1))
            .value = ex.TextCellValue(rowData[colIdx]);
      }
    }

    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 20);
    }

    // ── Save to device temp folder & share ──
    final fileBytes = excel.save();
    if (fileBytes == null) throw Exception('Excel file banane mein dikkat aayi');

    final dir = await getTemporaryDirectory();
    final fileName = 'ASHA_Beneficiaries_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final filePath = '${dir.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(fileBytes, flush: true);

    // Share sheet khulega — WhatsApp, Gmail, Files, etc.
    await Share.shareXFiles(
      [XFile(filePath, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
      subject: 'ASHA Beneficiaries Excel',
      text: 'ASHA Worker beneficiary data — $fileName',
    );

    return 'Excel ready! Share/Save karein.';
  }
}

// ══════════════════════════════════════════════════════════
//  SCHEME DATA MODEL
// ══════════════════════════════════════════════════════════
class SchemeDetail {
  final String name;
  final String shortDesc;
  final String amount;
  final Color color;
  final IconData icon;
  final String ministry;
  final String launched;
  final String objective;
  final List<String> eligibility;
  final List<String> benefits;
  final List<String> documents;
  final List<String> howToApply;
  final String contactOffice;
  final String helpline;
  final String portalUrl;

  const SchemeDetail({
    required this.name, required this.shortDesc, required this.amount,
    required this.color, required this.icon, required this.ministry,
    required this.launched, required this.objective, required this.eligibility,
    required this.benefits, required this.documents, required this.howToApply,
    required this.contactOffice, required this.helpline, required this.portalUrl,
  });
}

// ══════════════════════════════════════════════════════════
//  ALL SCHEMES DATA
// ══════════════════════════════════════════════════════════
final List<SchemeDetail> allSchemes = [
  SchemeDetail(
    name: 'Janani Suraksha Yojana (JSY)',
    shortDesc: 'Institutional delivery incentive for BPL mothers',
    amount: '₹1,400',
    color: const Color(0xFFD81B60),
    icon: Icons.pregnant_woman_rounded,
    ministry: 'Ministry of Health & Family Welfare',
    launched: '2005',
    objective: 'JSY is a safe motherhood intervention under the National Health Mission. It aims to reduce maternal and infant mortality by promoting institutional delivery among poor pregnant women.',
    eligibility: [
      'All pregnant women from BPL families',
      'SC/ST women in rural areas (all categories)',
      'Women aged 19 years and above',
      'For first two live births only',
      'Must deliver at government or accredited private hospital',
    ],
    benefits: [
      '₹1,400 cash incentive for rural area delivery',
      '₹1,000 cash incentive for urban area delivery',
      'ASHA worker gets ₹600 incentive per case',
      'Free ante-natal care (ANC) services',
      'Free transport to hospital provided',
      'Free medicines during delivery',
    ],
    documents: [
      'BPL / Ration card', 'Aadhar card of mother',
      'Bank account details (for DBT)', 'ANC registration card (MCP card)', 'Age proof (if required)',
    ],
    howToApply: [
      'Register at nearest Anganwadi or Sub-centre',
      'Get ANC registration done early in pregnancy',
      'Contact ASHA worker in your village',
      'Deliver at government hospital or empanelled private hospital',
      'Cash benefit transferred to bank account after delivery',
    ],
    contactOffice: 'Primary Health Centre (PHC) / Sub-District Hospital',
    helpline: '104 (NHM Helpline)',
    portalUrl: 'https://nhm.gov.in/index1.php?lang=1&level=3&sublinkid=841&lid=309',
  ),
  SchemeDetail(
    name: 'PM Matru Vandana Yojana (PMMVY)',
    shortDesc: 'Maternity benefit for first child',
    amount: '₹5,000',
    color: const Color(0xFF1565C0),
    icon: Icons.favorite_rounded,
    ministry: 'Ministry of Women & Child Development',
    launched: '2017',
    objective: 'PMMVY provides partial wage compensation to women for wage loss during pregnancy and child birth so that women can take adequate rest before and after delivery of the first living child.',
    eligibility: [
      'Pregnant women and lactating mothers',
      'For first living child only',
      'Women aged 19 years and above',
      'Women not employed with Central/State Government',
      'Miscarriage/stillbirth cases eligible for remaining instalments',
    ],
    benefits: [
      '₹1,000 - 1st instalment on early ANC registration',
      '₹2,000 - 2nd instalment after 6 months of pregnancy',
      '₹2,000 - 3rd instalment after child birth & vaccination',
      'Total benefit: ₹5,000 per beneficiary',
      'Additional ₹1,000 for institutional delivery under JSY',
    ],
    documents: [
      'Aadhar card (mandatory)', "Husband's Aadhar card",
      'Bank account / Post Office passbook', 'MCP (Mother & Child Protection) card',
      'Proof of pregnancy / ANC registration',
    ],
    howToApply: [
      'Register at Anganwadi Centre (AWC) within 150 days of LMP',
      'Fill Form 1A for 1st instalment',
      'Fill Form 1B for 2nd instalment after ANC',
      'Fill Form 1C for 3rd instalment after delivery',
      'Amount credited directly to bank account via DBT',
    ],
    contactOffice: 'Anganwadi Centre / CDPO Office / District WCD Office',
    helpline: '181 (Women Helpline) / 7998799804 (PMMVY)',
    portalUrl: 'https://pmmvy.wcd.gov.in',
  ),
  SchemeDetail(
    name: 'Ayushman Bharat - PMJAY',
    shortDesc: 'Health insurance upto ₹5 lakh per family per year',
    amount: '₹5 Lakh',
    color: const Color(0xFF1A9E5C),
    icon: Icons.health_and_safety_rounded,
    ministry: 'Ministry of Health & Family Welfare',
    launched: '2018',
    objective: 'Pradhan Mantri Jan Arogya Yojana (PM-JAY) provides health cover of ₹5 lakh per family per year for secondary and tertiary care hospitalisation to over 12 crore poor and vulnerable families.',
    eligibility: [
      'Families included in SECC 2011 database',
      'Rural families in D1-D5 deprivation categories',
      'Occupational category families in urban areas',
      'Automatically included - no registration needed',
      'Beneficiary families can check status on PM-JAY portal',
    ],
    benefits: [
      '₹5 lakh health cover per family per year',
      'Covers 1,949+ medical procedures',
      'Cashless treatment at empanelled hospitals',
      'Pre and post hospitalization costs covered',
      'No cap on family size or age',
      'All pre-existing diseases covered from day 1',
    ],
    documents: [
      'Aadhar card / Ration card', 'Mobile number (for OTP verification)',
      'No physical card needed (biometric verification)', 'PM-JAY Golden Card (if issued)',
    ],
    howToApply: [
      'Visit nearest Ayushman Mitra at empanelled hospital',
      'Check eligibility at pmjay.gov.in or helpline 14555',
      'Verify identity with Aadhar / Ration card',
      'Get e-card generated on the spot',
      'Treatment starts immediately at empanelled hospitals',
    ],
    contactOffice: 'Empanelled Government / Private Hospitals',
    helpline: '14555 / 1800-111-565 (Toll Free)',
    portalUrl: 'https://pmjay.gov.in',
  ),
  SchemeDetail(
    name: 'RBSK - Rashtriya Bal Swasthya Karyakram',
    shortDesc: 'Free health screening & treatment for children 0-18 years',
    amount: 'Free',
    color: const Color(0xFF00897B),
    icon: Icons.child_care_rounded,
    ministry: 'Ministry of Health & Family Welfare',
    launched: '2013',
    objective: 'RBSK aims for early identification and early intervention for children from birth to 18 years for 4Ds — Defects at birth, Diseases, Deficiencies and Development delays including Disabilities.',
    eligibility: [
      'All children from 0 to 18 years of age',
      'Newborns in government hospitals',
      'Children at Anganwadi Centres',
      'Students in government & government-aided schools',
      'No income limit - universal coverage',
    ],
    benefits: [
      'Free health screening at birth and at school',
      'Free treatment for 30 identified conditions',
      'Free surgery for heart defects, cleft lip/palate',
      'Free hearing aids and assistive devices',
      'Free referral to District Early Intervention Centre (DEIC)',
      'Free transport for treatment if required',
    ],
    documents: [
      'Birth certificate (for newborns)', 'School ID card (for school children)',
      'Aadhar card (if available)', 'No documents required for initial screening',
    ],
    howToApply: [
      'Mobile Health Teams visit schools and AWCs automatically',
      'Parents can also approach PHC / CHC for screening',
      'Identified children referred to DEIC for further evaluation',
      'Treatment arranged through RBSK referral system',
      'Contact ASHA worker or ANM for more information',
    ],
    contactOffice: 'District Early Intervention Centre (DEIC) / PHC',
    helpline: '104 (NHM Helpline)',
    portalUrl: 'https://rbsk.nhm.gov.in',
  ),
  SchemeDetail(
    name: 'National Iron+ Initiative',
    shortDesc: 'Iron & folic acid supplementation for all age groups',
    amount: 'Free',
    color: const Color(0xFFFF6B2B),
    icon: Icons.medication_rounded,
    ministry: 'Ministry of Health & Family Welfare',
    launched: '2013',
    objective: 'The National Iron+ Initiative aims to combat iron deficiency anaemia across all age groups through weekly iron and folic acid supplementation programme.',
    eligibility: [
      'Children 6-59 months (syrup form)', 'Children 5-10 years (small tablet)',
      'Adolescents 10-19 years (large tablet)', 'Pregnant women (180 tablets during pregnancy)',
      'Lactating mothers (180 tablets post-delivery)', 'Women of reproductive age (14-45 years)',
    ],
    benefits: [
      'Free Iron-Folic Acid (IFA) tablets / syrup',
      'Weekly supplementation for children & adolescents',
      'Daily supplementation for pregnant & lactating women',
      'Reduces risk of anaemia and iron deficiency',
      'Improves cognitive development in children',
      'Available at all government health facilities',
    ],
    documents: [
      'No documents required', 'Available free at Anganwadi Centres',
      'Available at PHC / Sub-centres', 'Distributed through ASHA workers',
    ],
    howToApply: [
      'Contact ASHA worker or ANM in your area',
      'Visit nearest Anganwadi Centre',
      'Available every week at schools (school health programme)',
      'Pregnant women get tablets at ANC visits',
      'No registration or application needed',
    ],
    contactOffice: 'Anganwadi Centre / PHC / Sub-Centre',
    helpline: '104 (NHM Helpline)',
    portalUrl: 'https://nhm.gov.in/index1.php?lang=1&level=3&sublinkid=1072&lid=612',
  ),
  SchemeDetail(
    name: 'Poshan Abhiyan',
    shortDesc: 'Comprehensive nutrition mission for women and children',
    amount: 'Free',
    color: const Color(0xFF7B2FBE),
    icon: Icons.restaurant_rounded,
    ministry: 'Ministry of Women & Child Development',
    launched: '2018',
    objective: "Poshan Abhiyan (PM's Overarching Scheme for Holistic Nutrition) aims to improve nutritional status of children (0-6 years), adolescent girls, pregnant women and lactating mothers.",
    eligibility: [
      'Children aged 0-6 years', 'Pregnant and lactating women',
      'Adolescent girls aged 14-18 years', 'Women of reproductive age',
      'Families in all districts across India',
    ],
    benefits: [
      'Supplementary nutrition through Anganwadi centres',
      'Monthly growth monitoring of children',
      'Nutrition counselling and education',
      'Early childhood care and education (ECCE)',
      'Convergence with health, sanitation and water schemes',
      'Community-based events (Poshan Maah, Poshan Pakhwada)',
    ],
    documents: [
      'Aadhar card (for registration)', 'Birth certificate of child',
      'MCP card for pregnant/lactating women', 'Ration card (if available)',
    ],
    howToApply: [
      'Register at nearest Anganwadi Centre',
      'Contact local ASHA or Anganwadi Worker',
      'Attend monthly Village Health & Nutrition Day (VHND)',
      'Participate in Poshan Maah activities in September',
      'Track child growth on Poshan Tracker app',
    ],
    contactOffice: 'Anganwadi Centre / CDPO Office / District WCD Office',
    helpline: '181 (Women Helpline) / 1800-11-7711',
    portalUrl: 'https://poshantracker.in',
  ),
];

// ══════════════════════════════════════════════════════════
//  ENROLL BENEFICIARY BOTTOM SHEET — VOICE ENABLED
// ══════════════════════════════════════════════════════════
class EnrollBeneficiarySheet extends StatefulWidget {
  final SchemeDetail scheme;
  const EnrollBeneficiarySheet({super.key, required this.scheme});
  @override
  State<EnrollBeneficiarySheet> createState() => _EnrollBeneficiarySheetState();
}

class _EnrollBeneficiarySheetState extends State<EnrollBeneficiarySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _mobileCtrl   = TextEditingController();
  final _aadhaarCtrl  = TextEditingController();
  final _villageCtrl  = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _ashaNameCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  // ── Voice ──
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;
  String? _listeningField;
  String _selectedLang = 'hi-IN';

  final Map<String, String> _langOptions = {
    'हिंदी': 'hi-IN',
    'English': 'en-IN',
    'मराठी': 'mr-IN',
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onError: (e) => debugPrint('Speech error: $e'),
      onStatus: (s) {
        if ((s == 'done' || s == 'notListening') && mounted) {
          setState(() => _listeningField = null);
        }
      },
    );
    if (mounted) setState(() => _speechAvailable = available);
  }

  Future<void> _startListening(String fieldKey, TextEditingController ctrl) async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Microphone permission nahi mili'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) setState(() => _listeningField = null);
      return;
    }
    if (mounted) setState(() => _listeningField = fieldKey);
    await _speech.listen(
      localeId: _selectedLang,
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        if (mounted) {
          setState(() {
            ctrl.text = result.recognizedWords;
            if (result.finalResult) _listeningField = null;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _nameCtrl.dispose(); _mobileCtrl.dispose(); _aadhaarCtrl.dispose();
    _villageCtrl.dispose(); _districtCtrl.dispose(); _ashaNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitEnrollment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final record = BeneficiaryRecord(
      schemeName: widget.scheme.name,
      beneficiaryName: _nameCtrl.text.trim(),
      mobileNumber: _mobileCtrl.text.trim(),
      aadhaarNumber: _aadhaarCtrl.text.trim(),
      village: _villageCtrl.text.trim(),
      district: _districtCtrl.text.trim(),
      ashaWorkerName: _ashaNameCtrl.text.trim(),
      enrollmentDate: _formatDate(DateTime.now()),
    );

    ExcelExportService.addRecord(record);

    try {
      final msg = await ExcelExportService.exportToExcel(_ashaNameCtrl.text.trim());
      if (mounted) {
        setState(() { _isLoading = false; _isSuccess = true; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('✅ $msg'),
          backgroundColor: widget.scheme.color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ));
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  Widget _voiceField({
    required String fieldKey,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final active = _listeningField == fieldKey;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: color, size: 18),
        suffixIcon: GestureDetector(
          onTap: () => _startListening(fieldKey, controller),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: active ? Colors.red : color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              active ? Icons.stop_rounded : Icons.mic_rounded,
              color: active ? Colors.white : color, size: 16,
            ),
          ),
        ),
        filled: true,
        fillColor: active ? Colors.red.shade50 : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color, width: 1.5)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: active ? const BorderSide(color: Colors.red, width: 1.5) : BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.scheme.color;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F6F3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16, right: 16, top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 16),

              Row(children: [
                Container(padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.how_to_reg_rounded, color: color, size: 20)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Enroll Beneficiary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A2332))),
                  Text(widget.scheme.name, style: TextStyle(fontSize: 11, color: color), overflow: TextOverflow.ellipsis),
                ])),
              ]),
              const SizedBox(height: 14),

              // Language selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Row(children: [
                  Icon(Icons.mic_rounded, color: color, size: 16),
                  const SizedBox(width: 8),
                  Text('Voice Language:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                  const SizedBox(width: 10),
                  ..._langOptions.entries.map((entry) {
                    final isSel = _selectedLang == entry.value;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedLang = entry.value),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSel ? color : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSel ? color : Colors.grey.shade300),
                        ),
                        child: Text(entry.key, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: isSel ? Colors.white : Colors.grey[700])),
                      ),
                    );
                  }),
                ]),
              ),
              const SizedBox(height: 12),

              // Listening banner
              if (_listeningField != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(children: [
                    const Icon(Icons.graphic_eq_rounded, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Sun raha hoon... boliye 🎤',
                        style: TextStyle(fontSize: 12, color: Colors.red.shade700, fontWeight: FontWeight.w600))),
                    GestureDetector(
                      onTap: () async { await _speech.stop(); if (mounted) setState(() => _listeningField = null); },
                      child: const Icon(Icons.stop_circle_rounded, color: Colors.red, size: 20),
                    ),
                  ]),
                ),

              _voiceField(fieldKey: 'asha', controller: _ashaNameCtrl,
                  label: 'ASHA Worker Name *', icon: Icons.person_pin_rounded, color: color,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 10),
              _voiceField(fieldKey: 'name', controller: _nameCtrl,
                  label: 'Beneficiary Name *', icon: Icons.person_rounded, color: color,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Name required';
                    if (v.trim().length < 3) return 'Min 3 characters';
                    return null;
                  }),
              const SizedBox(height: 10),
              _voiceField(fieldKey: 'mobile', controller: _mobileCtrl,
                  label: 'Mobile Number *', icon: Icons.phone_rounded, color: color,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Phone required';
                    final s = v.trim().replaceAll(RegExp(r'\s+'), '');
                    if (s.length != 10) return 'Exactly 10 digits chahiye';
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(s)) return '6-9 se shuru hona chahiye';
                    return null;
                  }),
              const SizedBox(height: 10),
              _voiceField(fieldKey: 'aadhaar', controller: _aadhaarCtrl,
                  label: 'Aadhaar Number', icon: Icons.credit_card_rounded, color: color,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _voiceField(fieldKey: 'village', controller: _villageCtrl,
                    label: 'Village / Ward *', icon: Icons.location_on_rounded, color: color,
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
                const SizedBox(width: 10),
                Expanded(child: _voiceField(fieldKey: 'district', controller: _districtCtrl,
                    label: 'District *', icon: Icons.map_rounded, color: color,
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
              ]),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.07), borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Row(children: [
                  Icon(Icons.share_rounded, color: color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    '📊 Save karke WhatsApp / Gmail se share karein ya Files mein save karein.',
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
                  )),
                ]),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitEnrollment,
                  icon: _isLoading
                      ? const SizedBox(width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : _isSuccess
                          ? const Icon(Icons.check_circle_rounded, size: 18)
                          : const Icon(Icons.save_rounded, size: 18),
                  label: Text(
                    _isLoading ? 'Saving...' : _isSuccess ? 'Saved Successfully!' : 'Enroll & Export Excel',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSuccess ? Colors.green : color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ENROLLED BENEFICIARIES PAGE
// ══════════════════════════════════════════════════════════
class EnrolledBeneficiariesPage extends StatefulWidget {
  const EnrolledBeneficiariesPage({super.key});
  @override
  State<EnrolledBeneficiariesPage> createState() => _EnrolledBeneficiariesPageState();
}

class _EnrolledBeneficiariesPageState extends State<EnrolledBeneficiariesPage> {
  bool _isExporting = false;

  Future<void> _exportAll() async {
    setState(() => _isExporting = true);
    try {
      final msg = await ExcelExportService.exportToExcel('All');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('✅ $msg'),
        backgroundColor: const Color(0xFF1A9E5C),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = ExcelExportService.allRecords;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F3),
      appBar: AppBar(
        title: const Text('Enrolled Beneficiaries', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        backgroundColor: const Color(0xFF1A9E5C),
        foregroundColor: Colors.white,
        actions: [
          if (records.isNotEmpty)
            IconButton(
              onPressed: _isExporting ? null : _exportAll,
              icon: _isExporting
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.share_rounded),
              tooltip: 'Export & Share Excel',
            ),
        ],
      ),
      body: records.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('No beneficiaries enrolled yet', style: TextStyle(color: Colors.grey, fontSize: 15)),
            ]))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final r = records[index];
                final schemeColor = allSchemes
                    .firstWhere((s) => s.name == r.schemeName, orElse: () => allSchemes.first)
                    .color;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 36, height: 36,
                          decoration: BoxDecoration(color: schemeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.person_rounded, color: schemeColor, size: 18)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r.beneficiaryName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2332))),
                        Text(r.schemeName, style: TextStyle(fontSize: 11, color: schemeColor), overflow: TextOverflow.ellipsis),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Enrolled', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(children: [
                      _chip(Icons.phone_rounded, r.mobileNumber),
                      const SizedBox(width: 8),
                      _chip(Icons.location_on_rounded, '${r.village}, ${r.district}'),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      _chip(Icons.calendar_today_rounded, r.enrollmentDate),
                      const SizedBox(width: 8),
                      _chip(Icons.person_pin_rounded, r.ashaWorkerName),
                    ]),
                  ]),
                );
              },
            ),
    );
  }

  Widget _chip(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ]);
}

// ══════════════════════════════════════════════════════════
//  SCHEME DETAIL PAGE
// ══════════════════════════════════════════════════════════
class SchemeDetailPage extends StatelessWidget {
  final SchemeDetail scheme;
  const SchemeDetailPage({super.key, required this.scheme});

  Future<void> _launchPortal(BuildContext context) async {
    final uri = Uri.parse(scheme.portalUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Portal: ${scheme.portalUrl}'),
              backgroundColor: scheme.color,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(label: 'Copy', textColor: Colors.white,
                onPressed: () {}),
            ));
      }
    }
  }

  Future<void> _openEnrollSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnrollBeneficiarySheet(scheme: scheme),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('✅ Beneficiary enrolled & Excel updated!'),
        backgroundColor: scheme.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: const Color(0xFFF2F6F3),
        body: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.color, scheme.color.withOpacity(0.75)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 38, height: 38,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text('Scheme Details',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Text(scheme.amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: scheme.color)),
                ),
              ]),
              const SizedBox(height: 20),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                    ),
                    child: Icon(scheme.icon, color: Colors.white, size: 28)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(scheme.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(scheme.shortDesc, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85), height: 1.4)),
                ])),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                _infoBadge(Icons.account_balance_rounded, scheme.ministry),
                const SizedBox(width: 8),
                _infoBadge(Icons.calendar_today_rounded, 'Since ${scheme.launched}'),
              ]),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _launchPortal(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Icon(Icons.open_in_browser_rounded, color: scheme.color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Official Government Portal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: scheme.color)),
                      Text(scheme.portalUrl, style: TextStyle(fontSize: 9.5, color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
                    ])),
                    Icon(Icons.arrow_forward_ios_rounded, color: scheme.color, size: 12),
                  ]),
                ),
              ),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _DetailCard(icon: Icons.info_outline_rounded, title: 'Objective', color: scheme.color,
                    child: Text(scheme.objective, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2332), height: 1.6))),
                const SizedBox(height: 12),
                _DetailCard(icon: Icons.verified_user_rounded, title: 'Eligibility / पात्रता', color: scheme.color,
                    child: Column(children: scheme.eligibility.map((e) => _BulletRow(text: e, color: scheme.color)).toList())),
                const SizedBox(height: 12),
                _DetailCard(icon: Icons.card_giftcard_rounded, title: 'Benefits / लाभ', color: scheme.color,
                    child: Column(children: scheme.benefits.map((e) => _BulletRow(text: e, color: scheme.color, icon: Icons.check_circle_rounded)).toList())),
                const SizedBox(height: 12),
                _DetailCard(icon: Icons.folder_rounded, title: 'Documents Required / दस्तावेज़', color: scheme.color,
                    child: Column(children: scheme.documents.map((e) => _BulletRow(text: e, color: scheme.color, icon: Icons.description_rounded)).toList())),
                const SizedBox(height: 12),
                _DetailCard(icon: Icons.how_to_reg_rounded, title: 'How to Apply / आवेदन कैसे करें', color: scheme.color,
                    child: Column(children: List.generate(scheme.howToApply.length,
                        (i) => _NumberedRow(number: i + 1, text: scheme.howToApply[i], color: scheme.color)))),
                const SizedBox(height: 12),
                _DetailCard(icon: Icons.phone_in_talk_rounded, title: 'Contact & Helpline', color: scheme.color,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.location_on_rounded, size: 16, color: scheme.color),
                        const SizedBox(width: 8),
                        Expanded(child: Text(scheme.contactOffice, style: const TextStyle(fontSize: 12.5, color: Color(0xFF1A2332), height: 1.4))),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Icon(Icons.call_rounded, size: 16, color: scheme.color),
                        const SizedBox(width: 8),
                        Text('Helpline: ${scheme.helpline}',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: scheme.color)),
                      ]),
                    ])),
                const SizedBox(height: 20),

                Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => Share.share(
                      '📋 *${scheme.name}*\n\n'
                      '${scheme.shortDesc}\n\n'
                      '💰 Benefit: ${scheme.amount}\n'
                      '🏛️ ${scheme.ministry}\n\n'
                      '📞 Helpline: ${scheme.helpline}\n'
                      '🌐 Portal: ${scheme.portalUrl}\n\n'
                      'ASHA Worker App se share kiya gaya',
                      subject: scheme.name,
                    ),
                    icon: const Icon(Icons.share_rounded, size: 17), label: const Text('Share'),
                    style: OutlinedButton.styleFrom(foregroundColor: scheme.color, side: BorderSide(color: scheme.color),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(
                    onPressed: () => _launchPortal(context),
                    icon: const Icon(Icons.language_rounded, size: 17), label: const Text('Portal'),
                    style: OutlinedButton.styleFrom(foregroundColor: scheme.color, side: BorderSide(color: scheme.color),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  )),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: ElevatedButton.icon(
                    onPressed: () => _openEnrollSheet(context),
                    icon: const Icon(Icons.how_to_reg_rounded, size: 17), label: const Text('Enroll'),
                    style: ElevatedButton.styleFrom(backgroundColor: scheme.color, foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  )),
                ]),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) => Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: Colors.white, size: 11),
            const SizedBox(width: 5),
            Flexible(child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.white, height: 1.3), overflow: TextOverflow.ellipsis)),
          ]),
        ),
      );
}

// ══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ══════════════════════════════════════════════════════════
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;
  const _DetailCard({required this.icon, required this.title, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(color: color.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Row(children: [
            Container(width: 30, height: 30,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 16)),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(14), child: child),
      ]),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  const _BulletRow({required this.text, required this.color, this.icon = Icons.circle});

  @override
  Widget build(BuildContext context) {
    final isBullet = icon == Icons.circle;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isBullet
            ? Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 5, right: 10),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle))
            : Padding(padding: const EdgeInsets.only(top: 1, right: 8),
                child: Icon(icon, color: color, size: 14)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, color: Color(0xFF1A2332), height: 1.45))),
      ]),
    );
  }
}

class _NumberedRow extends StatelessWidget {
  final int number;
  final String text;
  final Color color;
  const _NumberedRow({required this.number, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 22, height: 22, margin: const EdgeInsets.only(right: 10, top: 1),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(child: Text('$number', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)))),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5, color: Color(0xFF1A2332), height: 1.45))),
      ]),
    );
  }
}