import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../services/whatsapp_service.dart';
import 'inquiry_screen.dart';
import '../services/state_manager.dart';
import 'cart_screen.dart';
import '../widgets/animated_entrance.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int activeImageIndex = 0;
  bool isFavorite = false;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount = product.hasDiscount;
    final activePrice = product.discountPrice ?? product.price;

    return Scaffold(
      backgroundColor: TextileColors.background,
      body: Stack(
        children: [
          // Scrollable details content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 100,
            ), // padding for sticky bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Image Carousel
                _buildImageCarousel(product),

                // Content Card
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Stock Status Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: TextileColors.primary.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: const TextStyle(
                                color: TextileColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStockColor(
                                product.stockStatus,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.stockStatus,
                              style: TextStyle(
                                color: _getStockColor(product.stockStatus),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Product Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: TextileColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Ratings & Review Summary
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: TextileColors.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TextileColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "(${product.reviewsCount} customer reviews)",
                            style: const TextStyle(
                              fontSize: 13,
                              color: TextileColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pricing section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "₹${activePrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: TextileColors.primary,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 12),
                            Text(
                              "₹${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: TextileColors.textLight,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: TextileColors.secondary.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${product.discountPercentage}% OFF",
                                style: const TextStyle(
                                  color: TextileColors.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(width: 4),
                          Text(
                            product.category == 'Fabrics' ? 'per meter' : '',
                            style: const TextStyle(
                              color: TextileColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Textile Specification Grid
                      const Text(
                        "Fabric Specifications",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TextileColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSpecificationsGrid(product),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TextileColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: TextileColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom overlay App Bar for navigation
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: TextileColors.textPrimary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    ListenableBuilder(
                      listenable: CartNotifier.instance,
                      builder: (context, _) {
                        final count = CartNotifier.instance.totalItemsCount;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: TextileColors.textPrimary,
                                  size: 20,
                                ),
                                if (count > 0)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: TextileColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite
                                  ? "${product.name} added to favorites"
                                  : "${product.name} removed from favorites",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? TextileColors.error
                              : TextileColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sticky bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStickyBottomActionBar(product),
          ),
        ],
      ),
    );
  }

  // Large Hero Sliding image carousel
  Widget _buildImageCarousel(Product product) {
    final images = product.images.isNotEmpty
        ? product.images
        : [product.imageUrl];
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.40,
      width: double.infinity,
      child: Stack(
        children: [
          // Slide Builder
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) {
              setState(() {
                activeImageIndex = idx;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, err, stack) {
                  return Container(
                    color: TextileColors.surface,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 80,
                      color: TextileColors.textLight,
                    ),
                  );
                },
              );
            },
          ),

          // Custom dot indicator overlay
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (idx) {
                  final isActive = activeImageIndex == idx;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 8,
                    width: isActive ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? TextileColors.accent
                          : Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

          // Out of stock mask overlay
          if (!product.isAvailable)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "OUT OF STOCK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Dynamic grid of textile properties
  Widget _buildSpecificationsGrid(Product product) {
    final specs = [
      {
        "label": "Fabric Type",
        "value": product.fabricType,
        "icon": Icons.texture,
      },
      {"label": "Pattern/Weave", "value": product.pattern, "icon": Icons.style},
      {
        "label": "Fabric Width",
        "value": product.width,
        "icon": Icons.square_foot,
      },
      {
        "label": "Weight (GSM)",
        "value": "${product.gsm} gsm",
        "icon": Icons.monitor_weight_outlined,
      },
      {
        "label": "Color Tone",
        "value": product.color,
        "icon": Icons.palette_outlined,
      },
      {
        "label": "Min. Order Qty",
        "value": product.minOrderQty,
        "icon": Icons.shopping_basket_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final spec = specs[index];
        return AnimatedEntrance(
          delay: Duration(milliseconds: index * 50),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: TextileColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TextileColors.border, width: 0.8),
            ),
            child: Row(
              children: [
                Icon(
                  spec["icon"] as IconData,
                  color: TextileColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spec["label"] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: TextileColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      spec["value"] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: TextileColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }

  // Bottom action sheet
  Widget _buildStickyBottomActionBar(Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quantity Selector & Add to Cart button Row
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: TextileColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: TextileColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TextileColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: TextileColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ListenableBuilder(
                    listenable: CartNotifier.instance,
                    builder: (context, _) {
                      final inCart = CartNotifier.instance.isInCart(product);
                      return ElevatedButton.icon(
                        onPressed: () {
                          CartNotifier.instance.addItem(
                            product,
                            quantity: quantity,
                          );
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "$quantity x ${product.name} in cart!",
                              ),
                              backgroundColor: TextileColors.success,
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: "VIEW",
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: inCart
                              ? TextileColors.accent
                              : TextileColors.primary,
                          foregroundColor: inCart
                              ? TextileColors.textPrimary
                              : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(
                          inCart ? Icons.shopping_bag : Icons.add_shopping_cart,
                          size: 18,
                        ),
                        label: Text(
                          inCart ? "Update Quantity" : "Add to Cart",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Business buttons grid
          Row(
            children: [
              // 1. inquiry Form button
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InquiryScreen(
                            prefilledProductName: product.name,
                            prefilledCategory: product.category,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TextileColors.primary,
                      side: const BorderSide(
                        color: TextileColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Inquiry Form",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 2. WhatsApp ordering button
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final orderMsg = WhatsAppService.formatOrderMessage(
                        product,
                        quantity,
                      );
                      WhatsAppService.launchWhatsApp(message: orderMsg);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TextileColors.success,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text(
                      "Order WhatsApp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStockColor(String status) {
    switch (status.toLowerCase()) {
      case 'in stock':
        return TextileColors.success;
      case 'low stock':
        return TextileColors.warning;
      case 'out of stock':
      default:
        return TextileColors.error;
    }
  }
}
