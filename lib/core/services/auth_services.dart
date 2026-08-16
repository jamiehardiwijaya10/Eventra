import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/routes.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String roleName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception('User gagal dibuat di Authentication');
    }

    debugPrint('USER ID: ${user.id}');
    debugPrint('ROLE NAME YANG DIKIRIM: "$roleName"');

    final role = await _client
        .from('roles')
        .select('id')
        .eq('name', roleName)
        .single();

    debugPrint('ROLE: $role');

    await _client.from('profiles').insert({
      'id': user.id,
      'role_id': role['id'],
    });

    debugPrint('PROFILE BERHASIL DIBUAT');

    return response;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception("Login gagal");
    }

    debugPrint("LOGIN BERHASIL");
    debugPrint("USER ID : ${user.id}");
    debugPrint("EMAIL   : ${user.email}");

    return response;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
  await _client.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: 'io.supabase.flutter://login-callback',
  );
  }

Future<void> createProfile({
  required String roleName,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User tidak ditemukan");
    }

    final role = await _client
        .from('roles')
        .select('id')
        .eq('name', roleName)
        .single();

    await _client.from('profiles').insert({
      'id': user.id,
      'role_id': role['id'],
    });

    debugPrint("PROFILE GOOGLE BERHASIL DIBUAT");
  }

  Future<String> getUserRole() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final profile = await _client
        .from('profiles')
        .select('roles(name)')
        .eq('id', user.id)
        .single();

    return profile['roles']['name'] as String;
  }

  Future<void> goToHomeByRole(BuildContext context) async {
    final role = await getUserRole();

    if (!context.mounted) return;

    switch (role) {
      case "User":
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.homecostumer,
        );
        break;

      case "Booth Owner":
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.homebooth,
        );
        break;

      case "EO":
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.homeeo,
        );
        break;

      default:
        throw Exception("Role tidak dikenali");
    }
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final response = await _client
        .from('profiles')
        .select('''
          *,
          roles(name)
        ''')
        .eq('id', user.id)
        .single();

    return response;
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? avatarUrl,
    String? companyName,
    String? teamLeader,
    String? officialWebsite,
    String? brandName,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    await _client
        .from('profiles')
        .update({
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'avatar_url': avatarUrl,
          'company_name': companyName,
          'team_leader': teamLeader,
          'official_website': officialWebsite,
          'brand_name': brandName,
        })
        .eq('id', user.id);
  }

  Future<String> uploadProfileImage({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final path =
        'avatars/${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

    await _client.storage
        .from('profile_avatars')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

    return _client.storage
        .from('profile_avatars')
        .getPublicUrl(path);
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
}