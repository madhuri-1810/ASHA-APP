import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'login_screen.dart';

// ══════════════════════════════════════════════════════════
//  REGISTRATION SCREEN
// ══════════════════════════════════════════════════════════
class RegScreen extends StatefulWidget {
  final String role; // 'admin' | 'supervisor' | 'asha'
  const RegScreen({super.key, required this.role});
  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final _fk    = GlobalKey<FormState>();
  bool _loading = false;

  final _name  = TextEditingController();
  final _id    = TextEditingController();
  final _extra = TextEditingController();
  final _dist  = TextEditingController();
  final _email = TextEditingController();
  final _mob   = TextEditingController();
  final _pass  = TextEditingController();
  final _conf  = TextEditingController();

  String get _lang => langNotifier.value;
  String t(String k) => Tr.g(k, _lang);

  // ── Role-based colors ──
  Color get color  => widget.role == 'admin' ? kBlue  : widget.role == 'supervisor' ? kOrange  : kGreen;
  Color get colorD => widget.role == 'admin' ? kBlueDark : widget.role == 'supervisor' ? kOrangeDark : kGreenDark;
  Color get colorL => widget.role == 'admin' ? kBlueLight : widget.role == 'supervisor' ? kOrangeLight : kGreenLight;

  IconData get icon => widget.role == 'admin'
      ? Icons.admin_panel_settings_rounded
      : widget.role == 'supervisor'
          ? Icons.supervisor_account_rounded
          : Icons.health_and_safety_rounded;

  int get loginTab => widget.role == 'admin' ? 0 : widget.role == 'supervisor' ? 1 : 2;

  @override
  void dispose() {
    for (final c in [_name, _id, _extra, _dist, _email, _mob, _pass, _conf])
      c.dispose();
    super.dispose();
  }

  // ── Submit ──
  Future<void> _submit() async {
    if (!_fk.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    _showSuccess();
  }

  // ── Success Dialog ──
  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ValueListenableBuilder<String>(
        valueListenable: langNotifier,
        builder: (_, lang, __) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Success icon
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: colorL, shape: BoxShape.circle),
                child: Icon(Icons.check_circle_rounded, color: color, size: 38),
              ),
              const SizedBox(height: 6),
              const Text('🎉', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(t('regSuccess'),
                  style: TextStyle(
                      fontSize: R.fs(context, 17),
                      fontWeight: FontWeight.w800,
                      color: kText),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(t('regMsg'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: R.fs(context, 12.5),
                      color: kMuted,
                      height: 1.55)),
              const SizedBox(height: 22),
              // Go to Login button
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (_) => LoginScreen(initialTab: loginTab)));
                  },
                  icon: const Icon(Icons.login_rounded, size: 17),
                  label: Text(t('goLogin')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    textStyle: TextStyle(
                        fontSize: R.fs(context, 14),
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        final pad    = R.pad(context);
        final isDesk = R.isDesktop(context);

        final title  = widget.role == 'admin' ? t('adminReg')     : widget.role == 'supervisor' ? t('superReg')  : t('ashaReg');
        final desc   = widget.role == 'admin' ? t('adminRegDesc') : widget.role == 'supervisor' ? t('superRegDesc') : t('ashaRegDesc');
        final btnTxt = widget.role == 'admin' ? t('btnAdmin')     : widget.role == 'supervisor' ? t('btnSuper')  : t('btnAsha');

        return ResponsiveScaffold(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 18),
              child: Column(children: [

                // ── Top Bar ──
                Row(children: [
                  BackBtn(onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  LangBar(activeColor: color),
                ]),
                const SizedBox(height: 16),

                // ── Header Banner ──
                Container(
                  padding: EdgeInsets.all(isDesk ? 20 : 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [color, colorD],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(
                        color: color.withOpacity(0.28),
                        blurRadius: 16,
                        offset: const Offset(0, 6))],
                  ),
                  child: Row(children: [
                    Container(
                      width: isDesk ? 54 : 48,
                      height: isDesk ? 54 : 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.35), width: 1.5),
                      ),
                      child: Icon(icon, color: Colors.white, size: isDesk ? 28 : 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: TextStyle(
                                  fontSize: R.fs(context, 16),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          const SizedBox(height: 2),
                          Text(desc,
                              style: TextStyle(
                                  fontSize: R.fs(context, 11),
                                  color: Colors.white.withOpacity(.85))),
                        ])),
                  ]),
                ),
                const SizedBox(height: 16),

                // ── Form Card ──
                Container(
                  padding: EdgeInsets.all(isDesk ? 24 : 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4))],
                  ),
                  child: Form(
                    key: _fk,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        // ── Section 1: Personal Info ──
                        _secLabel(t('secPersonal'), color),
                        AppField(
                          controller: _name,
                          label: t('fullName'),
                          hint: t('fullNameHint'),
                          icon: Icons.person_outline,
                          color: color,
                          validator: (v) => Validators.name(v, lang),
                        ),
                        const SizedBox(height: 14),

                        // ── Section 2: Work Info ──
                        _secLabel(t('secWork'), color),
                        isDesk
                            ? Row(children: [
                                Expanded(child: _idField(lang)),
                                const SizedBox(width: 12),
                                Expanded(child: _extraField(lang)),
                              ])
                            : Column(children: [
                                _idField(lang),
                                const SizedBox(height: 12),
                                _extraField(lang),
                              ]),

                        // District (ASHA only)
                        if (widget.role == 'asha') ...[
                          const SizedBox(height: 12),
                          AppField(
                            controller: _dist,
                            label: t('district'),
                            hint: t('districtHint'),
                            icon: Icons.account_balance_outlined,
                            color: color,
                            validator: (v) => Validators.place(v, lang),
                          ),
                        ],
                        const SizedBox(height: 14),

                        // ── Section 3: Contact & Security ──
                        _secLabel(t('secContact'), color),

                        // Email (Admin & Supervisor only)
                        if (widget.role != 'asha') ...[
                          AppField(
                            controller: _email,
                            label: t('email'),
                            hint: t('emailHint'),
                            icon: Icons.email_outlined,
                            color: color,
                            keyboard: TextInputType.emailAddress,
                            validator: (v) => Validators.email(v, lang),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Mobile
                        AppField(
                          controller: _mob,
                          label: t('mobile'),
                          hint: t('mobileHint'),
                          icon: Icons.phone_outlined,
                          color: color,
                          keyboard: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) => Validators.mobile(v, lang),
                        ),
                        const SizedBox(height: 12),

                        // Password + Confirm Password
                        isDesk
                            ? Row(children: [
                                Expanded(child: _passField(lang)),
                                const SizedBox(width: 12),
                                Expanded(child: _confirmField(lang)),
                              ])
                            : Column(children: [
                                _passField(lang),
                                const SizedBox(height: 12),
                                _confirmField(lang),
                              ]),

                        const SizedBox(height: 22),

                        // ── Register Button ──
                        SizedBox(
                          width: double.infinity,
                          height: isDesk ? 54 : 50,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              disabledBackgroundColor: color.withOpacity(0.55),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              textStyle: TextStyle(
                                  fontSize: R.fs(context, 14),
                                  fontWeight: FontWeight.w700),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.5, color: Colors.white))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.how_to_reg_rounded, size: 18),
                                      const SizedBox(width: 8),
                                      Text(btnTxt),
                                    ]),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Already have account link
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        LoginScreen(initialTab: loginTab))),
                            style: TextButton.styleFrom(foregroundColor: color),
                            child: Text(t('haveAccount'),
                                style: TextStyle(
                                    fontSize: R.fs(context, 12.5),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        );
      },
    );
  }

  // ── ID Field (Admin ID / Supervisor ID / ASHA ID) ──
  Widget _idField(String lang) => AppField(
        controller: _id,
        label: widget.role == 'admin'
            ? Tr.g('adminId', lang)
            : widget.role == 'supervisor'
                ? Tr.g('superId', lang)
                : Tr.g('ashaId', lang),
        hint: widget.role == 'admin'
            ? Tr.g('adminIdHint', lang)
            : widget.role == 'supervisor'
                ? Tr.g('superIdHint', lang)
                : Tr.g('ashaIdHint', lang),
        icon: Icons.badge_outlined,
        color: color,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
          TextInputFormatter.withFunction(
              (old, newVal) => newVal.text.length <= 20 ? newVal : old),
        ],
        validator: (v) {
          if (widget.role == 'admin') return Validators.adminId(v, lang);
          if (widget.role == 'supervisor') return Validators.supervisorId(v, lang);
          return Validators.ashaId(v, lang);
        },
      );

  // ── Extra Field (Department / Zone / Village) ──
  Widget _extraField(String lang) => AppField(
        controller: _extra,
        label: widget.role == 'admin'
            ? Tr.g('department', lang)
            : widget.role == 'supervisor'
                ? Tr.g('zone', lang)
                : Tr.g('village', lang),
        hint: widget.role == 'admin'
            ? Tr.g('deptHint', lang)
            : widget.role == 'supervisor'
                ? Tr.g('zoneHint', lang)
                : Tr.g('villageHint', lang),
        icon: widget.role == 'admin'
            ? Icons.business_outlined
            : widget.role == 'supervisor'
                ? Icons.map_outlined
                : Icons.location_on_outlined,
        color: color,
        validator: (v) => Validators.place(v, lang),
      );

  // ── Password Field ──
  Widget _passField(String lang) => AppField(
        controller: _pass,
        label: Tr.g('password', lang),
        hint: Tr.g('passHint', lang),
        icon: Icons.lock_outline,
        color: color,
        isPassword: true,
        validator: (v) => Validators.password(v, lang),
      );

  // ── Confirm Password Field ──
  Widget _confirmField(String lang) => AppField(
        controller: _conf,
        label: Tr.g('confirmPass', lang),
        hint: Tr.g('confirmHint', lang),
        icon: Icons.lock_outline,
        color: color,
        isPassword: true,
        validator: (v) => Validators.confirmPassword(v ?? '', _pass.text, lang),
      );
}

// ══════════════════════════════════════════════════════════
//  SECTION LABEL HELPER
// ══════════════════════════════════════════════════════════
Widget _secLabel(String text, Color color) => Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Row(children: [
        Container(
            width: 4, height: 16,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.3)),
      ]),
    );
