import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/booth_service.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../shared/widgets/image_picker.dart';

class EditBoothPage extends StatefulWidget {
  final Map<String, dynamic> booth;

  const EditBoothPage({
    super.key,
    required this.booth,
  });

  @override
  State<EditBoothPage> createState() => _EditBoothPageState();
}

class _EditBoothPageState extends State<EditBoothPage> {
  final BoothService _boothService = BoothService();
  final SupabaseClient _client = Supabase.instance.client;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  late final TextEditingController ownerNameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController instagramController;

  String? selectedCategory;
  String? selectedBusinessType;

  Uint8List? logoImage;
  Uint8List? bannerImage;
  Uint8List? boothPhotoImage;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    final booth = widget.booth;

    ownerNameController = TextEditingController(
      text: widget.booth['owner_name']?.toString() ?? '',
    );

    phoneController = TextEditingController(
      text: widget.booth['phone']?.toString() ?? '',
    );

    emailController = TextEditingController(
      text: widget.booth['email']?.toString() ?? '',
    );

    instagramController = TextEditingController(
      text: widget.booth['instagram']?.toString() ?? '',
    );

    nameController = TextEditingController(
      text: booth['name']?.toString() ?? '',
    );

    descriptionController = TextEditingController(
      text: booth['description']?.toString() ?? '',
    );

    selectedCategory = booth['category']?.toString();
    selectedBusinessType = booth['business_type']?.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();

    ownerNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    instagramController.dispose();
  }

  Future<Uint8List?> pickImage() async {
    return await ImagePickerService.pickFromGallery();
  }

  Future<String?> uploadImage(
    Uint8List image,
    String type,
  ) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final fileName =
        '${user.id}/${type}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage
        .from('booth_images')
        .uploadBinary(
          fileName,
          image,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    return _client.storage
        .from('booth_images')
        .getPublicUrl(fileName);
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty) {
      showMessage("Nama booth wajib diisi");
      return;
    }

    if (selectedCategory == null) {
      showMessage("Category wajib dipilih");
      return;
    }

    if (selectedBusinessType == null) {
      showMessage("Business Type wajib dipilih");
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      showMessage("Description wajib diisi");
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      String? newLogo;
      String? newBanner;
      String? newBoothPhoto;

      if (logoImage != null) {
        newLogo = await uploadImage(
          logoImage!,
          'logo',
        );
      }

      if (bannerImage != null) {
        newBanner = await uploadImage(
          bannerImage!,
          'banner',
        );
      }

      if (boothPhotoImage != null) {
        newBoothPhoto = await uploadImage(
          boothPhotoImage!,
          'booth_photo',
        );
      }

      await _boothService.updateBooth(
        boothId: widget.booth['id'].toString(),

        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory!,
        businessType: selectedBusinessType!,

        ownerName: ownerNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        instagram: instagramController.text.trim(),

        logo: newLogo,
        banner: newBanner,
        boothPhoto: newBoothPhoto,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      showMessage("Gagal update booth: $e");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget imagePickerCard({
    required String title,
    required String? existingUrl,
    required Uint8List? selectedImage,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      selectedImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : existingUrl != null &&
                        existingUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          existingUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _emptyImage(icon);
                          },
                        ),
                      )
                    : _emptyImage(icon),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _emptyImage(IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 42,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        const Text("Tap untuk mengganti gambar"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Edit Booth"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            imagePickerCard(
              title: "Booth Logo",
              existingUrl: widget.booth['logo']?.toString(),
              selectedImage: logoImage,
              icon: Icons.storefront_outlined,
              onTap: () async {
                final image = await pickImage();

                if (image == null) return;

                setState(() {
                  logoImage = image;
                });
              },
            ),

            imagePickerCard(
              title: "Booth Banner",
              existingUrl: widget.booth['banner']?.toString(),
              selectedImage: bannerImage,
              icon: Icons.image_outlined,
              onTap: () async {
                final image = await pickImage();

                if (image == null) return;

                setState(() {
                  bannerImage = image;
                });
              },
            ),

            imagePickerCard(
              title: "Booth Photo",
              existingUrl: widget.booth['booth_photo']?.toString(),
              selectedImage: boothPhotoImage,
              icon: Icons.photo_camera_outlined,
              onTap: () async {
                final image = await pickImage();

                if (image == null) return;

                setState(() {
                  boothPhotoImage = image;
                });
              },
            ),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Booth Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Food",
                  child: Text("Food"),
                ),
                DropdownMenuItem(
                  value: "Beverage",
                  child: Text("Beverage"),
                ),
                DropdownMenuItem(
                  value: "Fashion",
                  child: Text("Fashion"),
                ),
                DropdownMenuItem(
                  value: "Accessories",
                  child: Text("Accessories"),
                ),
                DropdownMenuItem(
                  value: "Craft",
                  child: Text("Craft"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: selectedBusinessType,
              decoration: const InputDecoration(
                labelText: "Business Type",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Individual",
                  child: Text("Individual"),
                ),
                DropdownMenuItem(
                  value: "UMKM",
                  child: Text("UMKM"),
                ),
                DropdownMenuItem(
                  value: "Company",
                  child: Text("Company"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedBusinessType = value;
                });
              },
            ),

            const SizedBox(height: 18),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 28),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: "Owner Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: instagramController,
              decoration: const InputDecoration(
                labelText: "Instagram",
                prefixText: "@",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
