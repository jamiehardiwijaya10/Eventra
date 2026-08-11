import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../section_titles.dart';

class ReviewSubmitStep extends StatelessWidget {
  final String boothName;
  final String category;
  final String businessType;
  final String description;

  final String ownerName;
  final String phone;
  final String email;
  final String instagram;

  final List<String> selectedProducts;

  final Uint8List? logoImage;
  final Uint8List? bannerImage;
  final Uint8List? boothImage;

  final bool agree;
  final ValueChanged<bool?> onAgreeChanged;

  final VoidCallback onEditBooth;
  final VoidCallback onEditContact;
  final VoidCallback onEditProducts;
  final VoidCallback onEditUpload;

  const ReviewSubmitStep({
    super.key,
    required this.boothName,
    required this.category,
    required this.businessType,
    required this.description,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.instagram,
    required this.selectedProducts,
    required this.logoImage,
    required this.bannerImage,
    required this.boothImage,
    required this.agree,
    required this.onAgreeChanged,
    required this.onEditBooth,
    required this.onEditContact,
    required this.onEditProducts,
    required this.onEditUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const RegistrationSectionTitle(
          title: "Review & Submit",
          subtitle:
          "Please review all information before submitting your registration.",
        ),

        const SizedBox(height: 20),

        _ReviewCard(
          title: "Booth Information",
          onEdit: onEditBooth,
          children: [
            _ReviewTile("Booth Name", boothName),
            _ReviewTile("Category", category),
            _ReviewTile("Business Type", businessType),
            _ReviewTile("Description", description),
          ],
        ),

        const SizedBox(height: 18),

        _ReviewCard(
          title: "Contact Information",
          onEdit: onEditContact,
          children: [
            _ReviewTile("Owner", ownerName),
            _ReviewTile("Phone", phone),
            _ReviewTile("Email", email),
            _ReviewTile("Instagram", instagram),
          ],
        ),

        const SizedBox(height: 18),

        _ReviewCard(
          title: "Selected Products",
          onEdit: onEditProducts,
          children: selectedProducts.isEmpty
              ? const [
            Text("No product selected.")
          ]
              : selectedProducts
              .map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          )
              .toList(),
        ),

        const SizedBox(height: 18),

        _ReviewCard(
          title: "Uploaded Images",
          onEdit: onEditUpload,
          children: [

            _ImagePreview(
              title: "Logo",
              image: logoImage,
            ),

            const SizedBox(height: 12),

            _ImagePreview(
              title: "Banner",
              image: bannerImage,
            ),

            const SizedBox(height: 12),

            _ImagePreview(
              title: "Booth",
              image: boothImage,
            ),

          ],
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: agree,
            activeColor: Colors.orange,
            onChanged: onAgreeChanged,
            title: const Text(
              "I confirm that all information provided is correct.",
            ),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onEdit;

  const _ReviewCard({
    required this.title,
    required this.children,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                ),
                label: const Text("Edit"),
              ),

            ],
          ),

          const Divider(),

          ...children,

        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String title;
  final String value;

  const _ReviewTile(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
            ),
          ),

        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String title;
  final Uint8List? image;

  const _ImagePreview({
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        SizedBox(
          width: 90,
          child: Text(title),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: image == null
              ? Container(
            width: 70,
            height: 70,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image),
          )
              : Image.memory(
            image!,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),

      ],
    );
  }
}