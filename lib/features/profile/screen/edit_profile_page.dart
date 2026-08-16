import 'package:flutter/material.dart';
import '../../../core/services/auth_services.dart';
import '../../../core/theme/app_color.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;

  const EditProfilePage({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;

  late final TextEditingController _companyNameController;
  late final TextEditingController _teamLeaderController;
  late final TextEditingController _websiteController;
  late final TextEditingController _brandNameController;

  late final TextEditingController _instagramController;
  late final TextEditingController _facebookController;
  late final TextEditingController _tiktokController;
  late final TextEditingController _xController;

  Uint8List? _selectedImageBytes;
  String? _selectedImageExtension;

  bool _isSaving = false;

  String get _role {
    return widget.profile['roles']?['name']?.toString() ?? '';
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      final extension = image.name.contains('.')
          ? image.name.split('.').last.toLowerCase()
          : 'jpg';

      if (!mounted) return;

      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageExtension = extension;
      });
    } catch (e) {
      debugPrint("PICK PROFILE IMAGE ERROR: $e");

      if (!mounted) return;

      _showMessage("Gagal memilih foto");
    }
  }

  bool get _isEo => _role == 'EO';
  bool get _isBoothOwner => _role == 'Booth Owner';

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.profile['first_name']?.toString() ?? '',
    );

    _lastNameController = TextEditingController(
      text: widget.profile['last_name']?.toString() ?? '',
    );

    _phoneController = TextEditingController(
      text: widget.profile['phone']?.toString() ?? '',
    );

    _companyNameController = TextEditingController(
      text: widget.profile['company_name']?.toString() ?? '',
    );

    _teamLeaderController = TextEditingController(
      text: widget.profile['team_leader']?.toString() ?? '',
    );

    _websiteController = TextEditingController(
      text: widget.profile['official_website']?.toString() ?? '',
    );

    _brandNameController = TextEditingController(
      text: widget.profile['brand_name']?.toString() ?? '',
    );

    _instagramController = TextEditingController(
      text: widget.profile['ig']?.toString() ?? '',
    );

    _facebookController = TextEditingController(
      text: widget.profile['facebook']?.toString() ?? '',
    );

    _tiktokController = TextEditingController(
      text: widget.profile['tiktok']?.toString() ?? '',
    );

    _xController = TextEditingController(
      text: widget.profile['x']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();

    _companyNameController.dispose();
    _teamLeaderController.dispose();
    _websiteController.dispose();
    _brandNameController.dispose();

    _instagramController.dispose();
    _facebookController.dispose();
    _tiktokController.dispose();
    _xController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isEo &&
        _companyNameController.text.trim().isEmpty) {
      _showMessage("Company name tidak boleh kosong");
      return;
    }

    if (_isBoothOwner &&
        _brandNameController.text.trim().isEmpty) {
      _showMessage("Business name tidak boleh kosong");
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final data = <String, dynamic>{
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      if (_isEo) {
        data['company_name'] =
            _companyNameController.text.trim();

        data['team_leader'] =
            _teamLeaderController.text.trim();

        data['official_website'] =
            _websiteController.text.trim();

        data['ig'] =
            _instagramController.text.trim();

        data['facebook'] =
            _facebookController.text.trim();

        data['tiktok'] =
            _tiktokController.text.trim();

        data['x'] =
            _xController.text.trim();
      }

      if (_isBoothOwner) {
        data['brand_name'] =
            _brandNameController.text.trim();

        data['official_website'] =
            _websiteController.text.trim();

        data['ig'] =
            _instagramController.text.trim();

        data['facebook'] =
            _facebookController.text.trim();

        data['tiktok'] =
            _tiktokController.text.trim();

        data['x'] =
            _xController.text.trim();
      }

      if (_selectedImageBytes != null &&
          _selectedImageExtension != null) {
        final avatarUrl =
            await _profileService.uploadProfileAvatar(
          bytes: _selectedImageBytes!,
          fileExtension: _selectedImageExtension!,
        );

        data['avatar_url'] = avatarUrl;
      }

      await _profileService.updateProfile(data);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("UPDATE PROFILE ERROR: $e");

      if (!mounted) return;

      _showMessage("Gagal menyimpan profile");

      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColor.primary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _authService.currentUser?.email ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _selectedImageBytes != null
                    ? MemoryImage(_selectedImageBytes!)
                    : widget.profile['avatar_url'] != null &&
                            widget.profile['avatar_url']
                                .toString()
                                .isNotEmpty
                        ? NetworkImage(
                            widget.profile['avatar_url'].toString(),
                          )
                        : null,
                child: _selectedImageBytes == null &&
                        (widget.profile['avatar_url'] == null ||
                            widget.profile['avatar_url'].toString().isEmpty)
                    ? Icon(
                        Icons.person_rounded,
                        size: 52,
                        color: Colors.grey.shade500,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton.icon(
                onPressed: _pickProfileImage,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text("Change Photo"),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Basic Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildTextField(
              label: "First Name",
              controller: _firstNameController,
              icon: Icons.person_outline_rounded,
            ),

            _buildTextField(
              label: "Last Name",
              controller: _lastNameController,
              icon: Icons.person_outline_rounded,
            ),

            _buildTextField(
              label: "Phone Number",
              controller: _phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            TextField(
              enabled: false,
              controller: TextEditingController(
                text: email,
              ),
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(
                  Icons.email_outlined,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (_isEo) ...[
              const SizedBox(height: 12),

              const Text(
                "EO Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              _buildTextField(
                label: "Company Name",
                controller: _companyNameController,
                icon: Icons.business_outlined,
              ),

              _buildTextField(
                label: "Person in Charge",
                controller: _teamLeaderController,
                icon: Icons.groups_outlined,
              ),

              _buildTextField(
                label: "Official Website",
                controller: _websiteController,
                icon: Icons.language_outlined,
                keyboardType: TextInputType.url,
              ),
            ],

           if (_isBoothOwner) ...[
            const SizedBox(height: 12),

            const Text(
              "Business Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildTextField(
              label: "Business Name",
              controller: _brandNameController,
              icon: Icons.storefront_outlined,
            ),

            _buildTextField(
              label: "Official Website",
              controller: _websiteController,
              icon: Icons.language_outlined,
              keyboardType: TextInputType.url,
            ),
          ],
          

            if (_isEo || _isBoothOwner) ...[
              const SizedBox(height: 12),

              const Text(
                "Social Media",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              _buildTextField(
                label: "Instagram",
                controller: _instagramController,
                icon: Icons.camera_alt_outlined,
              ),

              _buildTextField(
                label: "Facebook",
                controller: _facebookController,
                icon: Icons.facebook_outlined,
              ),

              _buildTextField(
                label: "TikTok",
                controller: _tiktokController,
                icon: Icons.music_note_outlined,
              ),

              _buildTextField(
                label: "X",
                controller: _xController,
                icon: Icons.close,
              ),
            ],

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}