import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Franja decorativa con los 3 colores de la bandera de Ecuador.
/// Puramente estética: se usa como sello/encabezado institucional
/// en las pantallas de autenticación.
class FlagStripe extends StatelessWidget {
  final double height;

  const FlagStripe({super.key, this.height = 5});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Row(
        children: [
          Expanded(child: Container(height: height, color: AppTheme.flagYellow)),
          Expanded(child: Container(height: height, color: AppTheme.flagBlue)),
          Expanded(child: Container(height: height, color: AppTheme.flagRed)),
        ],
      ),
    );
  }
}
