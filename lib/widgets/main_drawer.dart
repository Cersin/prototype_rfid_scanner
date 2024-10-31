import 'package:flutter/material.dart';
import 'package:telegrosik/screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.callback});

  final VoidCallback callback;

  Future<void> _goToSettings(ctx) async {
    await Navigator.of(ctx)
        .push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Telegrosik'),
          ),
          ListTile(
              title: const Text('Przejdź do ustawień'),
              onTap: () => _goToSettings(context)),
        ],
      ),
    );
  }
}
