import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'asha_dashboard.dart';
import 'login_screen.dart';
import 'reg_screen.dart';

// ══════════════════════════════════════════════════════════
//  GLOBAL LANGUAGE NOTIFIER
// ══════════════════════════════════════════════════════════
final langNotifier = ValueNotifier<String>('en');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const AshaApp());
}

// ══════════════════════════════════════════════════════════
//  RESPONSIVE HELPER
// ══════════════════════════════════════════════════════════
class R {
  static bool isMobile(BuildContext ctx)  => MediaQuery.of(ctx).size.width < 600;
  static bool isTablet(BuildContext ctx)  => MediaQuery.of(ctx).size.width >= 600 && MediaQuery.of(ctx).size.width < 1024;
  static bool isDesktop(BuildContext ctx) => MediaQuery.of(ctx).size.width >= 1024;

  static double maxW(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w >= 1024) return 480;
    if (w >= 600)  return 520;
    return w;
  }

  static double fs(BuildContext ctx, double base) {
    if (isDesktop(ctx)) return base + 2;
    if (isTablet(ctx))  return base + 1;
    return base;
  }

  static double pad(BuildContext ctx) {
    if (isDesktop(ctx)) return 32;
    if (isTablet(ctx))  return 28;
    return 20;
  }
}

// ══════════════════════════════════════════════════════════
//  COLORS
// ══════════════════════════════════════════════════════════
const kBlue        = Color(0xFF1565C0);
const kBlueDark    = Color(0xFF0D47A1);
const kBlueLight   = Color(0xFFE8F0FB);
const kOrange      = Color(0xFFFF6B2B);
const kOrangeDark  = Color(0xFFE05520);
const kOrangeLight = Color(0xFFFFF0EA);
const kGreen       = Color(0xFF1A9E5C);
const kGreenDark   = Color(0xFF0D7A45);
const kGreenLight  = Color(0xFFE8F8F0);
const kBg          = Color(0xFFF2F6F3);
const kText        = Color(0xFF1A2332);
const kMuted       = Color(0xFF6B7A8D);
const kBorder      = Color(0xFFE2EAF0);

// ══════════════════════════════════════════════════════════
//  TRANSLATIONS — English / हिंदी / मराठी
// ══════════════════════════════════════════════════════════
class Tr {
  static const _d = {
    'appTitle':       {'en': 'ASHA Worker App',       'hi': 'आशा वर्कर ऐप',         'mr': 'आशा वर्कर ॲप'},
    'appSubtitle':    {'en': 'National Health Mission','hi': 'राष्ट्रीय स्वास्थ्य मिशन','mr': 'राष्ट्रीय आरोग्य अभियान'},
    'welcomeDesc':    {'en': 'Empowering health workers across every village of India','hi': 'भारत के हर गांव में स्वास्थ्य कार्यकर्ताओं को सशक्त बनाना','mr': 'भारतातील प्रत्येक गावात आरोग्य कार्यकर्त्यांना सक्षम करणे'},
    'footer':         {'en': 'National Health Mission • Government of India','hi': 'राष्ट्रीय स्वास्थ्य मिशन • भारत सरकार','mr': 'राष्ट्रीय आरोग्य अभियान • भारत सरकार'},
    'newUser':        {'en': 'New User? Choose your role to register','hi': 'नया यूज़र? पंजीकरण के लिए भूमिका चुनें','mr': 'नवीन यूजर? नोंदणीसाठी भूमिका निवडा'},
    'alreadyLogin':   {'en': 'Already Registered? Login','hi': 'पहले से रजिस्टर? लॉगिन करें','mr': 'आधीच नोंदणी? लॉगिन करा'},
    'register':       {'en': 'Register',    'hi': 'पंजीकरण',   'mr': 'नोंदणी'},
    'adminCard':      {'en': 'Admin',       'hi': 'एडमिन',      'mr': 'प्रशासक'},
    'superCard':      {'en': 'Supervisor',  'hi': 'सुपरवाइज़र', 'mr': 'पर्यवेक्षक'},
    'ashaCard':       {'en': 'ASHA Worker', 'hi': 'आशा वर्कर',  'mr': 'आशा वर्कर'},
    'adminReg':       {'en': 'Administrator Registration','hi': 'एडमिन पंजीकरण','mr': 'प्रशासक नोंदणी'},
    'adminRegDesc':   {'en': 'Create your administrator account','hi': 'अपना एडमिन अकाउंट बनाएं','mr': 'तुमचे प्रशासक खाते तयार करा'},
    'superReg':       {'en': 'Supervisor Registration','hi': 'सुपरवाइज़र पंजीकरण','mr': 'पर्यवेक्षक नोंदणी'},
    'superRegDesc':   {'en': 'Create your supervisor account','hi': 'अपना सुपरवाइज़र अकाउंट बनाएं','mr': 'तुमचे पर्यवेक्षक खाते तयार करा'},
    'ashaReg':        {'en': 'ASHA Worker Registration','hi': 'आशा वर्कर पंजीकरण','mr': 'आशा वर्कर नोंदणी'},
    'ashaRegDesc':    {'en': 'Create your ASHA worker account','hi': 'अपना आशा वर्कर अकाउंट बनाएं','mr': 'तुमचे आशा वर्कर खाते तयार करा'},
    'fullName':       {'en': 'Full Name',          'hi': 'पूरा नाम',               'mr': 'पूर्ण नाव'},
    'fullNameHint':   {'en': 'Enter your full name','hi': 'अपना पूरा नाम दर्ज करें','mr': 'तुमचे पूर्ण नाव टाका'},
    'adminId':        {'en': 'Admin ID',           'hi': 'एडमिन आईडी',             'mr': 'प्रशासक आयडी'},
    'adminIdHint':    {'en': 'e.g. ADM-NHM01',     'hi': 'जैसे: ADM-NHM01',        'mr': 'उदा: ADM-NHM01'},
    'superId':        {'en': 'Supervisor ID',      'hi': 'सुपरवाइज़र आईडी',        'mr': 'पर्यवेक्षक आयडी'},
    'superIdHint':    {'en': 'e.g. SUP-WAR01',     'hi': 'जैसे: SUP-WAR01',        'mr': 'उदा: SUP-WAR01'},
    'ashaId':         {'en': 'ASHA ID',            'hi': 'आशा आईडी',               'mr': 'आशा आयडी'},
    'ashaIdHint':     {'en': 'e.g. MH-ASHA-12345', 'hi': 'जैसे: MH-ASHA-12345',   'mr': 'उदा: MH-ASHA-12345'},
    'department':     {'en': 'Department',         'hi': 'विभाग',                  'mr': 'विभाग'},
    'deptHint':       {'en': 'e.g. Health Dept.',  'hi': 'जैसे: स्वास्थ्य विभाग',  'mr': 'उदा: आरोग्य विभाग'},
    'zone':           {'en': 'Zone / Block',       'hi': 'ज़ोन / ब्लॉक',           'mr': 'झोन / ब्लॉक'},
    'zoneHint':       {'en': 'e.g. Wardha Block',  'hi': 'जैसे: वर्धा ब्लॉक',     'mr': 'उदा: वर्धा ब्लॉक'},
    'village':        {'en': 'Village / Area',     'hi': 'गांव / क्षेत्र',         'mr': 'गाव / क्षेत्र'},
    'villageHint':    {'en': 'Enter village name', 'hi': 'गांव का नाम दर्ज करें',  'mr': 'गावाचे नाव टाका'},
    'district':       {'en': 'District',           'hi': 'जिला',                   'mr': 'जिल्हा'},
    'districtHint':   {'en': 'e.g. Nagpur',        'hi': 'जैसे: नागपुर',           'mr': 'उदा: नागपूर'},
    'email':          {'en': 'Email Address',      'hi': 'ईमेल पता',               'mr': 'ईमेल पत्ता'},
    'emailHint':      {'en': 'email@nhm.gov.in',   'hi': 'ईमेल@nhm.gov.in',       'mr': 'ईमेल@nhm.gov.in'},
    'mobile':         {'en': 'Mobile Number',      'hi': 'मोबाइल नंबर',            'mr': 'मोबाइल नंबर'},
    'mobileHint':     {'en': 'e.g. 9876543210',    'hi': 'जैसे: 9876543210',       'mr': 'उदा: 9876543210'},
    'password':       {'en': 'Password',           'hi': 'पासवर्ड',                'mr': 'पासवर्ड'},
    'passHint':       {'en': 'Min 6 chars + numbers','hi': 'कम से कम 6 अक्षर + अंक','mr': 'किमान 6 अक्षरे + अंक'},
    'confirmPass':    {'en': 'Confirm Password',   'hi': 'पासवर्ड पुष्टि करें',    'mr': 'पासवर्ड पुन्हा टाका'},
    'confirmHint':    {'en': 'Re-enter password',  'hi': 'पासवर्ड दोबारा दर्ज करें','mr': 'पासवर्ड पुन्हा टाका'},
    'secPersonal':    {'en': 'Personal Information','hi': 'व्यक्तिगत जानकारी',     'mr': 'वैयक्तिक माहिती'},
    'secWork':        {'en': 'Work Information',   'hi': 'कार्य जानकारी',           'mr': 'कार्य माहिती'},
    'secContact':     {'en': 'Contact & Security', 'hi': 'संपर्क और सुरक्षा',      'mr': 'संपर्क आणि सुरक्षा'},
    'btnAdmin':       {'en': 'Register as Administrator','hi': 'एडमिन के रूप में पंजीकरण करें','mr': 'प्रशासक म्हणून नोंदणी करा'},
    'btnSuper':       {'en': 'Register as Supervisor','hi': 'सुपरवाइज़र के रूप में पंजीकरण करें','mr': 'पर्यवेक्षक म्हणून नोंदणी करा'},
    'btnAsha':        {'en': 'Register as ASHA Worker','hi': 'आशा वर्कर के रूप में पंजीकरण करें','mr': 'आशा वर्कर म्हणून नोंदणी करा'},
    'haveAccount':    {'en': 'Already have an account? Login','hi': 'पहले से अकाउंट है? लॉगिन करें','mr': 'आधीच खाते आहे? लॉगिन करा'},
    'goLogin':        {'en': 'Go to Login',        'hi': 'लॉगिन पर जाएं',          'mr': 'लॉगिनवर जा'},
    'regSuccess':     {'en': 'Registration Successful!','hi': 'पंजीकरण सफल हो गया!','mr': 'नोंदणी यशस्वी झाली!'},
    'regMsg':         {'en': 'Account created! You can now login.','hi': 'अकाउंट बन गया! अब आप लॉगिन कर सकते हैं।','mr': 'खाते तयार झाले! आता तुम्ही लॉगिन करू शकता.'},
    'loginSub':       {'en': 'Sign in to your account','hi': 'अपने अकाउंट में साइन इन करें','mr': 'खात्यात साइन इन करा'},
    'adminTab':       {'en': 'Admin',      'hi': 'एडमिन',      'mr': 'प्रशासक'},
    'superTab':       {'en': 'Supervisor', 'hi': 'सुपरवाइज़र', 'mr': 'पर्यवेक्षक'},
    'ashaTab':        {'en': 'ASHA',       'hi': 'आशा',         'mr': 'आशा'},
    'loginAdmin':     {'en': 'Login as Administrator','hi': 'एडमिन के रूप में लॉगिन करें','mr': 'प्रशासक म्हणून लॉगिन करा'},
    'loginSuper':     {'en': 'Login as Supervisor','hi': 'सुपरवाइज़र के रूप में लॉगिन करें','mr': 'पर्यवेक्षक म्हणून लॉगिन करा'},
    'loginAsha':      {'en': 'Login as ASHA Worker','hi': 'आशा वर्कर के रूप में लॉगिन करें','mr': 'आशा वर्कर म्हणून लॉगिन करा'},
    'forgotPass':     {'en': 'Forgot Password?',  'hi': 'पासवर्ड भूल गए?',         'mr': 'पासवर्ड विसरलात?'},
    'noAccount':      {'en': "Don't have account? Register",'hi': 'अकाउंट नहीं है? पंजीकरण करें','mr': 'खाते नाही? नोंदणी करा'},
    'username':       {'en': 'Email / Username',  'hi': 'ईमेल / यूज़रनेम',         'mr': 'ईमेल / युजरनेम'},
    'vRequired':      {'en': 'This field is required',                   'hi': 'यह फ़ील्ड आवश्यक है',                'mr': 'हे फील्ड आवश्यक आहे'},
    'vShortName':     {'en': 'Name must be at least 3 characters',       'hi': 'नाम कम से कम 3 अक्षर का होना चाहिए', 'mr': 'नाव किमान 3 अक्षरांचे असावे'},
    'vInvalidName':   {'en': 'Only letters and spaces allowed',          'hi': 'केवल अक्षर और स्पेस',                'mr': 'फक्त अक्षरे आणि स्पेस'},
    'vEmail':         {'en': 'Enter valid email (e.g. name@nhm.gov.in)', 'hi': 'मान्य ईमेल दर्ज करें',              'mr': 'वैध ईमेल टाका'},
    'vMobile':        {'en': 'Enter valid 10-digit number (starts 6-9)', 'hi': '6-9 से शुरू 10 अंकों का नंबर',       'mr': '6-9 ने सुरू 10 अंकी नंबर'},
    'vShortPass':     {'en': 'Password must be at least 6 characters',  'hi': 'पासवर्ड कम से कम 6 अक्षर',           'mr': 'पासवर्ड किमान 6 अक्षरे'},
    'vWeakPass':      {'en': 'Must contain letters and numbers',         'hi': 'अक्षर और अंक दोनों होने चाहिए',      'mr': 'अक्षरे आणि अंक दोन्ही असावेत'},
    'vPassMismatch':  {'en': 'Passwords do not match',                   'hi': 'पासवर्ड मेल नहीं खाते',              'mr': 'पासवर्ड जुळत नाहीत'},
    'vAdminId':       {'en': 'Format: ADM-XXX (e.g. ADM-NHM01)',        'hi': 'फॉर्मेट: ADM-XXX (ADM-NHM01)',       'mr': 'फॉरमॅट: ADM-XXX (ADM-NHM01)'},
    'vSuperId':       {'en': 'Format: SUP-XXX (e.g. SUP-WAR01)',        'hi': 'फॉर्मेट: SUP-XXX (SUP-WAR01)',       'mr': 'फॉरमॅट: SUP-XXX (SUP-WAR01)'},
    'vAshaId':        {'en': 'Format: MH-ASHA-12345',                   'hi': 'फॉर्मेट: MH-ASHA-12345',             'mr': 'फॉरमॅट: MH-ASHA-12345'},
    'vPlace':         {'en': 'Only letters and spaces allowed',         'hi': 'केवल अक्षर और स्पेस',                'mr': 'फक्त अक्षरे आणि स्पेस'},
  };
  static String g(String k, String lang) => _d[k]?[lang] ?? _d[k]?['en'] ?? k;
}

// ══════════════════════════════════════════════════════════
//  VALIDATORS
// ══════════════════════════════════════════════════════════
class Validators {
  static String? name(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vShortName', lang);
    if (v.trim().length < 3) return Tr.g('vShortName', lang);
    if (!RegExp(r"^[a-zA-Z\u0900-\u097F\u0A00-\u0A7F\s.'-]+$").hasMatch(v.trim()))
      return Tr.g('vInvalidName', lang);
    return null;
  }

  static String? email(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vRequired', lang);
    if (!RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim()))
      return Tr.g('vEmail', lang);
    return null;
  }

  static String? mobile(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vRequired', lang);
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return Tr.g('vMobile', lang);
    return null;
  }

  static String? password(String? v, String lang) {
    if (v == null || v.isEmpty) return Tr.g('vShortPass', lang);
    if (v.length < 6) return Tr.g('vShortPass', lang);
    if (!RegExp(r'[a-zA-Z]').hasMatch(v)) return Tr.g('vWeakPass', lang);
    if (!RegExp(r'[0-9]').hasMatch(v)) return Tr.g('vWeakPass', lang);
    return null;
  }

  static String? confirmPassword(String? v, String original, String lang) {
    if (v != original) return Tr.g('vPassMismatch', lang);
    return null;
  }

  static String? adminId(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vRequired', lang);
    if (!RegExp(r'^ADM-\w{2,10}$', caseSensitive: false).hasMatch(v.trim()))
      return Tr.g('vAdminId', lang);
    return null;
  }

  static String? supervisorId(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vRequired', lang);
    if (!RegExp(r'^SUP-\w{2,10}$', caseSensitive: false).hasMatch(v.trim()))
      return Tr.g('vSuperId', lang);
    return null;
  }

  static String? ashaId(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vRequired', lang);
    if (!RegExp(r'^[A-Z]{2}-ASHA-\w{2,10}$', caseSensitive: false).hasMatch(v.trim()))
      return Tr.g('vAshaId', lang);
    return null;
  }

  static String? place(String? v, String lang) {
    if (v == null || v.trim().isEmpty) return Tr.g('vRequired', lang);
    if (v.trim().length < 2) return Tr.g('vRequired', lang);
    if (!RegExp(r"^[a-zA-Z\u0900-\u097F\u0A00-\u0A7F\s/,.-]+$").hasMatch(v.trim()))
      return Tr.g('vPlace', lang);
    return null;
  }
}

// ══════════════════════════════════════════════════════════
//  ROOT APP
// ══════════════════════════════════════════════════════════
class AshaApp extends StatelessWidget {
  const AshaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => MaterialApp(
        title: 'ASHA Worker App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: kBg,
          colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  RESPONSIVE SCAFFOLD
// ══════════════════════════════════════════════════════════
class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  const ResponsiveScaffold({super.key, required this.child, this.bgColor});

  @override
  Widget build(BuildContext context) {
    final isLarge = !R.isMobile(context);
    return Scaffold(
      backgroundColor: isLarge ? const Color(0xFFE8F0EA) : (bgColor ?? kBg),
      body: isLarge
          ? Center(
              child: Container(
                width: R.maxW(context),
                margin: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: bgColor ?? kBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 40,
                      offset: const Offset(0, 12))],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(24), child: child),
              ),
            )
          : child,
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ══════════════════════════════════════════════════════════

// Language Bar
class LangBar extends StatelessWidget {
  final Color activeColor;
  const LangBar({super.key, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.translate_rounded, size: 14, color: kMuted),
          const SizedBox(width: 5),
          ...[
            {'code': 'en', 'label': 'EN'},
            {'code': 'hi', 'label': 'हि'},
            {'code': 'mr', 'label': 'म'},
          ].map((o) {
            final sel = lang == o['code'];
            return GestureDetector(
              onTap: () => langNotifier.value = o['code']!,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: sel ? activeColor : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? activeColor : kBorder),
                ),
                child: Text(o['label']!,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        color: sel ? Colors.white : kMuted)),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Back Button
class BackBtn extends StatelessWidget {
  final VoidCallback onTap;
  const BackBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.08), blurRadius: 8)],
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: kText),
        ),
      );
}

// App Field (Shared TextFormField)
class AppField extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final Color color;
  final bool isPassword;
  final TextInputType keyboard;
  final int? maxLength;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const AppField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.color,
    this.isPassword = false,
    this.keyboard = TextInputType.text,
    this.maxLength,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final fs = R.fs(context, 13.0);
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      keyboardType: widget.keyboard,
      maxLength: widget.maxLength,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(fontSize: fs, color: kText),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        counterText: '',
        labelStyle: TextStyle(fontSize: fs - 1, color: kMuted),
        hintStyle: TextStyle(fontSize: fs - 1, color: kMuted.withOpacity(0.55)),
        prefixIcon: Icon(widget.icon, color: widget.color, size: 18),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18, color: kMuted),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: EdgeInsets.symmetric(
            vertical: R.isDesktop(context) ? 15 : 12, horizontal: 14),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: kBorder, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: widget.color, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colors.red, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colors.red, width: 2)),
        errorStyle: const TextStyle(fontSize: 10.5),
        errorMaxLines: 3,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  WELCOME SCREEN
// ══════════════════════════════════════════════════════════
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _go(BuildContext ctx, Widget screen) {
    Navigator.push(
        ctx,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => screen,
          transitionsBuilder: (_, a, __, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 280),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        String t(String k) => Tr.g(k, lang);
        final pad = R.pad(context);
        final logoSize = R.isDesktop(context) ? 90.0 : R.isTablet(context) ? 82.0 : 76.0;

        return ResponsiveScaffold(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 22),
              child: Column(children: [
                LangBar(activeColor: kGreen),
                SizedBox(height: R.isDesktop(context) ? 36 : 24),

                // Logo
                Container(
                  width: logoSize, height: logoSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                        colors: [kGreen, kGreenDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [BoxShadow(
                        color: kGreen.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8))],
                  ),
                  child: Icon(Icons.local_hospital_rounded,
                      color: Colors.white,
                      size: R.isDesktop(context) ? 42 : 36),
                ),
                const SizedBox(height: 16),

                // Title
                Text(t('appTitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: R.fs(context, 24),
                        fontWeight: FontWeight.w800,
                        color: kText)),
                const SizedBox(height: 4),
                Text(t('appSubtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: R.fs(context, 12),
                        color: kMuted,
                        letterSpacing: .4)),
                const SizedBox(height: 12),
                Text(t('welcomeDesc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: R.fs(context, 13),
                        color: Colors.grey.shade600,
                        height: 1.55)),
                SizedBox(height: R.isDesktop(context) ? 32 : 24),

                // Role selection label
                Text(t('newUser'),
                    style: TextStyle(
                        fontSize: R.fs(context, 11.5),
                        fontWeight: FontWeight.w700,
                        color: kMuted,
                        letterSpacing: .4)),
                const SizedBox(height: 14),

                // Role Cards → goes to reg_screen.dart
                Row(children: [
                  _RoleCard(
                    icon: Icons.admin_panel_settings_rounded,
                    label: t('adminCard'),
                    subLabel: t('register'),
                    color: kBlue, bgColor: kBlueLight,
                    onTap: () => _go(context, const RegScreen(role: 'admin')),
                  ),
                  const SizedBox(width: 10),
                  _RoleCard(
                    icon: Icons.supervisor_account_rounded,
                    label: t('superCard'),
                    subLabel: t('register'),
                    color: kOrange, bgColor: kOrangeLight,
                    onTap: () => _go(context, const RegScreen(role: 'supervisor')),
                  ),
                  const SizedBox(width: 10),
                  _RoleCard(
                    icon: Icons.health_and_safety_rounded,
                    label: t('ashaCard'),
                    subLabel: t('register'),
                    color: kGreen, bgColor: kGreenLight,
                    onTap: () => _go(context, const RegScreen(role: 'asha')),
                  ),
                ]),
                SizedBox(height: R.isDesktop(context) ? 28 : 18),

                // Divider
                Row(children: [
                  const Expanded(child: Divider(color: kBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR',
                        style: TextStyle(
                            fontSize: R.fs(context, 11),
                            color: kMuted.withOpacity(.6),
                            fontWeight: FontWeight.w600)),
                  ),
                  const Expanded(child: Divider(color: kBorder)),
                ]),
                const SizedBox(height: 16),

                // Login Button → goes to login_screen.dart
                SizedBox(
                  width: double.infinity,
                  height: R.isDesktop(context) ? 54 : 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _go(context, const LoginScreen(initialTab: 0)),
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(t('alreadyLogin')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: TextStyle(
                          fontSize: R.fs(context, 14),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: R.isDesktop(context) ? 28 : 20),

                // Footer
                Text(t('footer'),
                    style: const TextStyle(fontSize: 10, color: Color(0xFFADB5BD)),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
              ]),
            ),
          ),
        );
      },
    );
  }
}

// ── Role Card ──
class _RoleCard extends StatefulWidget {
  final IconData icon;
  final String label, subLabel;
  final Color color, bgColor;
  final VoidCallback onTap;
  const _RoleCard({
    required this.icon, required this.label, required this.subLabel,
    required this.color, required this.bgColor, required this.onTap,
  });
  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final iconSize  = R.isDesktop(context) ? 50.0 : 44.0;
    final iconInner = R.isDesktop(context) ? 25.0 : 22.0;
    return Expanded(
      child: GestureDetector(
        onTapDown:  (_) => setState(() => _pressed = true),
        onTapUp:    (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_pressed ? 0.94 : 1.0),
          transformAlignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              vertical: R.isDesktop(context) ? 18 : 14, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: _pressed ? widget.color : Colors.transparent, width: 2),
            boxShadow: [BoxShadow(
              color: _pressed
                  ? widget.color.withOpacity(0.18)
                  : Colors.black.withOpacity(0.06),
              blurRadius: _pressed ? 18 : 8,
              offset: const Offset(0, 3),
            )],
          ),
          child: Column(children: [
            Container(
              width: iconSize, height: iconSize,
              decoration: BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
              child: Icon(widget.icon, color: widget.color, size: iconInner),
            ),
            const SizedBox(height: 8),
            Text(widget.label,
                style: TextStyle(
                    fontSize: R.fs(context, 11),
                    fontWeight: FontWeight.w700,
                    color: widget.color),
                textAlign: TextAlign.center),
            Text(widget.subLabel,
                style: TextStyle(fontSize: R.fs(context, 9.5), color: kMuted)),
          ]),
        ),
      ),
    );
  }
}
