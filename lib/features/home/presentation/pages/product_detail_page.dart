import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../injection_container.dart';
import '../../data/models/product_item.dart';
import '../bloc/home_bloc.dart';
import '../bloc/product_detail_bloc.dart';
import '../widgets/product_detail_header.dart';
import '../widgets/product_rating_row.dart';
import '../widgets/product_size_selector.dart';
import '../widgets/product_quantity_selector.dart';
import '../widgets/product_accordion.dart';
import '../widgets/product_review_section.dart';
import '../widgets/product_related_section.dart';
import '../widgets/product_bottom_bar.dart';

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

  // ─── Static data (UI-only, bukan domain logic) ────────────
  static const List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Budi Santoso',
      'avatar': 'B',
      'rating': 5,
      'date': '20 Apr 2026',
      'comment':
          'Produk sangat bagus! Material premium dan nyaman dipakai. Ukuran sesuai dengan panduan.',
      'verified': true,
    },
    {
      'name': 'Rina Dewi',
      'avatar': 'R',
      'rating': 5,
      'date': '15 Apr 2026',
      'comment':
          'Pengiriman cepat, produk sesuai foto. Sangat puas dengan pembelian ini!',
      'verified': true,
    },
    {
      'name': 'Ahmad Fauzi',
      'avatar': 'A',
      'rating': 4,
      'date': '10 Apr 2026',
      'comment':
          'Kualitas oke, tapi warna sedikit berbeda dari foto. Overall masih worth it.',
      'verified': false,
    },
  ];

  static const List<Map<String, dynamic>> _relatedProducts = [
    {'name': 'Puffer Jacket', 'brand': 'Columbia', 'price': '\$210'},
    {'name': 'Trail Runner', 'brand': 'Salomon', 'price': '\$165'},
    {'name': 'Fleece Hoodie', 'brand': 'Patagonia', 'price': '\$128'},
  ];

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

  List<String> get _sizes => widget.product.type == 'shoes'
      ? ['38', '39', '40', '41', '42', '43']
      : ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  Map<String, String> get _details =>
      _productDetails[widget.product.id] ?? _productDetails['p1']!;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductDetailBloc>(),
      child: Scaffold(
        backgroundColor: widget.product.bgColor,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              return Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildSliverAppBar(context),
                      SliverToBoxAdapter(
                          child: _buildContent(context, state)),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ProductBottomBar(
                      product: widget.product,
                      state: state,
                    ),
                  ),
                ],
              );
            },
          ),
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
              color: AppColors.cobaltBlue,
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            final isWishlisted =
                homeState.wishlistIds.contains(widget.product.id);
            return Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => context
                    .read<HomeBloc>()
                    .add(HomeWishlistToggled(widget.product.id)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isWishlisted ? Colors.red.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    isWishlisted
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isWishlisted ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: widget.product.id,
          child: Image.asset(
            widget.product.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // ─── Content (komposisi widgets) ──────────────────────────
  Widget _buildContent(BuildContext context, ProductDetailState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductDetailHeader(product: widget.product),
          ProductRatingRow(product: widget.product),
          const SizedBox(height: 20),
          ProductSizeSelector(
            sizes: _sizes,
            selectedSize: state.selectedSize,
          ),
          const SizedBox(height: 20),
          ProductQuantitySelector(quantity: state.quantity),
          const SizedBox(height: 24),
          ProductAccordion(details: _details),
          const SizedBox(height: 24),
          ProductReviewSection(
            rating: widget.product.rating,
            reviews: _reviews,
          ),
          const SizedBox(height: 24),
          ProductRelatedSection(relatedProducts: _relatedProducts),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
