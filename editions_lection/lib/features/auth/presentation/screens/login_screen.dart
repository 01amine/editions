import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/images.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // email regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Validation function
  bool _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;

    // Email validation
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = "L'email est requis";
      });
      isValid = false;
    } else if (!_isValidEmail(_emailController.text.trim())) {
      setState(() {
        _emailError = "Veuillez entrer un email valide";
      });
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = "Le mot de passe est requis";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleLogin() {
    if (_validateForm()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Stack(
          children: [
            // Background image with overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.auth_background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: AppTheme.overlayColor.withOpacity(0.3),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.08),
                child: Column(
                  children: [
                    SizedBox(height: context.height * 0.1),
                    // Logo container with background for visibility
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppImages.logo,
                        width: context.width * 0.2,
                        height: context.width * 0.2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title with better styling
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "CONNECTER VOUS",
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: context.height * 0.05),
                    // Form container with background
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Votre email",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.primaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.height * 0.01),
                            MyTextField(
                              hintText: "Entrer votre email...",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              errorText: _emailError,
                            ),
                            SizedBox(height: context.height * 0.03),
                            Text(
                              "Mot de passe",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.primaryTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.height * 0.01),
                            MyTextField(
                              hintText: "Entrer votre mot de passe...",
                              controller: _passwordController,
                              obscureText: true,
                              errorText: _passwordError,
                            ),
                            SizedBox(height: context.height * 0.04),
                            // Login button
                            BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                Navigator.of(context).pushReplacementNamed('/home');
                                // if (state is AuthSuccess) {
                                //   Navigator.of(context).pushReplacementNamed('/home');
                                // } else if (state is AuthError) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text(state.message)),
                                //   );
                                // }
                              },
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: state is AuthLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.buttonColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: state is AuthLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            "CONTINUER",
                                            style: theme.textTheme.labelLarge?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: context.height * 0.04),
                            // Divider with "OU"
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppTheme.borderColor,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.width * 0.03),
                                  child: Text(
                                    "OU",
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: AppTheme.secondaryTextColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppTheme.borderColor,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.height * 0.04),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sign up link with background
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vous n'avez pas de compte ? ",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              "Créer un ici",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.height * 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}