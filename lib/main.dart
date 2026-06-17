import 'package:flutter/material.dart';
import 'screens/product_catalog_screen.dart';
import 'screens/category_screen.dart';
import 'screens/inquiry_screen.dart';
import 'screens/whatsapp_order_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'utils/colors.dart';
import 'utils/constants.dart';
import 'services/state_manager.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/login_dialog.dart';
import 'services/whatsapp_service.dart';
import 'widgets/marquee_widget.dart';
import 'widgets/video_background.dart';
import 'widgets/animated_entrance.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Vastra Textile Business",
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: TextileColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TextileColors.primary,
          primary: TextileColors.primary,
          secondary: TextileColors.secondary,
          tertiary: TextileColors.accent,
          surface: TextileColors.background,
        ),
        scaffoldBackgroundColor: TextileColors.background,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: TextileColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: TextileColors.cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: TextileColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextileColors.background,
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Seamless Hero Header (Includes brand identity & search bar)
            _buildBrandBanner(context),

            // Instagram-style Highlights Row
            _buildHighlightsRow(context),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListenableBuilder(
                    listenable: LanguageNotifier.instance,
                    builder: (context, _) {
                      return Text(
                        LanguageNotifier.instance.translate("dashboard"),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TextileColors.textPrimary,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),

                  // Grid of Business Operations (Compact 2x2 layout)
                  ListenableBuilder(
                    listenable: LanguageNotifier.instance,
                    builder: (context, _) {
                      final lang = LanguageNotifier.instance;

                      final card1 = AnimatedEntrance(
                        delay: Duration.zero,
                        child: _buildDashboardCard(
                          context,
                          title: lang.translate("catalog"),
                          subtitle: "Fabrics & Apparel",
                          icon: Icons.inventory_2_outlined,
                          color: TextileColors.primary,
                          imageUrl:
                              "https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&q=80&w=400",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductScreen(),
                              ),
                            );
                          },
                        ),
                      );

                      final card2 = AnimatedEntrance(
                        delay: const Duration(milliseconds: 100),
                        child: _buildDashboardCard(
                          context,
                          title: lang.translate("categories"),
                          subtitle: "Browse by line",
                          icon: Icons.grid_view_rounded,
                          color: const Color(0xFF028090),
                          imageUrl:
                              "https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&q=80&w=400",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoryScreen(),
                              ),
                            );
                          },
                        ),
                      );

                      final card3 = AnimatedEntrance(
                        delay: const Duration(milliseconds: 200),
                        child: _buildDashboardCard(
                          context,
                          title: lang.translate("inquiry"),
                          subtitle: "Request quotes",
                          icon: Icons.rate_review_outlined,
                          color: const Color(0xFFF0A500),
                          imageUrl:
                              "https://images.unsplash.com/photo-1506806732259-39c2d0268443?auto=format&fit=crop&q=80&w=400",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InquiryScreen(),
                              ),
                            );
                          },
                        ),
                      );

                      final card4 = AnimatedEntrance(
                        delay: const Duration(milliseconds: 300),
                        child: _buildDashboardCard(
                          context,
                          title: lang.translate("direct_order"),
                          subtitle: "Chat on WhatsApp",
                          icon: Icons.chat_bubble_outline_rounded,
                          color: TextileColors.success,
                          imageUrl:
                              "https://images.unsplash.com/photo-1608748010899-18f300247112?auto=format&fit=crop&q=80&w=400",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WhatsAppScreen(),
                              ),
                            );
                          },
                        ),
                      );

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          if (width >= 900) {
                            // Large Screen (Desktop, Tablet Landscape) -> 4 Columns in 1 Row
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: card1),
                                const SizedBox(width: 12),
                                Expanded(child: card2),
                                const SizedBox(width: 12),
                                Expanded(child: card3),
                                const SizedBox(width: 12),
                                Expanded(child: card4),
                              ],
                            );
                          } else if (width >= 600) {
                            // Medium Screen (Tablet Portrait, Folded layouts) -> 2x2 Grid using rows
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: card1),
                                    const SizedBox(width: 12),
                                    Expanded(child: card2),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: card3),
                                    const SizedBox(width: 12),
                                    Expanded(child: card4),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            // Small Screen (Mobile Portrait) -> 1 Column list of cards
                            return Column(
                              children: [
                                card1,
                                const SizedBox(height: 10),
                                card2,
                                const SizedBox(height: 10),
                                card3,
                                const SizedBox(height: 10),
                                card4,
                              ],
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Trending horizontal scroll collections section
                  _buildTrendingSection(context),
                  const SizedBox(height: 28),

                  // Wholesale Guarantee section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TextileColors.primary,
                          TextileColors.primary.withValues(alpha: 0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: TextileColors.primary.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              color: TextileColors.accent,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Wholesale Guarantee",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "We deal directly with handloom weavers and mills to bring you high-grade linen, pure silk, and organic cotton at direct wholesale pricing tiers.",
                          style: TextStyle(
                            color: Colors.white70,
                            backgroundColor: Colors.transparent,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 400),
                    child: _buildAboutUsSection(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutUsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Text(
          "Our Heritage & Mission",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: TextileColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isWide = width >= 650;

            final storyContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Crafting Trust Across Weaves",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: TextileColors.primary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Vastra Textiles is a premier distributor and platform for Indian handloom fabrics, silk sarees, designer kurtis, and premium home textiles. Founded in the textile hub of Surat, Gujarat, we bridge the gap between traditional master weavers and wholesale merchants worldwide.",
                  style: TextStyle(
                    fontSize: 13,
                    color: TextileColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "By establishing direct-from-mill contracts and using digital technology, we streamline wholesale procurement, inquiries, and custom bulk weave orders, empowering over 500+ weaving families.",
                  style: TextStyle(
                    fontSize: 13,
                    color: TextileColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            );

            final statsGrid = Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatItem("500+", "Weaver Partners"),
                _buildStatItem("30+", "Years of Trust"),
                _buildStatItem("15K+", "Bulk Shipments"),
                _buildStatItem("100%", "Quality Inspected"),
              ],
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: storyContent),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: TextileColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: TextileColors.border),
                        ),
                        child: statsGrid,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  storyContent,
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TextileColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: TextileColors.border),
                    ),
                    child: Center(child: statsGrid),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TextileColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TextileColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: TextileColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBrandBanner(BuildContext context) {
    final menuButton = Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        tooltip: "Menu",
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );

    final logoWidget = ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(
        "lib/assets/vastra_logo.png",
        width: 26,
        height: 26,
        fit: BoxFit.cover,
      ),
    );

    const titleText = Text(
      "VASTRA TEXTILES",
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: TextileColors.accent,
        letterSpacing: 1.2,
      ),
    );

    final welcomeText = ListenableBuilder(
      listenable: AuthNotifier.instance,
      builder: (context, _) {
        final name = AuthNotifier.instance.isLoggedIn
            ? AuthNotifier.instance.user!.name
            : "Partner";
        return Text(
          "Welcome, $name",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );

    final languageButton = ListenableBuilder(
      listenable: LanguageNotifier.instance,
      builder: (context, _) {
        return IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.public, color: Colors.black, size: 16),
          ),
          tooltip: "Change Language",
          onPressed: () => _showLanguageBottomSheet(context),
        );
      },
    );

    final supportButton = IconButton(
      icon: const Icon(Icons.support_agent, color: Colors.white, size: 22),
      tooltip: "Contact Support",
      onPressed: () => _showContactBottomSheet(context),
    );

    final cartButton = ListenableBuilder(
      listenable: CartNotifier.instance,
      builder: (context, _) {
        final count = CartNotifier.instance.totalItemsCount;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 22,
              ),
              tooltip: "View Cart",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            if (count > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: TextileColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$count',
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
    );

    final profileButton = ListenableBuilder(
      listenable: AuthNotifier.instance,
      builder: (context, _) {
        final auth = AuthNotifier.instance;
        return GestureDetector(
          onTap: () {
            if (auth.isLoggedIn) {
              _showProfileBottomSheet(context, auth);
            } else {
              showLoginDialog(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: TextileColors.accent, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white24,
              backgroundImage: auth.isLoggedIn
                  ? NetworkImage(auth.user!.avatarUrl)
                  : null,
              child: !auth.isLoggedIn
                  ? const Icon(Icons.person, size: 15, color: Colors.white)
                  : null,
            ),
          ),
        );
      },
    );

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: TextileVideoBackground(
        videoPath: "lib/assets/videos/textile_bg.mp4",
        opacity: 0.60,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 600;
                  if (isWide) {
                    // Desktop/Tablet layout: single row
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            menuButton,
                            const SizedBox(width: 4),
                            logoWidget,
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titleText,
                                const SizedBox(height: 2),
                                welcomeText,
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            languageButton,
                            supportButton,
                            cartButton,
                            const SizedBox(width: 4),
                            profileButton,
                          ],
                        ),
                      ],
                    );
                  } else {
                    // Mobile layout: split into 2 rows to prevent layout pixel overflow
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                menuButton,
                                const SizedBox(width: 4),
                                logoWidget,
                                const SizedBox(width: 8),
                                titleText,
                              ],
                            ),
                            Row(
                              children: [
                                cartButton,
                                const SizedBox(width: 8),
                                profileButton,
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: welcomeText,
                            ),
                            Row(
                              children: [
                                languageButton,
                                const SizedBox(width: 4),
                                supportButton,
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              // Continuously moving news line ticker
              Container(
                height: 22,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ListenableBuilder(
                  listenable: LanguageNotifier.instance,
                  builder: (context, _) {
                    return MarqueeWidget(
                      text: LanguageNotifier.instance.translate("news"),
                      style: const TextStyle(
                        color: TextileColors.accent,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: TextileColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      ListenableBuilder(
                        listenable: LanguageNotifier.instance,
                        builder: (context, _) {
                          return Text(
                            LanguageNotifier.instance.translate("search"),
                            style: const TextStyle(
                              color: TextileColors.textLight,
                              fontSize: 13,
                            ),
                          );
                        },
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

  Widget _buildHighlightsRow(BuildContext context) {
    final List<Map<String, dynamic>> highlights = [
      {
        "label": "New In",
        "imageUrl":
            "https://images.unsplash.com/photo-1608748010899-18f300247112?auto=format&fit=crop&q=80&w=200",
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductScreen()),
        ),
      },
      {
        "label": "Pure Silk",
        "imageUrl":
            "https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&q=80&w=200",
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProductScreen(initialCategory: "Sarees"),
          ),
        ),
      },
      {
        "label": "Raw Linen",
        "imageUrl":
            "https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&q=80&w=200",
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProductScreen(initialCategory: "Fabrics"),
          ),
        ),
      },
      {
        "label": "Embroidery",
        "imageUrl":
            "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?auto=format&fit=crop&q=80&w=200",
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProductScreen(initialCategory: "Kurtis"),
          ),
        ),
      },
      {
        "label": "Bed Decor",
        "imageUrl":
            "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&q=80&w=200",
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProductScreen(initialCategory: "Bedsheets"),
          ),
        ),
      },
      {
        "label": "WhatsApp",
        "imageUrl":
            "https://images.unsplash.com/photo-1608748010899-18f300247112?auto=format&fit=crop&q=80&w=200",
        "action": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WhatsAppScreen()),
        ),
      },
      {
        "label": "About Us",
        "imageUrl":
            "https://images.unsplash.com/photo-1506806732259-39c2d0268443?auto=format&fit=crop&q=80&w=200",
        "action": () => _showAboutDialog(context),
      },
    ];

    return Container(
      height: 106,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: highlights.length,
        itemBuilder: (context, index) {
          final item = highlights[index];
          return AnimatedEntrance(
            delay: Duration(milliseconds: index * 60),
            offset: const Offset(24.0, 0.0),
            child: GestureDetector(
              onTap: item["action"] as VoidCallback,
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: TextileColors.accent,
                          width: 1.8,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: TextileColors.surface,
                        backgroundImage: NetworkImage(
                          item["imageUrl"] as String,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["label"] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: TextileColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSection(BuildContext context) {
    final featuredProducts = TextileConstants.products.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Trending Weaves",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TextileColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(),
                  ),
                );
              },
              child: const Text(
                "View All",
                style: TextStyle(
                  color: TextileColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TextileColors.border, width: 0.8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            product.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                Container(color: TextileColors.surface),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: TextileColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.fabricType,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: TextileColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${(product.discountPrice ?? product.price).toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: TextileColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return HoverScaleContainer(
      child: SizedBox(
        height: 68,
        child: Card(
          elevation: 1.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background Image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: TextileColors.surface);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: TextileColors.surface);
                },
              ),
              // Dark Gradient Overlay (left-to-right to support left-aligned text)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.black.withValues(alpha: 0.30),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    // Floating Circle Icon (Left aligned)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 14),
                    // Text details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Trailing Chevron
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withValues(alpha: 0.70),
                      size: 14,
                    ),
                  ],
                ),
              ),
              // InkWell Tap Overlay
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: color.withValues(alpha: 0.2),
                    highlightColor: color.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Vastra Textiles",
      applicationVersion: "v1.1.0",
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "lib/assets/vastra_logo.png",
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      children: const [
        Text(
          "Vastra Textiles is a premier distributor and platform for Indian handloom fabrics, silk sarees, designer kurtis, and home textiles.\n\n"
          "Developed to simplify wholesale transactions via streamlined B2B cart lists, direct WhatsApp orders, and inquiries.",
        ),
      ],
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final currentLang = LanguageNotifier.instance.currentLanguage;
        final List<Map<String, String>> langs = [
          {"name": "English", "native": "English"},
          {"name": "Hindi", "native": "हिंदी"},
          {"name": "Gujarati", "native": "ગુજરાતી"},
          {"name": "Tamil", "native": "தமிழ்"},
          {"name": "Spanish", "native": "Español"},
          {"name": "French", "native": "Français"},
          {"name": "German", "native": "Deutsch"},
          {"name": "Chinese", "native": "中文"},
          {"name": "Arabic", "native": "العربية"},
          {"name": "Japanese", "native": "日本語"},
        ];

        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    "Select Language / भाषा चुनें",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TextileColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: langs.length,
                    itemBuilder: (context, index) {
                      final lang = langs[index];
                      final isSelected = currentLang == lang["name"];
                      return ListTile(
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? TextileColors.primary
                              : TextileColors.textSecondary,
                        ),
                        title: Text(
                          lang["native"]!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? TextileColors.textPrimary
                                : TextileColors.textSecondary,
                          ),
                        ),
                        subtitle: Text(lang["name"]!),
                        onTap: () {
                          LanguageNotifier.instance.changeLanguage(
                            lang["name"]!,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Language changed to ${lang['native']}",
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: TextileColors.primary,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contact Support",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TextileColors.primary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Need help with bulk shipments, weave specifications, or pricing? Contact our Surat B2B support desk.",
                style: TextStyle(
                  color: TextileColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TextileColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone, color: TextileColors.primary),
                ),
                title: const Text(
                  "Call Direct Office",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text("+91 98765 43210"),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TextileColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email, color: TextileColors.primary),
                ),
                title: const Text(
                  "Email Sales Team",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text("sales@vastra.com"),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TextileColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: TextileColors.primary,
                  ),
                ),
                title: const Text(
                  "Weaving Mill & Office",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: const Text("104, Handloom Market, Surat, Gujarat"),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    WhatsAppService.launchWhatsApp(
                      message:
                          "Hello Vastra Textiles Support, I need some help regarding wholesale orders.",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TextileColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.chat),
                  label: const Text(
                    "Start WhatsApp Chat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileBottomSheet(BuildContext context, AuthNotifier auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Partner Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TextileColors.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(auth.user!.avatarUrl),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    auth.user!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TextileColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.user!.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: TextileColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TextileColors.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TextileColors.border),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Tier",
                              style: TextStyle(
                                color: TextileColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Gold Wholesaler",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Inquiries",
                              style: TextStyle(
                                color: TextileColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "3 Pending",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.secondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Default Commission",
                              style: TextStyle(
                                color: TextileColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "15% Off Catalog",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextileColors.success,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        auth.logout();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Logged out successfully"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TextileColors.error,
                        side: const BorderSide(
                          color: TextileColors.error,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Sign Out of Account",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HoverScaleContainer extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const HoverScaleContainer({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<HoverScaleContainer> createState() => _HoverScaleContainerState();
}

class _HoverScaleContainerState extends State<HoverScaleContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _isHovered ? widget.scale : 1.0,
          _isHovered ? widget.scale : 1.0,
          1.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
