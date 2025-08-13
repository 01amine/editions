import 'package:flutter/material.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/core/extensions/extensions.dart';

class ModuleFilterWidget extends StatefulWidget {
  final List<String> modules;
  final String? selectedModule;
  final Function(String?) onModuleChanged;
  final bool showAllOption;

  const ModuleFilterWidget({
    super.key,
    required this.modules,
    required this.onModuleChanged,
    this.selectedModule,
    this.showAllOption = true,
  });

  @override
  State<ModuleFilterWidget> createState() => _ModuleFilterWidgetState();
}

class _ModuleFilterWidgetState extends State<ModuleFilterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modules.isEmpty) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            if (_isExpanded) _buildModulesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrer par module',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryTextColor,
                    ),
                  ),
                  if (widget.selectedModule != null)
                    Text(
                      widget.selectedModule!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.primaryTextColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          Container(
            height: 1,
            width: double.infinity,
            color: AppTheme.primaryTextColor.withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 12),
          ),
          SizedBox(
            height: context.height * 0.25,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (widget.showAllOption)
                    _buildModuleChip(
                      'Tous les modules',
                      isSelected: widget.selectedModule == null,
                      onTap: () => widget.onModuleChanged(null),
                      isAllOption: true,
                    ),
                  ...widget.modules.map((module) => _buildModuleChip(
                        module,
                        isSelected: widget.selectedModule == module,
                        onTap: () => widget.onModuleChanged(module),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleChip(
    String module, {
    required bool isSelected,
    required VoidCallback onTap,
    bool isAllOption = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryTextColor.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.primaryColor 
                          : AppTheme.primaryTextColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    module,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.primaryTextColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isAllOption)
                  Icon(
                    Icons.apps_rounded,
                    size: 16,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.primaryTextColor.withOpacity(0.5),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}