import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/registration/product_selector.dart';
import '../widgets/registration/step_indicator.dart';
import '../widgets/registration/registration_navigation.dart';
import '../widgets/registration/steps/booth_information_step.dart';
import '../widgets/registration/steps/contact_information_step.dart';
import '../widgets/registration/steps/upload_assets_step.dart';
import '../widgets/registration/steps/review_submit_step.dart';
import '../widgets/registration/validator.dart';
import 'registration_success_page.dart';
import 'add_product_page.dart';
import '../../../shared/widgets/image_picker.dart';
import '../../../core/services/booth_service.dart';

class RegistrationFormPage extends StatefulWidget {
  final String eventId;

  const RegistrationFormPage({
    super.key,
    required this.eventId,
  });

  @override
  State<RegistrationFormPage> createState() =>
      _RegistrationFormPageState();
}

class _RegistrationFormPageState
    extends State<RegistrationFormPage> {

  int currentStep = 0;

  final BoothService _boothService = BoothService();
  bool agree = false;
  bool isSubmitting = false;

  final boothNameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedBusinessType;

  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final instagramController = TextEditingController();

  Uint8List? logoImage;
  Uint8List? bannerImage;
  Uint8List? boothImage;

  List<ProductSelectorModel> products = [];

  bool isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    loadMyProducts();
  }

  Future<void> loadMyProducts() async {
    try {
      final data = await _boothService.getMyProducts();

      if (!mounted) return;

      setState(() {
        products = data.map((product) {
          return ProductSelectorModel(
            id: product['id'].toString(),
            name: product['name']?.toString() ?? '-',
            category: product['category']?.toString() ?? '-',
            price: product['price']?.toString() ?? '0',
            description:
                product['description']?.toString() ?? '',
            image: product['image']?.toString() ?? '',
            availableStock:
                int.tryParse(
                      product['available_stock']
                              ?.toString() ??
                          '0',
                    ) ??
                    0,
            isAvailable:
                product['is_available'] == true,
          );
        }).toList();

        isLoadingProducts = false;
      });
    } catch (e) {
      debugPrint("LOAD PRODUCTS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoadingProducts = false;
      });

      showError("Gagal memuat products");
    }
  }

  @override
  void dispose() {

    boothNameController.dispose();
    descriptionController.dispose();

    ownerNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    instagramController.dispose();

    super.dispose();
  }

  Future<void> pickLogo() async {
    final image = await ImagePickerService.pickFromGallery();

    if (image == null) return;

    setState(() {
      logoImage = image;
    });
  }

  Future<void> pickBanner() async {
    final image = await ImagePickerService.pickFromGallery();

    if (image == null) return;

    setState(() {
      bannerImage = image;
    });
  }

  Future<void> pickBoothPhoto() async {
    final image = await ImagePickerService.pickFromGallery();

    if (image == null) return;

    setState(() {
      boothImage = image;
    });
  }

  void nextStep() {

    String? error;

    switch (currentStep) {

      case 0:
        error = RegistrationValidator.validateBooth(
          boothName: boothNameController.text,
          category: selectedCategory,
          businessType: selectedBusinessType,
          description: descriptionController.text,
        );
        break;

      case 1:
        error = RegistrationValidator.validateContact(
          owner: ownerNameController.text,
          phone: phoneController.text,
          email: emailController.text,
        );
        break;

      case 2:
        error = RegistrationValidator.validateUpload(
          logo: logoImage,
          banner: bannerImage,
          booth: boothImage,
        );
        break;

      case 3:
        error = RegistrationValidator.validateAgreement(
          agree: agree,
        );
        break;
    }

    if (error != null) {
      showError(error);
      return;
    }

    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    } else {
      submitRegistration();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

    Future<String?> uploadRegistrationImage(
    Uint8List? image,
    String type,
  ) async {
    if (image == null) return null;

    return await _boothService.uploadBoothImage(
      type: type,
      image: image,
    );
  }

  Future<void> submitRegistration() async {
    if (!agree) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final logoUrl = await uploadRegistrationImage(
        logoImage,
        'logo',
      );

      final bannerUrl = await uploadRegistrationImage(
        bannerImage,
        'banner',
      );

      final boothPhotoUrl = await uploadRegistrationImage(
        boothImage,
        'booth_photo',
      );

      final booth = await _boothService.createBooth(
        eventId: widget.eventId,
        name: boothNameController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory!,
        businessType: selectedBusinessType!,
        ownerName: ownerNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        instagram: instagramController.text.trim(),
        logo: logoUrl,
        banner: bannerUrl,
        boothPhoto: boothPhotoUrl,
      );

      final boothId = booth['id'].toString();

      final selectedProducts = products
          .where((product) => product.selected)
          .map((product) {
        return ProductCopyData(
          name: product.name,
          category: product.category,
          description: product.description,
          price:
              num.tryParse(product.price) ?? 0,
          availableStock: product.availableStock,
          image: product.image,
          isAvailable: product.isAvailable,
        );
      }).toList();

      await _boothService.copyProductsToBooth(
        boothId: boothId,
        products: selectedProducts,
      );

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RegistrationSuccessPage(),
        ),
      );
    } catch (e) {
      debugPrint("REGISTER BOOTH ERROR: $e");

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      showError(
        "Gagal mendaftarkan booth: $e",
      );
    }
  }

  Widget buildStepBody() {
    switch (currentStep) {

      case 0:
        return _boothStep();

      case 1:
        return _contactStep();

      case 2:
        return _uploadStep();

      case 3:
        return _reviewStep();

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("Register Booth"),
      ),

      body: Column(

        children: [

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: RegistrationStepIndicator(
              currentStep: currentStep,
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: buildStepBody(),
            ),
          ),

          RegistrationNavigation(
            currentStep: currentStep,
            totalStep: 4,
            onBack: previousStep,
            onNext: nextStep,
          ),

        ],
      ),
    );
  }

 Widget _boothStep() {
    if (isLoadingProducts) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BoothInformationStep(
      boothNameController: boothNameController,
      descriptionController: descriptionController,

      selectedCategory: selectedCategory,
      selectedBusinessType: selectedBusinessType,

      onCategoryChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },

      onBusinessTypeChanged: (value) {
        setState(() {
          selectedBusinessType = value;
        });
      },

      products: products,

      onAddProduct: () async {
        final added = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddProductPage(),
          ),
        );

        if (added == null) return;

        if (added is ProductSelectorModel) {
          setState(() {
            products.add(added);
          });
        }
      },
    );
  }

  Widget _contactStep() {
    return ContactInformationStep(
      ownerNameController: ownerNameController,
      phoneController: phoneController,
      emailController: emailController,
      instagramController: instagramController,
    );
  }

  Widget _uploadStep() {
    return UploadAssetsStep(
      logoImage: logoImage,
      bannerImage: bannerImage,
      boothImage: boothImage,

      onLogoTap: pickLogo,
      onBannerTap: pickBanner,
      onBoothTap: pickBoothPhoto,
    );
  }

  Widget _reviewStep() {
    return ReviewSubmitStep(
      boothName: boothNameController.text,
      category: selectedCategory ?? "-",
      businessType: selectedBusinessType ?? "-",
      description: descriptionController.text,

      ownerName: ownerNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      instagram: instagramController.text,

      selectedProducts: products
          .where((e) => e.selected)
          .map((e) => e.name)
          .toList(),

      logoImage: logoImage,
      bannerImage: bannerImage,
      boothImage: boothImage,

      agree: agree,

      onAgreeChanged: (value) {
        setState(() {
          agree = value ?? false;
        });
      },

      onEditBooth: () {
        setState(() {
          currentStep = 0;
        });
      },

      onEditContact: () {
        setState(() {
          currentStep = 1;
        });
      },

      onEditProducts: () {
        setState(() {
          currentStep = 0;
        });
      },

      onEditUpload: () {
        setState(() {
          currentStep = 2;
        });
      },
    );
  }
}