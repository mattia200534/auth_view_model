import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/models/user_profiles.dart';
import 'package:model/viewmodel/profile_view_model.dart';
import 'package:model/views/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    profileVM.loadUserProfile().then((_) {
      final profile = profileVM.profile;
      if (profile != null) {
        _usernameController.text = profile.username;
        _selectedBirthDate = profile.birthdate;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final profile = profileVM.profile;
    return Scaffold(
      appBar: AppBar(title: Text("Profilo Utente")),
      body: profileVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Logica per cambiare l'avatar
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : AssetImage('assets/default_avatar.jpg')
                                    as ImageProvider,
                          child: profile?.avatarUrl == null
                              ? Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'inserisci un username';
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Data di Nascita"),
                      subtitle: Text(
                        _selectedBirthDate != null
                            ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(_selectedBirthDate!)
                            : "Seleziona la data di nascita",
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedBirthDate ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedBirthDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Salva Profilo"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedBirthDate != null) {
                          final username = _usernameController.text.trim();

                          if (profile == null) {
                            await profileVM.createUserProfile(
                              username,
                              _selectedBirthDate!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profilo creato con successo'),
                              ),
                            );
                          } else {
                            final updatedProfile = UserProfiles(
                              id: profile.id,
                              username: username,
                              birthdate: _selectedBirthDate!,
                              avatarUrl: profile.avatarUrl,
                            );
                            await profileVM.updateUserProfile(updatedProfile);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profilo salvato con successo'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
