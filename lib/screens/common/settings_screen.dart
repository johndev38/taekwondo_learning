import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/progress_notifier.dart';
import '../../notifiers/theme_notifier.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'PARAMÈTRES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            letterSpacing: 3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(label: 'AFFICHAGE'),
          Consumer<ThemeNotifier>(
            builder: (context, theme, _) => _SettingsTile(
              icon: Icons.dark_mode_rounded,
              title: 'Thème sombre',
              subtitle: theme.darkTheme ? 'Activé' : 'Désactivé',
              trailing: Switch(
                value: theme.darkTheme,
                onChanged: (_) => theme.toggleTheme(),
                activeColor: const Color(0xFFCC1122),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionHeader(label: 'PROGRESSION'),
          Consumer<ProgressNotifier>(
            builder: (context, p, _) {
              final belt = p.currentBeltId;
              return _SettingsTile(
                icon: Icons.military_tech_rounded,
                title: 'Ceinture courante',
                subtitle: belt == 'none' ? 'Non définie' : belt,
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14),
                onTap: () {
                  Navigator.pop(context);
                  // La page Ma progression permet de changer la ceinture
                },
              );
            },
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.restart_alt_rounded,
            title: 'Réinitialiser ma progression',
            subtitle: 'Supprime ceinture courante, favoris et validations',
            iconColor: const Color(0xFFCC1122),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Réinitialiser ?'),
                  content: const Text(
                      'Toute ta progression (ceinture, favoris, items cochés) sera effacée. Continuer ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFCC1122)),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Réinitialiser'),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await context.read<ProgressNotifier>().reset();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Progression réinitialisée')),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 16),
          const _SectionHeader(label: 'APPLICATION'),
          _SettingsTile(
            icon: Icons.info_rounded,
            title: 'À propos',
            subtitle: 'Sources FFTDA · Version',
            trailing:
                const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF37474F),
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? const Color(0xFF0A1628);
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
