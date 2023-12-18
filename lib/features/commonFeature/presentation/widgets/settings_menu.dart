import 'package:flutter/material.dart';

import '../../domain/user.dart';
import '../children_page.dart';
import '../my_account.dart';

class SettingsMenu extends StatelessWidget {
  final User user;

  const SettingsMenu({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            SettingsTile(
              icon: Icons.person,
              title: 'My Account',
              subtitle: 'View info',
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyAccountPage(user: user)),
                )
              },
            ),
            SettingsTile(
              icon: Icons.medical_services,
              title: 'Medicines',
              subtitle: 'View your Medicines',
              onTap: () => {print("Medicines")},
            ),
            SettingsTile(
              icon: Icons.child_care,
              title: 'Children',
              subtitle: 'Manage your linked Children',
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildrenPage(parentID: user.docId)),
                )
              },
            ),
            SettingsTile(
              icon: Icons.logout,
              title: 'Log out',
              subtitle: '',
              onTap: () => {},
            ),
          ],
        ).toList(),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
