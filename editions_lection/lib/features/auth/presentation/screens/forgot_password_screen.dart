import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../bloc/auth_bloc.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PasswordResetView _currentView = PasswordResetView.emailInput;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onForgetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(ForgetPasswordRequested(
            email: _emailController.text,
          ));
    }
  }

  void _onVerifyCode() {
    // We're just using the email from the first step
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentView = PasswordResetView.newPassword;
      });
    }
  }

  void _onResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(ResetPasswordRequested(
            email: _emailController.text,
            code: _otpController.text,
            newPassword: _newPasswordController.text,
          ));
    }
  }

  Widget _buildEmailInputView() {
    return Column(
      children: [
        const Text('Enter your email to receive a password reset code 📧'),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: _onForgetPassword,
          child: const Text('Send Code'),
        ),
      ],
    );
  }

  Widget _buildOtpInputView() {
    return Column(
      children: [
        const Text('A 4-digit code has been sent to your email. Check it out and enter it below! 🔒'),
        OtpTextField(
          numberOfFields: 4,
          onCodeChanged: (String code) {
            _otpController.text = code;
          },
          onSubmit: (String verificationCode) {
            _otpController.text = verificationCode;
          },
        ),
        ElevatedButton(
          onPressed: _onVerifyCode,
          child: const Text('Verify Code'),
        ),
      ],
    );
  }

  Widget _buildNewPasswordView() {
    return Column(
      children: [
        const Text('Enter your new password below! 🔑'),
        TextFormField(
          controller: _newPasswordController,
          decoration: const InputDecoration(labelText: 'New Password'),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: _onResetPassword,
          child: const Text('Reset Password'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PasswordResetCodeSent) {
            setState(() {
              _currentView = PasswordResetView.otpInput;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Code sent! Check your email.')),
            );
          } else if (state is PasswordResetSuccess) {
            // Navigate back to the login screen
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset successful! You can now log in.')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: _currentView == PasswordResetView.emailInput
                  ? _buildEmailInputView()
                  : _currentView == PasswordResetView.otpInput
                      ? _buildOtpInputView()
                      : _buildNewPasswordView(),
            ),
          );
        },
      ),
    );
  }
}

enum PasswordResetView { emailInput, otpInput, newPassword }