import 'package:model/models/user_profiles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  //metodo per recuperare i dati del profilo utente
  Future<UserProfiles?> fetchUserProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    //query al database
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return UserProfiles.fromMap(response);
  }

  //metodo per la creazione del profilo utente
  Future<void> createUserProfile(UserProfiles profile) async {
    await _client.from('profiles').insert(profile.toMap());
  }

  //metodo per l'aggiornamento del profilo utente
  Future<void> updateUserProfile(UserProfiles profile) async {
    await _client.from('profiles').update(profile.toMap()).eq('id', profile.id);
  }
}
