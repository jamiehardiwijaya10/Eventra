import 'package:eventra/core/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/constant/app_strings.dart';
import '../../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _IsLoading = false;
  bool _IsPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          _BGDecoration(color: AppColor.primary),
          SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            _LoginHeader(
                              bodyColor: AppColor.black,
                              darkColor: AppColor.black,
                            ),

                            const SizedBox(height: 48,),
                            _LoginForms(
                              primaryColor: AppColor.primary,
                              darkColor: AppColor.black,
                              bodyColor: AppColor.black,
                              borderColor: AppColor.border,
                              isPasswordVisible: _IsPasswordVisible,
                              onTogglePasswordVisibility: () {
                                setState(() {
                                  _IsPasswordVisible = !_IsPasswordVisible;
                                });
                              }
                            ),

                            const SizedBox(height: 30,),
                            _LoginButton(btnColor: AppColor.black),

                            const SizedBox(height: 15,),
                            _SocialLogin(bodyColor: AppColor.black, darkColor: AppColor.black, borderColor: AppColor.border),
                            _FooterSection(primaryColor: AppColor.primary, bodyColor: AppColor.black)
                            
                          ],
                        ),
                      ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}

// The Circle Shi
class _BGDecoration extends StatelessWidget {
  final Color color;
  const _BGDecoration({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: _blob(280, color.withOpacity(0.08))
        ),

        Positioned(
          bottom: -80,
          right: -60,
          child: _blob(230, color.withOpacity(0.12)),
        ),
      ],
    );
  }
  Widget _blob(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _LoginHeader extends StatelessWidget {
  final Color darkColor, bodyColor;
  const _LoginHeader({required this.darkColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70,),
        Text("Welcome Back", style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColor.black,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 5,),
        Text("Enter your credentials to access your account", style: AppTextStyle.body
        ),
      ],
    );
  }
}

class _LoginForms extends StatelessWidget {
  final Color primaryColor, darkColor, bodyColor, borderColor;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;

  const _LoginForms({
    super.key,
    required this.primaryColor,
    required this.darkColor,
    required this.bodyColor,
    required this.borderColor,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Email Address"),
        _inputField(Icons.mail_outline_rounded, "Enter your email"),
        const SizedBox(height: 24,),
        _label("Password"),
        _inputField(Icons.lock_open_rounded, "Enter your password", isPassword: true, suffix: IconButton(onPressed: onTogglePasswordVisibility, icon: Icon(isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, size: 20, color: bodyColor,)) )
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsetsGeometry.only(bottom: 10, left: 4),
    child: Text(text, style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: bodyColor.withOpacity(0.8),
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _inputField(IconData icon, String hint, {bool isPassword = false, Widget? suffix}) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(color: darkColor.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ]

      ),

      child: TextField(
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(
          color: darkColor,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: bodyColor.withOpacity(0.4), fontSize: 15),
          prefixIcon: Icon(icon, color: primaryColor, size: 22,),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18)
        ),
      ),
    );
  }
}

class _forgotPassword extends StatelessWidget {
  final Color primaryColor;
  const _forgotPassword({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Row(

    );
  }
}


// Login Button
class _LoginButton extends StatelessWidget {
  final Color btnColor;
  const _LoginButton({required this.btnColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16)
          ),
          elevation: 0
        ),
        onPressed: () {},
        child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
      ),
    );
  }
}

class _SocialLogin extends StatelessWidget {
  final Color bodyColor, darkColor, borderColor;
  const _SocialLogin({required this.bodyColor, required this.darkColor, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text("Or continue with", style: TextStyle(color: bodyColor.withOpacity(0.7), fontSize: 15, fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16,),
        Row(
          children: [
            _tile("Google", null, icon: FaIcon(FontAwesomeIcons.google, size: 18,)),
            const SizedBox(width: 16,),
            _tile("Apple", null, icon: Icon(Icons.apple))
          ],
        ),
      ],
    );
  }

  Widget _tile(String label, String? imgUrl, {Widget? icon}) {
    return Expanded(
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imgUrl != null)
              Image.network(imgUrl, height: 18)
            else if (icon != null)
              icon!,

            const SizedBox(width: 12,),
            Text(label, style: TextStyle(
              fontWeight: FontWeight.w700,
              color: darkColor,
              fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final Color primaryColor, bodyColor;
  const _FooterSection({required this.primaryColor, required this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: bodyColor),),
        TextButton(onPressed: () {}, child: Text
          ("Create an Account", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800),))
      ],
    );
  }
}

