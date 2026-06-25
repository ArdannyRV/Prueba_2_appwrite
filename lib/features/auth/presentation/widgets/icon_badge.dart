import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Contenedor cuadrado (no circular) para iconos de cabecera.
/// Reemplaza los íconos circulares "suaves" por un sello más
/// formal/institucional, en línea con el dominio (mesas electorales).
class IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const IconBadge({
    super.key,
    required this.icon,
    this.size = 72,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppTheme.primaryColor;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor, width: 1.5),
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: badgeColor,
      ),
    );
  }
}
