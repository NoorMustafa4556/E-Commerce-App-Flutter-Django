import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/ShopProvider.dart';
import '../../providers/AuthProvider.dart';
import '../../utils/Config.dart';
import '../../providers/ThemeProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedCategoryId;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).fetchCategories();
      Provider.of<ShopProvider>(context, listen: false).fetchProducts();
      Provider.of<ShopProvider>(context, listen: false).fetchCart();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<ShopProvider>(context, listen: false).fetchProducts(
        categoryId: _selectedCategoryId,
        search: query.trim().isEmpty ? null : query.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: _buildDrawer(context, auth, shop),
        body: CustomScrollView(
          slivers: [
            // ─── Premium SliverAppBar ──────────────────────────────────
            SliverAppBar(
              expandedHeight: 130,
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Hi, ${auth.user?.firstName.isNotEmpty == true ? auth.user!.firstName : auth.user?.username ?? 'User'} 👋',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const Text(
                            'Shopaholic',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
              backgroundColor: const Color(0xFF667EEA),
              foregroundColor: Colors.white,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                // Cart icon
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/cart'),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
                        if (shop.cart != null && shop.cart!.totalItems > 0)
                          Positioned(
                            right: 0, top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                              child: Text(
                                '${shop.cart!.totalItems}',
                                style: const TextStyle(color: Colors.white, fontSize: 8),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ─── Search Bar ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.07), blurRadius: 10, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) {
                      setState(() {});
                      _onSearchChanged(v);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF667EEA), size: 22),
                      suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onSubmitted: _onSearchChanged,
                  ),
                ),
              ),
            ),

            // ─── Category Chips ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: shop.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return _categoryChip(null, 'All');
                      final cat = shop.categories[index - 1];
                      return _categoryChip(cat.id, cat.name);
                    },
                  ),
                ),
              ),
            ),

            // ─── Products Grid ─────────────────────────────────────────
            if (shop.isLoading)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else if (shop.products.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No products found', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _productCard(context, shop.products[index], shop),
                    childCount: shop.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth, ShopProvider shop) {
    final profilePic = auth.user?.profilePic;
    return Drawer(
      child: Column(
        children: [
          // Premium Drawer Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  backgroundImage: (profilePic != null && profilePic.isNotEmpty)
                    ? NetworkImage(profilePic.startsWith('http') ? profilePic : '${AppConfig.baseUrl}$profilePic')
                    : null,
                  child: (profilePic == null || profilePic.isEmpty)
                    ? const Icon(Icons.person, size: 36, color: Colors.white)
                    : null,
                ),
                const SizedBox(height: 12),
                Text(
                  auth.user?.username ?? 'User',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  auth.user?.email ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerTile(context, Icons.home_rounded, 'Home', () => Navigator.pop(context)),
                _drawerTile(context, Icons.history_rounded, 'My Orders', () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/orders');
                }),
                _drawerTile(context, Icons.favorite_rounded, 'Favorites', () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/favorites');
                }),
                _drawerTile(context, Icons.person_rounded, 'Profile', () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                }),
                const Divider(indent: 16, endIndent: 16),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    final isDark = themeProvider.themeMode == ThemeMode.dark;
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        isDark ? 'Light Mode' : 'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (v) => themeProvider.toggleTheme(),
                        activeColor: const Color(0xFF667EEA),
                      ),
                      onTap: () => themeProvider.toggleTheme(),
                    );
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                _drawerTile(context, Icons.logout_rounded, 'Logout', () {
                  Navigator.pop(context);
                  auth.logout().then((_) {
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  });
                }, color: Colors.redAccent),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Shopaholic v1.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF667EEA)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF667EEA), size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color ?? Theme.of(context).textTheme.bodyLarge?.color)),
      onTap: onTap,
    );
  }

  Widget _categoryChip(int? id, String name) {
    final isSelected = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedCategoryId = id);
          Provider.of<ShopProvider>(context, listen: false).fetchProducts(categoryId: id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)])
              : null,
            color: isSelected ? null : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
            boxShadow: isSelected ? [
              BoxShadow(color: const Color(0xFF667EEA).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))
            ] : [],
          ),
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCard(BuildContext context, product, ShopProvider shop) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.06), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: product.image != null
                  ? Image.network(
                      product.image!.startsWith('http') ? product.image! : '${AppConfig.baseUrl}${product.image!}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : Container(color: Colors.grey.shade100, child: const Icon(Icons.image_outlined, color: Colors.grey)),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          color: Color(0xFF667EEA),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          shop.updateCart(product.id, 'add');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Added to cart!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: const Color(0xFF667EEA),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
