import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/flag_stripe.dart';
import 'login_page.dart';
import 'package:elecciones/features/actas/presentation/pages/captura_acta_page.dart';

class WelcomePage extends StatelessWidget {
  final UserEntity user;

  const WelcomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sello institucional
                const FlagStripe(),
                const SizedBox(height: 32),

                // Animated icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.verified_rounded,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome title
                Text(
                  '¡Bienvenido!',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // User name
                if (user.displayName != null && user.displayName!.isNotEmpty)
                  Text(
                    user.displayName!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 8),

                // User email
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Success card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Has iniciado sesión correctamente',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tu cuenta está activa y lista para usar',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Capture Acta button
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CapturaActaPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Registrar Acta de Mesa'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Logout button
                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const SignOutRequested());
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Cerrar sesión'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
