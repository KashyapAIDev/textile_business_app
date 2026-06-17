import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';

class WhatsAppService {
  static const String defaultPhone = "918866410100"; // Default business contact

  /// Launch WhatsApp with a given phone number and text message
  static Future<bool> launchWhatsApp({
    String phone = defaultPhone,
    required String message,
  }) async {
    // Standardize phone format (remove symbols, spaces, and lead plus)
    final cleanPhone = phone.replaceAll(RegExp(r'[+\-\s()]+'), '');
    final url =
        "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}";
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Format a WhatsApp order message for a specific product and quantity
  static String formatOrderMessage(Product product, int quantity) {
    final double totalPrice =
        (product.discountPrice ?? product.price) * quantity;

    return "Hello! I would like to place an order for the following textile product:\n\n"
        "📦 *Product*: ${product.name}\n"
        "🏷️ *Category*: ${product.category}\n"
        "🧵 *Fabric*: ${product.fabricType}\n"
        "🎨 *Color*: ${product.color}\n"
        "📏 *Width*: ${product.width}\n"
        "⚖️ *Weight*: ${product.gsm} GSM\n"
        "🔢 *Quantity*: $quantity\n"
        "💰 *Estimated Price*: ₹${totalPrice.toStringAsFixed(2)}\n\n"
        "Please confirm availability and share payment/shipping details. Thank you!";
  }

  /// Format a WhatsApp general inquiry message for a specific product
  static String formatProductInquiryMessage(Product product) {
    return "Hello! I am inquiring about the product *${product.name}* (${product.category}).\n\n"
        "Details:\n"
        "• Fabric: ${product.fabricType}\n"
        "• Pattern: ${product.pattern}\n"
        "• Width: ${product.width}\n"
        "• Min Order: ${product.minOrderQty}\n\n"
        "Could you please share more information regarding bulk pricing, discount tiers, and delivery times for this fabric?";
  }
}
