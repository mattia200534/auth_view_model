import 'package:flutter/material.dart';
import 'package:model/core/profile_service.dart';
import 'package:model/models/user_profiles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final SupabaseClient _client = Supabase.instance.client;

  UserProfiles? profile;
  bool isLoading = false;

  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      profile = await _profileService.fetchUserProfile();
    } catch (e) {
      print('Errore caricamento profilo: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createUserProfile(String username, DateTime birthDate) async {
    final id = _client.auth.currentUser?.id;
    if (id == null) return;

    final newProfile = UserProfiles(
      id: id,
      username: username,
      birthdate: birthDate,
      avatarUrl: null,
    );

    try {
      await _profileService.createUserProfile(newProfile);
      profile = newProfile;
    } catch (e) {
      print("errore creazione profilo: $e");
    }

    notifyListeners();
  }

  Future<void> updateUserProfile(UserProfiles updateUserProfile) async {
    if (profile == null) return;

    try {
      await _profileService.updateUserProfile(updateUserProfile);
      profile = updateUserProfile;
    } catch (e) {
      print("errore aggiornamento profilo: $e");
    }

    notifyListeners();
  }
}
