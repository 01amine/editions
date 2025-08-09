import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/core/extensions/extensions.dart';

import '../../../../core/constants/images.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _studyYearController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error messages
  String? _fullNameError;
  String? _phoneNumberError;
  String? _emailError;
  String? _passwordError;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthdayController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _studyYearController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  // Email validation function
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Phone number validation function
  bool _isValidPhoneNumber(String phone) {
    // Allow various phone number formats
    return RegExp(r'^[\+]?[0-9]{8,15}$')
        .hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  // Password validation function
  bool _isValidPassword(String password) {
    // At least 6 characters
    return password.length >= 6;
  }

  // Validation function
  bool _validateForm() {
    setState(() {
      _fullNameError = null;

      _phoneNumberError = null;
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;

    // Full name validation
    if (_fullNameController.text.trim().isEmpty) {
      setState(() {
        _fullNameError = "Le nom complet est requis";
      });
      isValid = false;
    } else if (_fullNameController.text.trim().length < 2) {
      setState(() {
        _fullNameError = "Le nom doit contenir au moins 2 caractères";
      });
      isValid = false;
    }

    // Phone number validation
    if (_phoneNumberController.text.trim().isEmpty) {
      setState(() {
        _phoneNumberError = "Le numéro de téléphone est requis";
      });
      isValid = false;
    } else if (!_isValidPhoneNumber(_phoneNumberController.text.trim())) {
      setState(() {
        _phoneNumberError = "Veuillez entrer un numéro de téléphone valide";
      });
      isValid = false;
    }

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
    } else if (!_isValidPassword(_passwordController.text.trim())) {
      setState(() {
        _passwordError = "Le mot de passe doit contenir au moins 6 caractères";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleSignup() {
    if (_validateForm()) {
      context.read<AuthBloc>().add(
            SignupRequested(
              fullName: _fullNameController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              studyYear: _studyYearController.text.trim(),
              specialite: _specialiteController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = context.width > 600;
    final isLarge = context.width > 900;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: context.height - MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLarge
                      ? context.width * 0.25
                      : isTablet
                          ? context.width * 0.15
                          : context.width * 0.06,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        SizedBox(height: context.height * 0.01),

                        // Logo section
                        _buildLogoSection(context, isTablet),

                        SizedBox(height: context.height * 0.002),

                        // Welcome text
                        _buildWelcomeSection(context, theme, isTablet),

                        SizedBox(height: context.height * 0.04),

                        // Form container
                        _buildFormContainer(context, theme, isTablet),

                        SizedBox(height: context.height * 0.03),

                        // Login section
                        _buildLoginSection(context, theme),

                        SizedBox(height: context.height * 0.08),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, bool isTablet) {
    return Image.asset(
      AppImages.logo,
      width: isTablet ? context.width * 0.15 : context.width * 0.2,
      height: isTablet ? context.width * 0.15 : context.width * 0.2,
      fit: BoxFit.contain,
    );
  }

  Widget _buildWelcomeSection(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Column(
      children: [
        Text(
          "CRÉER UN COMPTE",
          style: theme.textTheme.displaySmall?.copyWith(
            color: AppTheme.primaryTextColor.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 28 : 24,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: context.height * 0.02),
        Text(
          "Rejoignez notre communauté de lecteurs",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.primaryTextColor.withOpacity(0.8),
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormContainer(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: -5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full name field
            _buildFieldSection(
              context,
              theme,
              "Nom complet",
              "Entrez votre nom complet...",
              _fullNameController,
              _fullNameError,
              TextInputType.name,
              false,
              Icons.person_outline,
              isTablet,
            ),

            SizedBox(height: context.height * 0.025),

            // Phone number field
            _buildFieldSection(
              context,
              theme,
              "Numéro de téléphone",
              "Entrez votre numéro de téléphone...",
              _phoneNumberController,
              _phoneNumberError,
              TextInputType.phone,
              false,
              Icons.phone_outlined,
              isTablet,
            ),

            SizedBox(height: context.height * 0.025),

            // Email field
            _buildFieldSection(
              context,
              theme,
              "Adresse email",
              "Entrez votre adresse email...",
              _emailController,
              _emailError,
              TextInputType.emailAddress,
              false,
              Icons.email_outlined,
              isTablet,
            ),

            SizedBox(height: context.height * 0.025),

            // Password field
            _buildFieldSection(
              context,
              theme,
              "Mot de passe",
              "Entrez votre mot de passe...",
              _passwordController,
              _passwordError,
              TextInputType.visiblePassword,
              true,
              Icons.lock_outline,
              isTablet,
            ),

            SizedBox(height: context.height * 0.025),
            _buildFieldSection(
              context,
              theme,
              "Année d'étude",
              "Entrez votre année d'étude...",
              _studyYearController,
              null, // No error handling for this for now
              TextInputType.text,
              false,
              Icons.school_outlined,
              isTablet,
            ),

            SizedBox(height: context.height * 0.025),

// Speciality field
            _buildFieldSection(
              context,
              theme,
              "Spécialité",
              "Entrez votre spécialité...",
              _specialiteController,
              null, // No error handling for this for now
              TextInputType.text,
              false,
              Icons.auto_stories_outlined,
              isTablet,
            ),

            SizedBox(height: context.height * 0.025),

            // Terms and conditions
            _buildTermsSection(context, theme, isTablet),

            SizedBox(height: context.height * 0.02),

            // Signup button
            _buildSignupButton(context, theme, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldSection(
    BuildContext context,
    ThemeData theme,
    String label,
    String hint,
    TextEditingController controller,
    String? error,
    TextInputType keyboardType,
    bool obscure,
    IconData icon,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: isTablet ? 20 : 18,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: error != null
                    ? AppTheme.errorColor.withOpacity(0.1)
                    : AppTheme.primaryColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: MyTextField(
            hintText: hint,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscure,
            errorText: error,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryTextColor,
            fontSize: isTablet ? 13 : 12,
            height: 1.4,
          ),
          children: [
            TextSpan(text: "En créant un compte, vous acceptez nos "),
            TextSpan(
              text: "Conditions d'utilisation",
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(text: " et notre "),
            TextSpan(
              text: "Politique de confidentialité",
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(text: "."),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupButton(
      BuildContext context, ThemeData theme, bool isTablet) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: isTablet ? 56 : 52,
          decoration: BoxDecoration(
            gradient: state is AuthLoading
                ? LinearGradient(
                    colors: [
                      AppTheme.buttonColor.withOpacity(0.6),
                      AppTheme.secondaryColor.withOpacity(0.6),
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      AppTheme.buttonColor,
                      AppTheme.secondaryColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: state is AuthLoading
                ? []
                : [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: state is AuthLoading ? null : _handleSignup,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                alignment: Alignment.center,
                child: state is AuthLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "CRÉATION...",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: isTablet ? 22 : 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "CRÉER LE COMPTE",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginSection(BuildContext context, ThemeData theme) {
    final isTablet = context.width > 600;

    return Container(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Divider with text
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.borderColor,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "OU",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.borderColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.height * 0.02),

            // Login text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vous avez déjà un compte ? ",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.height * 0.015),

            // Login button
            Container(
              width: double.infinity,
              height: isTablet ? 48 : 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login,
                          color: AppTheme.primaryColor,
                          size: isTablet ? 20 : 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "SE CONNECTER",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
