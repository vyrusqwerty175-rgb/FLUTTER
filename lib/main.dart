import 'package:flutter/material.dart';

void main() => runApp(const ProConnectApp());

const ink = Color(0xFF17211F);
const muted = Color(0xFF77817D);
const green = Color(0xFF237A62);
const canvas = Color(0xFFF7F8F5);

class ProConnectApp extends StatelessWidget {
  const ProConnectApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ProConnect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(seedColor: green),
          fontFamily: 'Roboto',
        ),
        home: const MarketplacePage(),
      );
}

class Professional {
  const Professional({required this.name, required this.job, required this.rating, required this.reviews, required this.price, required this.emoji, required this.color, required this.distance, required this.available});
  final String name, job, rating, reviews, price, emoji, distance, available;
  final Color color;
}

const pros = <Professional>[
  Professional(name: 'Olivia Martinez', job: 'Home cleaning', rating: '4.9', reviews: '128', price: '\$35', emoji: '👩🏻‍🔧', color: Color(0xFFE7EFE5), distance: '0.8 mi away', available: 'Today, 2:30 PM'),
  Professional(name: 'James Wilson', job: 'Plumbing', rating: '5.0', reviews: '94', price: '\$50', emoji: '👨🏽‍🔧', color: Color(0xFFE8EAF5), distance: '1.2 mi away', available: 'Today, 4:00 PM'),
  Professional(name: 'Sophia Chen', job: 'Electrical', rating: '4.8', reviews: '76', price: '\$45', emoji: '👩🏻‍💻', color: Color(0xFFF3E9DF), distance: '2.1 mi away', available: 'Tomorrow, 9:00 AM'),
  Professional(name: 'Noah Brooks', job: 'Painting', rating: '4.9', reviews: '61', price: '\$40', emoji: '👨🏾‍🎨', color: Color(0xFFECE5F2), distance: '2.4 mi away', available: 'Today, 5:30 PM'),
];

const categories = <({String name, IconData icon})>[
  (name: 'All', icon: Icons.grid_view_rounded),
  (name: 'Cleaning', icon: Icons.cleaning_services_rounded),
  (name: 'Plumbing', icon: Icons.plumbing_rounded),
  (name: 'Electrical', icon: Icons.electrical_services_rounded),
  (name: 'Painting', icon: Icons.format_paint_rounded),
];

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});
  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final searchController = TextEditingController();
  final favorites = <String>{};
  String selectedCategory = 'All';
  int selectedTab = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Professional> get visiblePros {
    var result = pros;
    if (selectedCategory != 'All') {
      result = result.where((p) => p.job.toLowerCase().contains(selectedCategory.toLowerCase())).toList();
    }
    if (selectedTab == 1) result = result.where((p) => favorites.contains(p.name)).toList();
    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) result = result.where((p) => '${p.name} ${p.job}'.toLowerCase().contains(query)).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isHome = selectedTab == 0 || selectedTab == 1;
    return Scaffold(
      body: SafeArea(
        child: isHome ? _buildMarketplace() : _buildSimpleTab(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) => setState(() => selectedTab = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE6F1EC),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.favorite_border_rounded), selectedIcon: Icon(Icons.favorite_rounded), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildMarketplace() => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(22, 16, 22, 0), child: _header())),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(22, 27, 22, 0), child: _searchBox())),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(22, 27, 22, 0), child: _promoCard())),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(22, 28, 22, 14), child: _sectionTitle('Browse categories', 'See all')),
          SliverToBoxAdapter(child: SizedBox(height: 90, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 22), scrollDirection: Axis.horizontal, itemCount: categories.length, separatorBuilder: (_, __) => const SizedBox(width: 18), itemBuilder: (_, i) => _categoryItem(categories[i])))),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(22, 22, 22, 14), child: _sectionTitle(selectedTab == 1 ? 'Your saved pros' : 'Top professionals', 'View all')),
          if (visiblePros.isEmpty)
            SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(36), child: Center(child: Text(selectedTab == 1 ? 'No saved pros yet. Tap the heart on a professional to save them.' : 'No professionals match your search.', textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)))))
          else
            SliverPadding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 24), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _professionalCard(visiblePros[index])), childCount: visiblePros.length))),
        ],
      );

  Widget _header() => Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.handyman_rounded, color: Colors.white, size: 23)),
        const SizedBox(width: 11),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ProConnect', style: TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -.4)), Text('YOUR LOCAL EXPERTS', style: TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.25))]),
        const Spacer(),
        IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You’re all caught up!'))), style: IconButton.styleFrom(backgroundColor: Colors.white), icon: const Icon(Icons.notifications_none_rounded, color: ink)),
      ]);

  Widget _searchBox() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Find the right pro\nfor every project.', style: TextStyle(color: ink, fontSize: 29, height: 1.16, fontWeight: FontWeight.w800, letterSpacing: -.7)),
        const SizedBox(height: 10),
        const Row(children: [Icon(Icons.location_on_outlined, color: green, size: 17), SizedBox(width: 4), Text('Brooklyn, New York', style: TextStyle(color: muted, fontSize: 13)), Icon(Icons.keyboard_arrow_down_rounded, color: muted, size: 18)]),
        const SizedBox(height: 20),
        TextField(controller: searchController, onChanged: (_) => setState(() {}), decoration: InputDecoration(hintText: 'What service do you need?', hintStyle: const TextStyle(color: Color(0xFF9AA29F), fontSize: 14), prefixIcon: const Icon(Icons.search_rounded, color: green), suffixIcon: IconButton(onPressed: () => setState(() => searchController.clear()), icon: const Icon(Icons.tune_rounded, color: muted)), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
      ]);

  Widget _promoCard() => Container(padding: const EdgeInsets.all(19), decoration: BoxDecoration(color: const Color(0xFF1E6654), borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF1F705B), Color(0xFF184D43)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(20)), child: const Text('✨  FIRST BOOKING', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .7)),), const SizedBox(height: 10), const Text('A better home starts\nwith the right pro.', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.25)), const SizedBox(height: 12), GestureDetector(onTap: () => setState(() => selectedCategory = 'All'), child: const Row(children: [Text('Explore services', style: TextStyle(color: Color(0xFFC9E6D8), fontSize: 12, fontWeight: FontWeight.w700)), SizedBox(width: 5), Icon(Icons.arrow_forward_rounded, color: Color(0xFFC9E6D8), size: 15)]))]), const SizedBox(width: 6), const Text('🏡', style: TextStyle(fontSize: 58))]));

  Widget _sectionTitle(String title, String action) => Row(children: [Text(title, style: const TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -.3)), const Spacer(), Text(action, style: const TextStyle(color: green, fontSize: 12, fontWeight: FontWeight.w700))]);

  Widget _categoryItem(({String name, IconData icon}) category) {
    final selected = selectedCategory == category.name;
    return GestureDetector(onTap: () => setState(() => selectedCategory = category.name), child: SizedBox(width: 62, child: Column(children: [Container(width: 57, height: 57, decoration: BoxDecoration(color: selected ? green : Colors.white, borderRadius: BorderRadius.circular(18)), child: Icon(category.icon, color: selected ? Colors.white : green, size: 23)), const SizedBox(height: 7), Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: selected ? green : muted, fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500))])));
  }

  Widget _professionalCard(Professional pro) => GestureDetector(onTap: () => _showProfessional(pro), child: Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFF0F1EE))), child: Row(children: [Container(width: 70, height: 76, decoration: BoxDecoration(color: pro.color, borderRadius: BorderRadius.circular(15)), alignment: Alignment.center, child: Text(pro.emoji, style: const TextStyle(fontSize: 38))), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(pro.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w800))), GestureDetector(onTap: () => setState(() => favorites.contains(pro.name) ? favorites.remove(pro.name) : favorites.add(pro.name)), child: Icon(favorites.contains(pro.name) ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: favorites.contains(pro.name) ? const Color(0xFFE47767) : muted, size: 20))]), const SizedBox(height: 3), Text(pro.job, style: const TextStyle(color: muted, fontSize: 12)), const SizedBox(height: 7), Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFF0B74B), size: 16), const SizedBox(width: 3), Text(pro.rating, style: const TextStyle(color: ink, fontWeight: FontWeight.w700, fontSize: 11)), Text(' (${pro.reviews})', style: const TextStyle(color: muted, fontSize: 10)), const Spacer(), Text('from ${pro.price}', style: const TextStyle(color: green, fontWeight: FontWeight.w800, fontSize: 12))]), const SizedBox(height: 5), Row(children: [const Icon(Icons.near_me_outlined, size: 12, color: muted), const SizedBox(width: 3), Text(pro.distance, style: const TextStyle(color: muted, fontSize: 10)), const SizedBox(width: 10), const Icon(Icons.schedule_rounded, size: 12, color: muted), const SizedBox(width: 3), Expanded(child: Text(pro.available, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 10)))])]))]));

  Widget _buildSimpleTab() {
    final title = selectedTab == 2 ? 'Your bookings' : 'Your profile';
    final subtitle = selectedTab == 2 ? 'Your upcoming appointments will show up here.' : 'Manage your account and preferences.';
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 76, height: 76, decoration: BoxDecoration(color: const Color(0xFFE6F1EC), borderRadius: BorderRadius.circular(24)), child: Icon(selectedTab == 2 ? Icons.calendar_month_rounded : Icons.person_rounded, color: green, size: 36)), const SizedBox(height: 18), Text(title, style: const TextStyle(color: ink, fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)), if (selectedTab == 2) ...[const SizedBox(height: 20), FilledButton.icon(onPressed: () => setState(() => selectedTab = 0), icon: const Icon(Icons.search_rounded), label: const Text('Find a professional'), style: FilledButton.styleFrom(backgroundColor: green))]])));
  }

  void _showProfessional(Professional pro) => showModalBottomSheet<void>(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => Container(padding: const EdgeInsets.fromLTRB(24, 12, 24, 30), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))), child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(color: const Color(0xFFD8DEDA), borderRadius: BorderRadius.circular(4)))), const SizedBox(height: 22), Row(children: [Container(width: 76, height: 76, decoration: BoxDecoration(color: pro.color, borderRadius: BorderRadius.circular(20)), alignment: Alignment.center, child: Text(pro.emoji, style: const TextStyle(fontSize: 42))), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(pro.name, style: const TextStyle(color: ink, fontSize: 19, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(pro.job, style: const TextStyle(color: muted)), const SizedBox(height: 6), Text('⭐ ${pro.rating}  ·  ${pro.reviews} reviews', style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w600))])), IconButton(onPressed: () => setState(() => favorites.contains(pro.name) ? favorites.remove(pro.name) : favorites.add(pro.name)), icon: Icon(favorites.contains(pro.name) ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: const Color(0xFFE47767)))]), const SizedBox(height: 20), const Text('A trusted local professional, ready to help with your next project. Check availability and request a booking in just a few taps.', style: TextStyle(color: muted, height: 1.55)), const SizedBox(height: 18), Row(children: [const Icon(Icons.schedule_rounded, color: green, size: 18), const SizedBox(width: 7), Text('Next available: ${pro.available}', style: const TextStyle(color: ink, fontWeight: FontWeight.w600, fontSize: 13)), const Spacer(), Text('from ${pro.price}', style: const TextStyle(color: green, fontSize: 14, fontWeight: FontWeight.w800))]), const SizedBox(height: 22), SizedBox(width: double.infinity, child: FilledButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Booking request sent to ${pro.name}!'))); }, style: FilledButton.styleFrom(backgroundColor: green, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Request a booking', style: TextStyle(fontWeight: FontWeight.w700)))]))));
}
