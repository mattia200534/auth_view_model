import 'dart:io';

import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;
  final String bucket = 'media';

  //metodo per il caricamento delle immagini
  Future<String> uploadImage(File imageFile, String bookId) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
    final filepath = '$bookId/$fileName';
    final storageResponse = await _client.storage
        .from(bucket)
        .upload(filepath, imageFile);
    final publicUrl = _client.storage.from(bucket).getPublicUrl(filepath);
    return publicUrl;
  }
}
