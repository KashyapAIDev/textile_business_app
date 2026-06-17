import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';
import '../widgets/animated_entrance.dart';
import 'product_detail_screen.dart';
import '../services/state_manager.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  final String? initialCategory;

  const ProductScreen({super.key, this.initialCategory});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = "All";
  String searchQuery = "";
  String sortBy = "Popularity";
  double minPrice = 0.0;
  double maxPrice = 8000.0;

  // New textile-centric filter variables
  List<String> selectedMaterials = [];
  List<String> selectedPatterns = [];
  double minGsm = 0.0;
  double maxGsm = 900.0;
  bool showInStockOnly = false;

  final List<String> categories = [
    "All",
    "Sarees",
    "Fabrics",
    "Kurtis",
    "Bedsheets",
  ];
  final List<String> sortOptions = [
    "Popularity",
    "Price: Low to High",
    "Price: High to Low",
    "Customer Rating",
    "Alphabetical (A-Z)",
  ];

  // Textile filter options lists
  final List<String> materialOptions = [
    "Cotton",
    "Silk",
    "Linen",
    "Denim",
    "Georgette",
    "Velvet",
    "Organza",
    "Blends/Other",
  ];

  final List<String> patternOptions = [
    "Solid/Plain",
    "Printed",
    "Embroidered",
    "Zari/Handwoven",
    "Checked/Plaid",
    "Woven/Jacquard",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null &&
        categories.contains(widget.initialCategory)) {
      selectedCategory = widget.initialCategory!;
    }
  }

  bool _matchesMaterial(Product p, String material) {
    final fabric = p.fabricType.toLowerCase();
    switch (material) {
      case "Cotton":
        return fabric.contains("cotton") ||
            fabric.contains("khadi") ||
            fabric.contains("calico");
      case "Silk":
        return fabric.contains("silk") || fabric.contains("chanderi");
      case "Linen":
        return fabric.contains("linen");
      case "Denim":
        return fabric.contains("denim");
      case "Georgette":
        return fabric.contains("georgette");
      case "Velvet":
        return fabric.contains("velvet");
      case "Organza":
        return fabric.contains("organza");
      case "Blends/Other":
        return !fabric.contains("cotton") &&
            !fabric.contains("khadi") &&
            !fabric.contains("silk") &&
            !fabric.contains("chanderi") &&
            !fabric.contains("linen") &&
            !fabric.contains("denim") &&
            !fabric.contains("georgette") &&
            !fabric.contains("velvet") &&
            !fabric.contains("organza");
      default:
        return false;
    }
  }

  bool _matchesPattern(Product p, String patternOpt) {
    final pat = p.pattern.toLowerCase();
    switch (patternOpt) {
      case "Solid/Plain":
        return pat.contains("plain") ||
            pat.contains("solid") ||
            pat.contains("knit");
      case "Printed":
        return pat.contains("print") || pat.contains("painted");
      case "Embroidered":
        return pat.contains("embroidery") ||
            pat.contains("chikankari") ||
            pat.contains("zardozi");
      case "Zari/Handwoven":
        return pat.contains("zari") ||
            pat.contains("border") ||
            pat.contains("butis");
      case "Checked/Plaid":
        return pat.contains("plaid") ||
            pat.contains("checks") ||
            pat.contains("stripe") ||
            pat.contains("sateen") ||
            pat.contains("zigzag") ||
            pat.contains("chevron");
      case "Woven/Jacquard":
        return pat.contains("woven") ||
            pat.contains("canvas") ||
            pat.contains("twill") ||
            pat.contains("jacquard");
      default:
        return false;
    }
  }

  bool get _hasActiveFilters {
    return minPrice > 0.0 ||
        maxPrice < 8000.0 ||
        selectedMaterials.isNotEmpty ||
        selectedPatterns.isNotEmpty ||
        minGsm > 0.0 ||
        maxGsm < 900.0 ||
        showInStockOnly;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter and sort products dynamically based on user state
  List<Product> get _filteredAndSortedProducts {
    List<Product> items = List.from(TextileConstants.products);

    // 1. Filter by category
    if (selectedCategory != "All") {
      items = items
          .where(
            (p) => p.category.toLowerCase() == selectedCategory.toLowerCase(),
          )
          .toList();
    }

    // Filter by price range
    items = items.where((p) {
      final activePrice = p.discountPrice ?? p.price;
      return activePrice >= minPrice && activePrice <= maxPrice;
    }).toList();

    // Filter by materials (logical OR if multiple selected)
    if (selectedMaterials.isNotEmpty) {
      items = items.where((p) {
        return selectedMaterials.any((m) => _matchesMaterial(p, m));
      }).toList();
    }

    // Filter by patterns (logical OR if multiple selected)
    if (selectedPatterns.isNotEmpty) {
      items = items.where((p) {
        return selectedPatterns.any((pat) => _matchesPattern(p, pat));
      }).toList();
    }

    // Filter by GSM weight range
    items = items.where((p) {
      return p.gsm >= minGsm && p.gsm <= maxGsm;
    }).toList();

    // Filter by stock availability
    if (showInStockOnly) {
      items = items.where((p) {
        return p.isAvailable && p.stockQuantity > 0;
      }).toList();
    }

    // 2. Filter by search query
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      items = items.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.fabricType.toLowerCase().contains(query) ||
            p.pattern.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }).toList();
    }

    // 3. Sort
    switch (sortBy) {
      case "Price: Low to High":
        items.sort(
          (a, b) => (a.discountPrice ?? a.price).compareTo(
            b.discountPrice ?? b.price,
          ),
        );
        break;
      case "Price: High to Low":
        items.sort(
          (a, b) => (b.discountPrice ?? b.price).compareTo(
            a.discountPrice ?? a.price,
          ),
        );
        break;
      case "Customer Rating":
        items.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case "Alphabetical (A-Z)":
        items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case "Popularity":
      default:
        // Default sort by reviews count or internal ordering
        items.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredAndSortedProducts;

    return Scaffold(
      backgroundColor: TextileColors.background,
      appBar: AppBar(
        title: const Text(
          "Product Catalog",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        elevation: 0,
        backgroundColor: TextileColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          ListenableBuilder(
            listenable: CartNotifier.instance,
            builder: (context, _) {
              final cartCount = CartNotifier.instance.totalItemsCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    tooltip: "View Cart",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cartCount > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: TextileColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            tooltip: "Filter Products",
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: "Sort Products",
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Row
            Container(
              color: TextileColors.primary,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search fabric type, weaves, products...",
                    hintStyle: const TextStyle(
                      color: TextileColors.textLight,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: TextileColors.primary,
                    ),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: TextileColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                searchQuery = "";
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Horizontal Category Chips Row
            Container(
              height: 56,
              color: TextileColors.primary.withValues(alpha: 0.03),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : TextileColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: TextileColors.primary,
                      backgroundColor: TextileColors.cardBackground,
                      disabledColor: Colors.grey,
                      shadowColor: Colors.black.withValues(alpha: 0.1),
                      elevation: isSelected ? 2 : 0,
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : TextileColors.border,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedCategory = cat;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // Results count and active filter tags
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Showing ${filteredProducts.length} items",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: TextileColors.textSecondary,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: _showSortBottomSheet,
                    icon: const Icon(
                      Icons.swap_vert,
                      size: 16,
                      color: TextileColors.primary,
                    ),
                    label: Text(
                      sortBy,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: TextileColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_hasActiveFilters)
              Container(
                height: 38,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Clear all button chip
                    ActionChip(
                      avatar: const Icon(
                        Icons.clear_all,
                        size: 14,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Clear All",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: TextileColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      onPressed: () {
                        setState(() {
                          minPrice = 0.0;
                          maxPrice = 8000.0;
                          selectedMaterials.clear();
                          selectedPatterns.clear();
                          minGsm = 0.0;
                          maxGsm = 900.0;
                          showInStockOnly = false;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    if (minPrice > 0.0 || maxPrice < 8000.0) ...[
                      InputChip(
                        label: Text(
                          "Price: ₹${minPrice.round()} - ₹${maxPrice.round()}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: TextileColors.secondary,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          setState(() {
                            minPrice = 0.0;
                            maxPrice = 8000.0;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (showInStockOnly) ...[
                      InputChip(
                        label: const Text(
                          "In Stock Only",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: TextileColors.secondary,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          setState(() {
                            showInStockOnly = false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (minGsm > 0.0 || maxGsm < 900.0) ...[
                      InputChip(
                        label: Text(
                          "GSM: ${minGsm.round()} - ${maxGsm.round()}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: TextileColors.secondary,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                        onDeleted: () {
                          setState(() {
                            minGsm = 0.0;
                            maxGsm = 900.0;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                    ],
                    ...selectedMaterials.map(
                      (mat) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InputChip(
                          label: Text(
                            mat,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: TextileColors.primary,
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedMaterials.remove(mat);
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    ...selectedPatterns.map(
                      (pat) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InputChip(
                          label: Text(
                            pat,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: TextileColors.primary,
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedPatterns.remove(pat);
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Product Grid View
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.70,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return AnimatedEntrance(
                          delay: Duration(milliseconds: (index % 6) * 60),
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Displayed when search/filters return 0 items
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: TextileColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: TextileColors.textLight,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No Fabrics Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TextileColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We couldn't find matches for your selection. Try adjusting filters or clearing your search.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: TextileColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  searchQuery = "";
                  selectedCategory = "All";
                  minPrice = 0.0;
                  maxPrice = 8000.0;
                  selectedMaterials.clear();
                  selectedPatterns.clear();
                  minGsm = 0.0;
                  maxGsm = 900.0;
                  showInStockOnly = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TextileColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Reset Filters"),
            ),
          ],
        ),
      ),
    );
  }

  // Sort Bottom Sheet dialog sheet
  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Sort Catalog By",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TextileColors.textPrimary,
                  ),
                ),
              ),
              const Divider(),
              ...sortOptions.map((opt) {
                final isSelected = sortBy == opt;
                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? TextileColors.primary
                        : TextileColors.textSecondary,
                  ),
                  title: Text(
                    opt,
                    style: TextStyle(
                      color: isSelected
                          ? TextileColors.textPrimary
                          : TextileColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      sortBy = opt;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Redesigned Unified Filter Dashboard Bottom Sheet
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        double localMinPrice = minPrice;
        double localMaxPrice = maxPrice;
        List<String> localMaterials = List.from(selectedMaterials);
        List<String> localPatterns = List.from(selectedPatterns);
        double localMinGsm = minGsm;
        double localMaxGsm = maxGsm;
        bool localInStockOnly = showInStockOnly;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Handle and Title
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filters",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: TextileColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              localMinPrice = 0.0;
                              localMaxPrice = 8000.0;
                              localMaterials.clear();
                              localPatterns.clear();
                              localMinGsm = 0.0;
                              localMaxGsm = 900.0;
                              localInStockOnly = false;
                            });
                          },
                          child: const Text(
                            "Reset All",
                            style: TextStyle(
                              color: TextileColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Scrollable content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      children: [
                        // 1. STOCK AVAILABILITY SECTION
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Stock Availability",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: TextileColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Only show items ready to ship",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: TextileColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Switch.adaptive(
                              value: localInStockOnly,
                              activeThumbColor: TextileColors.primary,
                              onChanged: (val) {
                                setSheetState(() {
                                  localInStockOnly = val;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // 2. PRICE RANGE SECTION
                        const Text(
                          "Price Range",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: TextileColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${localMinPrice.round()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.primary,
                              ),
                            ),
                            Text(
                              "₹${localMaxPrice.round()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.primary,
                              ),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: RangeValues(localMinPrice, localMaxPrice),
                          min: 0.0,
                          max: 8000.0,
                          divisions: 80,
                          activeColor: TextileColors.primary,
                          inactiveColor: TextileColors.surface,
                          labels: RangeLabels(
                            "₹${localMinPrice.round()}",
                            "₹${localMaxPrice.round()}",
                          ),
                          onChanged: (RangeValues vals) {
                            setSheetState(() {
                              localMinPrice = vals.start;
                              localMaxPrice = vals.end;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPresetChip(
                              label: "Under ₹500",
                              selected:
                                  localMinPrice == 0.0 &&
                                  localMaxPrice == 500.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinPrice = 0.0;
                                  localMaxPrice = 500.0;
                                });
                              },
                            ),
                            _buildPresetChip(
                              label: "₹500 - ₹2000",
                              selected:
                                  localMinPrice == 500.0 &&
                                  localMaxPrice == 2000.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinPrice = 500.0;
                                  localMaxPrice = 2000.0;
                                });
                              },
                            ),
                            _buildPresetChip(
                              label: "₹2000 - ₹5000",
                              selected:
                                  localMinPrice == 2000.0 &&
                                  localMaxPrice == 5000.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinPrice = 2000.0;
                                  localMaxPrice = 5000.0;
                                });
                              },
                            ),
                            _buildPresetChip(
                              label: "Over ₹5000",
                              selected:
                                  localMinPrice == 5000.0 &&
                                  localMaxPrice == 8000.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinPrice = 5000.0;
                                  localMaxPrice = 8000.0;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // 3. CLOTH MATERIALS SECTION
                        const Text(
                          "Cloth Materials",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: TextileColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: materialOptions.map((mat) {
                            final isSelected = localMaterials.contains(mat);
                            return FilterChip(
                              label: Text(
                                mat,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : TextileColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              showCheckmark: false,
                              selectedColor: TextileColors.primary,
                              backgroundColor: TextileColors.surface,
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : TextileColors.border,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (selected) {
                                setSheetState(() {
                                  if (selected) {
                                    localMaterials.add(mat);
                                  } else {
                                    localMaterials.remove(mat);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // 4. WEAVE PATTERNS SECTION
                        const Text(
                          "Weaves & Patterns",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: TextileColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: patternOptions.map((pat) {
                            final isSelected = localPatterns.contains(pat);
                            return FilterChip(
                              label: Text(
                                pat,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : TextileColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              showCheckmark: false,
                              selectedColor: TextileColors.primary,
                              backgroundColor: TextileColors.surface,
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : TextileColors.border,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (selected) {
                                setSheetState(() {
                                  if (selected) {
                                    localPatterns.add(pat);
                                  } else {
                                    localPatterns.remove(pat);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // 5. FABRIC WEIGHT (GSM) SECTION
                        const Text(
                          "Fabric Weight (GSM)",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: TextileColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${localMinGsm.round()} GSM",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.primary,
                              ),
                            ),
                            Text(
                              "${localMaxGsm.round()} GSM",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.primary,
                              ),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: RangeValues(localMinGsm, localMaxGsm),
                          min: 0.0,
                          max: 900.0,
                          divisions: 18,
                          activeColor: TextileColors.primary,
                          inactiveColor: TextileColors.surface,
                          labels: RangeLabels(
                            "${localMinGsm.round()} GSM",
                            "${localMaxGsm.round()} GSM",
                          ),
                          onChanged: (RangeValues vals) {
                            setSheetState(() {
                              localMinGsm = vals.start;
                              localMaxGsm = vals.end;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPresetChip(
                              label: "Light (< 100 GSM)",
                              selected:
                                  localMinGsm == 0.0 && localMaxGsm == 100.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinGsm = 0.0;
                                  localMaxGsm = 100.0;
                                });
                              },
                            ),
                            _buildPresetChip(
                              label: "Medium (100 - 250 GSM)",
                              selected:
                                  localMinGsm == 100.0 && localMaxGsm == 250.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinGsm = 100.0;
                                  localMaxGsm = 250.0;
                                });
                              },
                            ),
                            _buildPresetChip(
                              label: "Heavy (> 250 GSM)",
                              selected:
                                  localMinGsm == 250.0 && localMaxGsm == 900.0,
                              onTap: () {
                                setSheetState(() {
                                  localMinGsm = 250.0;
                                  localMaxGsm = 900.0;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Action Buttons (Apply)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            minPrice = localMinPrice;
                            maxPrice = localMaxPrice;
                            selectedMaterials = localMaterials;
                            selectedPatterns = localPatterns;
                            minGsm = localMinGsm;
                            maxGsm = localMaxGsm;
                            showInStockOnly = localInStockOnly;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TextileColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : TextileColors.textPrimary,
          fontSize: 11,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedColor: TextileColors.secondary,
      backgroundColor: TextileColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (_) => onTap(),
    );
  }
}
