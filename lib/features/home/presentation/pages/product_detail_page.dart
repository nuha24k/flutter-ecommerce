import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import 'home_page.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductItem product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;

  String _selectedSize = 'M';
  String _selectedColor = 'White';
  int _quantity = 1;
  bool _isWishlisted = false;

  // Dummy reviews
  static const List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Budi Santoso',
      'avatar': 'B',
      'rating': 5,
      'date': '20 Apr 2026',
      'comment': 'Produk sangat bagus! Material premium dan nyaman dipakai. Ukuran sesuai dengan panduan.',
      'verified': true,
    },
    {
      'name': 'Rina Dewi',
      'avatar': 'R',
      'rating': 5,
      'date': '15 Apr 2026',
      'comment': 'Pengiriman cepat, produk sesuai foto. Sangat puas dengan pembelian ini!',
      'verified': true,
    },
    {
      'name': 'Ahmad Fauzi',
      'avatar': 'A',
      'rating': 4,
      'date': '10 Apr 2026',
      'comment': 'Kualitas oke, tapi warna sedikit berbeda dari foto. Overall masih worth it.',
      'verified': false,
    },
  ];

  // Related products dummy
  static const List<Map<String, dynamic>> _relatedProducts = [
    {'name': 'Puffer Jacket', 'brand': 'Columbia', 'price': '\$210', 'bg': Color(0xFFEEF0F5)},
    {'name': 'Trail Runner', 'brand': 'Salomon', 'price': '\$165', 'bg': Color(0xFFF5EEEE)},
    {'name': 'Fleece Hoodie', 'brand': 'Patagonia', 'price': '\$128', 'bg': Color(0xFFEEF5EE)},
  ];

  // Dropdown accordion state
  final Map<String, bool> _expanded = {
    'Description': true,
    'Size & Fit': false,
    'Materials': false,
    'Shipping & Returns': false,
  };

  static const List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  static const List<String> _colors = ['White', 'Black', 'Grey', 'Navy'];
  static const Map<String, Color> _colorMap = {
    'White': Color(0xFFF5F5F5),
    'Black': Color(0xFF1A1A1A),
    'Grey': Color(0xFF9E9E9E),
    'Navy': Color(0xFF1A237E),
  };

  static const Map<String, Map<String, String>> _productDetails = {
    'p1': {
      'Description':
          'The North Face D2 Utility Dryvent Jacket adalah jaket tahan air premium yang dirancang untuk petualangan outdoor. Teknologi DryVent™ memberikan perlindungan maksimal dari hujan dan angin sambil tetap breathable.',
      'Size & Fit':
          'Regular fit. Model menggunakan ukuran M dengan tinggi 180cm. Kami menyarankan untuk memesan ukuran biasa Anda. Panjang jaket: XS=68cm, S=70cm, M=72cm, L=74cm, XL=76cm.',
      'Materials':
          '100% Nylon DryVent™ recycled. Lining: 100% Polyester recycled. Fill: 100% Polyester recycled. Machine washable.',
      'Shipping & Returns':
          'Pengiriman gratis untuk pembelian di atas \$150. Estimasi tiba 3-5 hari kerja. Return gratis dalam 30 hari jika produk belum dipakai.',
    },
    'p2': {
      'Description':
          'ASICS GEL-1130 hadir dengan desain retro yang terinspirasi dari era 90-an. Dilengkapi teknologi GEL™ cushioning untuk kenyamanan sepanjang hari.',
      'Size & Fit':
          'True to size. Kami menyarankan memesan ukuran biasa Anda. Tersedia setengah ukuran. Lebar standar (D) untuk pria.',
      'Materials':
          'Upper: Mesh & Synthetic Leather. Midsole: SpEVA™ + GEL™ Technology. Outsole: AHAR™ Rubber. Berat: 310g (size 42).',
      'Shipping & Returns':
          'Pengiriman gratis untuk pembelian di atas \$100. Estimasi tiba 2-4 hari kerja. Tukar ukuran gratis dalam 14 hari.',
    },
    'p3': {
      'Description':
          'Nike Air Max 270 menampilkan unit Air terbesar di tumit yang pernah ada di lifestyle shoes. Foam midsole yang ringan memberikan bounce yang luar biasa.',
      'Size & Fit':
          'True to size. Desain low-profile. Cocok untuk casual everyday wear. Tersedia dalam full size dan half size.',
      'Materials':
          'Upper: Engineered Mesh + Synthetic. Midsole: Foam + Air Max unit 270°. Outsole: Rubber. Berat: 298g.',
      'Shipping & Returns':
          'Gratis ongkir ke seluruh Indonesia. Estimasi 2-3 hari kerja. Garansi produk 6 bulan untuk cacat pabrik.',
    },
    'p4': {
      'Description':
          'Adidas Ultraboost 22 hadir dengan upper Primeknit+ yang memeluk kaki secara alami. BOOST midsole memberikan energi return yang luar biasa di setiap langkah.',
      'Size & Fit':
          'Slim fit. Disarankan naik setengah ukuran. Continental™ Rubber outsole memberikan grip di berbagai permukaan.',
      'Materials':
          'Upper: Primeknit+. Midsole: BOOST™. Outsole: Continental™ Rubber. Tali: Flat laces. Berat: 312g.',
      'Shipping & Returns':
          'Free shipping untuk member. Estimasi 3-5 hari kerja. Return dalam 30 hari dengan kondisi original.',
    },
  };

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Map<String, String> get _details =>
      _productDetails[widget.product.id] ?? _productDetails['p1']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context),
                SliverToBoxAdapter(child: _buildContent(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sliver App Bar (Hero Image) ──────────────────────────
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: widget.product.bgColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1A1A2E),
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => setState(() => _isWishlisted = !_isWishlisted),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isWishlisted ? Colors.red.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                _isWishlisted
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _isWishlisted ? Colors.red : Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: widget.product.bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                _buildHeroIcon(),
                const SizedBox(height: 16),
                // Color dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _colors.map((c) {
                    final isSelected = c == _selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: isSelected ? 22 : 16,
                        height: isSelected ? 22 : 16,
                        decoration: BoxDecoration(
                          color: _colorMap[c],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.limeGreen
                                : Colors.grey.shade300,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIcon() {
    IconData icon;
    if (widget.product.brand == 'The North Face') {
      icon = Icons.checkroom_rounded;
    } else {
      icon = Icons.directions_run_rounded;
    }
    return Icon(icon, size: 140, color: Colors.grey.shade300);
  }

  // ─── Content ──────────────────────────────────────────────
  Widget _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductHeader(),
          _buildRatingRow(),
          const SizedBox(height: 20),
          _buildSizeSelector(),
          const SizedBox(height: 20),
          _buildQuantitySelector(),
          const SizedBox(height: 24),
          _buildDropdownAccordions(),
          const SizedBox(height: 24),
          _buildReviewSection(),
          const SizedBox(height: 24),
          _buildRelatedProducts(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── Product Header ───────────────────────────────────────
  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.brand,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.product.price,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Rating Row ───────────────────────────────────────────
  Widget _buildRatingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFB800), size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.product.rating.toString(),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '(248 reviews)',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.green.shade600, size: 13),
                const SizedBox(width: 4),
                Text(
                  'In Stock',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Size Selector ────────────────────────────────────────
  Widget _buildSizeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Size',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Size Guide',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cobaltBlue,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.cobaltBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: _sizes.map((size) {
              final isSelected = size == _selectedSize;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A1A2E) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1A1A2E)
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF1A1A2E)
                                  .withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Quantity Selector ────────────────────────────────────
  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'Quantity',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Row(
              children: [
                _qtyButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    _quantity.toString(),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                _qtyButton(
                  icon: Icons.add_rounded,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // ─── Dropdown Accordions ──────────────────────────────────
  Widget _buildDropdownAccordions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _details.entries.map((entry) {
          return _buildAccordionItem(
            title: entry.key,
            content: entry.value,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccordionItem({
    required String title,
    required String content,
  }) {
    final isOpen = _expanded[title] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            // Header
            GestureDetector(
              onTap: () => setState(() => _expanded[title] = !isOpen),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    _accordionIcon(title),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.limeGreen
                              : const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isOpen ? Colors.black : Colors.grey.shade500,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Body (Animated)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeOutCubic,
              secondCurve: Curves.easeInCubic,
              crossFadeState: isOpen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.grey.shade100, thickness: 1),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accordionIcon(String title) {
    IconData icon;
    Color color;
    switch (title) {
      case 'Description':
        icon = Icons.info_outline_rounded;
        color = AppColors.cobaltBlue;
        break;
      case 'Size & Fit':
        icon = Icons.straighten_rounded;
        color = Colors.purple;
        break;
      case 'Materials':
        icon = Icons.eco_outlined;
        color = Colors.green;
        break;
      case 'Shipping & Returns':
        icon = Icons.local_shipping_outlined;
        color = Colors.orange;
        break;
      default:
        icon = Icons.help_outline_rounded;
        color = Colors.grey;
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: color, size: 17),
    );
  }

  // ─── Review Section ──────────────────────────────────────
  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cobaltBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Rating Summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Big rating number
                Column(
                  children: [
                    Text(
                      widget.product.rating.toString(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A2E),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(5, (i) {
                        final full = i < widget.product.rating.floor();
                        return Icon(
                          full ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: const Color(0xFFFFB800),
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '248 ulasan',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Rating bars
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final star = 5 - i;
                      final pct = [0.78, 0.14, 0.05, 0.02, 0.01][i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              '$star',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFFB800), size: 10),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: Colors.grey.shade100,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFFFFB800),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Review cards
        ..._reviews.map((r) => _buildReviewCard(r)),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.cobaltBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    review['avatar'] as String,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        if (review['verified'] as bool) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.verified_rounded,
                                    color: Colors.green.shade600, size: 10),
                                const SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(review['rating'] as int, (_) =>
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFB800), size: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] as String,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Related Products ─────────────────────────────────────
  Widget _buildRelatedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'You May Also Like',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cobaltBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _relatedProducts.length,
            itemBuilder: (ctx, i) {
              final item = _relatedProducts[i];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: item['bg'] as Color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.grey.shade300,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['brand'] as String,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['price'] as String,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Bottom Bar ───────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total price info
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                _calculateTotal(),
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Add to Cart button
          Expanded(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${widget.product.name} ditambahkan ke keranjang!'),
                    backgroundColor: const Color(0xFF1A1A2E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  ),
                );
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A1A2E).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.limeGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTotal() {
    final rawPrice = widget.product.price.replaceAll(RegExp(r'[^\d]'), '');
    final price = int.tryParse(rawPrice) ?? 0;
    final total = price * _quantity;
    return '\$$total';
  }
}
