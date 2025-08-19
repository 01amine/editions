import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:editions_lection/core/extensions/extensions.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PasswordResetView _currentView = PasswordResetView.emailInput;

  String? _emailError;
  String? _otpError;
  String? _passwordError;

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
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _validateEmailForm() {
    setState(() {
      _emailError = null;
    });

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = "L'email est requis";
      });
      return false;
    } else if (!_isValidEmail(_emailController.text.trim())) {
      setState(() {
        _emailError = "Veuillez entrer un email valide";
      });
      return false;
    }
    return true;
  }

  bool _validateOtpForm() {
    setState(() {
      _otpError = null;
    });

    if (_otpController.text.trim().isEmpty || _otpController.text.length != 4) {
      setState(() {
        _otpError = "Veuillez entrer le code à 4 chiffres";
      });
      return false;
    }
    return true;
  }

  bool _validatePasswordForm() {
    setState(() {
      _passwordError = null;
    });

    if (_newPasswordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = "Le mot de passe est requis";
      });
      return false;
    } else if (_newPasswordController.text.length < 6) {
      setState(() {
        _passwordError = "Le mot de passe doit contenir au moins 6 caractères";
      });
      return false;
    }
    return true;
  }

  void _onForgetPassword() {
    if (_validateEmailForm()) {
      context.read<AuthBloc>().add(ForgetPasswordRequested(
            email: _emailController.text.trim(),
          ));
    }
  }

  void _onVerifyCode() {
    if (_validateOtpForm()) {
      setState(() {
        _currentView = PasswordResetView.newPassword;
      });
    }
  }

  void _onResetPassword() {
    if (_validatePasswordForm()) {
      context.read<AuthBloc>().add(ResetPasswordRequested(
            email: _emailController.text.trim(),
            code: _otpController.text,
            newPassword: _newPasswordController.text.trim(),
          ));
    }
  }

  void _goBack() {
    if (_currentView == PasswordResetView.otpInput) {
      setState(() {
        _currentView = PasswordResetView.emailInput;
      });
    } else if (_currentView == PasswordResetView.newPassword) {
      setState(() {
        _currentView = PasswordResetView.otpInput;
      });
    } else {
      Navigator.of(context).pop();
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.primaryColor,
              size: isTablet ? 24 : 20,
            ),
            onPressed: _goBack,
          ),
          title: Text(
            _getTitleText(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryTextColor,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 18 : 16,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: context.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
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
                        SizedBox(height: context.height * 0.02),

                        // Logo and header section
                        _buildHeaderSection(context, theme, isTablet),

                        SizedBox(height: context.height * 0.04),

                        // Main content
                        _buildMainContent(context, theme, isTablet),

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

  String _getTitleText() {
    switch (_currentView) {
      case PasswordResetView.emailInput:
        return "Mot de passe oublié";
      case PasswordResetView.otpInput:
        return "Vérification du code";
      case PasswordResetView.newPassword:
        return "Nouveau mot de passe";
    }
  }

  Widget _buildHeaderSection(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Column(
      children: [
        // Logo
        Container(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            _getHeaderIcon(),
            size: isTablet ? 48 : 40,
            color: AppTheme.primaryColor,
          ),
        ),

        SizedBox(height: context.height * 0.02),

        // Title
        Text(
          _getHeaderTitle(),
          style: theme.textTheme.displaySmall?.copyWith(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 26 : 22,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: context.height * 0.01),

        // Subtitle
        Text(
          _getHeaderSubtitle(),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.primaryTextColor.withOpacity(0.7),
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getHeaderIcon() {
    switch (_currentView) {
      case PasswordResetView.emailInput:
        return Icons.lock_reset;
      case PasswordResetView.otpInput:
        return Icons.security;
      case PasswordResetView.newPassword:
        return Icons.lock_outline;
    }
  }

  String _getHeaderTitle() {
    switch (_currentView) {
      case PasswordResetView.emailInput:
        return "Récupération de compte";
      case PasswordResetView.otpInput:
        return "Code de vérification";
      case PasswordResetView.newPassword:
        return "Nouveau mot de passe";
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentView) {
      case PasswordResetView.emailInput:
        return "Entrez votre adresse email pour recevoir un code de récupération";
      case PasswordResetView.otpInput:
        return "Entrez le code à 4 chiffres envoyé à votre email";
      case PasswordResetView.newPassword:
        return "Créez un nouveau mot de passe sécurisé pour votre compte";
    }
  }

  Widget _buildMainContent(
      BuildContext context, ThemeData theme, bool isTablet) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
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
        } else if (state is PasswordResetCodeSent) {
          setState(() {
            _currentView = PasswordResetView.otpInput;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Code envoyé ! Vérifiez votre email.'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (state is PasswordResetSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Mot de passe réinitialisé avec succès ! Vous pouvez maintenant vous connecter.'),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return _buildLoadingView(context, theme, isTablet);
        }

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
            child: _getCurrentViewWidget(context, theme, isTablet),
          ),
        );
      },
    );
  }

  Widget _buildLoadingView(
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
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: context.height * 0.03),
          Text(
            _getLoadingText(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryTextColor,
              fontSize: isTablet ? 16 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLoadingText() {
    switch (_currentView) {
      case PasswordResetView.emailInput:
        return "Envoi du code de récupération...";
      case PasswordResetView.otpInput:
        return "Vérification du code...";
      case PasswordResetView.newPassword:
        return "Réinitialisation du mot de passe...";
    }
  }

  Widget _getCurrentViewWidget(
      BuildContext context, ThemeData theme, bool isTablet) {
    switch (_currentView) {
      case PasswordResetView.emailInput:
        return _buildEmailInputView(context, theme, isTablet);
      case PasswordResetView.otpInput:
        return _buildOtpInputView(context, theme, isTablet);
      case PasswordResetView.newPassword:
        return _buildNewPasswordView(context, theme, isTablet);
    }
  }

  Widget _buildEmailInputView(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(height: context.height * 0.03),
        _buildActionButton(
          context,
          theme,
          "Envoyer le code",
          Icons.send,
          _onForgetPassword,
          isTablet,
        ),
        SizedBox(height: context.height * 0.02),
        _buildBackToLoginButton(context, theme, isTablet),
      ],
    );
  }

  Widget _buildOtpInputView(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Column(
      children: [
        // Email display
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: AppTheme.primaryColor,
                size: isTablet ? 20 : 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  _emailController.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.height * 0.03),

        // OTP Input
        OtpTextField(
          numberOfFields: 4,
          borderColor: AppTheme.borderColor,
          focusedBorderColor: AppTheme.primaryColor,
          fillColor: AppTheme.surfaceColor,
          filled: true,
          fieldWidth: isTablet ? 60 : 50,
          fieldHeight: isTablet ? 60 : 50,
          borderRadius: BorderRadius.circular(12),
          textStyle: theme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
          onCodeChanged: (String code) {
            _otpController.text = code;
            setState(() {
              _otpError = null;
            });
          },
          onSubmit: (String verificationCode) {
            _otpController.text = verificationCode;
          },
        ),

        if (_otpError != null) ...[
          SizedBox(height: 8),
          Text(
            _otpError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.errorColor,
              fontSize: isTablet ? 12 : 10,
            ),
          ),
        ],

        SizedBox(height: context.height * 0.03),

        _buildActionButton(
          context,
          theme,
          "Vérifier le code",
          Icons.verified_user,
          _onVerifyCode,
          isTablet,
        ),

        SizedBox(height: context.height * 0.02),

        _buildResendCodeButton(context, theme, isTablet),
      ],
    );
  }

  Widget _buildNewPasswordView(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldSection(
          context,
          theme,
          "Nouveau mot de passe",
          "Entrez votre nouveau mot de passe...",
          _newPasswordController,
          _passwordError,
          TextInputType.visiblePassword,
          true,
          Icons.lock_outline,
          isTablet,
        ),

        SizedBox(height: context.height * 0.02),

        // Password requirements
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: AppTheme.infoColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.infoColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.infoColor,
                    size: isTablet ? 18 : 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Exigences du mot de passe :",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.infoColor,
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 12 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "• Au moins 6 caractères\n• Recommandé : mélange de lettres, chiffres et symboles",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryTextColor,
                  fontSize: isTablet ? 12 : 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.height * 0.03),

        _buildActionButton(
          context,
          theme,
          "Réinitialiser le mot de passe",
          Icons.lock_reset,
          _onResetPassword,
          isTablet,
        ),
      ],
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

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme,
    String text,
    IconData icon,
    VoidCallback onPressed,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      height: isTablet ? 56 : 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.buttonColor,
            AppTheme.secondaryColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: isTablet ? 22 : 20,
                ),
                SizedBox(width: 12),
                Text(
                  text.toUpperCase(),
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
  }

  Widget _buildBackToLoginButton(
      BuildContext context, ThemeData theme, bool isTablet) {
    return Container(
      width: double.infinity,
      height: isTablet ? 48 : 44,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: AppTheme.primaryColor,
                  size: isTablet ? 20 : 18,
                ),
                SizedBox(width: 8),
                Text(
                  "RETOUR À LA CONNEXION",
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
    );
  }

  Widget _buildResendCodeButton(
      BuildContext context, ThemeData theme, bool isTablet) {
    return TextButton(
      onPressed: () {
        if (_validateEmailForm()) {
          context.read<AuthBloc>().add(ForgetPasswordRequested(
                email: _emailController.text.trim(),
              ));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.refresh,
            color: AppTheme.secondaryColor,
            size: isTablet ? 18 : 16,
          ),
          SizedBox(width: 8),
          Text(
            "Renvoyer le code",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 14 : 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

enum PasswordResetView { emailInput, otpInput, newPassword }
