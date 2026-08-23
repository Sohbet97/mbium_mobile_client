import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class HomeProductFiltres extends StatefulWidget {
  const HomeProductFiltres({
    super.key,
    required this.onTap,
    required this.filtres,
  });
  final Function(HomeFilterModel) onTap;
  final List<HomeFilterModel> filtres;
  @override
  State<HomeProductFiltres> createState() => _HomeProductFiltresState();
}

class _HomeProductFiltresState extends State<HomeProductFiltres> {
  // Tracked by index rather than by model instance — the filter list is
  // rebuilt fresh every build(), so comparing model objects directly would
  // never match (different instances each time) and selection would never
  // visually register.
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: widget.filtres.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final selected = index == _selectedIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onTap(widget.filtres[index]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: selected
                        ? const LinearGradient(
                            colors: [
                              AppColors.primaryGreen,
                              AppColors.secondaryGreen,
                            ],
                          )
                        : null,
                    color: selected ? null : Colors.white,
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : Colors.grey.withValues(alpha: 0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: selected
                            ? AppColors.primaryGreen.withValues(alpha: 0.28)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: selected ? 12 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.filtres[index].iconData,
                        size: 16,
                        color: selected ? Colors.white : AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.filtres[index].name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeFilterModel {
  final String name;
  final IconData iconData;

  HomeFilterModel({required this.name, required this.iconData});
}
