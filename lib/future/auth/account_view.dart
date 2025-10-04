import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/future/auth/mixin/account_view_mixin.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> with AccountMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          spacing: 20,
          children: [
            Text(
              userID,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black),
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'User Name'),
            ),
            ElevatedButton(
              onPressed: () => updateUserData(),
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => signOut(),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
