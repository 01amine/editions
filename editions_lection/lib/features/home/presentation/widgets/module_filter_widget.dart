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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          itemCount: widget.showAllOption
              ? widget.modules.length + 1
              : widget.modules.length,
          itemBuilder: (context, index) {
            if (widget.showAllOption && index == 0) {
              return _buildModuleChip(
                'Tous',
                isSelected: widget.selectedModule == null,
                onTap: () => widget.onModuleChanged(null),
                isAllOption: true,
                isFirst: true,
              );
            }

            final moduleIndex = widget.showAllOption ? index - 1 : index;
            final module = widget.modules[moduleIndex];

            return _buildModuleChip(
              module,
              isSelected: widget.selectedModule == module,
              onTap: () => widget.onModuleChanged(module),
              isLast: moduleIndex == widget.modules.length - 1,
            );
          },
        ),
      ),
    );
  }

  Widget _buildModuleChip(
    String module, {
    required bool isSelected,
    required VoidCallback onTap,
    bool isAllOption = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        right: isLast ? 0 : 12,
        left: isFirst ? 0 : 0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryTextColor.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAllOption)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.apps_rounded,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : AppTheme.primaryTextColor.withOpacity(0.7),
                    ),
                  ),
                Text(
                  module,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color:
                        isSelected ? Colors.white : AppTheme.primaryTextColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
