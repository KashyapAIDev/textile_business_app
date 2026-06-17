import 'package:flutter/material.dart';
import '../utils/colors.dart';

class InquiryScreen extends StatefulWidget {
  final String? prefilledProductName;
  final String? prefilledCategory;

  const InquiryScreen({
    super.key,
    this.prefilledProductName,
    this.prefilledCategory,
  });

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController productController;
  late final TextEditingController quantityController;
  late final TextEditingController cityController;
  late final TextEditingController messageController;

  String? selectedCategory;

  final List<String> categories = ["Sarees", "Fabrics", "Kurtis", "Bedsheets"];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    productController = TextEditingController(
      text: widget.prefilledProductName,
    );
    quantityController = TextEditingController();
    cityController = TextEditingController();
    messageController = TextEditingController();

    // Set default category if it matches our list
    if (widget.prefilledCategory != null &&
        categories.contains(widget.prefilledCategory)) {
      selectedCategory = widget.prefilledCategory;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    productController.dispose();
    quantityController.dispose();
    cityController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextileColors.background,
      appBar: AppBar(
        title: const Text(
          "Send Inquiry",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: TextileColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TextileColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TextileColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: TextileColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Fill out the inquiry form below. Our B2B sales team will get back to you with custom catalog options and quotes within 24 hours.",
                        style: TextStyle(
                          fontSize: 12,
                          color: TextileColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Customer Details
              const Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TextileColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Customer Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: TextileColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: TextileColors.cardBackground,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  hintText: "Enter 10-digit mobile number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: TextileColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: TextileColors.cardBackground,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (value.replaceAll(RegExp(r'\D'), '').length < 8) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter your email (optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: TextileColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: TextileColors.cardBackground,
                ),
              ),

              const SizedBox(height: 24),

              // Product Details
              const Text(
                "Inquiry Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: TextileColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  labelText: "Product Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.category,
                    color: TextileColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: TextileColors.cardBackground,
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a product category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: productController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                  hintText: "Specify the product / fabric design name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.shopping_bag,
                    color: TextileColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: TextileColors.cardBackground,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product/fabric details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Quantity Needed",
                        hintText: "e.g., 50 meters, 5 pieces",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.inventory,
                          color: TextileColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: TextileColors.cardBackground,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: "City",
                        hintText: "Your city",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.location_city,
                          color: TextileColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: TextileColors.cardBackground,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Additional Requirements",
                  hintText:
                      "Provide color specifications, custom prints, or timeline requests...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.message,
                    color: TextileColors.textSecondary,
                  ),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: TextileColors.cardBackground,
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TextileColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Submit Business Inquiry",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid - process submission
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TextileColors.accent),
          ),
        ),
      );

      // Simulate network request
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pop(context); // Close loading indicator

        // Show Success Dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: TextileColors.success,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text("Inquiry Received"),
              ],
            ),
            content: const Text(
              "Thank you for reaching out! Your inquiry has been sent to our sales coordinators. We will contact you soon.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  Navigator.pop(context); // Navigate back to preceding screen
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: TextileColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
  }
}
