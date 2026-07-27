import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum UserRole {
  customer,
  booth,
  organizer,
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserRole _selectedRole = UserRole.customer;


  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
  }

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
                          darkColor: AppColor.black,
                          bodyColor: AppColor.black,
                        ),

                      const SizedBox(height: 20,),

                      _RoleSelector(selectedRole: _selectedRole, onChanged: (role) {
                        setState(() {
                          _selectedRole = role;
                        });
                      }),

                      const SizedBox(height: 20,),

                      _RegisterForms(
                        primaryColor: AppColor.primary,
                        bodyColor: AppColor.black,
                        darkColor: AppColor.black,
                        borderColor: AppColor.border,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        isConfirmPasswordVisible: _isConfirmPasswordVisible,
                        onToggleConfirmPasswordVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),

                      const SizedBox(height: 25,),

                      _RegisterButton(btnColor: AppColor.black, onPressed: _register,),

                      const SizedBox(height: 15,),
                      _SocialLogin(bodyColor: AppColor.black, darkColor: AppColor.black, borderColor: AppColor.border),
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
            child: _blob(230, color.withOpacity(0.08))
        ),

        Positioned(
          bottom: -80,
          right: -60,
          child: _blob(280, color.withOpacity(0.12)),
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
        Text("Register", style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: AppColor.black,
          letterSpacing: -0.5,
        ),
        ),

        SizedBox(height: 5,),
        Text("Create an account to continue                              ", style: AppTextStyle.body
        ),
      ],
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  const _RoleSelector({required this.selectedRole, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildItem("Customer", UserRole.customer),
          _buildItem("Booth", UserRole.booth),
          _buildItem("Organizer", UserRole.organizer),
        ],
      )
    );
  }

  Widget _buildItem(String label, UserRole role) {
    final bool selected = selectedRole == role;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ] : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForms extends StatelessWidget {
  final Color primaryColor, darkColor, bodyColor, borderColor;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final bool isConfirmPasswordVisible;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _RegisterForms({
    super.key,
    required this.primaryColor,
    required this.darkColor,
    required this.bodyColor,
    required this.borderColor,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    required this.isConfirmPasswordVisible,
    required this.onToggleConfirmPasswordVisibility,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Email Address"),
        _inputField(Icons.mail_outline_rounded, "Enter your email", controller: emailController),

        const SizedBox(height: 24,),

        _label("Password"),
        _inputField(Icons.lock_open_rounded, "Enter your password", controller: passwordController ,isPassword: true, isVisible: isPasswordVisible, suffix: IconButton(
            onPressed: onTogglePasswordVisibility,
            icon: Icon(isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, size: 20, color: bodyColor.withOpacity(0.6),))),

        const SizedBox(height: 24,),

        _label("Confirm Password"),
        _inputField(Icons.lock_open_rounded, "Confirm your password", controller: confirmPasswordController ,isPassword: true, isVisible: isConfirmPasswordVisible, suffix: IconButton(
            onPressed: onToggleConfirmPasswordVisibility,
            icon: Icon(isConfirmPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, size: 20, color: bodyColor.withOpacity(0.6),))),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsetsGeometry.only(bottom: 10, left: 4),
    child: Text(text, style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: bodyColor.withOpacity(0.8),
      letterSpacing: 1.2,
    ),
    ),
  );

  Widget _inputField(IconData icon, String hint, {required TextEditingController controller, bool isPassword = false, bool isVisible = false ,Widget? suffix}) {
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
        controller: controller,
        obscureText: isPassword && !isVisible,
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

class _RegisterButton extends StatelessWidget {
  final Color btnColor;
  final VoidCallback onPressed;
  const _RegisterButton({
    super.key,
    required this.btnColor,
    required this.onPressed,
  });

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
          onPressed: onPressed,
          child: const Text
            ("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          )
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