import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/state_manager.dart';
import '../screens/product_catalog_screen.dart';
import '../screens/category_screen.dart';
import '../screens/inquiry_screen.dart';
import '../screens/whatsapp_order_screen.dart';
import 'login_dialog.dart';
import 'marquee_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: TextileColors.background,
      child: Column(
        children: [
          // Drawer Header reactive to Auth State
          ListenableBuilder(
            listenable: AuthNotifier.instance,
            builder: (context, _) {
              final auth = AuthNotifier.instance;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 24,
                  20,
                  24,
                ),
                decoration: const BoxDecoration(
                  color: TextileColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TextileColors.accent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage: auth.isLoggedIn
                                ? NetworkImage(auth.user!.avatarUrl)
                                : null,
                            child: !auth.isLoggedIn
                                ? const Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: TextileColors.primary,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.isLoggedIn
                                    ? auth.user!.name
                                    : "Guest Account",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                auth.isLoggedIn
                                    ? auth.user!.email
                                    : "Log in for wholesale tiers",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!auth.isLoggedIn)
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close drawer
                            showLoginDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TextileColors.accent,
                            foregroundColor: TextileColors.textPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Log In Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            auth.logout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Logged out successfully"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.logout,
                            size: 14,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Sign Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          // Drawer Continuous Moving News Line Ticker
          Container(
            color: TextileColors.primary.withValues(alpha: 0.06),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: const MarqueeWidget(
              text:
                  "📢 NOTE: Registered B2B partners receive prioritized shipping & custom weave print options. Contact Surat sales desk for commission structures. 📢",
              style: TextStyle(
                color: TextileColors.primary,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
              ),
              duration: Duration(seconds: 14),
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: "Home Dashboard",
                  onTap: () {
                    Navigator.pop(context);
                    // Pop to home (main.dart screen is Home)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  title: "Browse Catalog",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.grid_view_rounded,
                  title: "Fabric Categories",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.rate_review_outlined,
                  title: "B2B Inquiry Form",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InquiryScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  title: "WhatsApp Ordering",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WhatsAppScreen(),
                      ),
                    );
                  },
                ),
                const Divider(
                  color: TextileColors.border,
                  indent: 20,
                  endIndent: 20,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: "About Vastra",
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),

          // Bottom brand footer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Vastra Textiles v1.1.0",
              style: TextStyle(
                fontSize: 11,
                color: TextileColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: TextileColors.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: TextileColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: TextileColors.textLight,
        size: 16,
      ),
      horizontalTitleGap: 8,
      onTap: onTap,
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
          "Developed to simplify wholesale transactions via streamlined business inquiries and direct chat interfaces.",
        ),
      ],
    );
  }
}
