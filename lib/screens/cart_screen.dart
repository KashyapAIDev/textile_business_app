import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/state_manager.dart';
import '../services/whatsapp_service.dart';
import '../widgets/animated_entrance.dart';
import 'inquiry_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _checkoutWhatsApp(
    BuildContext context,
    List<CartItem> items,
    double totalAmount,
  ) {
    if (items.isEmpty) return;

    StringBuffer buffer = StringBuffer();
    buffer.writeln(
      "Hello! I would like to place a wholesale order for the following cart items:\n",
    );

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final product = item.product;
      final price = product.discountPrice ?? product.price;
      final itemTotal = price * item.quantity;

      buffer.writeln("${i + 1}. *${product.name}*");
      buffer.writeln(
        "   🧵 Fabric: ${product.fabricType} | Weave: ${product.pattern}",
      );
      buffer.writeln("   🎨 Color: ${product.color} | Width: ${product.width}");
      buffer.writeln(
        "   🔢 Qty: ${item.quantity} | Rate: ₹${price.toStringAsFixed(0)}",
      );
      buffer.writeln("   💰 Item Total: ₹${itemTotal.toStringAsFixed(0)}");
      buffer.writeln("");
    }

    buffer.writeln("--------------------------------");
    buffer.writeln("🏁 *Estimated Total*: ₹${totalAmount.toStringAsFixed(2)}");
    buffer.writeln(
      "\nPlease confirm availability and share invoice details. Thank you!",
    );

    WhatsAppService.launchWhatsApp(message: buffer.toString());
  }

  void _submitCartInquiry(BuildContext context, List<CartItem> items) {
    if (items.isEmpty) return;

    // Prefill product details from the list of cart items
    final productNames = items
        .map((item) => "${item.product.name} (Qty: ${item.quantity})")
        .join(", ");
    final firstCategory = items.first.product.category;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InquiryScreen(
          prefilledProductName: productNames,
          prefilledCategory: firstCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextileColors.background,
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: TextileColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          ListenableBuilder(
            listenable: CartNotifier.instance,
            builder: (context, _) {
              final cart = CartNotifier.instance;
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: "Clear Cart",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Clear Cart"),
                      content: const Text(
                        "Are you sure you want to remove all items from your cart?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(
                              color: TextileColors.textSecondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            cart.clearCart();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "CLEAR",
                            style: TextStyle(
                              color: TextileColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: CartNotifier.instance,
        builder: (context, _) {
          final cart = CartNotifier.instance;
          final items = cart.items;

          if (items.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AnimatedEntrance(
                      delay: Duration(milliseconds: index * 60),
                      child: _buildCartItemCard(context, cart, item),
                    );
                  },
                ),
              ),
              _buildPriceSummaryCard(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: TextileColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: TextileColors.textLight.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Cart is Empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TextileColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add premium silks, fabrics, or bedding to compile a bulk inquiry or place direct orders.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: TextileColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close cart screen to go back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TextileColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Continue Browsing"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartNotifier cart,
    CartItem item,
  ) {
    final product = item.product;
    final singlePrice = product.discountPrice ?? product.price;
    final itemTotal = singlePrice * item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TextileColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TextileColors.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              SizedBox(
                width: 100,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: TextileColors.surface,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: TextileColors.textLight,
                    ),
                  ),
                ),
              ),

              // Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: TextileColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => cart.removeItem(product),
                            child: const Icon(
                              Icons.delete_outline,
                              color: TextileColors.error,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${product.fabricType} | Qty min: ${product.minOrderQty}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: TextileColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Price & Quantity control
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹${singlePrice.toStringAsFixed(0)}${product.category == 'Fabrics' ? '/m' : ''}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: TextileColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "₹${itemTotal.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: TextileColors.primary,
                                ),
                              ),
                            ],
                          ),

                          // Quantity Selector
                          Container(
                            decoration: BoxDecoration(
                              color: TextileColors.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cart.updateQuantity(
                                      product,
                                      item.quantity - 1,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: TextileColors.primary,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: TextileColors.textPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cart.updateQuantity(
                                      product,
                                      item.quantity + 1,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                      color: TextileColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummaryCard(BuildContext context, CartNotifier cart) {
    final double subtotal = cart.totalAmount;
    final double gst = subtotal * 0.05; // 5% GST on textiles
    final double grandTotal = subtotal + gst;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pricing rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subtotal (excl. tax)",
                  style: TextStyle(
                    color: TextileColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "₹${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: TextileColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Est. GST (5%)",
                  style: TextStyle(
                    color: TextileColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "₹${gst.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: TextileColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: TextileColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: TextileColors.textPrimary,
                  ),
                ),
                Text(
                  "₹${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: TextileColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkout options
            Row(
              children: [
                // 1. Inquiry Form Option
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => _submitCartInquiry(context, cart.items),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TextileColors.primary,
                        side: const BorderSide(
                          color: TextileColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Inquiry Form",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. WhatsApp Checkout Option
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _checkoutWhatsApp(context, cart.items, grandTotal),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TextileColors.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.chat, size: 18),
                      label: const Text(
                        "Order WhatsApp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
