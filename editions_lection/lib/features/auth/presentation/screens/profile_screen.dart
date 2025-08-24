import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:editions_lection/features/auth/domain/entities/user.dart';
import 'package:editions_lection/features/auth/domain/entities/speciality.dart';
import 'package:editions_lection/features/auth/domain/entities/area.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers for the form fields
  final _phoneController = TextEditingController();
  final _studyYearController = TextEditingController();

  // Dropdown selections
  Speciality? _selectedSpeciality;
  Area? _selectedArea;

  // Error states for validation
  String? _phoneError;
  String? _studyYearError;
  String? _specialityError;
  String? _areaError;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _startAnimations();

    // Fetch current user data
    context.read<AuthBloc>().add(GetCurrentUserEvent());
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _phoneController.dispose();
    _studyYearController.dispose();
    super.dispose();
  }

  // Helper functions for dropdown display names
  String _getSpecialityDisplayName(Speciality speciality) {
    switch (speciality) {
      case Speciality.medcine:
        return 'Médecine';
      case Speciality.pharmacie:
        return 'Pharmacie';
      case Speciality.dentaire:
        return 'Dentaire';
      case Speciality.pharmacieIndustrielle:
        return 'Pharmacie Industrielle';
    }
  }

  String _getAreaDisplayName(Area area) {
    switch (area) {
      case Area.Alger:
        return 'Alger';
      case Area.Tipaza:
        return 'Tipaza';
      case Area.Tiziouzou:
        return 'Tizi Ouzou';
      case Area.Oran:
        return 'Oran';
      case Area.SidiBelAbbes:
        return 'Sidi Bel Abbès';
    }
  }

  // Get speciality from string
  Speciality? _getSpecialityFromString(String specialityString) {
    for (Speciality speciality in Speciality.values) {
      if (speciality.toString().split('.').last == specialityString) {
        return speciality;
      }
    }
    return null;
  }

  // Get area from string
  Area? _getAreaFromString(String areaString) {
    for (Area area in Area.values) {
      if (area.toString().split('.').last == areaString) {
        return area;
      }
    }
    return null;
  }

  // Validation functions
  bool _isValidPhoneNumber(String phone) {
    return RegExp(r'^[\+]?[0-9]{8,15}$')
        .hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  bool _isValidStudyYear(String studyYear) {
    if (studyYear.trim().isEmpty) return false;
    final year = int.tryParse(studyYear.trim());
    if (year == null) return false;
    return year >= 1 && year <= 12;
  }

  bool _validateEditForm() {
    setState(() {
      _phoneError = null;
      _studyYearError = null;
      _specialityError = null;
      _areaError = null;
    });

    bool isValid = true;

    // Phone validation
    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        _phoneError = "Le numéro de téléphone est requis";
      });
      isValid = false;
    } else if (!_isValidPhoneNumber(_phoneController.text.trim())) {
      setState(() {
        _phoneError = "Veuillez entrer un numéro de téléphone valide";
      });
      isValid = false;
    }

    // Study year validation
    if (_studyYearController.text.trim().isEmpty) {
      setState(() {
        _studyYearError = "L'année d'étude est requise";
      });
      isValid = false;
    } else if (!_isValidStudyYear(_studyYearController.text.trim())) {
      setState(() {
        _studyYearError = "L'année d'étude doit être un nombre entre 1 et 12";
      });
      isValid = false;
    }

    // Speciality validation
    if (_selectedSpeciality == null) {
      setState(() {
        _specialityError = "La spécialité est requise";
      });
      isValid = false;
    }

    // Area validation
    if (_selectedArea == null) {
      setState(() {
        _areaError = "La zone géographique est requise";
      });
      isValid = false;
    }

    return isValid;
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Déconnexion'),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(color: AppTheme.primaryTextColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(User user) {
    // Reset error states
    _phoneError = null;
    _studyYearError = null;
    _specialityError = null;
    _areaError = null;

    // Populate controllers and selections with current user data
    _phoneController.text = user.phoneNumber;
    _studyYearController.text = user.studyYear;
    _selectedSpeciality = _getSpecialityFromString(user.specialite);
    _selectedArea = _getAreaFromString(user.area);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Modifier le profil',
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Mettez à jour vos informations',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.primaryTextColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                color:
                                    AppTheme.primaryTextColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Phone Number Field
                        _buildDialogField(
                          setDialogState,
                          'Numéro de téléphone',
                          'Entrez votre numéro de téléphone...',
                          _phoneController,
                          _phoneError,
                          Icons.phone_outlined,
                          TextInputType.phone,
                        ),

                        const SizedBox(height: 24),

                        // Study Year Field
                        _buildDialogField(
                          setDialogState,
                          'Année d\'étude',
                          'Entrez votre année d\'étude (1-12)...',
                          _studyYearController,
                          _studyYearError,
                          Icons.school_outlined,
                          TextInputType.number,
                        ),

                        const SizedBox(height: 24),

                        // Speciality Dropdown
                        _buildDialogSpecialityDropdown(setDialogState),

                        const SizedBox(height: 24),

                        // Area Dropdown
                        _buildDialogAreaDropdown(setDialogState),

                        const SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryTextColor
                                      .withOpacity(0.7),
                                  side: BorderSide(
                                    color: AppTheme.primaryTextColor
                                        .withOpacity(0.3),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Annuler'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_validateEditForm()) {
                                    Navigator.of(context).pop();
                                    final updatedData = {
                                      'phone_number': _phoneController.text,
                                      'specialite': _selectedSpeciality
                                          .toString()
                                          .split('.')
                                          .last,
                                      'study_year': _studyYearController.text,
                                      'era': _selectedArea
                                          .toString()
                                          .split('.')
                                          .last,
                                    };
                                    context.read<AuthBloc>().add(
                                        UpdateUserEvent(userData: updatedData));
                                  } else {
                                    setDialogState(
                                        () {}); // Refresh dialog to show errors
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Sauvegarder',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogField(
    StateSetter setDialogState,
    String label,
    String hint,
    TextEditingController controller,
    String? error,
    IconData icon,
    TextInputType keyboardType,
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
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            // Add explicit text style to ensure visibility
            style: TextStyle(
              color: AppTheme.primaryTextColor, // Ensure text is visible
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            onChanged: (value) {
              setDialogState(() {
                if (controller == _phoneController) {
                  _phoneError = null;
                } else if (controller == _studyYearController) {
                  _studyYearError = null;
                }
              });
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppTheme.secondaryTextColor
                    .withOpacity(0.6), // Make hint more visible
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors
                  .white, // Use white background instead of AppTheme.backgroundColor
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: error != null
                      ? AppTheme.errorColor
                      : Colors.grey.shade300,
                  width: error != null ? 1.5 : 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: error != null
                      ? AppTheme.errorColor
                      : Colors.grey.shade300,
                  width: error != null ? 1.5 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: error != null
                      ? AppTheme.errorColor
                      : AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorText: error,
              errorStyle: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogSpecialityDropdown(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.auto_stories_outlined,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Spécialité',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
                color: _specialityError != null
                    ? AppTheme.errorColor.withOpacity(0.1)
                    : AppTheme.primaryColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _specialityError != null
                    ? AppTheme.errorColor
                    : Colors.black,
                width: _specialityError != null ? 1.5 : 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Speciality>(
                value: _selectedSpeciality,
                hint: Text(
                  'Sélectionnez votre spécialité...',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                style: TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontSize: 14,
                ),
                dropdownColor: Colors.white,
                items: Speciality.values.map((Speciality speciality) {
                  return DropdownMenuItem<Speciality>(
                    value: speciality,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _getSpecialityDisplayName(speciality),
                        style: TextStyle(
                          color: AppTheme.primaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Speciality? newValue) {
                  setDialogState(() {
                    _selectedSpeciality = newValue;
                    _specialityError = null;
                  });
                },
              ),
            ),
          ),
        ),
        if (_specialityError != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              _specialityError!,
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDialogAreaDropdown(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Zone géographique',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
                color: _areaError != null
                    ? AppTheme.errorColor.withOpacity(0.1)
                    : AppTheme.primaryColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _areaError != null ? AppTheme.errorColor : Colors.black,
                width: _areaError != null ? 1.5 : 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Area>(
                value: _selectedArea,
                hint: Text(
                  'Sélectionnez votre zone géographique...',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                style: TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontSize: 14,
                ),
                dropdownColor: Colors.white,
                items: Area.values.map((Area area) {
                  return DropdownMenuItem<Area>(
                    value: area,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _getAreaDisplayName(area),
                        style: TextStyle(
                          color: AppTheme.primaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Area? newValue) {
                  setDialogState(() {
                    _selectedArea = newValue;
                    _areaError = null;
                  });
                },
              ),
            ),
          ),
        ),
        if (_areaError != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              _areaError!,
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppTheme.primaryTextColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profil',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            // User has been logged out, navigate to login screen
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (Route<dynamic> route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is UserLoaded) {
            // Show a success message when the user data is re-loaded
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profil mis à jour avec succès!'),
                backgroundColor: AppTheme.primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return _buildLoadingState();
            } else if (state is UserLoaded) {
              return _buildProfileContent(state.user);
            } else if (state is AuthError) {
              return _buildErrorState(state.message);
            } else {
              // Try to get user data
              return _buildNoUserState();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement du profil...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(GetCurrentUserEvent()),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoUserState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: AppTheme.primaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune donnée utilisateur',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(GetCurrentUserEvent()),
            icon: const Icon(Icons.person),
            label: const Text('Charger le profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(User user) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.width * 0.05),
          child: Column(
            children: [
              // Profile Avatar Section
              _buildProfileAvatar(user),
              SizedBox(height: context.height * 0.03),

              // User Info Cards
              _buildInfoCard(user),
              SizedBox(height: context.height * 0.02),

              // Academic Info Card
              _buildAcademicInfoCard(user),
              SizedBox(height: context.height * 0.03),

              // Action Buttons
              _buildActionButtons(user),
              SizedBox(height: context.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(User user) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person_outline_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryTextColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Informations personnelles',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.person,
            label: 'Nom complet',
            value: user.fullName,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            value: user.phoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoCard(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Informations académiques',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.bookmark_outline,
            label: 'Spécialité',
            value: _getSpecialityDisplayName(
                _getSpecialityFromString(user.specialite) ??
                    Speciality.medcine),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Année d\'étude',
            value: '${user.studyYear}ème année',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Zone',
            value: _getAreaDisplayName(
                _getAreaFromString(user.area) ?? Area.Alger),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryTextColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(User user) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showEditProfileDialog(user);
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Modifier le profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout_outlined),
            label: const Text('Se déconnecter'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
