import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/event_service.dart';
import '../widgets/create_event/event_information_step.dart';
import '../widgets/create_event/venue_schedule_step.dart';
import '../widgets/create_event/booth_configuration_step.dart';
import '../widgets/create_event/review_publish_step.dart';
import '../widgets/create_event/event_step_indicator.dart';
import '../widgets/create_event/event_navigation.dart';
import '../widgets/create_event/event_validators.dart';
import 'event_success_page.dart';
import 'dart:typed_data';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({
    super.key,
  });

  @override
  State<CreateEventPage> createState() =>
      _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final EventService _eventService = EventService();

  int currentStep = 0;
  bool isSubmitting = false;
  bool agree = false;

  final eventNameController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  String? selectedCategory;

  Uint8List? bannerImage;
  Uint8List? logoImage;
  Uint8List? floorplanImage;

  bool isIndoor = false;

  final venueController =
  TextEditingController();

  final addressController =
  TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  final maximumBoothController =
  TextEditingController();

  final registrationFeeController =
  TextEditingController();

  DateTime? registrationDeadline;

  List<String> selectedBoothCategories = [];

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    eventNameController.dispose();
    descriptionController.dispose();

    venueController.dispose();
    addressController.dispose();

    maximumBoothController.dispose();
    registrationFeeController.dispose();

    super.dispose();
  }

  Future<Uint8List?> pickImage() async {
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (result == null) return null;

    return await result.readAsBytes();
  }

  Future pickBanner() async {
    final image = await pickImage();

    if (image == null) return;

    setState(() {
      bannerImage = image;
    });
  }

  Future pickLogo() async {
    final image = await pickImage();

    if (image == null) return;

    setState(() {
      logoImage = image;
    });
  }

  Future pickFloorplan() async {
    final image = await pickImage();

    if (image == null) return;

    setState(() {
      floorplanImage = image;
    });
  }

  Future<void> selectStartDate() async {

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate:
      startDate ?? DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      startDate = picked;
    });
  }

  Future<void> selectEndDate() async {

    final picked = await showDatePicker(
      context: context,
      firstDate:
      startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
      initialDate:
      endDate ??
          startDate ??
          DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      endDate = picked;
    });
  }

  Future<void> selectDeadline() async {

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate:
      startDate ?? DateTime(2100),
      initialDate:
      registrationDeadline ??
          DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      registrationDeadline = picked;
    });
  }
  Future<void> selectOpeningTime() async {

    final picked = await showTimePicker(
      context: context,
      initialTime:
      openingTime ??
          const TimeOfDay(
            hour: 8,
            minute: 0,
          ),
    );

    if (picked == null) return;

    setState(() {
      openingTime = picked;
    });
  }

  Future<void> selectClosingTime() async {

    final picked = await showTimePicker(
      context: context,
      initialTime:
      closingTime ??
          const TimeOfDay(
            hour: 21,
            minute: 0,
          ),
    );

    if (picked == null) return;

    setState(() {
      closingTime = picked;
    });
  }

  void toggleBoothCategory(
      String category) {

    setState(() {

      if (selectedBoothCategories
          .contains(category)) {

        selectedBoothCategories
            .remove(category);

      } else {

        selectedBoothCategories
            .add(category);

      }

    });
  }

  void nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    } else {
      publishEvent();
    }
  }

  void previousStep() {

    if (currentStep == 0) return;

    setState(() {
      currentStep--;
    });
  }

  Future<void> submitEvent() async {

    setState(() {
      isSubmitting = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      isSubmitting = false;
    });
  }

  Widget buildStepBody() {

    switch (currentStep) {

      case 0:
        return EventInformationStep(
          eventNameController: eventNameController,
          descriptionController: descriptionController,

          selectedCategory: selectedCategory,

          onCategoryChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
          },

          bannerImage: bannerImage,
          logoImage: logoImage,

          onBannerTap: pickBanner,
          onLogoTap: pickLogo,
        );

      case 1:
        return VenueScheduleStep(

          isIndoor: isIndoor,

          onEventTypeChanged: (value) {
            setState(() {
              isIndoor = value;
            });
          },

          venueController: venueController,
          addressController: addressController,

          startDate: startDate,
          endDate: endDate,

          openingTime: openingTime,
          closingTime: closingTime,

          onStartDateTap: selectStartDate,
          onEndDateTap: selectEndDate,

          onOpeningTimeTap: selectOpeningTime,
          onClosingTimeTap: selectClosingTime,

          floorplan: floorplanImage,
          onFloorplanTap: pickFloorplan,
        );

      case 2:
        return BoothConfigurationStep(

          maximumBoothController:
          maximumBoothController,

          registrationFeeController:
          registrationFeeController,

          registrationDeadline:
          registrationDeadline,

          onDeadlineTap:
          selectDeadline,

          selectedCategories:
          selectedBoothCategories,

          onCategoryToggle:
          toggleBoothCategory,
        );

      case 3:
        return ReviewPublishStep(

          eventName:
          eventNameController.text,

          category:
          selectedCategory ?? "-",

          description:
          descriptionController.text,

          venue:
          venueController.text,

          address:
          addressController.text,

          startDate:
          startDate == null
              ? "-"
              : "${startDate!.day}/${startDate!.month}/${startDate!.year}",

          endDate:
          endDate == null
              ? "-"
              : "${endDate!.day}/${endDate!.month}/${endDate!.year}",

          openingTime:
          openingTime == null
              ? "-"
              : openingTime!.format(context),

          closingTime:
          closingTime == null
              ? "-"
              : closingTime!.format(context),

          maximumBooth:
          maximumBoothController.text,

          registrationFee:
          registrationFeeController.text,

          categories:
          selectedBoothCategories,

          banner:
          bannerImage,

          logo:
          logoImage,

          floorplan:
          floorplanImage,

          agree:
          agree,

          onAgreeChanged: (value) {

            setState(() {

              agree = value ?? false;

            });

          },
        );

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
        title: const Text(
          "Create Event",
        ),
      ),

      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: EventStepIndicator(
              currentStep: currentStep,
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: buildStepBody(),
            ),
          ),

          EventNavigation(
            currentStep: currentStep,
            totalStep: 4,
            onBack: previousStep,
            onNext: onNextPressed,
            isLoading: isSubmitting,
          ),
        ],
      ),
    );
  }

  String? validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return CreateEventValidator.validateStep1(
          eventName: eventNameController.text,
          category: selectedCategory,
          banner: bannerImage,
          logo: logoImage,
        );

      case 1:
        return CreateEventValidator.validateStep2(
          isIndoor: isIndoor,
          venue: venueController.text,
          address: addressController.text,
          startDate: startDate,
          endDate: endDate,
          openingTime: openingTime,
          closingTime: closingTime,
          floorplan: floorplanImage,
        );

      case 2:
        return CreateEventValidator.validateStep3(
          maximumBooth: maximumBoothController.text,
          registrationFee: registrationFeeController.text,
          registrationDeadline: registrationDeadline,
          startDate: startDate,
          categories: selectedBoothCategories,
        );

      case 3:
        return CreateEventValidator.validateStep4(
          agree: agree,
        );

      default:
        return null;
    }
  }

  void showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void onNextPressed() {
    final error = validateCurrentStep();
    if (error != null) {
      showValidationError(error);
      return;
    }

    nextStep();
  }

  Future publishEvent() async {
    if (!agree) {
      showValidationError(
        "Please complete all required information.",
      );
      return;
    }

    if (startDate == null || endDate == null) {
      showValidationError(
        "Start date dan end date wajib diisi.",
      );
      return;
    }

    if (bannerImage == null) {
      showValidationError(
        "Banner event wajib dipilih.",
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final categoryId =
          await _eventService.getCategoryIdByName(
        selectedCategory!,
      );

      if (categoryId == null) {
        throw Exception(
          "Kategori '$selectedCategory' tidak ditemukan di database.",
        );
      }

      final bannerUrl =
          await _eventService.uploadEventBanner(
        bytes: bannerImage!,
        fileName:
            'event-banner-${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      debugPrint("BANNER URL: $bannerUrl");

      await _eventService.createEvent(
        title: eventNameController.text.trim(),
        description: descriptionController.text.trim(),
        banner: bannerUrl,
        location: addressController.text.trim(),
        startDate: startDate!,
        endDate: endDate!,
        categoryId: categoryId,
      );

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const EventSuccessPage(),
        ),
      );
    } catch (e) {
      debugPrint("CREATE EVENT ERROR: $e");

      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      showValidationError(
        "Gagal membuat event: $e",
      );
    }
  }
}