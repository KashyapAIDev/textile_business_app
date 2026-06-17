import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../services/state_manager.dart';
import '../screens/cart_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount = product.hasDiscount;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.03 : 1.0,
            _isHovered ? 1.03 : 1.0,
            1.0,
          ),
          decoration: BoxDecoration(
            color: TextileColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.04),
                blurRadius: _isHovered ? 15 : 10,
                offset: Offset(0, _isHovered ? 6 : 4),
              ),
            ],
            border: Border.all(
              color: _isHovered
                  ? TextileColors.primary.withValues(alpha: 0.5)
                  : TextileColors.border,
              width: 0.8,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image with badges
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedScale(
                        scale: _isHovered ? 1.06 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: Image.network(
                          product.imageUrl,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: TextileColors.surface,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                                color: TextileColors.textLight,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: TextileColors.surface,
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      TextileColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Wishlist / Favorite Icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
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
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? TextileColors.error
                                  : TextileColors.textSecondary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      // Discount Badge
                      if (hasDiscount)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TextileColors.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${product.discountPercentage}% OFF",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Stock Status Badge
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStockColor(
                              product.stockStatus,
                            ).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.stockStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Info
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Fabric Type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.category,
                            style: const TextStyle(
                              color: TextileColors.textLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            product.fabricType,
                            style: const TextStyle(
                              color: TextileColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Product Title
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: TextileColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: TextileColors.accent,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              color: TextileColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${product.reviewsCount})",
                            style: const TextStyle(
                              color: TextileColors.textLight,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Pricing & Add to Cart Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "₹${(product.discountPrice ?? product.price).toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        color: TextileColors.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (hasDiscount) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        "₹${product.price.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          color: TextileColors.textLight,
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (product.category == 'Fabrics')
                                  const Text(
                                    "/meter",
                                    style: TextStyle(
                                      color: TextileColors.textLight,
                                      fontSize: 9,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ListenableBuilder(
                            listenable: CartNotifier.instance,
                            builder: (context, _) {
                              final inCart = CartNotifier.instance.isInCart(
                                product,
                              );
                              return InkWell(
                                onTap: () {
                                  if (inCart) {
                                    CartNotifier.instance.removeItem(product);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${product.name} removed from cart",
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    CartNotifier.instance.addItem(product);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${product.name} added to cart!",
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
                                                builder: (context) =>
                                                    const CartScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: inCart
                                        ? TextileColors.accent
                                        : TextileColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    inCart
                                        ? Icons.shopping_bag
                                        : Icons.add_shopping_cart,
                                    color: inCart
                                        ? TextileColors.textPrimary
                                        : Colors.white,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
