import 'package:flutter/material.dart';
import '../services/whatsapp_service.dart';
import '../utils/colors.dart';

class WhatsAppScreen extends StatefulWidget {
  const WhatsAppScreen({super.key});

  @override
  State<WhatsAppScreen> createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen> {
  void openWhatsApp() async {
    const String message =
        "Hello! I am browsing your textile catalog and would like to inquire about fabrics and bulk order options. Please share the details.";
    WhatsAppService.launchWhatsApp(message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextileColors.background,
      appBar: AppBar(
        title: const Text(
          "WhatsApp Order",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: TextileColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Large stylized WhatsApp Circle Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: TextileColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  size: 80,
                  color: TextileColors.success,
                ),
              ),
              const SizedBox(height: 24),

              // Informative Headline
              const Text(
                "Direct WhatsApp Checkout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TextileColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Chat directly with our B2B sales desk to place custom fabric orders, get quantity discounts, or ask for specific fabric rolls.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: TextileColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // How it works card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: TextileColors.border,
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "How to Order:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TextileColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStepRow(
                        num: "1",
                        title: "Browse & Select",
                        desc:
                            "Go to the Product Catalog and choose your fabrics.",
                      ),
                      const Divider(height: 24),
                      _buildStepRow(
                        num: "2",
                        title: "Set Quantity",
                        desc:
                            "Use the item page counter to set lengths or pieces.",
                      ),
                      const Divider(height: 24),
                      _buildStepRow(
                        num: "3",
                        title: "Chat & Finalize",
                        desc:
                            "Tap 'Order WhatsApp' on the item page to send pre-filled details.",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Large Call-To-Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: openWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TextileColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.chat, size: 20),
                  label: const Text(
                    "Open WhatsApp Chat",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Typical response time: under 15 minutes",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: TextileColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String num,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: TextileColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              num,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TextileColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: TextileColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
