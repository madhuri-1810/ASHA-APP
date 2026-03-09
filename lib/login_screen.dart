import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'asha_dashboard.dart';
import 'reg_screen.dart';

// ══════════════════════════════════════════════════════════
//  LOGIN SCREEN
// ══════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  final int initialTab;
  const LoginScreen({super.key, this.initialTab = 0});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  final _colors = [kBlue, kOrange, kGreen];
  final _gradients = [
    [kBlue, kBlueDark],
    [kOrange, kOrangeDark],
    [kGreen, kGreenDark],
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTab);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Color get _active => _colors[_tab.index];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        String t(String k) => Tr.g(k, lang);
        final pad = R.pad(context);
        final isDesk = R.isDesktop(context);
        final logoSz = isDesk ? 76.0 : 68.0;

        return ResponsiveScaffold(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 18),
              child: Column(children: [
                // Top bar
                Row(children: [
                  BackBtn(onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  LangBar(activeColor: _active),
                ]),
                SizedBox(height: isDesk ? 28 : 20),

                // Animated Logo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: logoSz, height: logoSz,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: _gradients[_tab.index],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                          color: _active.withOpacity(0.3),
                          blurRadius: 22,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: Icon(Icons.local_hospital_rounded,
                      color: Colors.white, size: isDesk ? 36 : 32),
                ),
                const SizedBox(height: 12),

                // Title
                Text(t('appTitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: R.fs(context, 21),
                        fontWeight: FontWeight.w800,
                        color: kText)),
                const SizedBox(height: 3),
                Text(t('loginSub'),
                    style: TextStyle(
                        fontSize: R.fs(context, 12), color: kMuted)),
                SizedBox(height: isDesk ? 24 : 18),

                // Tab Card
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                          color: _active.withOpacity(0.13),
                          blurRadius: 28,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Column(children: [
                      // Tab Bar
                      Container(
                        color: const Color(0xFFF8FAFC),
                        child: TabBar(
                          controller: _tab,
                          labelColor: _active,
                          unselectedLabelColor: kMuted,
                          indicatorColor: _active,
                          indicatorWeight: 3,
                          labelStyle: TextStyle(
                              fontSize: R.fs(context, 10.5),
                              fontWeight: FontWeight.w700),
                          unselectedLabelStyle:
                              TextStyle(fontSize: R.fs(context, 10)),
                          tabs: [
                            Tab(
                                icon: const Icon(
                                    Icons.admin_panel_settings_outlined,
                                    size: 20),
                                text: t('adminTab')),
                            Tab(
                                icon: const Icon(
                                    Icons.supervisor_account_outlined,
                                    size: 20),
                                text: t('superTab')),
                            Tab(
                                icon: const Icon(
                                    Icons.health_and_safety_outlined,
                                    size: 20),
                                text: t('ashaTab')),
                          ],
                        ),
                      ),

                      // Tab Views
                      SizedBox(
                        height: isDesk ? 360 : 320,
                        child: TabBarView(
                          controller: _tab,
                          children: [
                            // Admin Login
                            _LoginForm(
                              color: kBlue,
                              idLabel: t('username'),
                              idHint: 'admin@nhm.gov.in',
                              idIcon: Icons.person_outline,
                              idType: _IdType.email,
                              showMobile: false,
                              btnText: t('loginAdmin'),
                            ),
                            // Supervisor Login
                            _LoginForm(
                              color: kOrange,
                              idLabel: t('superId'),
                              idHint: Tr.g('superIdHint', lang),
                              idIcon: Icons.manage_accounts_outlined,
                              idType: _IdType.supervisorId,
                              showMobile: true,
                              btnText: t('loginSuper'),
                            ),
                            // ASHA Login
                            _LoginForm(
                              color: kGreen,
                              idLabel: t('ashaId'),
                              idHint: Tr.g('ashaIdHint', lang),
                              idIcon: Icons.badge_outlined,
                              idType: _IdType.ashaId,
                              showMobile: true,
                              btnText: t('loginAsha'),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

                const SizedBox(height: 14),

                // Register link
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (_) => const WelcomeScreen())),
                  child: Text(t('noAccount'),
                      style: TextStyle(
                          color: _active,
                          fontSize: R.fs(context, 13),
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 6),
                Text(t('footer'),
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFFADB5BD)),
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

// ══════════════════════════════════════════════════════════
//  ID TYPE ENUM
// ══════════════════════════════════════════════════════════
enum _IdType { email, supervisorId, ashaId }

// ══════════════════════════════════════════════════════════
//  LOGIN FORM WIDGET
// ══════════════════════════════════════════════════════════
class _LoginForm extends StatefulWidget {
  final String idLabel, idHint, btnText;
  final IconData idIcon;
  final _IdType idType;
  final bool showMobile;
  final Color color;

  const _LoginForm({
    required this.color,
    required this.idLabel,
    required this.idHint,
    required this.idIcon,
    required this.idType,
    required this.showMobile,
    required this.btnText,
  });

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _fk  = GlobalKey<FormState>();
  final _id  = TextEditingController();
  final _mob = TextEditingController();
  final _pw  = TextEditingController();
  bool _loading = false;

  String get _lang => langNotifier.value;

  @override
  void dispose() {
    _id.dispose();
    _mob.dispose();
    _pw.dispose();
    super.dispose();
  }

  // ID Validator based on type
  String? _validateId(String? v) {
    switch (widget.idType) {
      case _IdType.email:
        return Validators.email(v, _lang);
      case _IdType.supervisorId:
        return Validators.supervisorId(v, _lang);
      case _IdType.ashaId:
        return Validators.ashaId(v, _lang);
    }
  }

  Future<void> _login() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AshaHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        final pad = R.isDesktop(context) ? 20.0 : 16.0;
        return Padding(
          padding: EdgeInsets.fromLTRB(pad, pad, pad, 12),
          child: Form(
            key: _fk,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ID / Email field
                AppField(
                  controller: _id,
                  label: widget.idLabel,
                  hint: widget.idHint,
                  icon: widget.idIcon,
                  color: widget.color,
                  keyboard: widget.idType == _IdType.email
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  inputFormatters: widget.idType != _IdType.email
                      ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]'))]
                      : null,
                  validator: _validateId,
                ),
                const SizedBox(height: 11),

                // Mobile (Supervisor + ASHA only)
                if (widget.showMobile) ...[
                  AppField(
                    controller: _mob,
                    label: Tr.g('mobile', lang),
                    hint: Tr.g('mobileHint', lang),
                    icon: Icons.phone_outlined,
                    color: widget.color,
                    keyboard: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => Validators.mobile(v, lang),
                  ),
                  const SizedBox(height: 11),
                ],

                // Password
                AppField(
                  controller: _pw,
                  label: Tr.g('password', lang),
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  color: widget.color,
                  isPassword: true,
                  validator: (v) => Validators.password(v, lang),
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        foregroundColor: widget.color,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(Tr.g('forgotPass', lang),
                        style: TextStyle(fontSize: R.fs(context, 11.5))),
                  ),
                ),

                const Spacer(),

                // Login Button
                SizedBox(
                  height: R.isDesktop(context) ? 52 : 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      disabledBackgroundColor: widget.color.withOpacity(0.55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      textStyle: TextStyle(
                          fontSize: R.fs(context, 14),
                          fontWeight: FontWeight.w700),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.login_rounded, size: 17),
                              const SizedBox(width: 7),
                              Text(widget.btnText),
                            ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
