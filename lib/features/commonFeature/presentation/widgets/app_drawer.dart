import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: 1,
            //backgroundColor: const Color.fromRGBO(0, 0, 139, 1),
            centerTitle: true,
            automaticallyImplyLeading: false, // back button: false
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping_outlined),
            title: const Text('Track Package'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed(CustomerScreen.id);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              //  Navigator.of(context).pushReplacementNamed(ProfileScreen.id);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              //_auth.signOut();
              //Navigator.pop(context);
              //Navigator.of(context).pushReplacementNamed(WelcomeScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
