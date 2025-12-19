import 'package:flutter/material.dart';
import 'package:model/viewmodel/auth_view_model.dart';
import 'package:model/views/auth/login_view.dart';
import 'package:model/views/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Supabaseapp"),
        actions: [
          IconButton(
            onPressed: () async {
              await vm.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginView()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text("home view")),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
