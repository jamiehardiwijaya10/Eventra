import 'package:flutter/material.dart';
import '../../../../core/services/booth_service.dart';
import '../../../../core/theme/app_color.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../shared/widgets/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final BoothService _boothService = BoothService();
  final SupabaseClient _client = Supabase.instance.client;
  
  Uint8List? productImage;
  bool isUploadingImage = false;

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController stockController;

  String? category;
  bool isAvailable = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    nameController = TextEditingController(
      text: product['name']?.toString() ?? '',
    );

    priceController = TextEditingController(
      text: product['price']?.toString() ?? '',
    );

    descriptionController = TextEditingController(
      text: product['description']?.toString() ?? '',
    );

    stockController = TextEditingController(
      text: product['available_stock']?.toString() ?? '0',
    );

    category = product['category']?.toString();

    isAvailable = product['is_available'] == true;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<String?> uploadNewImage() async {
    if (productImage == null) return null;

    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User belum login");
    }

    final fileName = '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage
        .from('product_images')
        .uploadBinary(
          fileName,
          productImage!,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    return _client.storage.from('product_images').getPublicUrl(fileName);
  }

  Future<void> save() async {
    if (nameController.text.trim().isEmpty ||
        category == null ||
        priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama, category, dan price wajib diisi")),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      String? newImageUrl;
      if (productImage != null) {
        newImageUrl = await uploadNewImage();

        if (newImageUrl != null) {
          final oldImage = widget.product['image']?.toString();

          if (oldImage != null && oldImage.isNotEmpty) {
            final uri = Uri.parse(oldImage);
            const marker = '/storage/v1/object/public/product_images/';

            if (uri.path.contains(marker)) {
              final oldPath = uri.path.split(marker).last;

              await _client.storage.from('product_images').remove([oldPath]);
            }
          }
        }
      }

      await _boothService.updateProduct(
        productId: widget.product['id'].toString(),
        name: nameController.text.trim(),
        category: category!,
        description: descriptionController.text.trim(),
        price: num.tryParse(priceController.text.trim()) ?? 0,
        availableStock: int.tryParse(stockController.text.trim()) ?? 0,
        isAvailable: isAvailable,
        image: newImageUrl,
      );
      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal update product: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Edit Product"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final image = await ImagePickerService.pickFromGallery();

                if (image == null) return;

                setState(() {
                  productImage = image;
                });
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: productImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(productImage!, fit: BoxFit.cover),
                      )
                    : (widget.product['image'] != null &&
                          widget.product['image'].toString().isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.product['image'].toString(),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 40),
                          SizedBox(height: 8),
                          Text("Pilih Product Image"),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Food", child: Text("Food")),
                DropdownMenuItem(value: "Drink", child: Text("Drink")),
                DropdownMenuItem(value: "Snack", child: Text("Snack")),
              ],
              onChanged: (value) {
                setState(() {
                  category = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stock",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Product Available"),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
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
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
